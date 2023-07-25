//
//  ScreenUpdateTimer.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 25.07.2023.
//

import QuartzCore

protocol ScreenUpdateTimer: AnyObject {
    var didUpdateTime: (() -> Void)? { get set }
    
    func start()
    func stop()
}

final class ScreenUpdateTimerImpl: ScreenUpdateTimer {
    
    var didUpdateTime: (() -> Void)?
    
    private var displayLink: CADisplayLink?
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        displayLink?.remove(from: .main, forMode: .common)
        displayLink = nil
    }
    
    @objc private func tick() {
        didUpdateTime?()
    }
}
