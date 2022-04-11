//
//  APIService.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/12.
//

import Foundation

import Alamofire
import RxSwift

enum APIServiceError: Error {
    case forbidden, notFound, conflict, internalServerError
}

final class APIService {
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseJSON { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value as! T)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(APIServiceError.forbidden)
                    case 404:
                        observer.onError(APIServiceError.notFound)
                    case 409:
                        observer.onError(APIServiceError.conflict)
                    case 500:
                        observer.onError(APIServiceError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
