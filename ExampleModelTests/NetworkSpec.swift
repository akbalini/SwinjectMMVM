//
//  NetworkSpec.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import Quick
import Nimble
@testable import ExampleModel

class NetworkSpec: QuickSpec{
    override func spec() {
        var network: Network!
        beforeEach{
            network = Network()
        }
        
        describe("JSON"){
            it("eventually get JSON data as specified with parameters.") {
                var json: [String: AnyObject]? = nil
                let url = "https://httpbin.org/get"
                network.requestJSON(url, parameters: ["a": "b", "x": "y"])
                    .on(next: { json = $0 as? [String: AnyObject] })
                    .start()
                expect(json).toEventuallyNot(beNil(), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["a"] as? String)
                    .toEventually(equal("b"), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["x"] as? String)
                    .toEventually(equal("y"), timeout: 5)
            }
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                let url = "https://not.existing.server.comm/get"
                network.requestJSON(url, parameters: ["a": "b", "x": "y"])
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error)
                    .toEventually(equal(NetworkError.NotReachedServer), timeout: 5)
            }
            
        }
        describe("Image"){
            it("eventually gets an image.") {
                var image: UIImage?
                network.requestImage("https://httpbin.org/image/jpeg")
                    .on(next: {image = $0})
                    .start()
                
                expect(image).toEventuallyNot(beNil(),timeout: 5)
            }
            it("eventually gets an error if incorrect data for an image is returned.") {
                var error: NetworkError?
                network.requestImage("https://httpbin.org/get")
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(
                    equal(NetworkError.IncorrectDataReturned), timeout: 5)
            }
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                network.requestImage("https://not.existing.server.comm/image/jpeg")
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(
                    equal(NetworkError.NotReachedServer), timeout: 5)
            }
        }
        
    }
}