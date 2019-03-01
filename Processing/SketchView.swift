import Cocoa

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class SketchView: Canvas {
  
  var angle = 0.0
  let delta = Double.pi / 180
  
  let r = 50.0
  let offset = CGPoint(x: 150, y: 150)
  
  var graphPoints: [CGFloat] = []
  
  override func draw() {
    background(CGColor(gray: 0.18, alpha: 1.0))
    
    var pen = offset
    
    for i in 0...10 {
      // series
      let n = Double(i * 2 + 1)
      let rad = r * (4 / (n * Double.pi))
      let x = rad * cos(n * angle)
      let y = rad * sin(n * angle)
      
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
        x: CGFloat($0.offset) + offset.x + 150.0,
        y: $0.element
      )
    }
    drawPath(ps)
    if let graphsFirstPoint = ps.first {
      line(from: pen, to: graphsFirstPoint)
      ellipse(graphsFirstPoint, radius: 2)
    }
    
    // move
    angle += delta * 4
  }
  
  func add(point: CGFloat) {
    graphPoints.insert(point, at: 0)
    
    if graphPoints.count > 300 {
      graphPoints.removeLast()
    }
  }
  
}
