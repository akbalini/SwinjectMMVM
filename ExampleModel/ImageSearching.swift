//
//  ImageSearching.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import ReactiveCocoa

public protocol ImageSearching {
    func  searchImages() -> SignalProducer<ResponseEntity, NetworkError>
}