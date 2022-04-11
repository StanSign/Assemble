//
//  DefaultHomeBannerRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

import RxSwift
import Alamofire

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
        
        return Observable.create { observer -> Disposable in
            let request = AF.request(url, method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let dto = try JSONDecoder().decode(UpcomingResponseDTO.self, from: data)
                        observer.onNext(dto.toDomain())
                    } catch { }
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
