import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet weak var sketch: SketchView!
  
  @IBAction func speedChanged(_ sender: NSSlider) {
    sketch.speed = sender.doubleValue
  }
  @IBAction func seriesChanged(_ sender: NSSlider) {
    sketch.series = sender.integerValue
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
}

