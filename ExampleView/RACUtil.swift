//
//  RACUtil.swift
//  SwinjectMVVMExample
//
//  Created by Juarez Martinez, A. on 2/2/16.
//  Copyright © 2016 Akbal Juarez. All rights reserved.
//

import Foundation

import UIKit
import ReactiveCocoa

internal extension UITableViewCell{
    internal var racutil_prepareForReuseProducer: SignalProducer<(), NoError> {
        return self.rac_prepareForReuseSignal
            .toSignalProducer()
            .map {_ in }
            .flatMapError { _ in SignalProducer(value: ())}
    }

}