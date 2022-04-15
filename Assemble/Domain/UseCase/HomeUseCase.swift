//
//  FrontUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/06.
//

import Foundation

import RxSwift

protocol HomeUseCase {
    var upcomingList: PublishSubject<UpcomingList> { get set }
    var didLoadImage: PublishSubject<Bool> { get set }
    func fetchUpcomingList()
    func buttonPress()
}

final class DefaultHomeUseCase: HomeUseCase {
    //MARK: - Constants
    private let bannerRepository: HomeBannerRepository
    private let disposeBag: DisposeBag
    var upcomingList: PublishSubject<UpcomingList> = PublishSubject()
    var didLoadImage: PublishSubject<Bool> = PublishSubject()
    
    //MARK: - init
    init(bannerRepository: HomeBannerRepository) {
        self.bannerRepository = bannerRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    func fetchUpcomingList() {
        self.bannerRepository.fetchUpcomingData()
            .subscribe(onNext: { [weak self] upcomingList in
                self?.upcomingList.onNext(upcomingList)
            }, onCompleted: { [weak self] in
                self?.didLoadImage.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    func buttonPress() {
        print("Pressed")
    }
}
