//
//  TabbarViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/8/27.
//

import Foundation

public protocol TabbarViewModelCoordinatorlDelegate: AnyObject {
    func logout()
}

public class TabbarViewModel: NSObject {
    public weak var coordinatorDelegate: TabbarViewModelCoordinatorlDelegate?
    // public init() {
    //
    // }
    public func deleteDataAndLogout() -> Void {
        self.coordinatorDelegate?.logout()
    }
}
