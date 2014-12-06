//
//  PercentDrivenInteractiveTransition.swift
//  BetterBasement
//
//  Created by mrJacob on 11/25/14.
//  Copyright (c) 2014 Reverb. All rights reserved.
//

import UIKit

public class PercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition {
    public var panGestureIsActive : Bool = false
    
    private var panGestureView : UIView
    private let panGesture : UIPanGestureRecognizer!
    private var targetViewController : MenuController
    private var presentingViewController : UIViewController?
    private var context : UIViewControllerContextTransitioning?
    
    init(panGestureView: UIView, onViewController viewController : PercentDrivenInteractiveTransitionProtocol) {
        self.panGestureView = panGestureView
        self.targetViewController = viewController as MenuController
        super.init()
        panGesture = UIPanGestureRecognizer(target: self, action: "panGestureDidPan:")
        self.panGestureView.addGestureRecognizer(panGesture)
    }
    
    public func panGestureDidPan(panGesture : UIPanGestureRecognizer) {
        switch panGesture.state {
        case .Began:
            panGestureIsActive = true
            targetViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            break;
        case .Changed:
            let percentage = CGFloat(targetViewController.percentForPanGestureChanged(panGesture))
            updateInteractiveTransition(percentage)
            break;
        case .Ended, .Cancelled, .Failed:
            if targetViewController.shouldPanGestureFinish(panGesture) {
                self.finishInteractiveTransition()
            }
            else {
                self.cancelInteractiveTransition()
            }
            break;
        default:
            break;
        }
    }
    
    public override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) {
            if fromViewController is PercentDrivenInteractiveTransitionProtocol {
                presentingViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
                targetViewController.beginInteractiveTransition()
                context = transitionContext
            }
        }
    }
    
    public override func updateInteractiveTransition(percentComplete: CGFloat) {
        super.updateInteractiveTransition(percentComplete)
        targetViewController.moveToIntermediaryPercentage(Float(percentComplete))
    }
    
    public override func finishInteractiveTransition() {
        super.finishInteractiveTransition()
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            () -> Void in
            self.targetViewController.endInteractiveTransition()
            }) {
                (finished) -> Void in
                if let context = self.context {
                    context.completeTransition(true)
                    self.presentingViewController?.setNeedsStatusBarAppearanceUpdate()
                }
        }
    }
    
    public override func cancelInteractiveTransition() {
        super.cancelInteractiveTransition()
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            () -> Void in
            self.targetViewController.beginInteractiveTransition()
            }) {
                (finished) -> Void in
                if let context = self.context {
                    context.completeTransition(false)
                }
        }
    }
}
