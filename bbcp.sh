#!/usr/bin/env bash
# @meta version 1.0.1
# @meta author Matthew Delaney <MattDelaney_948@protonmail.com>
# @meta require-tools curl,base64,basename,grep
# @describe Copy local files to Bitburner Home
#
# Uses the Steam version's API. Files must be valid script files (js, ts, etc.).

# @arg src_files+ <SRC> Local files to upload. If "-", read from stdin.
# @arg dst! <DST> Destination file/directory.
# @env BB_API_TOKEN! From API Server > Copy Auth Token
# @env BB_API_URL=http://localhost:9990

main() {
    assertBbServerRunning
    assertTokenValid

    if stdinRequested; then
        uploadStdin
    elif aFileProvided; then
        uploadFile
    else
        uploadFiles
    fi
}

assertBbServerRunning() {
    if ! curl "$BB_API_URL" >/dev/null 2>&1; then
        errmsg "Can't connect to API server."
        exit 1
    fi
}

assertTokenValid() {
    response=$(curl \
        -H "Authorization: Bearer $BB_API_TOKEN" \
        "$BB_API_URL" 2>/dev/null
    )

    if grep -q "Invalid authentication token" <<< "$response"; then
        errmsg "API Token was rejected:" \
            "$response"
        exit 1
    fi
}

stdinRequested() {
    test "${argc_src_files[0]}" = "-"
}

aFileProvided() {
    test "${#argc_src_files[@]}" -eq 1
}

uploadStdin() {
    assertDstIsFile
    content=$(cat | base64)
    makeRequest "$argc_dst" "$content"
}

uploadFile() {
    assertAllFilesReadable
    theFile=${argc_src_files[0]}
    content=$(base64 -i "$theFile")

    if hasFileExtension "$argc_dst"; then
        makeRequest "$argc_dst" "$content"
    else
        ensureDstDoesntEndInSlash
        bname=$(basename "$theFile")
        makeRequest "$argc_dst/$bname" "$content"
    fi
}

uploadFiles() {
    assertAllFilesReadable
    assertDstIsDir
    ensureDstDoesntEndInSlash
    for fname in "${argc_src_files[@]}"; do
        bname=$(basename "$fname")
        content=$(base64 -i "$fname")
        makeRequest "$argc_dst/$bname" "$content"
    done
}

assertAllFilesReadable() {
    for f in "${argc_src_files[@]}"; do
        if [ ! -r "$f" ]; then
            errmsg "File not readable: $f"
            exit 1
        fi
    done
}

assertDstIsDir() {
    if hasFileExtension "$argc_dst"; then
        errmsg "Destination expected to be a directory: $argc_dst"
        exit 1
    fi
}

assertDstIsFile() {
    if ! hasFileExtension "$argc_dst"; then
        errmsg "Destination expected to be a file: $argc_dst"
        exit 1
    fi
}

# Provided so doing bbcp aFile.js myDir/ works, which won't otherwise
ensureDstDoesntEndInSlash() {
    argc_dst=${argc_dst%/}
}

hasFileExtension() {
    [[ "$1" =~ \..*$ ]]
}

makeRequest() {
    bbPath="$1"
    content="$2"
    curl -X POST "$BB_API_URL" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $BB_API_TOKEN" \
         -d '{
               "action": "UPSERT",
               "filename": "'"$bbPath"'",
               "code": "'"$content"'"
             }' 2>/dev/null | grep -v '"success":true' >&2
}

errmsg() {
    echo "error: $*" >&2
}

eval "$(argc --argc-eval "$0" "$@")"
