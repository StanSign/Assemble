//
//  SearchUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Foundation

import RxSwift

protocol SearchUseCase {
    var searchResultList: PublishSubject<SearchResultList> { get set }
    func fetchSearchResult(with query: String)
}

final class DefaultSearchUseCase: SearchUseCase {
    //MARK: - Constants
    private let searchRepository: SearchRepository
    private let disposeBag: DisposeBag
    var searchResultList: PublishSubject<SearchResultList> = PublishSubject()
    
    //MARK: - init
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    func fetchSearchResult(with query: String) {
        self.searchRepository.fetchSearchResult(with: query)
            .subscribe(onNext: { [weak self] result in
                self?.searchResultList.onNext(result)
            })
            .disposed(by: disposeBag)
    }

}

