# Check if the required number of arguments was provided
if ($args.Count -lt 2)
{
    Write-Error "Error: Missing arguments. Usage: script.ps1 baseDirectory outputFile [-SkipBinary]"
    exit 1
}

# Set the base directory and output file from the arguments
$baseDirectory = $args[0]
$outputFile = $args[1]

# Set the default value for the $skipBinary variable
$skipBinary = $false

# Check if the -SkipBinary option was provided
$skipBinaryOptionIndex = $args | Select-String -SimpleMatch "-SkipBinary" | Select-Object -ExpandProperty LineNumber
if ($skipBinaryOptionIndex)
{
    $skipBinary = $true
}

# Get all the ".md" files in the base directory and its subdirectories, excluding the .git subdirectory
$mdFiles = Get-ChildItem -Path $baseDirectory -Recurse -File -Exclude ".git" | Where-Object { $_.Directory -notmatch ".git" } | Where-Object { $_.Extension -eq ".md" }

# Get all the remaining files in the base directory and its subdirectories, excluding the .git subdirectory
$otherFiles = Get-ChildItem -Path $baseDirectory -Recurse -File -Exclude ".git" | Where-Object { $_.Directory -notmatch ".git" } | Where-Object { $_.Extension -ne ".md" }

# Open the output file
$outputFileStream = New-Object System.IO.FileStream($outputFile, [System.IO.FileMode]::OpenOrCreate)
$outputFileStream.SetLength(0)
$output = New-Object System.IO.StreamWriter($outputFileStream)

# Write the header to the output file
$output.WriteLine("Files processed:")
$mdFiles | ForEach-Object {
    $output.WriteLine(" - Filename: $( $_.Name )")
    $output.WriteLine("   Filepath: $( $_.FullName )")
}
$otherFiles | ForEach-Object {
    $output.WriteLine(" - Filename: $( $_.Name )")
    $output.WriteLine("   Filepath: $( $_.FullName )")
}
$output.WriteLine("Total number of files processed: $( $mdFiles.Count + $otherFiles.Count )")
$output.WriteLine()

# Initialize the progress counter
$progressCounter = 0

# Set the total number of files being processed
$totalFiles = $mdFiles.Count + $otherFiles.Count

# Process the ".md" files first
foreach ($file in $mdFiles)
{
    # Increment the progress counter
    $progressCounter++

    # Calculate the current progress percentage
    $progressPercent = [int](($progressCounter / $totalFiles) * 100)

    # Display the progress bar
    Write-Progress -Activity "Processing files" -Status "Processing file $( $file.Name ) -PercentComplete $progressPercent"

    # Read the contents of the file as a single string
    $contents = Get-Content -Path $file.FullName -Raw

    # Write the file name to the output file
    $output.WriteLine("File: $( $file.FullName )")

    # Write the contents of the file to the output file
    $output.WriteLine($contents)
    $output.WriteLine()
}

# Process the remaining files
foreach ($file in $otherFiles)
{
    # Skip binary files if the -SkipBinary option was provided
    if ($skipBinary -and $file.Extension -match "^(.jpg|.jpeg|.png|.gif|.bmp|.mp3|.mp4|.mpeg|.wav|.wma|.wmv|.webm|.ogg|.flac|.aac|.ac3|.eot|.otf|.ttf|.woff|.woff2)$")
    {
        continue
    }

    # Increment the progress counter
    $progressCounter++

    # Calculate the current progress percentage
    $progressPercent = [int](($progressCounter / $totalFiles) * 100)

    # Display the progress bar
    Write-Progress -Activity "Processing files" -Status "Processing file $( $file.Name ) -PercentComplete $progressPercent"

    # Read the contents of the file as a single string
    $contents = Get-Content -Path $file.FullName -Raw

    # Write the file name to the output file
    $output.WriteLine("File: $( $file.FullName )")

    # Write the contents of the file to the output file
    $output.WriteLine($contents)
    $output.WriteLine()
}

# Close the output file
$output.Close()
