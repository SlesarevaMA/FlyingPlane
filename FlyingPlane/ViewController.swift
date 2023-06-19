//
//  ViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 15.06.2023.
//

import UIKit

private enum Metrics {
    static let planeHeight: CGFloat = 120
    static let step: CGFloat = 25
    static let barrierSide: CGFloat = 50
    
    enum Image {
        static let plane = "Plane"
        static let bang = "Bang"
        static let background = "Background"
        static let stone = "Stone"
    }
}

final class ViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let copieBackgroundImageView = UIImageView()
    private let planeImageView = UIImageView()
    private let barrierImageView = UIImageView()
    
    private var backgroundPhase: Phase = .second
    private var planePhase: Phase = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
        addBarrierAnimate()
    }
        
    private func addViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(copieBackgroundImageView)
        view.addSubview(planeImageView)
        view.addSubview(barrierImageView)
    }
    
    private func configureViews() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTouched)))
        
        backgroundImageView.image = UIImage(named: Metrics.Image.background)
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleToFill
        
        guard let cgImage = UIImage(named: Metrics.Image.background)?.cgImage else {
            return
        }
        
        copieBackgroundImageView.image = UIImage(
            cgImage: cgImage,
            scale: 1,
            orientation: .up
        )
        copieBackgroundImageView.frame = CGRect(
            x: backgroundImageView.frame.origin.x,
            y: -backgroundImageView.frame.height,
            width: backgroundImageView.frame.width,
            height: backgroundImageView.frame.height
        )
        copieBackgroundImageView.contentMode = .scaleToFill
        
        planeImageView.frame = CGRect(
            x: (view.frame.width - Metrics.planeHeight) / 2,
            y: view.frame.height * 0.8 - Metrics.planeHeight / 2,
            width: Metrics.planeHeight,
            height: Metrics.planeHeight
        )
        planeImageView.image = UIImage(named: Metrics.Image.plane)
        planeImageView.contentMode = .scaleToFill
        
        barrierImageView.image = UIImage(named: Metrics.Image.stone)
        barrierImageView.frame = CGRect(
            x: CGFloat.random(in: view.frame.width * 0.25 ..< view.frame.width * 0.75),
            y: 0,
            width: Metrics.barrierSide,
            height: Metrics.barrierSide
        )
    }
    
    private func animate() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.updateBackgroundPhase()
        }) { _ in
            self.backgroundPhase = self.backgroundPhase.next()
        }
    }
    
    private func updateBackgroundPhase() {
        switch backgroundPhase {
        case .first:
            copieBackgroundImageView.isHidden = true
            backgroundImageView.frame.origin.y = 0
            copieBackgroundImageView.frame.origin.y = -backgroundImageView.frame.height
        case .second:
            copieBackgroundImageView.isHidden = false
            copieBackgroundImageView.frame.origin.y = 0
            backgroundImageView.frame.origin.y = view.frame.height
        case .third:
            backgroundImageView.frame.origin.y = -backgroundImageView.frame.height
            copieBackgroundImageView.frame.origin.y = 0
        case .fourth:
            backgroundImageView.frame.origin.y = 0
            copieBackgroundImageView.frame.origin.y = backgroundImageView.frame.height
        }
    }
    
    @objc private func viewTouched(gestureRecognizer: UIGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: view)
        
        if touchLocation.x < view.bounds.width / 2 {
            left()
        } else {
            right()
        }
    }
    
    private func right() {
        let nextFrame = planeImageView.frame.offsetBy(dx: Metrics.step, dy: 0)
        
        animatedStep(nextFrame: nextFrame)

        if nextFrame.maxX > view.frame.width * 0.85 {
            UIView.animate(withDuration: 3, delay: 0, options: [.repeat], animations: {
                self.updatePlanePhase()
            }) {_ in
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        }
        
//        if ((barrierImageView.layer.presentation()?.frame.intersects(planeImageView.frame)) != nil) {
//            planeImageView.image = UIImage(named: Metrics.Image.bang)
//        }
    }
    
    private func left() {
        let nextFrame = planeImageView.frame.offsetBy(dx: -Metrics.step, dy: 0)
        
        animatedStep(nextFrame: nextFrame)

        if nextFrame.minX < view.frame.width * 0.15 {
            UIView.animate(withDuration: 3, delay: 0, options: [.repeat], animations:  {
                self.updatePlanePhase()
            }) {_ in
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        }
        
//        if ((barrierImageView.layer.presentation()?.frame.intersects(planeImageView.layer.presentation()!.frame)) != nil) {
//            planeImageView.image = UIImage(named: Metrics.Image.bang)
//        }
    }
    
    private func updatePlanePhase() {
        switch planePhase {
        case .first:
            planeImageView.image = UIImage(named: Metrics.Image.plane)
        case .second:
            planeImageView.image = UIImage(named: Metrics.Image.bang)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        case .third:
            view.isUserInteractionEnabled = false
            self.planeImageView.isHidden = true
            planeImageView.frame.origin.x = (view.frame.width - Metrics.planeHeight) / 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        case .fourth:
            self.planeImageView.isHidden = false
            view.isUserInteractionEnabled = true
            self.planeImageView.image = UIImage(named: Metrics.Image.plane)
        }
    }
    
    private func animatedStep(nextFrame: CGRect) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.planeImageView.frame = nextFrame
        }
    }
    
    private func addBarrierAnimate() {
        UIView.animate(withDuration: 2,  delay: 0, options: [.repeat, .curveLinear]) {
            self.barrierImageView.frame.origin.y = self.view.frame.height
        }
    }
}
