import Cocoa

class Canvas: NSView {
 
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
    setupView()
  }

  private var timer: Timer? = nil
  var frameRate = 120 // fps
  var frameCount = 0
  
  private func setupTimer() {
    let interval = 1.0 / Double(frameRate)
    
    let drawBlock: (Timer) -> Void = { [unowned self] _ in
      self.setNeedsDisplay(self.bounds)
      self.frameCount += 1
    }
    
    timer  = Timer(timeInterval: interval, repeats: true, block: drawBlock)
    RunLoop.main.add(timer!, forMode: .common)
  }
  
  private func setupView() {
    setup() 
    setupTimer()
  }
  
  override var isFlipped: Bool {
    return true
  }
  
  var ctx: CGContext {
    return NSGraphicsContext.current!.cgContext
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    draw()
  }
  
  // MARK: - Helpers
  
  func translate(by offset: CGPoint) {
    ctx.translateBy(x: offset.x, y: offset.y)
  }
  
  func fill(_ color: CGColor) {
    ctx.setFillColor(color)
  }
  
  func rect(_ frame: CGRect) {
    ctx.fill(frame)
  }
  
  func stroke(_ color: CGColor) {
    ctx.setStrokeColor(color)
  }
  
  func ellipse(_ point: CGPoint, radius: Double) {
    let rect = CGRect(
      x: point.x - CGFloat(radius),
      y: point.y - CGFloat(radius),
      width: CGFloat(radius) * 2,
      height: CGFloat(radius) * 2
    )
    
    ctx.strokeEllipse(in: rect)
    ctx.fillEllipse(in: rect)
  }
  
  func lineWidth(_ width: CGFloat) {
    ctx.setLineWidth(width)
  }
  
  func line(from a: CGPoint, to b: CGPoint) {
    ctx.move(to: a)
    ctx.addLine(to: b)
    ctx.strokePath()
  }
  
  func drawPath(_ points: [CGPoint], closing: Bool = false) {
    guard points.count > 1 else { return }
    
    let path = NSBezierPath()
    path.move(to: points.first!)
    for point in points.suffix(from: 1) {
      path.line(to: point)
    }
    
    if closing {
      path.close()
    }
    
    path.stroke()
  }
  
  func background(_ color: CGColor) {
    fill(color)
    rect(bounds)
  }
  
  // MARK: - Methods to override
  
  func setup() {}
  
  func draw() {}
}
