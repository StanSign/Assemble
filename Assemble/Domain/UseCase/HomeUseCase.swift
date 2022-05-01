//
//  FrontUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/06.
//

import Foundation

import RxSwift

protocol HomeUseCase {
    var  upcomingCount: Int? { get set }
    var upcomingList: PublishSubject<UpcomingList> { get set }
    var isUpcomingFetchFinished: PublishSubject<Bool> { get set }
    var bannerData: BehaviorSubject<[BannerData]> { get set }
    var bannerActualPage: BehaviorSubject<Int> { get set }
    var bannerCurrentPage: BehaviorSubject<Int> { get set }
    var bannerPresentedPage: BehaviorSubject<Int> { get set }
    
    func fetchUpcomingList()
    func updateActualPage(offset: CGPoint, width: CGFloat) -> Int
}

final class DefaultHomeUseCase: HomeUseCase {
    
    //MARK: - Constants
    var upcomingCount: Int?
    var upcomingList: PublishSubject<UpcomingList> = PublishSubject()
    var isUpcomingFetchFinished: PublishSubject<Bool> = PublishSubject()
    var bannerData: BehaviorSubject<[BannerData]> = BehaviorSubject(value: [])
    var bannerActualPage: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    var bannerCurrentPage: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    var bannerPresentedPage: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    private let bannerRepository: HomeBannerRepository
    private let disposeBag: DisposeBag
    
    //MARK: - init
    init(bannerRepository: HomeBannerRepository) {
        self.bannerRepository = bannerRepository
        self.disposeBag = DisposeBag()
    }
    
    init(bannerData: [BannerData], bannerRepository: HomeBannerRepository) {
        self.bannerData = BehaviorSubject(value: bannerData)
        self.upcomingCount = bannerData.count
        self.bannerRepository = bannerRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    func fetchUpcomingList() {
        self.bannerRepository.fetchUpcomingData()
            .subscribe(onNext: { [weak self] upcomingList in
                guard let bannerData = self?.createBannerData(with: upcomingList) else { return }
                self?.bannerData.onNext(bannerData)
                self?.upcomingCount = upcomingList.count
                
                self?.upcomingList.onNext(upcomingList)
            }, onCompleted: { [weak self] in
                self?.isUpcomingFetchFinished.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    func updateActualPage(offset: CGPoint, width: CGFloat) -> Int {
        let actualPage = Int(ceil(offset.x / width))
        self.bannerActualPage.onNext(actualPage)
        
        let currentPage = self.calculatePresentedPage(with: actualPage)
//        print("Current Page: \(currentPage)")
        self.bannerCurrentPage.onNext(currentPage)
        
        self.bannerPresentedPage.onNext(currentPage % 3)
        
        return actualPage
    }
}

private extension DefaultHomeUseCase {
    func calculatePresentedPage(with actualPage: Int) -> Int {
        guard let upcomingCount = self.upcomingCount else { return 0 }
        return (actualPage % 3) + upcomingCount
    }
    
    func createBannerData(with upcomingList: UpcomingList) -> [BannerData] {
        var banners: [BannerData] = []
        for upcoming in upcomingList.upcomings {
            banners.append(BannerData(
                title: upcoming.title.splitAndGet(.head, by: [":"]),
                subtitle: upcoming.title.splitAndGet(.tail, by: [":"]),
                imageURL: upcoming.imageURL,
                d_day: upcoming.releaseDate.getStateFromReleaseDate()
            ))
        }
        let carousel = Array(repeating: banners, count: 3)
        return carousel.flatMap({ $0 })
    }
}
