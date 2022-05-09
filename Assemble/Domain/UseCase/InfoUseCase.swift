//
//  InfoUseCase.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/10.
//

import Foundation

import RxSwift

protocol InfoUseCase {
    
}

final class DefaultInfoUseCase: InfoUseCase {
    //MARK: - Constants
//    private let <#nameRepository#>: <#Repository Class#>
    private let disposeBag: DisposeBag
    
    //MARK: - init
    init() {
//        self.<#nameRepository#> = <#nameRepository#>
        self.disposeBag = DisposeBag()
    }
    
    //MARK: - functions
    
}

