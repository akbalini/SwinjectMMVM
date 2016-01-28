//
//  ResponseEntity.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 27/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import Himotoki

public struct ResponseEntity{
    public let totalCount: Int64
    public let images: [ImageEntity]
}

// MARK: Decodable
extension ResponseEntity: Decodable {
    public static func decode(e: Extractor) throws -> ResponseEntity {
        return try ResponseEntity(
            totalCount: e <| "totalHits",
            images: e <|| "hits")
    }
}