//
//  ImageSearchTableViewModel.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import ExampleModel
import ReactiveCocoa

public final class ImageSearchTableViewModel: ImageSearchTableViewModeling{
    public var cellModels: AnyProperty<[ImageSearchTableViewCellModeling]> {
        return AnyProperty(_cellModels)
    }
    private let _cellModels = MutableProperty<[ImageSearchTableViewCellModeling]>([])
    
    private let imageSearch: ImageSearching
    private let network: Networking
    public init(imageSearch: ImageSearching,network: Networking){
        self.imageSearch = imageSearch
        self.network = network
    }
    
    public func startSearch() {
        imageSearch.searchImages()
            .map { response in
                response.images.map{
                    ImageSearchTableViewCellModel(image: $0,network: self.network)
                        as ImageSearchTableViewCellModeling
                }
            }
            .observeOn(UIScheduler())
            .on(next: { cellModels in
                self._cellModels.value = cellModels
            })
            .start()
    }
    
}