import Foundation


class Control {
  var primitiveValue : CGFloat = 0.0
  var value : CGFloat {
  get {
    return primitiveValue
  }
  set(newValue) {
    primitiveValue = newValue
    updateUI(false)
    }
  }

  func setValue(value newValue:CGFloat, animated:Bool) {
    primitiveValue = newValue
    updateUI(animated)
  }

  func updateUI(animated:Bool) {
    println("Animating: \(animated)")
  }

}


let control = Control()
control.value = 1

control.setValue(value: 2, animated: false)
control.setValue(value: 2, animated: true)

struct X {}

struct Y {
  let x:X
}

func each<C:Swift.Collection>(collection: C, fn:(C.GeneratorType.Element, C.IndexType) -> ()) -> C {
  for index in indices(collection) {
    fn(collection[index], index)
  }
  return collection
}
