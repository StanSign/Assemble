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
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.upcomingList = UpcomingList(
            count: 0,
            statusCode: 0,
            description: "",
            title: "",
            upcomings: []
        )
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        let bannerData = PublishRelay<[BannerData]>()
        let didLoadBanner = PublishRelay<Bool>()
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // input
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.homeUseCase.fetchUpcomingList()
            })
            .disposed(by: disposeBag)
        
        // output
        let output = Output()
        
        self.homeUseCase.upcomingList
            .map({ $0.upcomings })
            .map({ upcomings -> [BannerData] in
                self.upcomingCount = upcomings.count
                let banners = self.createBannerData(with: upcomings)
                let carouselBanner = self.createCarouselData(with: banners)
                return carouselBanner
            })
            .bind(to: output.bannerData)
            .disposed(by: disposeBag)
        
        self.homeUseCase.didLoadImage
            .filter({ $0 })
            .subscribe(onNext: { didLoad in
                output.didLoadBanner.accept(didLoad)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension HomeViewModel {
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
