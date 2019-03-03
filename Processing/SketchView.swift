import Cocoa

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

protocol SketchViewDelegate: class {
  func didUpdate(fouriersCount: Int)
}

class SketchView: Canvas {
  
  enum State { case draw, render }
  var state = State.render
  
  var series = 5
  let offset = CGPoint(x: 300, y: 150)
  
  weak var delegate: SketchViewDelegate? = nil
  
  private var angle = 0.0
  private var delta: Double {
    return Double.pi * 2 / Double(fouriers.count)
  }
  
  private var graphPoints: [CGPoint] = []
  
  var fouriers: [Epicycle] = [] {
    didSet {
      delegate?.didUpdate(fouriersCount: fouriers.count)
    }
  }
  
  override func setup() {
    let sampleInterval = 10
    let paths = loadPath(from: "sk")
      .enumerated()
      .filter { $0.offset % sampleInterval == 0 }
      .map { Complex(($0.element.x - 200), $0.element.y - 200) * 1.5  }
    
    fouriers = dft(paths)
      .sorted(by: { $0.radius > $1.radius })
  }
  
  override func draw() {
    background(CGColor(gray: 0.18, alpha: 1.0))
    translate(by: offset)
    
    switch state {
    case .draw:
      renderDrawing()
    case .render:
      renderFourier()
    }
  }
  
  private func renderDrawing() {
    lineWidth(1.0)
    stroke(.white)
    drawPath(drawingPaths)
  }
  
  private func renderFourier() {
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
      stroke(CGColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0))
      line(from: pen, to: lastPen)
      
      pen = lastPen
    }
    
    // draw graphs
    stroke(.white)
    graphPoints.append(pen)
    drawPath(graphPoints)
    
    if graphPoints.count >= fouriers.count {
      graphPoints.removeAll()
    }
    
    // move
    angle += delta
  }
  
  var drawingPaths: [CGPoint] = []
  
  override func mouseDown(with event: NSEvent) {
    state = .draw
    
    graphPoints = []
    drawingPaths = []
    angle = 0.0
    series = 3
  }
  
  override func mouseDragged(with event: NSEvent) {
    let point = convert(event.locationInWindow, from: nil) - offset
    drawingPaths.append(point)
  }
  
  override func mouseUp(with event: NSEvent) {
    let complexPaths = drawingPaths
      .map { Complex($0) * Double.pi }

    fouriers = dft(complexPaths)
      .sorted(by: { $0.radius > $1.radius })
    
    state = .render
    
    series = fouriers.count
  }
  
}
