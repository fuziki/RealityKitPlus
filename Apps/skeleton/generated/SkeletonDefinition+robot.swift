//
//  SkeletonDefinition+robot.swift
//  try-reality-kit
//
//  Created by fuziki on 2022/08/12
//
//

import Foundation
import SkeletonLib

extension SkeletonDefinition {
    public static let robot = RobotSkeletonDefinition()
}

public class RobotSkeletonDefinition: SkeletonDefinitionProtocol {
    public func index(for joint: SkeletonJoint) -> Int {
        let index: Int
        switch joint {
        case .root:
            index = 1
        case .hips:
            index = 2
        case .leftUpleg:
            index = 3
        case .leftLeg:
            index = 4
        case .leftFoot:
            index = 5
        case .leftToes:
            index = 6
        case .leftToesend:
            index = 7
        case .rightUpleg:
            index = 8
        case .rightLeg:
            index = 9
        case .rightFoot:
            index = 10
        case .rightToes:
            index = 11
        case .rightToesend:
            index = 12
        case .spine1:
            index = 13
        case .spine2:
            index = 14
        case .spine3:
            index = 15
        case .spine4:
            index = 16
        case .spine5:
            index = 17
        case .spine6:
            index = 18
        case .spine7:
            index = 19
        case .neck1:
            index = 20
        case .neck2:
            index = 21
        case .neck3:
            index = 22
        case .neck4:
            index = 23
        case .head:
            index = 24
        case .jaw:
            index = 25
        case .chin:
            index = 26
        case .nose:
            index = 27
        case .rightEye:
            index = 28
        case .rightEyeupperlid:
            index = 29
        case .rightEyelowerlid:
            index = 30
        case .rightEyeball:
            index = 31
        case .leftEye:
            index = 32
        case .leftEyeupperlid:
            index = 33
        case .leftEyelowerlid:
            index = 34
        case .leftEyeball:
            index = 35
        case .rightShoulder1:
            index = 36
        case .rightArm:
            index = 37
        case .rightForearm:
            index = 38
        case .rightHand:
            index = 39
        case .rightHandpinkystart:
            index = 40
        case .rightHandpinky1:
            index = 41
        case .rightHandpinky2:
            index = 42
        case .rightHandpinky3:
            index = 43
        case .rightHandpinkyend:
            index = 44
        case .rightHandringstart:
            index = 45
        case .rightHandring1:
            index = 46
        case .rightHandring2:
            index = 47
        case .rightHandring3:
            index = 48
        case .rightHandringend:
            index = 49
        case .rightHandmidstart:
            index = 50
        case .rightHandmid1:
            index = 51
        case .rightHandmid2:
            index = 52
        case .rightHandmid3:
            index = 53
        case .rightHandmidend:
            index = 54
        case .rightHandindexstart:
            index = 55
        case .rightHandindex1:
            index = 56
        case .rightHandindex2:
            index = 57
        case .rightHandindex3:
            index = 58
        case .rightHandindexend:
            index = 59
        case .rightHandthumbstart:
            index = 60
        case .rightHandthumb1:
            index = 61
        case .rightHandthumb2:
            index = 62
        case .rightHandthumbend:
            index = 63
        case .leftShoulder1:
            index = 64
        case .leftArm:
            index = 65
        case .leftForearm:
            index = 66
        case .leftHand:
            index = 67
        case .leftHandpinkystart:
            index = 68
        case .leftHandpinky1:
            index = 69
        case .leftHandpinky2:
            index = 70
        case .leftHandpinky3:
            index = 71
        case .leftHandpinkyend:
            index = 72
        case .leftHandringstart:
            index = 73
        case .leftHandring1:
            index = 74
        case .leftHandring2:
            index = 75
        case .leftHandring3:
            index = 76
        case .leftHandringend:
            index = 77
        case .leftHandmidstart:
            index = 78
        case .leftHandmid1:
            index = 79
        case .leftHandmid2:
            index = 80
        case .leftHandmid3:
            index = 81
        case .leftHandmidend:
            index = 82
        case .leftHandindexstart:
            index = 83
        case .leftHandindex1:
            index = 84
        case .leftHandindex2:
            index = 85
        case .leftHandindex3:
            index = 86
        case .leftHandindexend:
            index = 87
        case .leftHandthumbstart:
            index = 88
        case .leftHandthumb1:
            index = 89
        case .leftHandthumb2:
            index = 90
        case .leftHandthumbend:
            index = 91
        }
        return index
    }
}
