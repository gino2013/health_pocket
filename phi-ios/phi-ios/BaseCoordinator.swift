//
//  BaseCoordinator.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    func start() {}
}
