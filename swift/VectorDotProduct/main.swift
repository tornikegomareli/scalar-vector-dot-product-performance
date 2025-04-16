import Foundation

let vectorSize = 10_000_000
print("Running Swift vector dot product benchmark with size: \(vectorSize)")

struct Vector3D {
  let x: Double
  let y: Double
  let z: Double

  func dot(_ other: Vector3D) -> Double {
    return x * other.x + y * other.y + z * other.z
  }

  static func random() -> Vector3D {
    return Vector3D(
      x: Double.random(in: Double.leastNormalMagnitude...Double.greatestFiniteMagnitude)
        * (Bool.random() ? 1 : -1),
      y: Double.random(in: Double.leastNormalMagnitude...Double.greatestFiniteMagnitude)
        * (Bool.random() ? 1 : -1),
      z: Double.random(in: Double.leastNormalMagnitude...Double.greatestFiniteMagnitude)
        * (Bool.random() ? 1 : -1)
    )
  }
}

print("Generating \(vectorSize) random 3D vectors...")
var vectorsA = [Vector3D]()
var vectorsB = [Vector3D]()

func calculateAllDotProducts(_ a: inout [Vector3D], _ b: inout [Vector3D]) -> Double {
  var sum = 0.0
  var i = 0

  while i < vectorSize {
    a.append(Vector3D.random())
    b.append(Vector3D.random())
    sum += a[i].dot(b[i])
    i += 1
  }

  return sum
}

print("Starting benchmark...")
let start = Date()
let result = calculateAllDotProducts(&vectorsA, &vectorsB)
let timeElapsed = Date().timeIntervalSince(start)
let minutes = Int(timeElapsed) / 60
let seconds = Int(timeElapsed) % 60
let milliseconds = Int((timeElapsed - Double(Int(timeElapsed))) * 1000)

print("Result: \(result)")
print("Time breakdown: \(minutes) minutes, \(seconds) seconds, \(milliseconds) milliseconds")
print("Total time in seconds: \(timeElapsed)")
