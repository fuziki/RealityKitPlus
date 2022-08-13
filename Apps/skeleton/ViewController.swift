//
//  ViewController.swift
//  
//  
//  Created by fuziki on 2022/08/13
//  
//

import Combine
import RealityKit
import SkeletonLib
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!

    let animator = SkeletonAnimator(definition: SkeletonDefinition.robot)

    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let robotScene: ProjectRobot.RobotScene = try! ProjectRobot.loadRobotScene()
        print("robotScene: \(robotScene)")
        
        let robot = robotScene.robot!
        print("robot: \(robot)")
        
        let model = robot.children.recursiveFirst(where: { $0 is ModelEntity })! as! ModelEntity
        print("model: \(model)")
        animator.target = model

        let newAnchor = AnchorEntity(world: [0, 0, -1])
        newAnchor.addChild(robotScene)
        arView.scene.addAnchor(newAnchor)
        arView.scene
            .publisher(for:  SceneEvents.Update.self)
            .sink { [weak self] (_: SceneEvents.Update) in
                self?.animator.update()
            }
            .store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.animator.set(joint: .leftArm, rotateFromNeutral: Transform(pitch: 0, yaw: .pi / 2 * 0.9, roll: 0).rotation)
            self?.animator.set(joint: .rightArm, rotateFromNeutral: Transform(pitch: 0, yaw: .pi / 2 * 0.9, roll: 0).rotation)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.animator.set(joint: .leftArm, rotateFromNeutral: Transform(pitch: 0, yaw: .pi / 2 * 0.9, roll: .pi / -4).rotation)
            self?.animator.set(joint: .leftForearm, rotateFromNeutral: Transform(pitch: 0, yaw: 0, roll: .pi / -4).rotation)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.animator.set(joint: .leftArm, rotateFromNeutral: Transform(pitch: 0, yaw: .pi / 2 * 0.9, roll: .pi / -2).rotation)
            self?.animator.set(joint: .leftForearm, rotateFromNeutral: Transform(pitch: 0, yaw: 0, roll: .pi / -2).rotation)
        }
    }


}

