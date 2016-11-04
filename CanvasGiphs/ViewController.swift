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
    @IBOutlet weak var trayArrow: UIImageView!
    
    var startTrayPoint: CGPoint!
    var trayClosedPosition: CGPoint!
    var trayOpenPosition: CGPoint!
    var newFace: UIImageView!
    var newFaceStartPoint: CGPoint!
    var facePanStartPoint: CGPoint!
    
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
            if panGestureRecognizer.velocity(in: parentView).y > 0 {
                print("Gesture changed to: closing")
                self.trayArrow.transform.rotated(by: 0)
            } else {
                print("Gesture changed to: opening")
                self.trayArrow.transform.rotated(by: CGFloat(M_PI))
            }
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
            
        }
    }

    @IBAction func onFacePanGesture(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: parentView)
        
        if sender.state == .began {
            let faceImage = sender.view as! UIImageView
            newFace = UIImageView(image: faceImage.image)
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanFace))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onFacePinchGesture))
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(onFaceRotateGesture))
            pinchGestureRecognizer.delegate = self
            rotateGestureRecognizer.delegate = self
            newFace.isUserInteractionEnabled = true
            newFace.isMultipleTouchEnabled = true
            newFace.addGestureRecognizer(panGesture)
            newFace.addGestureRecognizer(pinchGestureRecognizer)
            newFace.addGestureRecognizer(rotateGestureRecognizer)
            parentView.addSubview(newFace)
            UIView.animate(withDuration: 0.2, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
            newFace.center = faceImage.center
            newFace.center.x += trayView.frame.origin.x
            newFace.center.y += trayView.frame.origin.y
            newFaceStartPoint = newFace.center
        } else if sender.state == .changed {
            newFace.center = CGPoint(x: newFaceStartPoint.x + currentPoint.x,y: newFaceStartPoint.y + currentPoint.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else if sender.state == .cancelled {
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didPanFace(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: parentView)
        let currentFace = sender.view as! UIImageView
        let currentTransform = currentFace.transform
        
        if sender.state == .began {
            facePanStartPoint = currentFace.center
            print("started at \(facePanStartPoint)")
            UIView.animate(withDuration: 0.2, animations: {
                currentFace.transform = CGAffineTransform(scaleX: 1.5*currentTransform.a, y: 1.5*currentTransform.d)
            })
        } else if sender.state == .changed {
            print("pan changed to \(currentPoint)")
            sender.view!.center = CGPoint(x: facePanStartPoint.x + currentPoint.x, y: facePanStartPoint.y + currentPoint.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                currentFace.transform = CGAffineTransform(scaleX: currentTransform.a*2/3, y: currentTransform.d*2/3)
            })
        }
    }
    
    func onFacePinchGesture(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
        
        if sender.state == .began {
            print("began pinch")
        } else if sender.state == .changed {
            print("changed pinch")
        } else if sender.state == .ended {
            print("ended pinch")
        }
    }
    
    func onFaceRotateGesture(_ sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.rotated(by: rotation)
        sender.rotation = 0
        
        if sender.state == .began {
            print("began rotate")
        } else if sender.state == .changed {
            print("changed rotate")
        } else if sender.state == .ended {
            print("ended rotate")
        }
    }
}

