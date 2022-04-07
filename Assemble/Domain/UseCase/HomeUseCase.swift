//
//  FrontUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/06.
//

import Foundation

import RxSwift

protocol HomeUseCase {
    func fetchHomeBannerData() -> Observable<[HomeBanner]>
}

final class DefaultHomeUseCase: HomeUseCase {
    private let bannerRepository: HomeBannerRepository
    private let disposeBag: DisposeBag
    
    init(bannerRepository: HomeBannerRepository) {
        self.bannerRepository = bannerRepository
        self.disposeBag = DisposeBag()
    }
    
    func fetchHomeBannerData() -> Observable<[HomeBanner]> {
        return Observable.create { emitter in
            self.bannerRepository.fetchBanner()
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
