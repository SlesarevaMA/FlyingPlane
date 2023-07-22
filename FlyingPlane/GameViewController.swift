//
//  GameViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 15.06.2023.
//

import UIKit
import FirebaseCrashlytics

private enum Metrics {
    static let planeHeight: CGFloat = 100
    static let step: CGFloat = 25
    static let barrierSide: CGFloat = 50
    
    enum Image {
        static let bang = "Bang"
        static let background = "Background"
        static let stone = "Stone"
    }
}

final class GameViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let copieBackgroundImageView = UIImageView()
    private let planeImageView = UIImageView()
    private let rockImageView = UIImageView()
    private let imageView = UIImageView()
    private let someView = UIView()
    
    private var barrierCount = 0
    private var backgroundPhase: Phase = .second
    private var planePhase: PlanePhase = .first
    
    private var displayLink: CADisplayLink?
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addViews()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
        addRockAnimation()
        
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataSource.addRecord(record: barrierCount)
    }
    
    @objc private func tick() {
        guard
            let rockPresentationLayer = rockImageView.layer.presentation(),
            let planePresentationLayer = planeImageView.layer.presentation(),
            planePhase == .first
        else {
            return
        }
        
        if rockPresentationLayer.frame.intersects(planePresentationLayer.frame) {
            UIView.animate(withDuration: 3, delay: 0, options: [.repeat], animations:  {
                self.updatePlanePhase()
            }) {_ in
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        }
        
        if planePresentationLayer.frame.maxY + planeImageView.frame.height <= rockPresentationLayer.frame.maxY {
            barrierCount += 1
        }
    }
        
    private func addViews() {
        [backgroundImageView, copieBackgroundImageView, planeImageView, rockImageView, imageView].forEach {
            view.addSubview($0)
        }
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
        
        if let planeString = dataSource.getPlane() {
            planeImageView.image = UIImage(named: planeString.rawValue)
        }
        planeImageView.contentMode = .scaleToFill
        
        rockImageView.image = UIImage(named: Metrics.Image.stone)
        resetRockFrame()
    }
    
    private func resetRockFrame() {
        rockImageView.frame = CGRect(
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
    }
    
    private func updatePlanePhase() {
        switch planePhase {
        case .first:
            planeImageView.isHidden = false
            view.isUserInteractionEnabled = true
            
            if let planeString = dataSource.getPlane() {
                planeImageView.image = UIImage(named: planeString.rawValue)
            }

        case .second:
            planeImageView.image = UIImage(named: Metrics.Image.bang)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        case .third:
            view.isUserInteractionEnabled = false
            planeImageView.isHidden = true
            planeImageView.frame.origin.x = (view.frame.width - Metrics.planeHeight) / 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        }
    }
    
    private func animatedStep(nextFrame: CGRect) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.planeImageView.frame = nextFrame
        }
    }
    
    private func addRockAnimation() {
        UIView.animate(withDuration: 2,  delay: 0, options: [.curveLinear], animations: {
            self.rockImageView.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            self.resetRockFrame()
            self.addRockAnimation()
        })
    }
}
