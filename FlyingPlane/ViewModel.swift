//
//  ViewModel.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 22.07.2023.
//

import Foundation

private enum Metrics {
    static let planeHeight: CGFloat = 100
    
    enum Image {
        static let bang = "Bang"
    }
}

final class ViewModel {
    private var barrierCount = 0
    private var backgroundPhase: Phase = .second
    private var planePhase: PlanePhase = .first
    
    weak var view: GameViewController?
    var dataSource: DataSource?
        
    func updateBackgroundPhase() {
        guard let height = view?.getHeight() else {
            return
        }
        
        switch backgroundPhase {
        case .first:
            view?.copieBackgroundIsHidden(isHidden: true)
            view?.changeBackgroundPhase(firstHeight: 0, secondHeight: -height)
            backgroundPhase = backgroundPhase.next()
        case .second:
            view?.copieBackgroundIsHidden(isHidden: false)
            view?.changeBackgroundPhase(firstHeight: height, secondHeight: 0)
            backgroundPhase = backgroundPhase.next()
        case .third:
            view?.changeBackgroundPhase(firstHeight: -height, secondHeight: 0)
            backgroundPhase = backgroundPhase.next()
        case .fourth:
            view?.changeBackgroundPhase(firstHeight: 0, secondHeight: height)
            backgroundPhase = backgroundPhase.next()
        }
    }
    
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
    
    func changePlanePhase() {
        planePhase = planePhase.next()
    }
    
    func addRecord() {
        dataSource?.addRecord(record: barrierCount)
    }
}
