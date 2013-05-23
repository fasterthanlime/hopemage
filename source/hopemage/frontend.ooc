
// third-party stuff
use nagaqueen
import nagaqueen/[OocListener]

// our stuff
import hopemage/[ast]

Frontend: class extends OocListener {

    module: Module

    init: func {
        module = Module new()
    }

    strict?: func -> Bool {
        false
    }

    onClassStart: func (name, doc: CString) {
        type := Type new(name toString(), Doc parse(doc toString()))
        module types add(type)
    }

}
