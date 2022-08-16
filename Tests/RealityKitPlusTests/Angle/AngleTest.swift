//
//  AngleTest.swift
//  
//  
//  Created by fuziki on 2022/08/16
//  
//

import XCTest
@testable import RealityKitPlus

final class AngleTest: XCTestCase {
    func testAngleDiff() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let degrees: [(a: Float, b: Float, e: Float)] = [
            // Positive numbers to 0
            (a: 0, b: 0, e: 0),
            (a: 90, b: 0, e: -90),
            (a: 180, b: 0, e: 180),
            (a: 270, b: 0, e: 90),
            (a: 360, b: 0, e: 0),
            (a: 90, b: 720, e: -90),

            // Negative number to 0
            (a: -90, b: 0, e: 90),
            (a: -180, b: 0, e: 180),
            (a: -270, b: 0, e: -90),
            (a: -360, b: 0, e: 0),
            (a: -90, b: -720, e: 90),

            // Crossed positive and negative numbers
            (a: 45, b: -45, e: -90),
            (a: -45, b: 45, e: 90),
            (a: -225, b: 225, e: 90),
            (a: 225, b: -225, e: -90),
            (a: -315, b: 315, e: -90),
            (a: 315, b: -315, e: 90),
        ]
        for d in degrees {
            let r = angleDiff(a: Float(d.a) * .pi / 180, b: Float(d.b) * .pi / 180)
            XCTAssertEqual(round(r * 180 / .pi), d.e, "a: \(d.a), b: \(d.b)")
        }
    }
}
