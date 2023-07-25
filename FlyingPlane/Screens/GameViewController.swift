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

enum BackgroundPosition {
    case top, middle, bottom
}

final class GameViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let secondBackgroundImageView = UIImageView()
    
    private let planeImageView = UIImageView()
    private let rockImageView = UIImageView()
    private let imageView = UIImageView()
    private let someView = UIView()
    
    private let presenter: PresenterImpl
    
    init(presenter: PresenterImpl) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addViews()
        configureViews()
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
        addRockAnimation()
        
        presenter.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.viewDidDisappear()
    }
    
    func changeBackgroundPosition(
        firstBackgroundPosition: BackgroundPosition,
        secondBackgroundPosition: BackgroundPosition
    ) {
        backgroundImageView.frame.origin.y = backgroundLocation(for: firstBackgroundPosition)
        secondBackgroundImageView.frame.origin.y = backgroundLocation(for: secondBackgroundPosition)
    }
    
    func showSecondBackgrund() {
        secondBackgroundImageView.isHidden = false
    }
    
    func hideSecondBackground() {
        secondBackgroundImageView.isHidden = true
    }
    
    func isPlaneCrashed() -> Bool {
        guard
            let rockLayerFrame = rockImageView.layer.presentation()?.frame,
            let planeLayerFrame = planeImageView.layer.presentation()?.frame
        else {
            return false
        }
        
        let planeIntersectsLeftRocks = planeLayerFrame.origin.x < view.frame.width * 0.15
        let planeIntersectsRightRocks = planeLayerFrame.origin.x > view.frame.width * 0.85
        let planeIntersectsRock = rockLayerFrame.intersects(planeLayerFrame)
        
        return planeIntersectsLeftRocks || planeIntersectsRightRocks || planeIntersectsRock
    }
    
    func updateAnimated(animations: @escaping () -> Void, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: animations, completion: { finished in
            completion()
        })
    }
    
    func takeStartingPosition() {
        planeImageView.frame.origin.x = (view.frame.width - Metrics.planeHeight) / 2
    }
    
    func changePlaneImage(imageString: String) {
        planeImageView.image = UIImage(named: imageString)
    }
    
    func changePlaneVisibility(isVisible: Bool) {
        planeImageView.isHidden = !isVisible
        view.isUserInteractionEnabled = isVisible
    }
    
    private func addViews() {
        [backgroundImageView, secondBackgroundImageView, planeImageView, rockImageView, imageView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureViews() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTouched)))
        
        let backgroundImage = UIImage(named: Metrics.Image.background)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleToFill
        
        secondBackgroundImageView.image = backgroundImage

        secondBackgroundImageView.frame = CGRect(
            x: backgroundImageView.frame.origin.x,
            y: -backgroundImageView.frame.height,
            width: backgroundImageView.frame.width,
            height: backgroundImageView.frame.height
        )
        secondBackgroundImageView.contentMode = .scaleToFill
        
        planeImageView.frame = CGRect(
            x: (view.frame.width - Metrics.planeHeight) / 2,
            y: view.frame.height * 0.8 - Metrics.planeHeight / 2,
            width: Metrics.planeHeight,
            height: Metrics.planeHeight
        )
        
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
    
    private func backgroundLocation(for position: BackgroundPosition) -> CGFloat {
        let height = view.frame.height
        
        switch position {
        case .top:
            return -height
        case .middle:
            return 0
        case .bottom:
            return height
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.presenter.updateBackgroundPhase()
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
    }
    
    private func move(to dx: CGFloat) -> CGRect {
        return planeImageView.frame.offsetBy(dx: dx, dy: 0)
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
