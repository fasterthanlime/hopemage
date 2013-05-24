
// third-party stuff
use nagaqueen
import nagaqueen/[OocListener]

// our stuff
import hopemage/[ast, project]

/**
 * Parses ooc files into modules
 */
Frontend: class extends OocListener {

    module: Module
    sourcePath: SourcePath

    init: func (=sourcePath)

    parse: func (path: String) {
        (pathElement, spec) := sourcePath map(path)
        module = Module new(spec)
        super()
    }

    strict?: func -> Bool {
        false
    }

    onClassStart: func (name, doc: CString) {
        type := Type new(name toString(), Doc parse(doc toString()))
        module types add(type)
    }

}
