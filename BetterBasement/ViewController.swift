import UIKit

class ViewController: UIViewController {
  @IBOutlet var menuItem:UIBarButtonItem!
  
  override func viewDidLoad(){
    menuItem.target = nil;
    menuItem.action = Selector("menuTapped:")
  }
  
  override func childViewControllerForStatusBarHidden()->UIViewController!{
    if let it = presentedViewController{
      return it
    } else{
      return nil
    }
  }
}

