//
//  ImageSearchTableViewControllerSpec.swift
//  SwinjectMVVMExample
//
//  Created by Juarez Martinez, A. on 2/1/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
import ExampleViewModel

@testable import ExampleView

class ImageSerachTableViewControllerSpec: QuickSpec {
    // MARK: Mock
    
    class MockViewModel: ImageSearchTableViewModeling {
        let cellModels = AnyProperty(MutableProperty<[ImageSearchTableViewCellModeling]>([]))
        var startSearchCallCount = 0
        func startSearch(){
            startSearchCallCount++
        }
    }
    
    override func spec() {
        it("starts searching images when the view is about to appear at the first time."){
            let viewModel = MockViewModel()
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ImageSearchTableViewController.self))
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("ImageSearchTableViewController") as! ImageSearchTableViewController
            viewController.viewModel = viewModel
            expect(viewModel.startSearchCallCount) == 0
            viewController.viewWillAppear(true)
            expect(viewModel.startSearchCallCount) == 1
            viewController.viewWillAppear(true)
            expect(viewModel.startSearchCallCount) == 1
        }
    }
}
