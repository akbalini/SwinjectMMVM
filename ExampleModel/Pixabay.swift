//
//  Pixabay.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

internal struct Pixbabay {
    internal static let apiURL = "https://pixabay.com/api/"
    
    internal static var requestParameters: [String: AnyObject] {
        return [
        "key": Config.apiKey,
        "image_type": "photo",
            "safesearch":true,
            "per_page": 50,
        ]
    }
    
}
extension Pixbabay {
    private struct Config{
        private static let apiKey = ""
    }
}