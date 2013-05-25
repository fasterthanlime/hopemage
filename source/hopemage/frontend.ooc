
// third-party stuff
use nagaqueen
import nagaqueen/[OocListener]

// our stuff
import hopemage/[ast, project, sourcepath]

// sdk stuff
import text/StringTokenizer
import io/File

/**
 * Parses ooc files into modules
 */
Frontend: class extends OocListener {

    module: Module
    sourcePath: SourcePath

    init: func (=sourcePath, path: String) {
        (libFolder, spec) := sourcePath split(path)
        if (!libFolder) {
            raise("%s: not found in source path" format(path))
        }

        cached := libFolder getCached(spec)
        if (cached) {
            // already parsed, ignore
            return
        }

        module = Module new(libFolder, spec)

        "> Parsing %s" printfln(spec)
        parse(path)

        for (imp in module imports) {
            file := sourcePath locate(imp spec)

            if (!file) {
                tokens := module spec split("/")
                if (tokens size >= 2) {
                    tokens remove(tokens last())
                    parent := tokens join("/")
                    spec := File new(parent + "/" + imp spec) getReducedPath()
                    file = sourcePath locate(spec)
                }
            }

            if (file) {
                Frontend new(sourcePath, file path)
            } else {
                "Module not found: %s" printfln(imp spec)
            }
        }
    }

    strict?: func -> Bool {
        false
    }

    onClassStart: func (name, doc: CString) {
        type := Type new(name toString(), Doc parse(doc toString()))
        module types add(type)
    }

    onImport: func (path, name: CString) {
        importPath := name toString()
        if (path) {
            importPath = path toString() + importPath
        }
        module imports add(Import new(importPath))
    }

}
