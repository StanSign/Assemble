//
//  NewsUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

import RxSwift

protocol NewsUseCase {
    var newsResult: PublishSubject<NewsResult> { get set }
    func fetchNews()
}

final class DefaultNewsUseCase: NewsUseCase {
    
    var newsResult: PublishSubject<NewsResult> = PublishSubject()
    
    //MARK: - Constants
    private let newsRepository: NewsRepository
    private let disposeBag: DisposeBag
    
    //MARK: - init
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    func fetchNews() {
        self.newsRepository.fetchNews()
            .subscribe(onNext: { [weak self] news in
                self?.newsResult.onNext(news)
            })
            .disposed(by: self.disposeBag)
    }
}

