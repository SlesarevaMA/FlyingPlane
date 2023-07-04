//
//  Phase.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 18.06.2023.
//

enum Phase: CaseIterable {
    case first
    case second
    case third
    case fourth
}

enum PlanePhase: CaseIterable{
    case first
    case second
    case third
}

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let allCasese = Self.allCases
        let currentIndex = allCasese.firstIndex(of: self)!
        let nextPossibleIndex = allCasese.index(after: currentIndex)
        let nextIndex = nextPossibleIndex == allCasese.endIndex ? allCasese.startIndex : nextPossibleIndex
        
        return allCasese[nextIndex]
    }
}
