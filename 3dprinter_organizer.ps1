param (
    # Customize the destination folder path for your 3D printer files
    [string]$DEST = "C:\path\to\your\destination\folder",

    # Customize the archive folder path to store processed archives
    [string]$ARCHIVE_DEST = "C:\path\to\your\archive\folder",

    # Customize the list of supported file extensions for 3D printer files
    [string]$SUPPORTED_EXTENSIONS = "3mf|obj|stl|scad",

    # Customize the list of archive file extensions to process
    [string]$ARCHIVE_EXTENSIONS = "zip|7z"
)

# Function to check if the archive contains 3D printer files
function Contains-PrinterFiles {
    param (
        [string]$file
    )

    if ($file -match "\.(zip)$") {
        (Expand-Archive -LiteralPath $file -PassThru | Get-ChildItem -Recurse) | Where-Object { $_.Extension -match "($SUPPORTED_EXTENSIONS)$" }
    } elseif ($file -match "\.(7z)$") {
        (7z.exe l $file | Select-String -Pattern "\.($SUPPORTED_EXTENSIONS)$").Line
    }
}

foreach ($f in $args) {
    # Check if the file matches the specified extensions (case-insensitive)
    if ($f -match "\.($SUPPORTED_EXTENSIONS|$ARCHIVE_EXTENSIONS)$") {
        # Get the filename without the path
        $filename = Split-Path $f -Leaf
        $destination = $DEST

        # Check if the file is an archive and contains 3D printer files
        if (($f -match "\.(zip|7z)$") -and (Contains-PrinterFiles $f)) {
            # Create a temporary directory to extract the contents
            $temp_dir = New-Item -ItemType Directory -Name "TempDir" -Path $env:TEMP

            if ($f -match "\.(zip)$") {
                Expand-Archive -LiteralPath $f -DestinationPath $temp_dir
            } elseif ($f -match "\.(7z)$") {
                & 7z.exe x -y $f -o$temp_dir > $null
            }

            # Check if the temporary directory contains files
            if (Test-Path "$temp_dir\*") {
                # Create a nested directory with the same filename in the destination folder
                $nested_dir = Join-Path $DEST ($filename -replace "\..+$", "")
                $counter = 1

                # Add a counter to the directory name if it already exists
                while (Test-Path $nested_dir) {
                    $nested_dir = Join-Path $DEST ("$($filename -replace "\..+$", "")_$counter")
                    $counter++
                }

                New-Item -ItemType Directory -Path $nested_dir | Out-Null

                # Move the extracted files to the nested directory
                Move-Item "$temp_dir\*" $nested_dir

                # Move the processed archive to the "Archive" folder
                Move-Item $f $ARCHIVE_DEST

                # Display a notification for the moved file with filename and destination folder name
                Add-Type -TypeDefinition @"
                    using System;
                    using System.Windows.Forms;
                    public class Notify {
                        public static void ShowNotification(string message, string title) {
                            NotifyIcon notifyIcon = new NotifyIcon();
                            notifyIcon.Visible = true;
                            notifyIcon.ShowBalloonTip(5000, title, message, ToolTipIcon.Info);
                            notifyIcon.Dispose();
                        }
                    }
"@
                [Notify]::ShowNotification("${filename -replace "\..+$", ""} has moved to $nested_dir/", "File Moved")
            }

            # Remove the temporary directory
            Remove-Item $temp_dir -Recurse -Force
        } else {
            # Check if the file already exists in the destination folder
            if (Test-Path "$DEST\$filename") {
                $counter = 1
                $new_filename = "$($filename -replace "\..+$", "")_$counter$($filename -replace "^.+(\..+)$", "\$1")"

                # Add a counter to the filename until it's unique in the destination folder
                while (Test-Path "$DEST\$new_filename") {
                    $counter++
                    $new_filename = "$($filename -replace "\..+$", "")_$counter$($filename -replace "^.+(\..+)$", "\$1")"
                }

                $destination = "$DEST\$new_filename"
            }

            # Move the file to the destination folder
            Move-Item $f $destination

            # Display a notification for the moved file with filename and destination folder name
            Add-Type -TypeDefinition @"
                using System;
                using System.Windows.Forms;
                public class Notify {
                    public static void ShowNotification(string message, string title) {
                        NotifyIcon notifyIcon = new NotifyIcon();
                        notifyIcon.Visible = true;
                        notifyIcon.ShowBalloonTip(5000, title, message, ToolTipIcon.Info);
                        notifyIcon.Dispose();
                    }
                }
"@
            [Notify]::ShowNotification("${filename -replace "\..+$", ""} has moved to $destination", "File Moved")
        }

        # Remove the processed archive from the Downloads folder
        if ($f -match "\.($ARCHIVE_EXTENSIONS)$") {
            Remove-Item $f
        }
    }
}
