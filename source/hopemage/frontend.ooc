
// third-party stuff
use nagaqueen
import nagaqueen/[OocListener]

// our stuff
import hopemage/[ast, project, sourcepath]

/**
 * Parses ooc files into modules
 */
Frontend: class extends OocListener {

    module: Module
    sourcePath: SourcePath

    init: func (=sourcePath, path: String) {
        (libFolder, spec) := sourcePath split(path)
        module = Module new(spec)
        libFolder add(module)
        parse(path)
    }

    strict?: func -> Bool {
        false
    }

    onClassStart: func (name, doc: CString) {
        type := Type new(name toString(), Doc parse(doc toString()))
        module types add(type)
    }

}
