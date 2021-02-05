//
//  ARViewViewController.swift
//  SmithonianDemo
//
//  Created by Jack Dempsey on 5/25/20.
//  Copyright © 2020 JackDempsey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

// var picHelper = pictureHelper.init()

class ARViewViewController: UIViewController,  ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBAction func arBack(_ sender: Any) {
        print("pressed Back")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .vertical
            
            sceneView.session.run(configuration)
        }
    
    func displayImage(pictureIndex: Int){
        // get image info in list and put it in the scene
        
        let tiffURL = picHelper.paintings[pictureIndex].tiffSource
        let tiffString = tiffURL.absoluteString
        picHelper.fetchImage(from: tiffString){ (imageData) in
        if let data = imageData {
            // referenced imageView from main thread
            // as iOS SDK warns not to use images from
            // a background thread
            DispatchQueue.main.async {
                let image = UIImage(data: data)!
                let planeGeometry = SCNPlane(width: 0.5, height: 0.5)
                planeGeometry.firstMaterial?.diffuse.contents = image
                
                let planeNode = SCNNode()
                planeNode.geometry = planeGeometry
                self.sceneView.scene.rootNode.addChildNode(planeNode)
                planeNode.position = SCNVector3(0, 0, -0.5)
            }
        } else {
                // show as an alert if you want to
            print("Error loading image");
        }
    }
}
    
    @IBAction func tappedScreen(_ sender: Any) {
        print("Tapped ARVIEW")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 284)
        label.text = "You Pressed the Screen!"
        self.view.addSubview(label)
        
        displayImage(pictureIndex: picHelper.tappedRow)
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
