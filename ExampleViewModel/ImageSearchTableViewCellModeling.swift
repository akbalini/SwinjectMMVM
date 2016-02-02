//
//  ImageSearchTableViewCellModeling.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//
import ReactiveCocoa

public protocol ImageSearchTableViewCellModeling {
    var id: UInt32 { get}
    var pageImageSizeText: String { get }
    var tagText: String { get }
    
    func getPreviewImage() -> SignalProducer<UIImage?, NoError>
}