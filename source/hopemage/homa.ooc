
// sdk stuff
import structs/ArrayList

main: func (args: ArrayList<String>) {
    app := Homa new()
    app handle(args)
}

Homa: class {

    versionString := "0.1"
    
    init: func {

    }

    handle: func (args: ArrayList<String>) {
        usage()
    }

    usage: func {
        "homa v%s" printfln(versionString)
    }

}

