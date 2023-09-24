//
//  Model.swift
//  BalinaSoftTestApp
//
//  Created by Artyom Butorin on 24.09.23.
//

import Foundation

struct PhotoType: Codable {
    let id: Int
    let name: String
    let image: URL?
}

struct PhotoTypeResponse: Codable {
    let page: Int
    let pageSize: Int
    let totalPages: Int
    let totalElements: Int
    let content: [PhotoType]
}

struct PhotoUploadData: Codable {
    let name: String
    let typeId: Int
    let photo: Data 
}
