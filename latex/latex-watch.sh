#!/bin/bash

# 1. Check if Output Directory is provided
if [ -z "$1" ]; then
    echo "Usage: ./latex-watch.sh <output-directory> [main-file.tex]"
    echo "Example: ./latex-watch.sh ./build main.tex"
    exit 1
fi

OUT_DIR="$1"
# Get the main file argument if provided, otherwise leave empty (latexmk will auto-detect)
MAIN_FILE="${2:-}"

# 2. Create the output directory locally first
# This prevents Docker from creating it as 'root', which causes permission errors.
mkdir -p "$OUT_DIR"

echo "--- Preparing Latexmk Environment ---"

# 3. Check if image exists, build only if missing
# 'docker images -q' returns the Image ID if found, or an empty string if not.
if [[ "$(docker images -q latexmk-runner 2> /dev/null)" == "" ]]; then
    echo "Image 'latexmk-runner' not found. Building now..."
    docker build -t latexmk-runner .
else
    echo "Image 'latexmk-runner' found. Skipping build."
fi

echo "--- Starting Watch Mode ---"
echo "Output Directory: $OUT_DIR"
if [ -n "$MAIN_FILE" ]; then echo "Target File: $MAIN_FILE"; fi
echo "---------------------------"

# 4. Run Docker
# -ti: Interactive mode (allows you to use Ctrl+C to stop)
# -v: Mount current directory to /workspace
# -u: Run as YOUR user ID (prevents output files being locked by root)
# -view=none: Tells latexmk NOT to try opening a PDF viewer inside the container
docker run --rm -ti \
    -v "$(pwd):/workspace" \
    -u "$(id -u):$(id -g)" \
    latexmk-runner \
    -outdir="$OUT_DIR" \
    -pvc \
    -view=none \
    $MAIN_FILE