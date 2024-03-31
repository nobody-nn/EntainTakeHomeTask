//
//  UIViewController+Present.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/26.
//

import SwiftUI

extension UIViewController {
    
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
    func presentInKeyWindowPresentedController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindowPresentedController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
}
