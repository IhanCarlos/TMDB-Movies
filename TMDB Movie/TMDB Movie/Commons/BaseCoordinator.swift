//
//  BaseCoordinator.swift
//  TMDB Movie
//
//  Created by ihan carlos on 15/04/26.
//

import Foundation
import UIKit

open class BaseCoordinator {

    public weak var parentCoordinator: BaseCoordinator?
    public private(set) var childCoordinators: [BaseCoordinator] = []

    public init() {}

    open func start() {
        preconditionFailure("This method needs to be overridden by concrete subclass.")
    }

    open func finish() {
        guard let parentCoordinator = parentCoordinator else {
            preconditionFailure(
                """
                ParentCoordinator must be not equal to nil or this method needs to be overridden by a concrete subclass.
                """
            )
        }
        removeAllChildCoordinators()
        parentCoordinator.removeChildCoordinator(self)
    }

    open func finishParent() {
        guard let parentCoordinator = parentCoordinator else {
            preconditionFailure(
                """
                ParentCoordinator must be not equal to nil or this method needs to be overridden by a concrete subclass.
                """
            )
        }
        parentCoordinator.finish()
    }

    public func addChildCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }

    public func insertChildCoordinatorIfNeeded(_ coordinator: BaseCoordinator, atPosition position: Int) {
        guard position < childCoordinators.count else { return }
        childCoordinators.insert(coordinator, at: position)
    }

    public func removeChildCoordinator(_ coordinator: BaseCoordinator) {
        if let index = childCoordinators.lastIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }

    public func removeAllCoordinators(_ coordinator: BaseCoordinator) {
        childCoordinators.removeAll(where: { $0 == coordinator })
    }

    public func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == false }
    }

    public func removeAllChildCoordinatorsBut<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == true }
    }

    public func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }

    public func removeChildCoordinatorsButFirst() {
        let coordinator = childCoordinators.first
        childCoordinators.removeAll(where: { coordinator != $0 })
    }

    public func removeAllChildCoordinatorsUntil<T>(type: T.Type) {
        for coordinator in childCoordinators.reversed() {
            if coordinator.self is T { break }
            removeChildCoordinator(coordinator)
        }
    }
}

extension BaseCoordinator: Equatable {
    public static func == (lhs: BaseCoordinator, rhs: BaseCoordinator) -> Bool {
        lhs === rhs
    }
}
