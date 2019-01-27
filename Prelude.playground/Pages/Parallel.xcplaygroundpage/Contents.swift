import Prelude

let anInt = Parallel<Int> { callback in
  print("Computing")
  callback(42)
}

sequence([anInt, anInt]).run { ints in
  print(ints)
}

let a = IO<Int> {
  print("Computing IO")
  return 42
}

let b = a
  .delay(1)
  .map { (x: Int) -> Int in print("map"); return x + 1 }
  .parallel
  .sequential

let c = IO<Int> { callback in
  print("Computing IO with callback")
  callback(10)
}

print(sequence([a, b, b, c]).perform())

1

