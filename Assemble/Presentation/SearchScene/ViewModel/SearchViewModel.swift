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
        
    }
    
    //MARK: - Output
    
    struct Output {
        
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // input
        
        // output
        let output = Output()
        
        return output
    }
}

private extension SearchViewModel {
    
}
