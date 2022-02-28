//
//  MenuBar.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/13.
//

import Tabman

class MenuBar {
    
    typealias BarType = TMBarView<MenuBarLayout, MenuBarButton, TMBarIndicator.None>
    
    static func make() -> TMBar {
        let bar = BarType()
        
        bar.scrollMode = .swipe
        
        bar.buttons.customize { (button) in
            button.tintColor = Colors.primaryTint
            button.unselectedTintColor = Colors.unselectedGray
        }
        
        // Wrap in Navigation Bar
        let navigationBar = bar.systemBar()
        navigationBar.backgroundStyle = .flat(color: .systemBackground)
        return navigationBar
    }
}
