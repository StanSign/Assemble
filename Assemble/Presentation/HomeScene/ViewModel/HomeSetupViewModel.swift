//
//  SetupViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeSetupViewModel {
    weak var coordinator: HomeSetupCoordinator?
    var bannerData: [BannerData]?
    
    private let homeUseCase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: HomeSetupCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        let bannerData = BehaviorRelay<[BannerData]>(value: [])
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // input
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.homeUseCase.fetchUpcomingList()
            })
            .disposed(by: disposeBag)
        
        let output = Output()
        
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
            .filter({ $0 == true })
            .subscribe(onNext: { _ in
                self.coordinator?.showHomeFlow(with: self.bannerData ?? [])
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension HomeSetupViewModel {
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
