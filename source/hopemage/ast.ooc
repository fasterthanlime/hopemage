
// sdk stuff
import structs/ArrayList

/**
 * An ooc file containing types and stuff
 */
Module: class {

    imports := ArrayList<Import> new()
    types := ArrayList<Type> new()
    spec: String

    init: func (=spec)

}

/**
 * An ooc type, like a class, a cover, etc.
 */
Type: class {

    name: String
    doc: Doc

    init: func (=name, =doc) {}

}

/**
 * A documentation string
 */
Doc: class {

    raw: String

    init: func (=raw)

    parse: static func (input: String) -> This {
        This new(input)
    }

}

/**
 * An import, that can be relative, absolute, etc.
 */
Import: class {

    path: String

    init: func (=path)

}

