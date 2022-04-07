//
//  AlamoFireService.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

import Alamofire
import RxSwift

final class AlamoFireService {
    
    func request(url: String) {
        AF.request(url).responseJSON { resopnse in
            switch resopnse.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let upcomingList = try JSONDecoder().decode(FilmResult.self, from: data)
                } catch {}
            case .failure(let error):
                print(error)
            }
        }
    }
}
