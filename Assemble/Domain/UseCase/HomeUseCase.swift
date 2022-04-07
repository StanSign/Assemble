//
//  FrontUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/06.
//

import Foundation

import RxSwift

protocol HomeUseCase {
    func fetchHomeBannerData() -> Observable<UpcomingList>
}

final class DefaultHomeUseCase: HomeUseCase {
    //MARK: - Constants
    private let bannerRepository: HomeBannerRepository
    private let disposeBag: DisposeBag
    
    //MARK: - init
    init(bannerRepository: HomeBannerRepository) {
        self.bannerRepository = bannerRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    func fetchHomeBannerData() -> Observable<UpcomingList> {
        return Observable.create { emitter in
            self.bannerRepository.fetchBannerData()
                .subscribe(onNext: { banner in
                    emitter.onNext(banner)
                }, onError: { error in
                    emitter.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
