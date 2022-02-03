if [ "$#" -le 2 ]; then
    echo "Usage: $0 <source directory> <target directory> <extension (optional)> ..."
    echo "Example: $0 ./dir1 ./dir2 .py .json"
    exit
fi

SRC_DIR=$1
TRG_DIR=$2
shift
shift

mkdir -p diff
cp -a .deps diff/.deps
find $SRC_DIR -type d | while read x; do (mkdir -p diff/${x/$SRC_DIR/""} && cp -a .deps diff/${x/$SRC_DIR/""}/.deps); done

if [ "$#" -ne 0 ]
then
    for ITEM in $@
    do
        find $SRC_DIR -type f -name "*$ITEM" | while read x; do echo ${x/$SRC_DIR/""}; done | while read relpath; do (echo "Comparing ${relpath}" && python diff2HtmlCompare.py ${SRC_DIR}${relpath} ${TRG_DIR}${relpath} && [ -f index.html ] && mv index.html diff${relpath}.html); done
    done
else
    find $SRC_DIR -type f | while read x; do echo ${x/$SRC_DIR/""}; done | while read relpath; do (python diff2HtmlCompare.py ${SRC_DIR}${relpath} ${TRG_DIR}${relpath} && [ -f index.html ] && mv index.html diff${relpath}.html); done
fi
