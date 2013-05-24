
// sdk stuff
import structs/[ArrayList]
import io/[File]

// our stuff
import hopemage/[ast, frontend, sourcepath]

/**
 * A project a main module set and a list of module sets
 * for dependencies.
 *
 * @see ModuleSet
 */
Project: class {

    sourcePath: SourcePath
    mainFolder: LibFolder

    init: func (=sourcePath) {
        if (sourcePath libFolders empty?()) {
            raise("SourcePath is empty, bailing out!")
        }
        mainFolder = sourcePath libFolders first()
        parseFolder(mainFolder)
    }

    parseFolder: func (libFolder: LibFolder) {
        File new(libFolder path) walk(|f| 
            if (f path endsWith?(".ooc")) {
                parse(f path)
            }
            true
        )
    }

    parse: func (path: String) {
        Frontend new(sourcePath, path)
    }

}

