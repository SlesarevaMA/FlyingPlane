//
//  Presenter.swift
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

protocol Presenter {
    var view: GameViewController? { get }
}

final class PresenterImpl {
    
    weak var view: GameViewController?
    
    private let settingsRepository: SettingsRepository
    private let recordsRepository: RecordsRepository
    private let timer: ScreenUpdateTimer
    
    private var isUpdatingPhase = false
    private var planePhase: PlanePhase = .first
    private var backgroundPhase: Phase = .second
    private var currentScore = 0
    
    init(settingsRepository: SettingsRepository, recordsRepository: RecordsRepository, timer: ScreenUpdateTimer) {
        self.settingsRepository = settingsRepository
        self.recordsRepository = recordsRepository
        self.timer = timer
    }
    
    func viewDidLoad() {
        if let plane = settingsRepository.getPlane() {
            view?.changePlaneImage(imageString: plane.rawValue)
        }
    }
    
    func viewDidAppear() {
        guard let speed = settingsRepository.getSpeed() else {
            return
        }
        
        switch speed {
        case .slow:
            view?.speed = 2
        case .average:
            view?.speed = 1
        case .high:
            view?.speed = 0.5
        }
        
        timer.start()
        timer.didUpdateTime = { [weak self] in
            self?.timeUpdated()
        }
    }
    
    func viewDidDisappear() {
        timer.stop()
        
        currentScore = view?.score ?? 0
        let person = settingsRepository.getPerson() ?? ""
        
        recordsRepository.addRecord(name: person, score: currentScore)
    }
        
    func updateBackgroundPhase() {
        guard let view else {
            return
        }
        
        switch backgroundPhase {
        case .first:
            view.hideSecondBackground()
            view.changeBackgroundPosition(firstBackgroundPosition: .middle, secondBackgroundPosition: .top)
            backgroundPhase = backgroundPhase.next()
        case .second:
            view.showSecondBackgrund()
            view.changeBackgroundPosition(firstBackgroundPosition: .bottom, secondBackgroundPosition: .middle)
            backgroundPhase = backgroundPhase.next()
        case .third:
            view.changeBackgroundPosition(firstBackgroundPosition: .top, secondBackgroundPosition: .middle)
            backgroundPhase = backgroundPhase.next()
        case .fourth:
            view.changeBackgroundPosition(firstBackgroundPosition: .middle, secondBackgroundPosition: .bottom)
            backgroundPhase = backgroundPhase.next()
        }
    }
    
    private func updatePlanePhase() {
        isUpdatingPhase = true
        
        planePhase = planePhase.next()
        
        switch planePhase {
        case .first:
            view?.changePlaneVisibility(isVisible: true)
            
            if let plane = settingsRepository.getPlane() {
                view?.changePlaneImage(imageString: plane.rawValue)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isUpdatingPhase = false
            }
        case .second:
            view?.changePlaneImage(imageString: Metrics.Image.bang)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.updatePlanePhase()
            }
        case .third:
            view?.updateAnimated(animations: {
                self.view?.changePlaneVisibility(isVisible: true)
                self.view?.takeStartingPosition()
            }, completion: {
                self.updatePlanePhase()
            })
        }
    }

    private func timeUpdated() {
        guard !isUpdatingPhase, planePhase == .first else {
            return
        }
        
        if view?.isPlaneCrashed() ?? false {
            updatePlanePhase()
        }
    }
}
