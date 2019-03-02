import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet weak var sketch: SketchView!
  
  @IBOutlet weak var speedSlider: NSSlider!
  @IBOutlet weak var seriesSlider: NSSlider!
  @IBOutlet weak var speedLabel: NSTextField!
  @IBOutlet weak var seriesLabel: NSTextField!
  @IBOutlet weak var waveSegments: NSSegmentedCell!
  
  @IBAction func tweakSlider(_ sender: NSSlider) {
    update()
  }
  @IBAction func waveChanged(_ sender: Any) {
    update()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    update()
  }
  
  func update() {
    sketch.speed = speedSlider.doubleValue
    sketch.series = seriesSlider.integerValue
    sketch.wave = SketchView.Wave(rawValue: waveSegments.selectedSegment)!
    
    speedLabel.stringValue = String(format: "%.2f", sketch.speed)
    seriesLabel.stringValue = "\(sketch.series)"
    
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
}

