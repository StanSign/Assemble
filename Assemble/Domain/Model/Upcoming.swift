//
//  Upcoming.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

struct Upcoming {
    let id: Int
    let title: String
    let titleEN: String
    let releaseDate: String
    let imageURL: String
}

struct UpcomingList {
    let count: Int
    let statusCode: Int
    let description: String
    let title: String
    let upcomings: [Upcoming]
}
