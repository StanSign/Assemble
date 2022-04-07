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
    private let disposeBag: DisposeBag
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    func fetchBannerData() -> Observable<UpcomingList> {
        let url = awsConfiguration.baseURL + awsConfiguration.upcomingFilmPath
        
        return RxAlamofire.requestJSON(.get, url)
            .map { (response, json) -> UpcomingList in
                guard let dict = json as? [String: Any] else {
                    return UpcomingList(count: 0, upcomings: [Upcoming(id: 0, title: "", titleEN: "", releaseDate: "", imageURL: "")])
                }
                return UpcomingList(count: 0, upcomings: [Upcoming(id: 0, title: "", titleEN: "", releaseDate: "", imageURL: "")])
            }
    }
}
