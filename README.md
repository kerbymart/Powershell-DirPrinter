# DirPrinter
A PowerShell script that prints the contents of a directory, including file names and paths, to a single text file. The files' contents are also written to the text file.

## Usage
To use the script, open a PowerShell window and navigate to the directory containing the script. Then, run the script with the following syntax:

```
.\DirPrinter.ps1 baseDirectory outputFile [-SkipBinary]
```

- `baseDirectory`: The path to the base directory to be processed.
- `outputFile`: The path to the output file where the directory contents will be written.
- `-SkipBinary` (optional): A flag indicating whether binary files should be skipped. If provided, binary files will be skipped.

Here's an example of how to run the script:

```
.\DirPrinter.ps1 C:\MyFiles C:\Output\DirectoryContents.txt -SkipBinary
```

This will print the contents of the directory at C:\MyFiles to the file at C:\Output\DirectoryContents.txt, skipping any binary files.

## Notes

- Binary files are defined as files with the following extensions: `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.mp3`, `.mp4`, `.mpeg`, `.wav`, `.wma`, `.wmv`, `.webm`, `.ogg`, `.flac`, `.aac`, `.ac3`, `.eot`, `.otf`, `.ttf`, `.woff`, `.woff2`, `.zip`, `.rar`, `.tar`, `.gz`, `.7z`, `.iso`, `.bin`, `.exe`, `.dll`, `.sys`, `.msi`, `.cab`.
- The script will process all files in the base directory and its subdirectories, excluding the ".git" subdirectory.
- The script will process ".md" files first, followed by the remaining files.
- The script will display a progress bar as it processes the files.
- If the output file already exists, it will be overwritten.

