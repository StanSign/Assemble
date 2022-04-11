//
//  DefaultHomeBannerRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

import RxSwift
import RxAlamofire

enum HomeBannerRepositoryError: Error {
    case decodingError
}

final class DefaultHomeBannerRepository: HomeBannerRepository {
    typealias Error = HomeBannerRepositoryError
    private let disposeBag: DisposeBag
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    func fetchUpcomingData() -> Observable<UpcomingList> {
        let url = awsConfiguration.baseURL + awsConfiguration.upcomingFilmPath
        
        return RxAlamofire.requestJSON(.get, url)
            .map { (response, json) -> UpcomingList in
                // Alamofire 이용하여 data를 UpcomingListDTO에 매핑
                print(json)
                guard let dto = json as? UpcomingResponseDTO else { throw Error.decodingError }
                // DTO의 toDomain 함수를 이용하여 UpcomingList type으로 return
                print(dto.toDomain())
                return dto.toDomain()
            }
    }
}
