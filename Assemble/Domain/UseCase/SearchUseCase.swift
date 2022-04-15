//
//  SearchUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Foundation

import RxSwift

protocol SearchUseCase {
    
}

final class DefaultSearchUseCase: SearchUseCase {
    //MARK: - Constants
    private let searchRepository: SearchRepository
    private let disposeBag: DisposeBag
    
    //MARK: - init
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    
}

