
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
    mainSet: ModuleSet

    init: func (=sourcePath) {
        libFolder := sourcePath libFolders first()
        if (!libFolder) {
            raise("SourcePath is empty, bailing out!")
        }
        mainSet = ModuleSet new(libFolder)
        parseSet(mainSet)
    }

    parseSet: func (moduleSet: ModuleSet) {
        File new(moduleSet libFolder) walk(|f| 
            if (f path endsWith?(".ooc")) {
                parse(f path, moduleSet)
            }
            true
        )
    }

    parse: func (path: String, modules: ModuleSet) {
        frontend := Frontend new(sourcePath, path)
        mainSet add(frontend module)
    }

}

/**
 * A set of modules that all live in the same
 * path element. 
 *
 * @see SourcePath
 */
ModuleSet: class {

    libFolder: String
    modules := ArrayList<Module> new()

    init: func (=libFolder)

    add: func (module: Module) {
        modules add(module)
    }

    contains?: func (module: Module) -> Bool {
        modules contains?(module)
    }

}

