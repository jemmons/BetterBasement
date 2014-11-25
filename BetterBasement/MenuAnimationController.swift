import UIKit

class MenuAnimationController : NSObject, UIViewControllerAnimatedTransitioning {
  var isPresenting:Bool
  
  
  init(isPresenting:Bool){
    self.isPresenting = isPresenting;
    super.init()
  }
  
  func performPresentAnimation(#fromController:UIViewController, toController:AnimatingMenu, inView containerView:UIView, context:UIViewControllerContextTransitioning){
    toController.view.frame = fromController.view.bounds
    toController.moveToClosedState()
    toController.setNeedsStatusBarAppearanceUpdate()
    
    containerView.addSubview(toController.view)
    
    let animationBlock = {
      toController.moveToOpenState()
    }
    
    let completionBlock = {
      (finished:Bool) in
      context.completeTransition(true)
    }
    
    UIView.animateWithDuration(transitionDuration(context), animations:animationBlock, completion:completionBlock)
  }
  
  func performDismissAnimation(#fromController:AnimatingMenu, toController:UIViewController, inView containerView:UIView, context:UIViewControllerContextTransitioning){
    let animationBlock = {
      fromController.moveToClosedState()
    }
    
    let completionBlock:(Bool)->() = {
      (finished:Bool) in
      context.completeTransition(true)
      toController.setNeedsStatusBarAppearanceUpdate()
    }
    
    UIView.animateWithDuration(transitionDuration(context), animations:animationBlock, completion:completionBlock)
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext:UIViewControllerContextTransitioning){
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let container = transitionContext.containerView()
        
        if(isPresenting){
            if let menuCast = to as? AnimatingMenu{
                performPresentAnimation(fromController:from!, toController:menuCast, inView:container, context:transitionContext)
            }
        } else{
            if let menuCast = from as? AnimatingMenu{
                performDismissAnimation(fromController:menuCast, toController:to!, inView:container, context:transitionContext)
            }
        }
    }
}