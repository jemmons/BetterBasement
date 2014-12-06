import UIKit

@objc protocol AnimatingMenu{
    var view:UIView! {get set}
    func setNeedsStatusBarAppearanceUpdate()
    func moveToOpenState()
    func moveToClosedState()
}


class MenuController : UIViewController, AnimatingMenu, PercentDrivenInteractiveTransitionProtocol {
    @IBOutlet var backButton:UIButton!
    @IBOutlet var menuView:UIView!
    weak var storedSnapshot:UIView?
    
    var interactiveTransition : PercentDrivenInteractiveTransition?
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        modalPresentationStyle = UIModalPresentationStyle.Custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactiveTransition = PercentDrivenInteractiveTransition(panGestureView: self.backButton, onViewController: self)
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
    
    //MARK: interactive
    
    func panGestureBegan() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func percentForPanGestureChanged(panGesture : UIPanGestureRecognizer) -> Float {
        let location = panGesture.locationInView(self.view)
        let percentage = location.x / CGRectGetWidth(self.view.bounds)
        return Float(percentage)
    }
    
    func shouldPanGestureFinish(panGesture : UIPanGestureRecognizer) -> Bool {
        var velocity = panGesture.velocityInView(self.view)
        return (velocity.x > 0.0)
    }
    
    func beginInteractiveTransition() {
        var point = self.view.center
        point.x -= CGRectGetWidth(self.menuView.bounds)
        self.storedSnapshot?.center = point
    }
    
    func moveToIntermediaryPercentage(percentage : Float) {
        var invertedPercentage = CGFloat((1.0 - percentage))
        var point = self.view.center
        point.x -= (CGRectGetWidth(self.menuView!.bounds) * invertedPercentage)
        self.storedSnapshot?.center = point
    }
    
    func endInteractiveTransition() {
        self.storedSnapshot?.center = self.view.center
    }
}

extension MenuController : UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented:UIViewController!, presentingController presenting:UIViewController!, sourceController source:UIViewController!) -> UIViewControllerAnimatedTransitioning!{
        return MenuAnimationController(isPresenting: true)
    }
    
    
    func animationControllerForDismissedController(dismissed:UIViewController!) -> UIViewControllerAnimatedTransitioning!{
        return MenuAnimationController(isPresenting: false)
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (interactiveTransition?.panGestureIsActive == true) {
            return interactiveTransition
        }
        else {
            return nil
        }
    }
}