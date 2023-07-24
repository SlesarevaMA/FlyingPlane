//
//  AnimationLogic.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 22.07.2023.
//

import UIKit

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

final class AnimationLogic {
    var barrierCount = 0
    var backgroundPhase: Phase = .second
    var planePhase: PlanePhase = .first
    
    weak var view: GameViewController?
    var dataSource: DataSource?
        
    func changePhase(rockLayerFrame: CGRect, planeLayerFrame: CGRect) {
        guard
            planePhase == .first
        else {
            return
        }

        if rockLayerFrame.intersects(planeLayerFrame) {
            view?.changePlanePhase()
        }

        if planeLayerFrame.maxY + Metrics.planeHeight <= rockLayerFrame.maxY {
            barrierCount += 1
        }
    }
    
    func updatePlanePhase() {
        switch planePhase {
        case .first:

            view?.changeVisibilityPlane(visibility: true)


            if let planeString = dataSource?.getPlane() {
                view?.changePlaneImage(imageString: planeString.rawValue)
            }

        case .second:
            view?.changePlaneImage(imageString: Metrics.Image.bang)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        case .third:
            view?.changeVisibilityPlane(visibility: true)

            view?.takeStartingPosition()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.planePhase = self.planePhase.next()
                self.updatePlanePhase()
            }
        }
    }
}
