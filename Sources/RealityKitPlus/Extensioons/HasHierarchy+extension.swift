//
//  File.swift
//  
//  
//  Created by fuziki on 2022/08/14
//  
//

import Foundation
import RealityKit

extension HasHierarchy {
    public func printChildren(nest: Int = 0) {
        print("\(nest) -> \(self)")
        for c in children {
            c.printChildren(nest: nest + 1)
        }
    }
}
