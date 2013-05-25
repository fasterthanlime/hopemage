
// sdk stuff
import io/File
import structs/[ArrayList]

// our stuff
import hopemage/[ast]

/**
 * A list of places where to look for an ooc file.
 *
 * Paths can be split in their components. For example, for the
 * path `~/Dev/hopemage/source/hopemage/sourcepath.ooc`,
 * we have:
 *
 *  * libFolder: `~/Dev/hopemage/source`
 *  * spec: `hopemage/sourcepath` (what you could import)
 *  * extension: `.ooc`
 *
 * To summarize:
 * path = libFolder + spec + ".ooc"
 */
SourcePath: class {

    libFolders := ArrayList<LibFolder> new()

    add: func (libPath: String) {
        libFolders add(LibFolder new(libPath))
    }

    locate: func (spec: String) -> File {
        for (libFolder in libFolders) {
            file := File new(libFolder path, spec + ".ooc")
            if (file exists?()) {
                return file
            }
        }
        null
    }

    split: func (path: String) -> (LibFolder, String) {
        path = File new(path) getAbsolutePath()
        for (libFolder in libFolders) {
            if (path startsWith?(libFolder path)) {
                return (libFolder, libFolder toSpec(path))
            }
        }

        (null, null)
    }

}

/**
 * A folder containing .ooc files, which are in turn
 * parsed into modules.
 */
LibFolder: class {

    path: String
    modules := ArrayList<Module> new()

    init: func (libPath: String) {
        path = File new(libPath) getAbsolutePath()
    }

    add: func (module: Module) {
        module libFolder = this
        modules add(module)
    }

    contains?: func (module: Module) -> Bool {
        modules contains?(module)
    }

    getCached: func ~spec (spec: String) -> Module {
        for (module in modules) {
            if (module spec == spec) {
                return module
            }
        }

        null
    }

    toSpec: func (path: String) -> String {
        path substring(this path size) trimLeft(File separator)
    }

}

