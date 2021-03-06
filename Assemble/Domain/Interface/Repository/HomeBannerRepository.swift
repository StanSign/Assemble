//
//  FrontRepository.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

import RxSwift

protocol HomeBannerRepository {
    func fetchUpcomingData() -> Observable<UpcomingList>
}
