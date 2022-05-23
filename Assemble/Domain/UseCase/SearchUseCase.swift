//
//  SearchUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Foundation

import RxSwift

protocol SearchUseCase {
    var searchResults: PublishSubject<[SearchResult]> { get set }
    func fetchSearchResult(with query: String)
}

final class DefaultSearchUseCase: SearchUseCase {
    //MARK: - Constants
    private let searchRepository: SearchRepository
    private let disposeBag: DisposeBag
    var searchResults: PublishSubject<[SearchResult]> = PublishSubject()
    
    //MARK: - init
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    func fetchSearchResult(with query: String) {
        self.searchRepository.fetchSearchResult(with: query)
            .subscribe(onNext: { [weak self] result in
                let searchResults = self!.searchRepository.fetchResultItems(from: result)
                self?.searchResults.onNext(searchResults)
            })
            .disposed(by: disposeBag)
    }

}

