//
//  DefaultSearchRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Foundation

import RxSwift
import Alamofire

final class DefaultSearchRepository: SearchRepository {
    
    private let disposeBag: DisposeBag
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    func fetchSearchResult(with query: String) -> Observable<SearchResultList> {
        print(query)
        let url = awsConfiguration.baseURL + awsConfiguration.searchPath + query
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return Observable.create { observer in
            let request = AF.request(encodedURL, method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(
                            withJSONObject: value,
                            options: .prettyPrinted
                        )
                        let dto = try JSONDecoder().decode(SearchResultDTO.self, from: data)
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
    
    func fetchResultItems(from searchList: SearchResultList) -> [SearchResult] {
        return searchList.results
    }
}
