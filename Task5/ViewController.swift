//
//  ViewController.swift
//  Task5
//
//  Created by neoviso on 9/2/22.
//

import UIKit

class ViewController: UIViewController {

    var circles: [CircleView] = []
    var isAnimated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawCircles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAnimationCircles()
    }
    
    private func drawCircles() {
        var number = 1
        while number <= 5 {
            let randomFrame = generateRandomFrame()
            let circleView = CircleView(frame: randomFrame)
            guard (circles.filter { $0.isCrossing(circleView) }).isEmpty else { print(false); continue }
            circles.append(circleView)
            number += 1
        }
        circles.sort(by: { $0.frame.width < $1.frame.width})
        for circleView in circles {
            self.view.addSubview(circleView)
        }
    }
    
    private func generateRandomFrame() -> CGRect {
        let viewHeight = UIScreen.main.bounds.size.height
        let viewWidth = UIScreen.main.bounds.size.width
        let maxRadius: CGFloat = 50
        let circleSize = CGFloat.random(in: 20...maxRadius)
        let x = CGFloat.random(in: 0...viewWidth-maxRadius)
        let y = CGFloat.random(in: 0...viewHeight-maxRadius)
        
        return CGRect(x: x, y: y, width: circleSize, height: circleSize)
    }
    
    private func getAnimationCircles() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            
            if self!.isAnimated {
                for (index, circle) in self!.circles.enumerated() {
                    circle.zoomAnimation(index: index)
                }
                self?.isAnimated = false
                
            } else if self!.circles.isEmpty {
                self?.drawCircles()
                for (index, circle) in self!.circles.enumerated() {
                    circle.zoomAnimation(index: index)
                }
            }
        }
        timer.fire()
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        if circles.contains(where: { $0.alpha == 1}) && self.isAnimated == false{
            for (index, circle) in circles.enumerated() {
                let location = touch.location(in: circle)
                if circle.bounds.contains(location) {
                    circle.shrinkAnimation()
                    circles.remove(at: index)
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
       }, completion: { if $0
        { self.removeFromSuperview() } })
   }
   
    func zoomAnimation(index: Int) {
        let animDuration = 3.5
        self.alpha = 0
        UIView.animate(withDuration: animDuration, delay: animDuration * Double(index), options: [.curveEaseIn], animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: nil)
   }
}




