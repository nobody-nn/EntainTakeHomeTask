//
//  JSONMapper.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import Foundation

struct JSONMapper {
    
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
        
        guard !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToDecodeContents
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

extension JSONMapper {
    enum MappingError: Error {
        case failedToDecodeContents
    }
}
