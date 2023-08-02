# AutoFile_3DPrints
Scripts to automatically move 3D Printing files to destination

# 3D Printer File Organizer

This repository contains two versions of a file organizer script for 3D printer files. The script helps you manage your 3D printer files by organizing them into a destination folder while maintaining a clean Downloads folder. It can handle both individual 3D printer files and archive files containing multiple 3D printer files.

## macOS (Automator Setup)

The `3dprinter_organizer.sh` script is designed to work on macOS and Linux systems using the Bash shell. However, macOS users can set up the script using Automator, which provides a more user-friendly approach.

### Setup Steps (macOS):

1. Open Automator (you can find it in the Applications folder).

2. Choose "New Document."

3. Select "Application" as the document type and click "Choose."

4. In the search bar, type "Run Shell Script" and drag it to the right pane.

5. In the "Run Shell Script" action, select "Pass input: as arguments."

6. Replace the default script with the contents of the `3dprinter_organizer.sh` script.

7. Customize the script variables:
   - `DEST`: Set the destination folder path for your 3D printer files.
   - `ARCHIVE_DEST`: Set the archive folder path to store processed archives.

8. Save the Automator application with a name like "3D Printer Organizer."

9. Now you can run the Automator application and drag and drop files onto it to organize your 3D printer files.

## Windows (PowerShell Setup)

The `3dprinter_organizer.ps1` script is designed to work on Windows systems using PowerShell.

### Setup Steps (Windows):

1. Customize the script parameters:
   - `$DEST`: Set the destination folder path for your 3D printer files.
   - `$ARCHIVE_DEST`: Set the archive folder path to store processed archives.

2. Save the script with the `.ps1` extension (e.g., `3dprinter_organizer.ps1`).

3. Ensure you have 7-Zip installed on your system and accessible via the PATH environment variable. You can download 7-Zip from https://www.7-zip.org/.

4. Open PowerShell (you can find it in the Start menu or by pressing Win + X and selecting "Windows PowerShell").

5. Navigate to the folder where you saved the `3dprinter_organizer.ps1` script.

6. Run the script using PowerShell with the files you want to organize as arguments:
   ```powershell
   .\3dprinter_organizer.ps1 file1.stl file2.zip file3.3mf
   ```

## Linux (Bash Setup)

The `3dprinter_organizer.sh` script is designed to work on Linux systems using the Bash shell.

### Setup Steps (Linux):

1. Customize the script variables:
   - `DEST`: Set the destination folder path for your 3D printer files.
   - `ARCHIVE_DEST`: Set the archive folder path to store processed archives.

2. Save the script with the `.sh` extension (e.g., `3dprinter_organizer.sh`).

3. Make the script executable:
   ```bash
   chmod +x 3dprinter_organizer.sh
   ```

4. Run the script with the files you want to organize as arguments:
   ```bash
   ./3dprinter_organizer.sh file1.stl file2.zip file3.3mf
   ```

## Disclaimer

The provided script is offered for educational and personal use only. The author assumes no responsibility for any misuse or damage caused by the script. Use it responsibly and carefully to avoid unintended data loss or any other undesirable outcomes.

## Note

- This script has been created with the assistance of an AI language model. While it has undergone testing on macOS with Automator, it is recommended to exercise caution when using it on other systems or platforms.
- Feel free to use, modify, and contribute to this project. If you encounter any issues or have suggestions for improvements, please create an issue or submit a pull request.
```
