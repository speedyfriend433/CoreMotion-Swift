import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SwiftUI ContentView를 포함하는 UIHostingController 생성
        let childView = UIHostingController(rootView: ContentView())
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}