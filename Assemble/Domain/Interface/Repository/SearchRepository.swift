//
//  SearchRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Foundation

import RxSwift

protocol SearchRepository {
    func fetchSearchResult(with query: String) -> Observable<SearchResultList>
    func fetchResultItems(from searchList: SearchResultList) -> [SearchResult]
}
