import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet weak var sketch: SketchView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
}

