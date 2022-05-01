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
    var bannerData: [BannerData]?
    
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
        let isFetchFinished = BehaviorRelay<Bool>(value: false)
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.bindSetup(to: output, disposeBag: disposeBag)
        
        // input
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.homeUseCase.fetchUpcomingList()
            })
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
        
        self.homeUseCase.bannerData
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

//MARK: - Setup Functions

private extension HomeViewModel {
    func bindSetup(to output: Output, disposeBag: DisposeBag) {
        self.homeUseCase.upcomingList
            .map({ $0.upcomings })
            .map({ upcomings -> [BannerData] in
                let banners = self.createBannerData(with: upcomings)
                let carouselBanner = self.createCarouselData(with: banners)
                self.bannerData = carouselBanner
                return carouselBanner
            })
            .bind(to: output.bannerData)
            .disposed(by: disposeBag)
        
        self.homeUseCase.isUpcomingFetchFinished
            .asDriver(onErrorJustReturn: false)
            .filter({ $0 == true })
            .do(onNext: { _ in
                let initialPage = self.getInitialPage()
                output.bannerInitialPage.accept(initialPage)
            })
            .drive(onNext: { _ in
                output.isFetchFinished.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    func createBannerData(with upcomings: [Upcoming]) -> [BannerData] {
        var banners: [BannerData] = []
        for upcoming in upcomings {
            banners.append(BannerData(
                title: upcoming.title.splitAndGet(.head, by: [":"]),
                subtitle: upcoming.title.splitAndGet(.tail, by: [":"]),
                imageURL: upcoming.imageURL,
                d_day: upcoming.releaseDate.getStateFromReleaseDate()
            ))
        }
        return banners
    }
    
    func createCarouselData(with banners: [BannerData]) -> [BannerData] {
        let carousel = Array(repeating: banners, count: 3)
        return carousel.flatMap{( $0 )}
    }
}

//MARK: - Private Functions

private extension HomeViewModel {
    func getInitialPage() -> Int {
        guard let initialPage = self.homeUseCase.upcomingCount else { return 0 }
        return initialPage
    }
}
