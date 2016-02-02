//
//  ImageSearchTableviewCellModelSpec.swift
//  SwinjectMVVMExample
//
//  Created by Juarez Martinez, A. on 2/1/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
@testable import ExampleModel
@testable import ExampleViewModel

class ImageSearchTableViewCellModelSpec: QuickSpec {
    
    class StubNetwork: Networking {
        func requestJSON(url: String, parameters: [String : AnyObject]?) -> SignalProducer<AnyObject, NetworkError> {
            return SignalProducer.empty
        }
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer(value: image1X1).observeOn(QueueScheduler())
        }
    }
    class ErrorStubNetwork: Networking {
        func requestJSON(url: String, parameters: [String : AnyObject]?) -> SignalProducer<AnyObject, NetworkError> {
            return SignalProducer.empty
        }
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer(error: .NotConnectedToInternet)
        }
    }
    override func spec() {
        var viewModel: ImageSearchTableViewCellModel!
        beforeEach{
            viewModel = ImageSearchTableViewCellModel(image: dummyResponse.images[0], network: StubNetwork())
        }
        describe("Constant values"){
            it("sets id.") {
                expect(viewModel.id).toEventually(equal(10000))
            }
            it("formats tag and page image size texts.") {
                expect(viewModel.pageImageSizeText).toEventually(equal("1000 x 2000"))
                expect(viewModel.tagText).toEventually(equal("a, b"))
            }
        }
        describe("eventually returns an image."){
            it("returns nil at the first time."){
                var image: UIImage? = image1X1
                viewModel.getPreviewImage()
                    .on(next: {image = $0})
                    .start()
                expect(image).toEventually(beNil())
            }
            it("eventually returns an image"){
                var image: UIImage? = nil
                viewModel.getPreviewImage()
                    .on(next: {image = $0})
                    .start()
                
                expect(image).toEventuallyNot(beNil())
            }
            it("returns an image on the main thread.") {
                var onMainThread = false
                viewModel.getPreviewImage()
                    .skip(1)
                    .on(next: {_ in onMainThread = NSThread.isMainThread()})
                    .start()
                expect(onMainThread).toEventually(beTrue())
            }
            context("With an image already downloaded"){
                it("inmediately returns the image omitting the first nil"){
                    var image: UIImage? = nil
                    viewModel.getPreviewImage().startWithCompleted {
                      viewModel.getPreviewImage()
                        .take(1)
                        .on(next: { image = $0})
                        .start()
                    }
                    expect(image).toEventuallyNot(beNil())
                }
            }
            
            context("on error"){
                it("returns nil."){
                    var image: UIImage? = image1X1
                    let viewModel = ImageSearchTableViewCellModel(image: dummyResponse.images[0], network: ErrorStubNetwork())
                    viewModel.getPreviewImage()
                    .skip(1)
                        .on(next: {image = $0})
                        .start()
                    
                    expect(image).toEventually(beNil())
                }
            }
        }
        
        
    }
}