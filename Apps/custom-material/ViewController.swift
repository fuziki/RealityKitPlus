//
//  ViewController.swift
//  
//  
//  Created by fuziki on 2022/08/14
//  
//

import RealityKit
import RealityKitPlus
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        arView.cameraMode = .nonAR

        let robotScene: ProjectRobot.RobotScene = try! ProjectRobot.loadRobotScene()
        print("robotScene: \(robotScene)")

        let robot: RealityKit.Entity = robotScene.robot!
        print("robot: \(robot)")

        let model = robot.children.recursiveFirst(where: { $0 is ModelEntity })! as! ModelEntity
        print("model: \(model)")

        let newAnchor = AnchorEntity(world: [0, 0, -1])
        newAnchor.addChild(robotScene)
        arView.scene.addAnchor(newAnchor)
    }


}

