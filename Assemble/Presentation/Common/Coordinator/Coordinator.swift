//
//  Coordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/08.
//

import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    // 모든 coordinator는 하나의 navCon을 필수적으로 갖는다
    var navigationController: UINavigationController { get set }
    // child coordinator를 보관하기 위한 배열
    var childCoordinators: [Coordinator] { get set }
    // Type
    var type: CoordinatorType { get }
    // Coordinator를 시작하기 위한 함수
    func start()
    // child coordinator들을 제거, parent coordinator에게 delloc 알림
    func finish()
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

//MARK: - Coordinator Output

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
