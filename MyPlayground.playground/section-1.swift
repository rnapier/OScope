


func each<C:Collection>(collection: C, fn:(C.GeneratorType.Element, C.IndexType) -> ()) -> C {
  for index in collection.startIndex...collection.endIndex {
    fn(collection[index], index)
  }
  return collection
}

let ret = each(["foo":true, "bar":false]) {
  println("1: Key \($1), Value:\($0)")
}
