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
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
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
                self.searchUseCase.fetchSearchResult(with: text)
            })
            .disposed(by: disposeBag)
        
        // output
        let output = Output()
        
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
