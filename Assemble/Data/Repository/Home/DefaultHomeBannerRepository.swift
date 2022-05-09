//
//  DefaultHomeBannerRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

import RxSwift
import Alamofire
import Kingfisher

enum HomeBannerRepositoryError: Error {
    case decodingError
    case emptyDataError
}

final class DefaultHomeBannerRepository: HomeBannerRepository {
    typealias Error = HomeBannerRepositoryError
    private let disposeBag: DisposeBag
    private var fetchCount = 0
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    func fetchUpcomingData() -> Observable<UpcomingList> {
        let url = awsConfiguration.baseURL + awsConfiguration.upcomingFilmPath
        let testURL = MockServerConstants.baseURL + MockServerConstants.upcomingFilmPath
        let testURL2 = MockServer2Constants.baseURL + MockServer2Constants.upcomingFilmPath
        
        return Observable.create { observer -> Disposable in
            let request = AF.request(testURL2, method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(
                            withJSONObject: value,
                            options: .prettyPrinted
                        )
                        let dto = try JSONDecoder().decode(UpcomingResponseDTO.self, from: data)
                        self.fetchBannerImage(from: dto.toDomain().upcomings) {
                            observer.onCompleted()
                        }
                        observer.onNext(dto.toDomain())
                    } catch { }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func fetchBannerImage(from upcomings: [Upcoming], completion: @escaping () -> ()) {
        for urlString in upcomings.map({ $0.imageURL }) {
            guard let url = URL(string: urlString) else { return }
            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            KingfisherManager.shared.retrieveImage(
                with: resource,
                options: [
                    .cacheOriginalImage
                ]) { result in
                    switch result {
                    case .success(_):
                        self.fetchCount += 1
                        if self.fetchCount == upcomings.count - 1 {
                            completion()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
