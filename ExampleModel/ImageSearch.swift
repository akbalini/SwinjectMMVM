//
//  ImageSearch.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//


import ReactiveCocoa
import Result
import Himotoki

public final class ImageSearch: ImageSearching {
    private let network: Networking
    
    public init(network: Networking){
        self.network = network
    }
    
    public func searchImages() -> SignalProducer<ResponseEntity, NetworkError> {
        let url = Pixbabay.apiURL
        let parameters = Pixbabay.requestParameters
        return network.requestJSON(url, parameters: parameters).attemptMap{ json in
            if let response = (try? decode(json)) as ResponseEntity? {
                return Result(value: response)
            } else {
                return Result(error: .IncorrectDataReturned)
            }
        }
    }
}