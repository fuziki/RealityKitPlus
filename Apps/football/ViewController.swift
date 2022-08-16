//
//  ViewController.swift
//  
//  
//  Created by fuziki on 2022/08/15
//  
//

import Combine
import RealityKit
import RealityKitPlus
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var controller: ControllerView!

    let camera = PerspectiveCamera()
    let cameraAnchor = AnchorEntity(world: .zero)

    var targetPlayerRot: Float = 0
    var player: HasPhysics!

    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        arView.cameraMode = .nonAR

        let scene = try! Football.loadBox()

        player = scene.player! as? HasPhysics
        print("player: \(player!)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.player.physicsBody!.mode = .kinematic
        }

        let newAnchor = AnchorEntity(world: .zero)
        newAnchor.addChild(scene)
        arView.scene.addAnchor(newAnchor)

        setupSkybox()
        setupLight()
        setupCamera()

        arView.scene
            .publisher(for:  SceneEvents.Update.self)
            .sink { [weak self] (u: SceneEvents.Update) in
                self?.updatePlayer(deltaTime: u.deltaTime)
                self?.updateCamera()
            }
            .store(in: &cancellables)
    }

    func updatePlayer(deltaTime: TimeInterval) {
        let p = controller.joyStick

        var current = player.transform.rotation.angle
        if player.transform.rotation.axis.y < 0 {
            current *= -1
        }
        if abs(p.x) > 0 || abs(p.y) > 0 {
            targetPlayerRot = atan2(-p.x, -p.y)
        }
        let diff = angleDiff(a: current, b: targetPlayerRot)
        player.physicsMotion!.angularVelocity = .init(x: 0, y: diff / Float(deltaTime) * 0.5, z: 0)
        player.physicsMotion!.linearVelocity = .init(x: p.x * -1, y: 0, z: p.y * -1)
    }

    // MARK: - Skybox
    func setupSkybox() {
        // https://developer.apple.com/documentation/realitykit/environmentresource
        let skybox = try! EnvironmentResource.load(named: "alps_field_1k")
        arView.environment.background = .skybox(skybox)
    }

    // MARK: - Light
    func setupLight() {
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
    }

    // MARK: - Camera
    func setupCamera() {
        camera.camera.fieldOfViewInDegrees = 60
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        updateCamera()
    }

    func updateCamera() {
        cameraAnchor.position = player.position + .init(x: 0, y: 1.5, z: -2)
        camera.look(at: player.position,
                    from: cameraAnchor.position,
                    relativeTo: nil)
    }
}
