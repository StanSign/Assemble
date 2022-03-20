//
//  AssembleAPIManager.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/19.
//

import RxSwift
import Alamofire
import RxAlamofire

class AssembleAPIManager {
    
    //MARK: - Constants
    let disposeBag = DisposeBag()
    private let baseURL = "https://rxsvl8lvm8.execute-api.ap-northeast-2.amazonaws.com/beta-1/"
    
    //MARK: - Shared
    static let shared = AssembleAPIManager()
    
    var searchResultList = PublishSubject<[Search]>()
    // Search Result Binded to searchResultList
    func requestSearchData(query: String) {
        if query == "" {
            return
        }
        let method = "search/\(query)"
        let encodedMethod = method.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        RxAlamofire.requestJSON(.get, baseURL + encodedMethod!)
            .map { $1 }
            .map { response -> [Search] in
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let searchResultListData = try JSONDecoder().decode(SearchResult.self, from: data)
                return searchResultListData.results
            }
            .subscribe(onNext: { [weak self] searchList in
                self?.searchResultList.onNext(searchList)
            })
            .disposed(by: disposeBag)
    }
    
    func convertType(_ type: String) -> String? {
        switch type {
        case "person":
            return "인물"
        case "film":
            return "영화"
        case "character":
            return "캐릭터"
        case "tv":
            return "드라마"
        default:
            return nil
        }
    }
}
