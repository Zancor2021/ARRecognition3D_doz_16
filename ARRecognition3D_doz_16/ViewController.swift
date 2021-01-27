//
//  ViewController.swift
//  ARRecognition3D_doz_16
//
//  Created by Alexander Hoch on 27.01.21.
//  Copyright © 2021 zancor. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var ballNode:SCNNode! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ball.dae")!
            ballNode = scene.rootNode.childNode(withName: "ball", recursively: false)
        let scaleFactor = 0.1
        ballNode!.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        ballNode!.position = SCNVector3(0, 0, -1)
        // Set the scene to the view
        sceneView.scene = scene
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
    }
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        print("LOL")
       guard let sceneView = sender.view as? ARSCNView else {return}
       let touchLcoation = sender.location(in: sceneView)
        print(touchLcoation.x)
        print(touchLcoation.y)
        print(ballNode.position.x)
        print(ballNode.position.y)
       let hitTestResult = self.sceneView.hitTest(touchLcoation, types: .existingPlane)
        print(hitTestResult)
        
        if !hitTestResult.isEmpty {
            // add something to scene
            // e.g self.sceneView.scene.rootNode.addChildNode(yourNode!)
            
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
