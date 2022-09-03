//
//  ViewController.swift
//  Task5
//
//  Created by neoviso on 9/2/22.
//

import UIKit

class ViewController: UIViewController {

    var circles: [CircleView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawCircles()
    }
    
    private func drawCircles() {
        var number = 1
        while number <= 5 {
            let randomFrame = getRandomFrame()
            let circleView = CircleView(frame: randomFrame)
            guard (circles.filter { $0.isCrossing(circleView) }).isEmpty else { print(false); continue }
            circles.append(circleView)
            number += 1
        }
        for circleView in circles {
            self.view.addSubview(circleView)
        }
    }
    
    private func getRandomFrame() -> CGRect {
        let viewHeight = UIScreen.main.bounds.size.height
        let viewWidth = UIScreen.main.bounds.size.width
        let maxRadius: CGFloat = 50
        let circleSize = CGFloat.random(in: 20...maxRadius)
        let x = CGFloat.random(in: 0...viewWidth-maxRadius)
        let y = CGFloat.random(in: 0...viewHeight-maxRadius)
        
        return CGRect(x: x, y: y, width: circleSize, height: circleSize)
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        if circles.contains(where: { $0.alpha == 1}) {
            for circle in circles {
                let location = touch.location(in: circle)
                if circle.bounds.contains(location) {
                    circle.shrinkAnimation()
                }
            }
        } else if circles.contains(where: { $0.alpha == 0}) {
            for circle in circles {
                if circle.alpha == 0 {
                    circle.zoomAnimation()
                    continue
                }
            }
        }
    }
}

extension UIView {
    func isCrossing(_ view: UIView) -> Bool {
        let firstParams = (midX: Float(self.frame.midX), midY: Float(self.frame.midY), radius: Float(self.frame.width/2))
        let secondParams = (midX: Float(view.frame.midX), midY: Float(view.frame.midY), radius: Float(view.frame.width/2))
        let distance = (firstParams.midX - secondParams.midX, firstParams.midY - secondParams.midY)
        let hypotenuse = sqrtf(powf(distance.0, 2) + powf(distance.1, 2))
        return hypotenuse - (firstParams.radius + secondParams.radius) <= 0 ? true : false
    }
    
    func shrinkAnimation() {
       UIView.animate(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut], animations: {
        self.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
        self.alpha = 0
       }, completion: nil)
   }
   
    func zoomAnimation() {
       UIView.animate(withDuration: 3.0, delay: 0.5, options: [.curveEaseIn], animations: {
        self.transform = .identity
        self.alpha = 1

       }, completion: nil)
   }
}




