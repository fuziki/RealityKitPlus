//
//  Entity.ChildCollection+extension.swift
//  
//  
//  Created by fuziki on 2022/08/13
//  
//

import Foundation
import RealityKit

extension Entity.ChildCollection {
    public func recursiveFirst(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Element? {
        if let child = try first(where: predicate) {
            return child
        }
        for c in self {
            if let grand = try c.children.recursiveFirst(where: predicate) {
                return grand
            }
        }
        return nil
    }
}
