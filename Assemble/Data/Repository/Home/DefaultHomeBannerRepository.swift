//
//  DefaultHomeBannerRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

import RxSwift
import Alamofire
import RxAlamofire

final class DefaultHomeBannerRepository: HomeBannerRepository {
    init() {
        
    }
    
    func fetchBanner() -> Observable<[HomeBanner]> {
        let url = awsConfiguration.baseURL + awsConfiguration.upcomingFilmPath
        
        fetchBannerData(url: url)
    }
    
    private func fetchBannerData(url: String) {
        
    }
}
