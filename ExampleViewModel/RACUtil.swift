//
//  RACUtil.swift
//  SwinjectMVVMExample
//
//  Created by Juarez Martinez, A. on 2/1/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSObject {
     var racutil_willDeallocProducer: SignalProducer<(), NoError> {
        return self.rac_willDeallocSignal()
            .toSignalProducer()
            .map{ _ in}
            .flatMapError{ _ in SignalProducer(value: ())}
    }
}