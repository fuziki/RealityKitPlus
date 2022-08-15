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

        // MARK: Robot Scene
        let robotScene: ProjectRobot.RobotScene = try! ProjectRobot.loadRobotScene()
        print("robotScene: \(robotScene)")

        let robot: RealityKit.Entity = robotScene.robot!
        setupRobot(robot: robot)

        let jupiter = robotScene.jupiter!
        setupJupiter(jupiter: jupiter)

        let saturn = robotScene.saturn!
        seupSaturn(saturn: saturn)

        let newAnchor = AnchorEntity(world: .zero)
        newAnchor.addChild(robotScene)
        arView.scene.addAnchor(newAnchor)

        // MARK: Misc
        setupSkybox()
        setupCamera()
        setupLight()

        // MARK: Update
        arView.scene
            .publisher(for:  SceneEvents.Update.self)
            .sink { [weak self] (_: SceneEvents.Update) in
                self?.updateCamera()
            }
            .store(in: &cancellables)
    }

    // MARK: - Use Custom Material
    func setupRobot(robot: Entity) {
        print("robot: \(robot)")

        let robotModel = robot.children.recursiveFirst(where: { $0 is ModelEntity })! as! ModelEntity
        print("robotModel: \(robotModel)")

        // MARK: CustomMaterial
        print("mesh: \(robotModel.model!.mesh)")
        for (i, m) in robotModel.model!.materials.enumerated() {
            print("material \(i): \(m)")
        }
        let device = MTLCreateSystemDefaultDevice()!
        let library = device.makeDefaultLibrary()!
        let surfaceShader = CustomMaterial.SurfaceShader(named: "mySurfaceShader", in: library)
        let geometryModifier = CustomMaterial.GeometryModifier(named: "emptyGeometryModifier", in: library)
        robotModel.model!.materials = robotModel.model!.materials.map { (material: Material) -> Material in
            let physically = material as! PhysicallyBasedMaterial
//            let new = try! CustomMaterial(from: material, surfaceShader: surfaceShader)
            var custom = try! CustomMaterial(surfaceShader: surfaceShader,
                                             geometryModifier: geometryModifier,
                                             lightingModel: .lit)
            custom.baseColor.tint = .init(red: 1, green: 1, blue: 1, alpha: 1)
            custom.custom.texture = .init(physically.baseColor.texture!.resource)
//            custom.blending = .transparent(opacity: 1.0)
            return custom
        }
    }

    // MARK: - Use Unlit Material
    func setupJupiter(jupiter: Entity) {
        print("jupiter: \(jupiter)")
        arView.installGestures(.all, for: jupiter as! HasCollision)

        let jupiterModels = jupiter.children.recursiveCompactMap { $0 as? ModelEntity }
        print("jupiterModels: \(jupiterModels)")
        for jupiterModel in jupiterModels {
            jupiterModel.model!.materials = jupiterModel.model!.materials.map { (material: Material) -> Material in
                let physically = material as! PhysicallyBasedMaterial
                var unlit = UnlitMaterial()
                unlit.color = physically.baseColor
                unlit.blending = .opaque
                return unlit
            }
        }
    }

    // MARK: - Modify Materials
    func seupSaturn(saturn: Entity) {
        print("saturn: \(saturn)")
        let saturnModels = saturn.children.recursiveCompactMap { $0 as? ModelEntity }
        print("saturnModels: \(saturnModels)")
        for saturnModel in saturnModels {
            saturnModel.model!.materials = saturnModel.model!.materials.map { (material: Material) -> Material in
                var physically = material as! PhysicallyBasedMaterial
                physically.metallic.scale = 1
                return physically
            }
        }
    }

    // MARK: - Skybox
    func setupSkybox() {
        // https://developer.apple.com/documentation/realitykit/environmentresource
        let skybox = try! EnvironmentResource.load(named: "alps_field_1k")
        arView.environment.background = .skybox(skybox)
    }

    // MARK: - Camera
    func setupCamera() {
        camera.camera.fieldOfViewInDegrees = 60
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        updateCamera()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        arView.addGestureRecognizer(panGesture)
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
}
