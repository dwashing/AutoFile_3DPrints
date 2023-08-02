#!/bin/bash

# Customize the destination folder path for your 3D printer files
DEST="/path/to/your/destination/folder"

# Customize the archive folder path to store processed archives
ARCHIVE_DEST="/path/to/your/archive/folder"

# Customize the list of supported file extensions for 3D printer files
SUPPORTED_EXTENSIONS="3mf|obj|stl|scad"

# Customize the list of archive file extensions to process
ARCHIVE_EXTENSIONS="zip|7z"

# Function to check if the archive contains 3D printer files
contains_printer_files() {
    local file="$1"
    
    # List the contents of the archive
    if [[ $file =~ \.(zip)$ ]]; then
        unzip -l "$file" | grep -E "\.($SUPPORTED_EXTENSIONS)\$"
    elif [[ $file =~ \.(7z)$ ]]; then
        7z l "$file" | grep -E "\.($SUPPORTED_EXTENSIONS)\$"
    fi
}

# Note: Before running the script, make sure to customize the variables above with appropriate paths.

for f in "$@"; do
    # Check if the file matches the specified extensions (case-insensitive)
    if [[ $f =~ \.($SUPPORTED_EXTENSIONS|$ARCHIVE_EXTENSIONS)$ ]]; then
        # Get the filename without the path
        filename=$(basename "$f")
        destination="$DEST"

        # Check if the file is an archive and contains 3D printer files
        if [[ ($f =~ \.(zip|7z)$) && -n "$(contains_printer_files "$f")" ]]; then
            # Create a temporary directory to extract the contents
            temp_dir=$(mktemp -d)

            if [[ $f =~ \.(zip)$ ]]; then
                unzip -q "$f" -d "$temp_dir"
            elif [[ $f =~ \.(7z)$ ]]; then
                7z x -y "$f" -o"$temp_dir" > /dev/null
            fi

            # Check if the temporary directory contains files
            if [ "$(ls -A "$temp_dir")" ]; then
                # Create a nested directory with the same filename in the destination folder
                nested_dir="$DEST/${filename%.*}"
                counter=1

                # Add a counter to the directory name if it already exists
                while [ -d "$nested_dir" ]; do
                    nested_dir="$DEST/${filename%.*}_$counter"
                    ((counter++))
                done

                mkdir -p "$nested_dir"

                # Move the extracted files to the nested directory
                mv "$temp_dir"/* "$nested_dir"

                # Move the processed archive to the "Archive" folder
                mv "$f" "$ARCHIVE_DEST"

                # Display a notification for the moved file with filename and destination folder name
                /usr/bin/osascript -e "display notification \"${filename%.*} has moved to $nested_dir/\""
            fi

            # Remove the temporary directory
            rm -r "$temp_dir"
        else
            # Check if the file already exists in the destination folder
            if [ -e "$DEST/$filename" ]; then
                counter=1
                new_filename="${filename%.*}_$counter.${filename##*.}"

                # Add a counter to the filename until it's unique in the destination folder
                while [ -e "$DEST/$new_filename" ]; do
                    counter=$((counter + 1))
                    new_filename="${filename%.*}_$counter.${filename##*.}"
                done

                destination="$DEST/$new_filename"
            fi

            # Move the file to the destination folder
            mv "$f" "$destination"

            # Display a notification for the moved file with filename and destination folder name
            /usr/bin/osascript -e "display notification \"${filename%.*} has moved to $destination\""
        fi

        # Remove the processed archive from the Downloads folder
        if [[ $f =~ \.($ARCHIVE_EXTENSIONS)$ ]]; then
            rm "$f"
        fi
    fi
done
