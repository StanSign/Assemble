//
//  awsConstants.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

enum awsConfiguration {
    /** without version */
    static let awsBaseURL = "https://rxsvl8lvm8.execute-api.ap-northeast-2.amazonaws.com/"
    /** with version */
    static let baseURL = "https://rxsvl8lvm8.execute-api.ap-northeast-2.amazonaws.com/beta-1/"
    
    /** Upcoming_GET */
    static let upcomingFilmPath = "films/upcoming"
    /** searchData */
    static let searchPath = "search/"
    /** news_GET */
    static let newsPath = "news/"
}
