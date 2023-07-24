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
    
    private let animationLogic: ViewModel
    
    private var displayLink: CADisplayLink?
    
    init(animationLogic: ViewModel) {
        self.animationLogic = animationLogic
        
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
        animationLogic.addRecord()
    }
    
    func changeBackgroundPhase(firstHeight: CGFloat, secondHeight: CGFloat) {
        backgroundImageView.frame.origin.y = firstHeight
        copieBackgroundImageView.frame.origin.y = secondHeight
    }
    
    func getHeight() -> CGFloat {
        return view.frame.height
    }
    
    func copieBackgroundIsHidden(isHidden: Bool) {
        copieBackgroundImageView.isHidden = isHidden
    }
    
    func changePlanePhase() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat], animations:  {
            self.animationLogic.updatePlanePhase()
        }) {_ in
            self.animationLogic.changePlanePhase()
            self.animationLogic.updatePlanePhase()
        }
    }
    
    func takeStartingPosition() {
        planeImageView.frame.origin.x = (view.frame.width - Metrics.planeHeight) / 2
    }
    
    func changePlaneImage(imageString: String) {
        planeImageView.image = UIImage(named: imageString)
    }
    
    func changeVisibilityPlane(visibility: Bool) {
        planeImageView.isHidden = !visibility
        view.isUserInteractionEnabled = visibility
    }
    
    @objc private func tick() {
        guard
            let rockLayerFrame = rockImageView.layer.presentation()?.frame,
            let planeLayerFrame = planeImageView.layer.presentation()?.frame
        else {
            return
        }
        
        animationLogic.changePhase(rockLayerFrame: rockLayerFrame, planeLayerFrame: planeLayerFrame)
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
        
        if let planeString = animationLogic.dataSource?.getPlane() {
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
            self.animationLogic.updateBackgroundPhase()
        })
    }
    
    @objc private func viewTouched(gestureRecognizer: UIGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: view)
        
        if touchLocation.x < view.bounds.width / 2 {
            moveOnTap(to: -1)
        } else {
            moveOnTap(to: 1)
        }
    }
    
    private func moveOnTap(to index: CGFloat) {
        let nextFrame = move(to: Metrics.step * index)
        animatedStep(nextFrame: nextFrame)

        if nextFrame.origin.x > view.frame.width * 0.85 || nextFrame.origin.x < view.frame.width * 0.15 {
            changePlanePhase()
        }
    }
    
    private func move(to step: CGFloat) -> CGRect {
        return planeImageView.frame.offsetBy(dx: step, dy: 0)
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
