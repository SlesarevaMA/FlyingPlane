//
//  CaseIterable+.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 16.07.2023.
//

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let allCasese = Self.allCases
        let currentIndex = allCasese.firstIndex(of: self)!
        let nextPossibleIndex = allCasese.index(after: currentIndex)
        let nextIndex = nextPossibleIndex == allCasese.endIndex ? allCasese.startIndex : nextPossibleIndex
        
        return allCasese[nextIndex]
    }
}
