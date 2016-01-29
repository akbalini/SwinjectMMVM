//
//  ImageSearchTableViewModel.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import ExampleModel

public final class ImageSearchTableViewModel: ImageSearchTableViewModeling{
    private let imageSearch: ImageSearching
    public init(imageSearch: ImageSearching){
        self.imageSearch = imageSearch
    }
    
    
}