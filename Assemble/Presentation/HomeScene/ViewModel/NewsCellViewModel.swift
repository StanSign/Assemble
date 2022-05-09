//
//  NewsCellViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/04.
//

import Foundation

import RxSwift
import RxRelay

final class NewsCellViewModel {
    private let newsUseCase: NewsUseCase
    private let disposeBag = DisposeBag()
    
    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let cellDidTapEvent: Observable<UITapGestureRecognizer>
        let urlString: Observable<String>
    }
    
    //MARK: - Output
    
    struct Output {
        let cellDidTapped = PublishRelay<Bool>()
    }
    
    //MARK: - Transform
    
    func transform(with input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.combineLatest(
            input.cellDidTapEvent,
            input.urlString
        ).subscribe(onNext: { _, urlString in
            self.newsUseCase.openURL(with: urlString)
            print("Tapped \(urlString)")
        })
        .disposed(by: disposeBag)
        
        return output
    }
}
