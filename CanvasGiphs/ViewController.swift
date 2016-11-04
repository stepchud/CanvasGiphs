//
//  ViewController.swift
//  CanvasGiphs
//
//  Created by Stephen Chudleigh on 11/3/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var trayView: UIView!
    
    var startTrayPoint: CGPoint!
    var trayClosedPosition: CGPoint!
    var trayOpenPosition: CGPoint!
    var newFace: UIImageView!
    var newFaceStartPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayOpenPosition = trayView.center
        trayClosedPosition = CGPoint(x: trayView.center.x, y: trayView.center.y + 151)
        trayView.center = trayOpenPosition
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {

        let currentPoint = panGestureRecognizer.translation(in: parentView)
        
        if panGestureRecognizer.state == .began {
            print("Gesture started at: \(currentPoint)")
            startTrayPoint = trayView.center
        } else if panGestureRecognizer.state == .changed {
            print("Gesture changed to: \(currentPoint)")
            trayView.center = CGPoint(x: startTrayPoint.x, y: startTrayPoint.y + currentPoint.y)
        } else if panGestureRecognizer.state == .ended {
            let v = panGestureRecognizer.velocity(in: parentView)
            print("Gesture velocity at: \(v)")
            if v.y > 0 { // closed
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
                    self.trayView.center = self.trayClosedPosition
                    }, completion: { (finished) in
                        
                })
            } else { // opened
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
                    self.trayView.center = self.trayOpenPosition
                    }, completion: { (finished) in
                        
                })
            }
        } else if panGestureRecognizer.state == .cancelled {
            print("Gesture CANCELLED")
        }
    }

    @IBAction func onFacePanGesture(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: parentView)
        
        if sender.state == .began {
            let faceImage = sender.view as! UIImageView
            newFace = UIImageView(image: faceImage.image)
            newFace.isUserInteractionEnabled = true
            newFace.isMultipleTouchEnabled = true
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onFacePinchGesture))
            pinchGestureRecognizer.delegate = self
            newFace.addGestureRecognizer(pinchGestureRecognizer)
            parentView.addSubview(newFace)
            UIView.animate(withDuration: 0.2, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
            newFace.center = faceImage.center
            newFace.center.x += trayView.frame.origin.x
            newFace.center.y += trayView.frame.origin.y
            newFaceStartPoint = newFace.center
        } else if sender.state == .changed {
            newFace.center = CGPoint(x: newFaceStartPoint.x + currentPoint.x,y: newFaceStartPoint.y + currentPoint.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        } else if sender.state == .cancelled {
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func onFacePinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            print("began pinch")
        } else if sender.state == .changed {
            print("changed pinch")
        } else if sender.state == .ended {
            print("ended pinch")
        }
    }
}

