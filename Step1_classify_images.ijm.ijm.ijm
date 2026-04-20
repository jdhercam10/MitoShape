// Clear environment
run("Close All");
run("Clear Results");
if (roiManager("count") != 0) roiManager("delete");

// Ask user for image directory
dir = getDirectory("Select the folder with images");
list = getFileList(dir);

// Create output folders
nucleiDir = dir + "Nuclei" + File.separator;
nmDir     = dir + "NM" + File.separator;
mitoDir   = dir + "Mitochondria" + File.separator;

File.makeDirectory(nucleiDir);
File.makeDirectory(nmDir);
File.makeDirectory(mitoDir);

// Loop through all files and classify
for (i = 0; i < list.length; i++) {
    name = list[i];
    path = dir + name;

    // Skip directories
    if (endsWith(name, "/")) continue;

    // Check channel number and move file to corresponding folder
    if (indexOf(name, "ch1") != -1) {
        File.rename(path, nucleiDir + name);
        print("Moved to Nuclei: " + name);
    }
    else if (indexOf(name, "ch2") != -1) {
        File.rename(path, nmDir + name);
        print("Moved to NM: " + name);
    }
    else if (indexOf(name, "ch3") != -1) {
        File.rename(path, mitoDir + name);
        print("Moved to Mitochondria: " + name);
    }
    else {
        print("Channel not recognized: " + name);
    }
}

print("Classification completed!");
