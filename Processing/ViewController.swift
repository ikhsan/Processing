import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet weak var sketch: SketchView!
  
  @IBOutlet weak var seriesSlider: NSSlider!
  @IBOutlet weak var seriesLabel: NSTextField!
  
  @IBAction func tweakSlider(_ sender: NSSlider) {
    update()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    update()
    seriesSlider.maxValue = Double(sketch.fouriers.count)
  }
  
  func update() {
    sketch.series = seriesSlider.integerValue
    
    seriesLabel.stringValue = "\(sketch.series)"
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
      
    }
  }
  
}

