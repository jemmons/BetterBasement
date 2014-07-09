import UIKit

class NavigationController: UINavigationController {
  @IBAction func menuTapped(sender:AnyObject)->(){
    if let vc = storyboard.instantiateViewControllerWithIdentifier("BasementController") as? UIViewController{
      presentViewController(vc, animated:true, completion:nil)
    }
  }
}
