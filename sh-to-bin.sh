#!/bin/bash
if [ -z "$1" ]; then
    echo "Shell Script Compiler v1.2 written by PQCraft 2020"
    echo "Uses shc to compile bash scripts into binaries"
    echo "Usage: sh-to-bin input [output]"
    exit
fi
if [ $1 = "--version" ]; then
    echo "Shell Script Compiler v1.1 written by PQCraft 2020"
    echo "Uses shc to compile bash scripts into binaries"
    exit
fi
if [ $1 = "--help" ]; then
    echo "Usage: sh-to-bin file [output]"
    exit
fi
if [[ $(head -q -n1 $1 | tr '\0' '\n' 2> /dev/null) = "#!/bin/bash" ]]; then
    echo Compiling...
else
    echo "$1 does not appear to be a bash script"
    echo -n "Continue? (Y/N): "; read OW
    if [ "$OW" != "y" ] && [ "$OW" != "Y" ]; then
        exit
    fi
fi
if [ -f "$1" ]; then
    if [ -f "$1.x.c" ] || [ -d "$1\.x.c" ]; then 
        echo "Conflicting file: $1.x.c";
        echo -n "Continue? (Y/N): "; read OW
        if [ "$OW" = "y" ] || [ "$OW" = "Y" ]; then
            rm -f $1\.x.c
        else
            exit
        fi
    fi
    if [ -f "$1.x" ] || [ -d "$1\.x" ]; then
        echo "Conflicting file: $1.x";
        echo -n "Continue? (Y/N): "; read OW
        if [ "$OW" = "y" ] || [ "$OW" = "Y" ]; then
            rm -f $1\.x
        else
            exit
        fi
    fi
    shc -f $1
    rm -f $1\.x.c
    if [ -z "$2" ]; then
        if [ -f "$(echo "$1" | cut -f 1 -d '.')" ] || [ -d "$(echo "$1" | cut -f 1 -d '.')" ]; then
            echo "Conflicting file: $(echo "$1" | cut -f 1 -d '.')"
            echo -n "Overwrite? (Y/N): "; read OW
            if [ "$OW" = "y" ] || [ "$OW" = "Y" ]; then
                mv $1\.x $(echo "$1" | cut -f 1 -d '.') > /dev/null
            else
                exit
            fi
        else
            mv $1\.x $(echo "$1" | cut -f 1 -d '.') > /dev/null
        fi
    else
        mv $1\.x $2 > /dev/null
    fi
    echo "Done."
else 
    if [ -d "$1" ]; then
        echo "$1 is a directory."
    else 
        echo "$1 does not exist."
    fi
fi
exit

