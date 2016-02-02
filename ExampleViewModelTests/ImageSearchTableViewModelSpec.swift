//
//  ImageSearchTableViewModelSpec.swift
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

class ImageSearchTableViewModelSpec: QuickSpec {
    class StubImageSearch: ImageSearching {
        func searchImages() -> SignalProducer<ResponseEntity, NetworkError> {
            return SignalProducer { observer, disposable in
                observer.sendNext(dummyResponse)
                observer.sendCompleted()
                
            }
            .observeOn(QueueScheduler())
        }
    }
    
    class StubNetwork: Networking {
        func requestJSON(url: String, parameters: [String : AnyObject]?) -> SignalProducer<AnyObject, NetworkError> {
            return SignalProducer.empty
        }
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
    }
    override func spec() {
        var viewModel: ImageSearchTableViewModel!
        beforeEach{
            viewModel = ImageSearchTableViewModel(imageSearch: StubImageSearch(),
            network: StubNetwork())
        }
        
        it("eventually sets cellModels property adter the search."){
            var cellModels: [ImageSearchTableViewCellModeling]? = nil
            viewModel.cellModels.producer
                .on(next: { cellModels = $0 })
                .start()
            viewModel.startSearch()
            
            expect(cellModels).toEventuallyNot(beNil())
            expect(cellModels?.count).toEventually(equal(2))
            expect(cellModels?[0].id).toEventually(equal(10000))
            expect(cellModels?[1].id).toEventually(equal(10001))
        }
        
        it("sets cellModels property on the main thread.") {
            var onMainThread = false
            viewModel.cellModels.producer
                .on(next: {_ in onMainThread = NSThread.isMainThread()})
                .start()
            viewModel.startSearch()
            expect(onMainThread).toEventually(beTrue())
        }
    }
}
