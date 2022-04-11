//
//  HomeViewModel.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/08.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase
    private let disposeBag = DisposeBag()
    var upcomingList: UpcomingList?
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.upcomingList = UpcomingList(
            count: 0,
            upcomings: []
        )
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    //MARK: - Input
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // input
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.homeUseCase.fetchUpcomingList()
            })
            .disposed(by: disposeBag)
        
        // output
        let output = Output()
        
        self.homeUseCase.upcomingList
            .subscribe(onNext: { [weak self] list in
//                print(list)
                self?.upcomingList = list
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
