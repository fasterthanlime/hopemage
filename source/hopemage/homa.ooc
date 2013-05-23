
// sdk stuff
import structs/ArrayList

// our stuff
use hopemage
import hopemage/[frontend, ast]

main: func (args: ArrayList<String>) {
    app := Homa new()
    app handle(args)
}

Homa: class {

    versionString := "0.1"
    
    init: func {

    }

    handle: func (args: ArrayList<String>) {
        if (args size > 1) {
            parse(args[1])
        } else {
            usage()
            exit(0)
        }
    }

    usage: func {
        "homa v%s" printfln(versionString)
        "Usage: homa FILE" println()
    }

    parse: func (path: String) {
        frontend := Frontend new()
        frontend parse(path)

        module := frontend module

        for (t in module types) {
            "## %s\n\n'''%s'''\n\n" printfln(t name, t doc raw)
        }
    }

}

