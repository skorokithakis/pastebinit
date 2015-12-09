#!/bin/sh
teststring="blah blah blah"

for interpreter in python python3; do
    for pastebin in $($interpreter pastebinit -l | egrep "^-" | sed "s/^- //g")
    do
        echo "Trying http://$pastebin ($interpreter)"
        URL=$(echo "$teststring\n$teststring\n$teststring" | $interpreter pastebinit -b http://$pastebin)

        if [ "$pastebin" = "paste.ubuntu.org.cn" ]; then
            out=$(wget -O - -q "$URL" | gzip -d | grep "$teststring")
        else
            out=$(wget -O - -q "$URL" | grep "$teststring")
        fi

        if [ -n "$out" ]; then
            echo "PASS: http://$pastebin ($URL) ($interpreter)"
        else
            echo "FAIL: http://$pastebin ($URL) ($interpreter)"
        fi
        echo ""
    done
done
