import Cocoa

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class SketchView: Canvas {
  
  enum Wave: Int { case square, saw }
  
  var speed = 1.0
  var series = 1
  var wave = Wave.square
  
  private var angle = 0.0
  private let delta = Double.pi / 180
  
  private let r = 50.0
  
  private var graphPoints: [CGFloat] = []
  
  private func series(_ i: Int) -> (rad: Double, x: Double, y: Double) {
    switch wave {
    case .square:
      let n = Double(i * 2 + 1)
      let rad = r * (4 / (n * Double.pi))
      let x = rad * cos(n * angle)
      let y = rad * sin(n * angle)
      
      return (rad: rad, x: x, y: y)
    case .saw:
      let n = Double(i + 1)
      let rad = r * (2 / (n * Double.pi))
      let x = rad * cos(n * angle)
      let y = rad * sin(n * angle)
      
      return (rad: rad, x: x, y: y)
    }
  }
  
  override func draw() {
    background(CGColor(gray: 0.18, alpha: 1.0))
    
    translate(by: CGPoint(x: 150, y: 150))
    
    var pen = CGPoint.zero
    
    for n in 0..<series {
      // series
      let (rad, x, y) = series(n)
      
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
    
    // draw curve
    add(point: pen.y)
    let ps = graphPoints.enumerated().map {
      CGPoint(
        x: CGFloat($0.offset) + 150.0,
        y: $0.element
      )
    }
    drawPath(ps)
    if let graphsFirstPoint = ps.first {
      line(from: pen, to: graphsFirstPoint)
      ellipse(graphsFirstPoint, radius: 2)
    }
    
    // move
    angle += delta * speed
  }
  
  func add(point: CGFloat) {
    graphPoints.insert(point, at: 0)
    
    if graphPoints.count > 300 {
      graphPoints.removeLast()
    }
  }
  
}
