import Cocoa

struct Coordinate: Codable {
  let x: Double
  let y: Double
}

func loadPath(from path: String) -> [Coordinate] {
  guard let asset = NSDataAsset(name: path),
    let paths = try? JSONDecoder().decode([Coordinate].self, from: asset.data)
    else { return [] }
  
  return paths
}
