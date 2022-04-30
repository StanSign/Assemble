//
//  HomeViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/08.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewDidAppearEvent: Observable<Void>
        let bannerContentOffset: Observable<CGPoint>
        let bannerBoundsWidth: Observable<CGFloat>
        let collectionViewDidEndDecelerating: Observable<Void>
        let searchButtonDidTapEvent: Observable<Void>
        let notifyButtonDidTapEvent: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        let bannerData = BehaviorRelay<[BannerData]>(value: [])
        let bannerActualPage = BehaviorRelay<Int>(value: 0)
        let bannerCurrentPage = BehaviorRelay<Int>(value: 0)
        let bannerPresentedPage = BehaviorRelay<Int>(value: 0)
        let scrollTo = PublishRelay<Int>()
        let bannerInitialPage = PublishRelay<Int>()
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input
        input.viewDidAppearEvent
            .map({
                let initialPage = self.getInitialPage()
                return initialPage
            })
            .bind(to: output.bannerInitialPage)
            .disposed(by: disposeBag)
        
        input.searchButtonDidTapEvent
            .subscribe({ [weak self] _ in
                self?.coordinator?.showSearchFlow()
            })
            .disposed(by: disposeBag)
        
        input.notifyButtonDidTapEvent
            .subscribe(onNext: {
                print("Notify Tapped")
            })
            .disposed(by: disposeBag)
        
        self.homeUseCase.bannerData?
            .bind(to: output.bannerData)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.bannerContentOffset,
            input.bannerBoundsWidth,
            resultSelector: { offset, width in
                let actualPage = self.homeUseCase.updateActualPage(offset: offset, width: width)
                return actualPage
            })
            .distinctUntilChanged()
            .bind(to: output.bannerActualPage)
            .disposed(by: disposeBag)
        
        self.homeUseCase.bannerCurrentPage
            .distinctUntilChanged()
            .bind(to: output.bannerCurrentPage)
            .disposed(by: disposeBag)
        
        self.homeUseCase.bannerPresentedPage
            .distinctUntilChanged()
            .bind(to: output.bannerPresentedPage)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.bannerActualPage,
            output.bannerCurrentPage
        ).filter { $0 != $1 }
            .map({ $1 })
            .bind(to: output.scrollTo)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension HomeViewModel {
    func getInitialPage() -> Int {
        guard let initialPage = self.homeUseCase.upcomingCount else { return 0 }
        return initialPage / 3
    }
}
