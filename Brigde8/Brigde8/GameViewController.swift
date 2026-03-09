//
//  GameViewController.swift
//  Brigde8
//
//  Created by anshu Li on 09/03/26.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = view as? SKView {
      // Create the scene programmatically
      let scene = BlueGameScene(size: view.bounds.size)
      scene.scaleMode = .resizeFill
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      view.presentScene(scene)
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
