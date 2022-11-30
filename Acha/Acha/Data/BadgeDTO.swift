//
//  BadgeDTO.swift
//  Acha
//
//  Created by hong on 2022/11/22.
//

import Foundation

struct BadgeDTO: Decodable {
    let id: Int
    let name: String
    let image: String
    let isHidden: Bool
}
