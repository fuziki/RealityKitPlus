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

        let robot: RealityKit.Entity = robotScene.robot!
        print("robot: \(robot)")

        let model = robot.children.recursiveFirst(where: { $0 is ModelEntity })! as! ModelEntity
        print("model: \(model)")
        animator.target = model

        arView.scene.addAnchor(robotScene)
        arView.scene
            .publisher(for:  SceneEvents.Update.self)
            .sink { [weak self] (_: SceneEvents.Update) in
                self?.animator.update()
            }
            .store(in: &cancellables)
    }

    @IBAction func onLeftArm(_ sender: UISlider) {
        animator.set(joint: .rightArm, rotateFromNeutral: Transform(pitch: 0, yaw: .pi / 2 * 0.9, roll: 0).rotation)
        animator.set(joint: .leftArm, rotateFromNeutral: Transform(pitch: 0, yaw: .pi / 2 * 0.9, roll: -sender.value).rotation)
    }

    @IBAction func onLeftForeArm(_ sender: UISlider) {
        animator.set(joint: .leftForearm, rotateFromNeutral: Transform(pitch: 0, yaw: 0, roll: -sender.value).rotation)
    }
}
