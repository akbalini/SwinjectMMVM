//
//  Network.swift
//  SwinjectMVVMExample
//
//  Created by Akbal Juarez on 28/01/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import ReactiveCocoa
import Alamofire

public final class Network: Networking{
    private let queue = dispatch_queue_create("SwinjectMVVMExample.ExampleModel.Network.Queue", DISPATCH_QUEUE_SERIAL)
    public init(){
        
    }
    
    public func requestJSON(url: String, parameters: [String : AnyObject]?) -> SignalProducer <AnyObject, NetworkError>{
        return SignalProducer { observer, disposable in
            let serializer = Alamofire.Request.JSONResponseSerializer()
            Alamofire.request(.GET, url, parameters: parameters).response(queue: self.queue, responseSerializer: serializer){
                response in
                switch response.result {
                case .Success (let val):
                    observer.sendNext(val)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(NetworkError(error: error))
                }
            }
            
        }
    }
}