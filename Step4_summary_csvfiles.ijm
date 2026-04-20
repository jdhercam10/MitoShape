// === Combine all CSV files in a selected folder into one ===
// Author: Juan Diego & ChatGPT
// Date: 2025-10-15

// Step 1: Ask user to select the folder
folder = getDirectory("Select the folder containing .csv files");

// Step 2: Define output file path
outputFile = folder + "Combined_Results.csv";

// Step 3: Get the list of CSV files
list = getFileList(folder);
n = list.length;
if (n == 0) {
    exit("No files found in the selected folder!");
}

// Step 4: Initialize variables
headerWritten = false;
combined = "";

// Step 5: Loop through each file
for (i = 0; i < n; i++) {
    name = list[i];
    if (!endsWith(name, ".csv")) continue;
    path = folder + name;
    
    // Read file content
    content = File.openAsString(path);
    lines = split(content, "\n");

    if (lengthOf(lines) < 2) continue; // Skip empty files
    
    if (!headerWritten) {
        // Write header from the first file
        combined += lines[0] + "\n";
        headerWritten = true;
    }
    
    // Append all lines except header
    for (j = 1; j < lengthOf(lines); j++) {
        if (trim(lines[j]) != "") {
            combined += lines[j] + "\n";
        }
    }
    
    print("Added: " + name);
}

// Step 6: Save combined file
File.saveString(combined, outputFile);
print("=== Combined CSV saved as: " + outputFile + " ===");
