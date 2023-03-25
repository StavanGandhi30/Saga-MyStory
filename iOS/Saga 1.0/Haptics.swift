//
//  Haptics.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/21/22.
//

import SwiftUI

func Haptics(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft){
    @AppStorage("applyHaptics") var applyHaptics: Bool = true
    
    if applyHaptics {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
