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
        
       configureLighting()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
    }
    
       
    @objc func handleTap(sender:UITapGestureRecognizer) {
        print("TOUCHED")
        resetTrackingConfiguration()
        
    }
    
    @objc func didTapScreen(rec: UITapGestureRecognizer) {
        print("lol")
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                print(hits.count)
                tappedNode?.removeFromParentNode()
                print(tappedNode)
                
            }else{
                resetTrackingConfiguration()
            }
        }
    }
    
    func create3dObject(name:String)->SCNNode{
        // Create a new scene
        let scene = SCNScene(named: name)!
        // This node will be parent of all the animation models
        let node = SCNNode()
        // Add all the child nodes to the parent node
        for child in scene.rootNode.childNodes {
            node.addChildNode(child)
        }
        // Set up some properties
              
        node.scale = SCNVector3(0.0009, 0.0009, 0.0009)
        // Add the node to the scene
        //sceneView.scene.rootNode.addChildNode(node)
        return node
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        //createOverlayView(imageName:"putin")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
   //1. Starte Tracking
   func resetTrackingConfiguration() {
        //1 a. Configuration
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        //1 b. Start now ..
        sceneView.session.run(configuration, options: options)
        print("Move camera around to detect images")
       
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("tracking")
        DispatchQueue.main.async {
            print("OOO")
            guard let imageAnchor = anchor as? ARImageAnchor,
                        let imageName = imageAnchor.referenceImage.name else { return }
            
            
            
            let planeNode = self.getPlaneNode(withReferenceImage: imageAnchor.referenceImage)
            
                          planeNode.eulerAngles.x = -.pi / 2
            
                          
            if(imageName == "michi"){
               node.addChildNode(self.create3dObject(name:"dancingWoman.dae"))
                
            }else{
                
            
            
            
                             
                                node.addChildNode(planeNode)
            if(imageName == "reset") {
                  planeNode.opacity = 1
             planeNode.geometry!.firstMaterial!.diffuse.contents = self.createOverlayView()
            }
            
            if(imageName == "putin") {
                       planeNode.geometry!.firstMaterial!.diffuse.contents = self.createOverlayImage()
                      }
            }
            print("Image detected: \"\(imageName)\"")
        }
    }
    
    func createOverlayView()->UIView{
           var outputView:UIView =  UIView(frame: CGRect(x: 0,y: 0,width: 150,height: 150))
           
         
                        outputView.backgroundColor = UIColor.red
                         


           
           return outputView
       }
    
    
    
    func createOverlayImage()->UIImageView{
        var outputView:UIImageView! //= UIView(frame: CGRect(x: 0,y: 0,width: 150,height: 150))
        
      
                        //outputView.backgroundColor = UIColor.clear
                       let img = UIImage(named: "skull.png")

                       outputView = UIImageView(frame: CGRect(x: 0,y: 0,width: 150,height: 150))
                                    outputView.image = img

        
        return outputView
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
          let plane = SCNPlane(width: image.physicalSize.width,
                               height: image.physicalSize.height)
          let node = SCNNode(geometry: plane)
          return node
      }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
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
