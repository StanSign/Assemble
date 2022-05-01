//
//  HapticService.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/01.
//

import UIKit

protocol HapticService {
    
}

final class DefaultHapticService: HapticService {
    static let shared = DefaultHapticService()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationGenerator = UINotificationFeedbackGenerator()
        notificationGenerator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.impactOccurred()
    }
}
