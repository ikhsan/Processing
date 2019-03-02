import Cocoa

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class SketchView: Canvas {
  
  enum Wave: Int { case square, saw }
  
  var series = 3
  
  private var angle = 0.0
  private lazy var delta = Double.pi * 2 / Double(fouriers.count)
  
  private var graphPoints: [CGPoint] = []
  
  var fouriers: [Epicycle] = []
  
  override func setup() {
    let sampleInterval = 5
    let paths = loadPath(from: "sk")
      .enumerated()
      .filter { $0.offset % sampleInterval == 0 }
      .map { Complex(($0.element.x - 200), $0.element.y - 200) * 1.5  }
    
    fouriers = dft(paths)
      .sorted(by: { $0.radius > $1.radius })
  }
  
  override func draw() {
    background(CGColor(gray: 0.18, alpha: 1.0))
    translate(by: CGPoint(x: 300, y: 150))
    
    var pen = CGPoint.zero
    
    for cycle in fouriers.prefix(upTo: series) {
      let rad = cycle.radius * 0.3
      let freq = cycle.frequency
      let phase = cycle.phase
      
      let x = rad * cos(freq * angle + phase)
      let y = rad * sin(freq * angle + phase)
      
      // circle
      fill(.clear)
      stroke(CGColor(gray: 0.5, alpha: 0.5))
      ellipse(pen, radius: rad)
      
      // moving dots
      fill(.white)
      let lastPen = CGPoint(x: x, y: y) + pen
      
      // moving line
      lineWidth(1.0)
      stroke(.white)
      line(from: pen, to: lastPen)
      
      pen = lastPen
    }
    
    // draw waves
    graphPoints.append(pen)
    drawPath(graphPoints)
    
    if graphPoints.count >= fouriers.count {
      graphPoints.removeAll()
    }
    
    // move
    angle += delta
  }
  
}
