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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAnimationCircles()
    }
    
    private func drawCircles() {
        var number = 1
        while number <= 20 {
            let randomFrame = generateRandomFrame()
            let circleView = CircleView(frame: randomFrame)
            guard (circles.filter { $0.isCrossing(circleView) }).isEmpty else { print(false); continue }
            
            circleView.layer.cornerRadius = circleView.frame.width / 2
            
            circleView.layer.masksToBounds = true
            circleView.backgroundColor = .random
            
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
        let timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
            
            guard let self = self else { return }
            
            for (index, circle) in self.circles.enumerated() {
                self.zoomAnimation(circle: circle, index: index)
            }
        }
        timer.fire()
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        if circles.contains(where: { $0.alpha == 1}) {
            for (index, circle) in circles.enumerated() {
                let location = touch.location(in: circle)
                if circle.bounds.contains(location) {
                    shrinkAnimation(circle: circle)
                    circles.remove(at: index)
                }
            }
        }
    }
}

extension ViewController {
    func shrinkAnimation(circle: CircleView) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
            circle.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
            circle.alpha = 0
        }, completion: { if $0
        { circle.removeFromSuperview() }
        if self.circles.isEmpty {
            self.drawCircles()
            for (index, circle) in self.circles.enumerated() {
                self.zoomAnimation(circle: circle, index: index)
            }
        }
        })
    }
    
    func zoomAnimation(circle: CircleView, index: Int) {
        let animDuration = 0.2
        circle.alpha = 0
        UIView.animate(withDuration: animDuration, delay: animDuration * Double(index), options: [.curveEaseIn], animations: {
            circle.transform = .identity
            circle.alpha = 1
        }, completion: nil)
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
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1), alpha: 1.0)
    }
}









