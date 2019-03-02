import Foundation

public struct Complex {
  let real: Double
  let imag: Double
  
  init(_ real: Double, _ imag: Double) {
    self.real = real
    self.imag = imag
  }
}

public func +(left: Complex, right: Complex) -> Complex {
  return Complex(left.real + right.real, left.imag + right.imag)
}

public func /(left: Complex, right: Int) -> Complex {
  return Complex(left.real / Double(right), left.imag / Double(right))
}

public func *(left: Complex, right: Double) -> Complex {
  return Complex(left.real * right, left.imag * right)
}

public func *(left: Complex, right: Complex) -> Complex {
  /*
   (a + bi) + (c + di)
   ac + adi + bic + bdi^2
   ac + adi + bic - bd
   (ac - bd) + (ad + bc)i
   */
  let real = left.real * right.real - left.imag * right.imag
  let imag = left.real * right.imag + left.imag * right.real
  return Complex(real, imag)
}

struct Epicycle {
  let frequency: Double
  let phase: Double
  let radius: Double
}

func dft(_ xs: [Complex]) -> [Epicycle] {
  let N = xs.count
  
  return xs.enumerated().map({ (k, _) -> Epicycle in
    
    var sum = Complex(0, 0)
    for (n, x) in xs.enumerated() {
      let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N);
      
      sum = sum + (x * Complex(cos(phi), -sin(phi)))
    }
    
    sum = sum / N
    
    let freq = Double(k)
    let radius = (pow(sum.real, 2) + pow(sum.imag, 2)).squareRoot()
    let phase = atan2(sum.imag, sum.real)
    
    return Epicycle(frequency: freq, phase: phase, radius: radius)
  })
}
