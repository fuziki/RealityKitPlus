//
//  ViewController.swift
//  
//  
//  Created by fuziki on 2022/08/14
//  
//

import Combine
import RealityKit
import RealityKitPlus
import UIKit

class ViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    @IBOutlet weak var arView: ARView!

    let camera = PerspectiveCamera()
    let cameraAnchor = AnchorEntity(world: .zero)

    var cancellables: Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        arView.cameraMode = .nonAR

        // MARK: Skybox
        // https://developer.apple.com/documentation/realitykit/environmentresource
        let skybox = try! EnvironmentResource.load(named: "alps_field_1k")
        arView.environment.background = .skybox(skybox)

        // MARK: Robot Scene
        let robotScene: ProjectRobot.RobotScene = try! ProjectRobot.loadRobotScene()
        print("robotScene: \(robotScene)")

        let robot: RealityKit.Entity = robotScene.robot!
        print("robot: \(robot)")

        let model = robot.children.recursiveFirst(where: { $0 is ModelEntity })! as! ModelEntity
        print("model: \(model)")

        let newAnchor = AnchorEntity(world: .zero)
        newAnchor.addChild(robotScene)
        arView.scene.addAnchor(newAnchor)

        // MARK: Camera
        camera.camera.fieldOfViewInDegrees = 60
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        updateCamera()

        // MARK: Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        arView.addGestureRecognizer(panGesture)

        // MARK: Light
        let directionalLight = DirectionalLight()
        directionalLight.light.color = .white
        directionalLight.light.intensity = 5000
        directionalLight.shadow?.maximumDistance = 5
        directionalLight.shadow?.depthBias = 5
        let lightAnchor = AnchorEntity(world: .zero)
        lightAnchor.position = .init(x: 0, y: 20, z: 5)
        directionalLight.look(at: .zero, from: lightAnchor.position, relativeTo: nil)
        lightAnchor.addChild(directionalLight)
        arView.scene.addAnchor(lightAnchor)

        // MARK: Update
        arView.scene
            .publisher(for:  SceneEvents.Update.self)
            .sink { [weak self] (_: SceneEvents.Update) in
                self?.updateCamera()
            }
            .store(in: &cancellables)
    }

    var cameraRotation: Float = 0
    var cameraHeight: Float = 1.7
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: arView)
        sender.setTranslation(.zero, in: arView)
        cameraRotation += Float(translation.x) / -200 * .pi
        cameraHeight += Float(translation.y) / 200
    }

    func updateCamera() {
        let x = sin(cameraRotation) * 2.5
        let z = cos(cameraRotation) * 2.5
        cameraAnchor.position = .init(x: x, y: cameraHeight, z: z)
        camera.look(at: .init(x: 0, y: 1.2, z: 0), from: cameraAnchor.position, relativeTo: nil)
    }
}
