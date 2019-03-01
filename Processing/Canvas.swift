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

  var displayLink: CVDisplayLink?
  
  private func setupView() {
    setup()
    
    // Source: https://github.com/alexito4/p5-in-Swift/blob/master/p5.playground/Sources/Sketch.swift
    let callback: CVDisplayLinkOutputCallback = {
      (displayLink, inNow, inOutputTime, flagsIn, flagsOut, context) -> CVReturn in
      
      DispatchQueue.main.sync {
        let view = unsafeBitCast(context, to: Canvas.self)
        view.setNeedsDisplay(view.bounds)
        view.displayIfNeeded()
      }
      return kCVReturnSuccess
    }
    
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
    CVDisplayLinkSetOutputCallback(displayLink!, callback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
    CVDisplayLinkStart(displayLink!)
  }
  
  override var isFlipped: Bool {
    return true
  }
  
  var ctx: CGContext {
    return NSGraphicsContext.current!.cgContext
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    setup()
    draw()
  }
  
  // MARK: - Helpers
  
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
  
  func drawPath(_ points: [CGPoint]) {
    guard points.count > 1 else { return }
    
    let path = NSBezierPath()
    path.move(to: points.first!)
    for point in points.suffix(from: 1) {
      path.line(to: point)
    }
//    path.close()
    
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
