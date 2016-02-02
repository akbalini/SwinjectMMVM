//
//  ImageSearchTableViewCell.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import UIKit
import ExampleViewModel
import ReactiveCocoa

internal final class ImageSearchTableViewCell: UITableViewCell {
    internal var viewModel: ImageSearchTableViewCellModeling?{
        didSet{
            tagLabel.text = viewModel?.tagText
            imageSizeLabel.text = viewModel?.pageImageSizeText
            
            if  let viewModel = viewModel {
                viewModel.getPreviewImage()
                    .takeUntil(self.racutil_prepareForReuseProducer)
                    .on(next: { self.previewImageView.image = $0})
                    .start()
                
            } else {
                previewImageView.image = nil
            }
        }
    }
    
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var imageSizeLabel: UILabel!
    
}
