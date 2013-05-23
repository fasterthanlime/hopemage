
// sdk stuff
import structs/ArrayList

Module: class {

   types := ArrayList<Type> new()

   init: func

}

Type: class {

    name: String
    doc: Doc

    init: func (=name, =doc) {}

}

Doc: class {

    raw: String

    init: func (=raw)

    parse: static func (input: String) -> This {
        This new(input)
    }

}

