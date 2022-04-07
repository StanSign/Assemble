//
//  HomeBannerResponseDTO.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/07.
//

import Foundation

// MARK: - Data Transfer Object (DTO)
// JSON response를 domain layer에 encode/decode하여 넣어주는 중간 단계의 Object

struct UpcomingResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case count
        case upcomings = "results"
    }
    let count: Int
    let upcomings: [UpcomingDTO]
}

extension UpcomingResponseDTO {
    struct UpcomingDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id = "fID"
            case title = "fNM"
            case titleEN = "fNM_en"
            case releaseDate = "fReleaseDate"
            case imageURL = "fImage"
        }
        let id: Int
        let title: String
        let titleEn: String
        let releaseDate: String
        let imageURL: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.title = try container.decode(String.self, forKey: .title)
            self.titleEn = try container.decode(String.self, forKey: .titleEN)
            self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
            self.imageURL = try container.decode(String.self, forKey: .imageURL)
        }
    }
}

//MARK: - Mapping to Domain

extension UpcomingResponseDTO {
    func toDomain() -> UpcomingList {
        return .init(count: count,
                     upcomings: upcomings.map { $0.toDomain() })
    }
}

extension UpcomingResponseDTO.UpcomingDTO {
    func toDomain() -> Upcoming {
        return .init(id: id,
                     title: title,
                     titleEN: titleEn,
                     releaseDate: releaseDate,
                     imageURL: imageURL)
    }
}
