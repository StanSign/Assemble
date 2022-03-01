//
//  APICalls.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/01.
//

import Alamofire
import AlamofireObjectMapper

class APICalls {
    func getFilmData() {
        let urlString: String = "https://rxsvl8lvm8.execute-api.ap-northeast-2.amazonaws.com/beta-1/films/2019070201"
        
        Alamofire.request(urlString).responseObject { (response: DataResponse<FilmResponse>) in
            
            let filmResponse = response.result.value
            
            if let filmResult = filmResponse?.results {
                for result in filmResult {
                    print(result.fNM)
                }
            }
        }
    }
}
