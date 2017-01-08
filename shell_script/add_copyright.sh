#!/bin/bash
# Author: oicu
# keeping inodes

# method 1
for file in *.c
do
    cat copyright.txt "$file" > tempfile
    tr -d '\r' < tempfile > "$file"
done
rm -f tempfile

# method 2
find . -type f \( -name "*.c" -o -name "*.h" \) | \
xargs -n1 -i sh -c '
    test -f "{}" && cat copyright.txt "{}" > tempfile && \
    tr -d "\r" < tempfile > "{}"
'
rm -f tempfile

# method 3
for file in */*.h
do
    sed -i '
        1 {
            r copyright.txt
            h
            d
        }
        2 {
            H
            g
        }' "$file"
    sed -i -e 's#\r$##' "$file"
done
