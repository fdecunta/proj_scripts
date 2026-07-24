#!/bin/sh

# Transform pdf to png. 
# Useful for transforming plots into png and then use them in .docx files.

# NOTE: requieres poppler-utils
# ---------------------------------------------

PDF="$1"
NAME="${PDF%.*}"

pdftoppm -png -singlefile -r 300 "$PDF" "$NAME"
