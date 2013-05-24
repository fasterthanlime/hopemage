
// sdk stuff
import io/File
import structs/[ArrayList]

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

    libFolders := ArrayList<String> new()

    add: func (libFolder: String) {
        file := File new(libFolder)
        libFolders add(file getAbsolutePath())
    }

    locate: func (spec: String) -> File {
        for (libFolder in libFolders) {
            file := File new(libFolder, spec + ".ooc")
            if (file exists?()) {
                return file
            }
        }
        null
    }

    split: func (path: String) -> (String, String) {
        path = File new(path) getAbsolutePath()
        for (libFolder in libFolders) {
            if (path startsWith?(libFolder)) {
                return (path, spec(libFolder, path))
            }
        }

        (null, null)
    }

    spec: func (libFolder, path: String) -> String {
        path substring(libFolder size) trimLeft(File separator)
    }

}

