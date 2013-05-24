
// sdk stuff
import structs/ArrayList
import text/StringTokenizer

// our stuff
use hopemage
import hopemage/[frontend, ast, project, sourcepath]

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
    
    init: func 

    handle: func (args: ArrayList<String>) {
        parseArgs(args)

        if (sourcePath libFolders empty?()) {
            usage()
            exit(0)
        } else {
            parse()
        }
    }

    parseArgs: func (args: ArrayList<String>) {
        args removeAt(0)

        for (arg in args) {
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
        project := Project new(sourcePath)

        for (module in project mainFolder modules) {
            "## %s" printfln(module spec)
            for (type in module types) {
                "## %s\n\n'''%s'''\n\n" printfln(type name, type doc raw)
            }
        }
    }

}

