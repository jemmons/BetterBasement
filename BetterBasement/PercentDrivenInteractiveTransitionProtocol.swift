//
//  PercentDrivenInteractiveTransitionProtocol.swift
//  BetterBasement
//
//  Created by mrJacob on 11/25/14.
//  Copyright (c) 2014 Reverb. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PercentDrivenInteractiveTransitionProtocol {
    func panGestureBegan()
    func percentForPanGestureChanged(panGesture : UIPanGestureRecognizer) -> Float
    func shouldPanGestureFinish(panGesture : UIPanGestureRecognizer) -> Bool

    func setNeedsStatusBarAppearanceUpdate()
    
    func beginInteractiveTransition()
    func moveToIntermediaryPercentage(percentage : Float)
    func endInteractiveTransition()
}
