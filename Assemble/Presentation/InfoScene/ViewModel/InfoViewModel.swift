//
//  InfoViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/10.
//

import Foundation

import RxSwift
import RxRelay

final class InfoViewModel {
    weak var coordinator: InfoCoordinator?
    private let infoUseCase: InfoUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: InfoCoordinator, infoUseCase: InfoUseCase) {
        self.coordinator = coordinator
        self.infoUseCase = infoUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        
    }
    
    //MARK: - Output
    
    struct Output {
        
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input
        
        // output
        
        return output
    }
}

//MARK: - Private Functions

private extension InfoViewModel {
    
}
