import UIKit

@objc protocol AnimatingMenu{
  var view:UIView! {get set}
  func setNeedsStatusBarAppearanceUpdate()
  func moveToOpenState()
  func moveToClosedState()
}


class MenuController : UIViewController, AnimatingMenu {
  @IBOutlet var backButton:UIButton!
  @IBOutlet var menuView:UIView!
  weak var storedSnapshot:UIView?
  
  
  required init(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
    modalPresentationStyle = UIModalPresentationStyle.Custom
    self.transitioningDelegate = self
  }
  
  
  override func prefersStatusBarHidden()->Bool{
    return true
  }
  
  
  @IBAction func screenshotTapped(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion:nil)
  }
  
  
  func moveToOpenState(){
    let newSnapshot = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)

    var point = view.center
    point.x -= menuView.bounds.size.width
    newSnapshot.center = point
    addShadowToView(newSnapshot)
    view.insertSubview(newSnapshot, belowSubview:backButton)
    
    storedSnapshot?.removeFromSuperview()
    storedSnapshot = newSnapshot
  }

  
  func moveToClosedState(){
    if let snapshot = storedSnapshot{
      snapshot.center = view.center
    }
  }
  
  
  func addShadowToView(view:UIView){
    view.layer.shadowColor = UIColor.blackColor().CGColor
    view.layer.shadowOpacity = 0.3
    view.layer.shadowOffset = CGSize(width: 2, height: 0)
    view.layer.shadowRadius = 4.0
  }
}


extension MenuController : UIViewControllerTransitioningDelegate{
  func animationControllerForPresentedController(presented:UIViewController!, presentingController presenting:UIViewController!, sourceController source:UIViewController!) -> UIViewControllerAnimatedTransitioning!{
    return MenuAnimationController(isPresenting: true)
  }
  
  
  func animationControllerForDismissedController(dismissed:UIViewController!) -> UIViewControllerAnimatedTransitioning!{
    return MenuAnimationController(isPresenting: false)
  }
}