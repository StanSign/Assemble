//
//  NewsRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

import RxSwift

protocol NewsRepository {
    func fetchNews() -> Observable<NewsResult>
}
