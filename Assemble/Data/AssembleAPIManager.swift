//
//  AssembleAPIManager.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/19.
//

import RxSwift
import Alamofire
import RxAlamofire
import Kingfisher

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
                let searchResultList = try JSONDecoder().decode(SearchResult.self, from: data)
                return searchResultList.results
            }
            .subscribe(onNext: { [weak self] searchList in
                self?.searchResultList.onNext(searchList)
            })
            .disposed(by: disposeBag)
    }
    
    func requestDetailInfo(_ id: Int?, _ type: contentType?, completion: @escaping (Data) -> ()) {
        let method = "\(type!)/\(id!)"
        AF.request(baseURL + method, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    completion(data)
                } catch { }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestAndSetImage(to imageView: UIImageView, with source: String?) {
        let dummyURL = "https://dummyimage.com/128x128/000000/ffffff&text=no+image"
        let imageURL = URL(string: source ?? dummyURL)
        imageView.kf.indicatorType = .custom(indicator: Loader())
        imageView.kf.setImage(with: imageURL, placeholder: nil, options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.5)),
            .cacheOriginalImage,
            .retryStrategy(DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(3)))
        ])
    }
    
    func convertType(_ type: String) -> String? {
        switch type {
        case "actors":
            fallthrough
        case "casts":
            return "인물"
        case "films":
            return "영화"
        case "characters":
            return "캐릭터"
        case "tvSeries":
            return "드라마"
        default:
            return nil
        }
    }
}
