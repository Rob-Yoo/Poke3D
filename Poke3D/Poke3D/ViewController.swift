//
//  ViewController.swift
//  Poke3D
//
//  Created by Jinyoung Yoo on 2023/07/14.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        guard let trackingImage = ARReferenceImage.referenceImages(inGroupNamed: "Card", bundle: Bundle.main) else {
            return
        }
        configuration.trackingImages = trackingImage
        configuration.maximumNumberOfTrackedImages = 2

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        if imageAnchor.referenceImage.name == "card1" {
            let eeveeNode = makeEeveeNode()!
            eeveeNode[0].transform = SCNMatrix4MakeRotation(GLKMathDegreesToRadians(90), 1, 0, 0)
            eeveeNode[0].scale = SCNVector3(0.001, 0.001, 0.001)
            
            node.addChildNode(eeveeNode[0])
            node.addChildNode(eeveeNode[1])
        }

        if imageAnchor.referenceImage.name == "card2" {
            let pikachuNode = makePikachuNode()!
            pikachuNode[0].transform = SCNMatrix4MakeRotation(GLKMathDegreesToRadians(90), 1, 0, 0)
            pikachuNode[0].scale = SCNVector3(0.001, 0.001, 0.001)
            
            node.addChildNode(pikachuNode[0])
            node.addChildNode(pikachuNode[1])
        }
        return node
    }
    
    // MARK: - Feature Methods
    
    func makePikachuNode() -> [SCNNode]? {
        guard let pikachuScene = SCNScene(named: "art.scnassets/Pikachu/Pikachu.scn") else {
            print("Here")
            return nil
        }
        if let pikachuNode = pikachuScene.rootNode.childNode(withName: "pikachu", recursively: true) {
            if let pikachuFNode = pikachuScene.rootNode.childNode(withName: "PikachuF", recursively: true) {
                return [pikachuNode, pikachuFNode]
            }
        }
        
        return nil
    }
    
    func makeEeveeNode() -> [SCNNode]? {
        guard let eeveeScene = SCNScene(named: "art.scnassets/Eevee/Eevee.scn") else {
            print("Here")
            return nil
        }
        if let eeveeNode = eeveeScene.rootNode.childNode(withName: "Eevee", recursively: true) {
            if let eeveeFNode = eeveeScene.rootNode.childNode(withName: "EeveeF", recursively: true) {
                return [eeveeNode, eeveeFNode]
            }
        }
        
        return nil
    }
}
