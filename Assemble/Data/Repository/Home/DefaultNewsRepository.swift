//
//  DefaultNewsRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

import RxSwift
import Alamofire

final class DefaultNewsRepository: NewsRepository {
    
    private let disposeBag: DisposeBag
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    func fetchNews() -> Observable<NewsResult> {
        let url = awsConfiguration.baseURL + awsConfiguration.newsPath
        let testURL = MockServerConstants.baseURL + MockServerConstants.newsPath
        let testURL2 = MockServer2Constants.baseURL + MockServer2Constants.newsPath
        
        return Observable.create { observer -> Disposable in
            let request = AF.request(testURL2, method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(
                            withJSONObject: value,
                            options: .prettyPrinted
                        )
                        let dto = try JSONDecoder().decode(NewsResultDTO.self, from: data)
                        observer.onNext(dto.toDomain())
                    } catch {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
