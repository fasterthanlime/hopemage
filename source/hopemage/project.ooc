
// sdk stuff
import structs/[ArrayList]
import io/[File]

// our stuff
import hopemage/[ast, frontend]

/**
 * A project a main module set and a list of module sets
 * for dependencies.
 *
 * @see ModuleSet
 */
Project: class {

    sourcePath: SourcePath
    mainSet: ModuleSet

    init: func (=sourcePath, path: String) {
        pathElement := sourcePath map(path)
        if (!pathElement) {
            raise("%s: can't be found in source path, bailing out." format(path))
        }

        mainSet = ModuleSet new(pathElement)
        parseMain()
    }

    parseMain: func {
        File new(mainSet pathElement) walk(|f| 
            if (f path endsWith?(".ooc")) {
                parse(f path, mainSet)
            }

            true
        )
    }

    parse: func (path: String, modules: ModuleSet) {
        frontend := Frontend new(sourcePath)
        frontend parse(path)
        mainSet add(frontend module)
    }

    parseDeps: func {
        // TODO: fill in
    }

}

/**
 * A set of modules that all live in the same
 * path element. 
 *
 * @see SourcePath
 */
ModuleSet: class {

    pathElement: String
    modules := ArrayList<Module> new()

    init: func (=pathElement)

    add: func (module: Module) {
        modules add(module)
    }

    contains?: func (module: Module) -> Bool {
        modules contains?(module)
    }

}

/**
 * A list of places where to look for an ooc file.
 *
 * Can map an absolute path to a path element,
 * or resolve a spec (e.g. package/module) to
 * an absolute path.
 *
 * To summarize:
 *
 * absolute path = path element + spec
 */
SourcePath: class {

    paths := ArrayList<String> new()

    add: func (path: String) {
        file := File new(path)

        paths add(file getAbsolutePath())
    }

    locate: func (spec: String) -> File {
        for (path in paths) {
            file := File new(path, spec + ".ooc")
            if (file exists?()) {
                return file
            }
        }
        null
    }

    map: func (path: String) -> (String, String) {
        file := File new(path)
        absolute := file getAbsolutePath()
        for (path in paths) {
            "- Comparing:" println()
            "%s" printfln(absolute)
            "%s" printfln(path)
            if (absolute startsWith?(path)) {
                return (path, spec(absolute, path))
            }
        }

        (null, null)
    }

    spec: func (absolute, path: String) -> String {
        absolute substring(path size) trimLeft(File separator)
    }

}

