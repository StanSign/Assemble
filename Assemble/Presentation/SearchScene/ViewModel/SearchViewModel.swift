//
//  SearchViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Foundation

import RxSwift
import RxRelay

final class SearchViewModel {
    weak var coordinator: SearchCoordinator?
    private let searchUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: SearchCoordinator, searchUseCase: SearchUseCase) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let backButtonDidTapEvent: Observable<Void>
        let screenEdgePanGestureEvent: Observable<Void>
        let searchBarEvent: Observable<String>
    }
    
    //MARK: - Output
    
    struct Output {
        let searchResults = BehaviorRelay<[SearchResult]>(value: [])
        let queryEmpty = BehaviorRelay<Bool>(value: true)
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        // input

        input.backButtonDidTapEvent
            .subscribe(onNext: {
                self.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.screenEdgePanGestureEvent
            .subscribe(onNext: {
                self.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.searchBarEvent
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text == "" {
                    output.queryEmpty.accept(true)
                } else {
                    output.queryEmpty.accept(false)
                }
                self.searchUseCase.fetchSearchResult(with: text)
            })
            .disposed(by: disposeBag)
        
        // output
        
        self.searchUseCase.searchResultList
            .map({ $0.results })
            .map({ result in
                return result
            })
            .bind(to: output.searchResults)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension SearchViewModel {
    
}
