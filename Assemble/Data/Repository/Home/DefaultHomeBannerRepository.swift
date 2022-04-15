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
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    func fetchUpcomingData() -> Observable<UpcomingList> {
        let url = awsConfiguration.baseURL + awsConfiguration.upcomingFilmPath
        let testURL = MockServerConstants.baseURL + MockServerConstants.upcomingFilmPath
        
        return Observable.create { observer -> Disposable in
            let request = AF.request(testURL, method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(
                            withJSONObject: value,
                            options: .prettyPrinted
                        )
                        let dto = try JSONDecoder().decode(UpcomingResponseDTO.self, from: data)
                        self.fetchBannerImage(from: dto.toDomain().upcomings)
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
    
    private func fetchBannerImage(from upcomings: [Upcoming]) {
        for (index, url) in upcomings.map({ URL(string: $0.imageURL) }).enumerated() {
            guard let url = url else { return }
            let resource = ImageResource(downloadURL: url, cacheKey: "bannerCache\(index)")
            let width = UIScreen.main.bounds.width
            let size = CGSize(width: width, height: width * 1.3)
            KingfisherManager.shared.retrieveImage(
                with: resource,
                options: [
                    .processor(DownsamplingImageProcessor(size: size)),
                    .scaleFactor(UIScreen.main.scale),
                    .alsoPrefetchToMemory
                ]) { _ in
                    // completion
                }
        }
    }
}
