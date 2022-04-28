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
    var upcomingList: UpcomingList?
    var upcomingCount: Int?
    var bannerCount = BehaviorRelay<Int>(value: 0)
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let bannerContentOffsetX: Observable<CGPoint>
        let bannerBoundsWidth: Observable<CGFloat>
        let searchButtonDidTapEvent: Observable<Void>
        let notifyButtonDidTapEvent: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        let bannerData = BehaviorRelay<[BannerData]>(value: [])
        let didLoadBanner = PublishRelay<Bool>()
        let upcomingCount = BehaviorRelay<Int>(value: 0) // Upcoming Count (Total Page Control)
        let bannerCount = BehaviorRelay<Int>(value: 0) // Total Banner Page Count
        let currentBannerPage = BehaviorRelay<Int?>(value: nil)
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // input
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
        
        // output
        let output = Output()
        
        self.homeUseCase.bannerData?
            .bind(to: output.bannerData)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.bannerBoundsWidth,
            input.bannerContentOffsetX,
            bannerCount,
            resultSelector: { (width, offset, bannerCount) -> Int? in
                if bannerCount == .zero {
                    return nil
                }
                return Int(ceil(offset.x / width)) % bannerCount
            })
            .bind(to: output.currentBannerPage)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension HomeViewModel {
    
}
