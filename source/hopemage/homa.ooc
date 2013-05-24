
// sdk stuff
import structs/ArrayList
import text/StringTokenizer

// our stuff
use hopemage
import hopemage/[frontend, ast, project]

main: func (args: ArrayList<String>) {
    app := Homa new()
    app handle(args)
}

/**
 * The main hopemage application
 */
Homa: class {

    versionString := "0.1"
    sourcePath := SourcePath new()
    path: String
    
    init: func 

    handle: func (args: ArrayList<String>) {
        parseArgs(args)

        if (path) {
            parse()
        } else {
            usage()
            exit(0)
        }
    }

    parseArgs: func (args: ArrayList<String>) {
        args removeAt(0)

        for (arg in args) {
            if (!arg contains?('=')) {
                path = arg
                continue
            }

            tokens := arg split('=')
            if (tokens size != 2) {
                onInvalidArg(arg)
                continue
            }
            match (tokens[0]) {
                case "--sourcepath" =>
                    sourcePath add(tokens[1]) 
                case =>
                    onInvalidArg(arg)
            }
        }
    }

    onInvalidArg: func (arg: String) {
        "Invalid argument: %s, ignoring.." printfln(arg)
    }

    usage: func {
        "homa v%s" printfln(versionString)
        "Usage: homa --sourcepath=FOLDERS" println()
    }

    parse: func {
        project := Project new(sourcePath, path)

        for (module in project mainSet modules) {
            "## %s" printfln(module spec)
            for (type in module types) {
                "## %s\n\n'''%s'''\n\n" printfln(type name, type doc raw)
            }
        }
    }

}

