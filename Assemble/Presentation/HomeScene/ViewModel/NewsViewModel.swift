//
//  NewsViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

import RxSwift
import RxRelay

final class NewsViewModel {
    private let newsUseCase: NewsUseCase
    private let disposeBag = DisposeBag()
    
    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let viewDidInit: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        let newsData = BehaviorRelay<[News]>(value: [])
    }
    
    func transform(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidInit
            .subscribe(onNext: { event in
                self.newsUseCase.fetchNews()
            })
            .disposed(by: disposeBag)
        
        self.newsUseCase.newsResult
            .map({ $0.results })
            .bind(to: output.newsData)
            .disposed(by: disposeBag)
        
        return output
    }
}
