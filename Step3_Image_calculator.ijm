// === Step 1: Setup ===
run("Close All");
run("Clear Results");
if (roiManager("count") != 0) roiManager("delete");

// === Step 2: Ask for directories ===
nmDir = getDirectory("Select the NM folder (ch2 images)");
mitoDir = getDirectory("Select the Mitochondria folder (ch3 images)");

// === Step 3: Prepare output folder ===
outputDir = File.getParent(mitoDir) + File.separator + "Subtracted_Results" + File.separator;
File.makeDirectory(outputDir);
print("Output folder: " + outputDir);

// === Step 4: Get image lists ===
nmList = getFileList(nmDir);
filtered = newArray();
for (i = 0; i < nmList.length; i++) {
    nameLower = toLowerCase(nmList[i]);

    if (endsWith(nameLower, ".tif") || endsWith(nameLower, ".tiff")) {
        filtered = Array.concat(filtered, nmList[i]);
    }
}
nmList = filtered;
Array.sort(nmList);



mitoList = getFileList(mitoDir);
filtered = newArray();
for (i = 0; i < mitoList.length; i++) {
    nameLower = toLowerCase(mitoList[i]);

    if (endsWith(nameLower, ".tif") || endsWith(nameLower, ".tiff")) {
        filtered = Array.concat(filtered, mitoList[i]);
    }
}
mitoList = filtered;
Array.sort(mitoList);


n = minOf(nmList.length, mitoList.length);

if (nmList.length != mitoList.length){
	print("error : not the same number of files");
	exit("error : not the same number of files");
}
print("Found " + n + " image pairs.");

// === Step 5: Loop through images ===
for (i = 0; i < n; i++) {
	


    nmName = nmList[i];
    mitoName = mitoList[i];
    
    if (endsWith(nmName, "/") || endsWith(mitoName, "/")) continue;
    
    nmPrefix   = substring(nmName, 0, 12);
	mitoPrefix = substring(mitoName, 0, 12);
	
	if (nmPrefix == mitoPrefix) {

	} else {
	    print("Not a match :"+nmName+"  vs  "+mitoName);
	    break;
	}

    

    print("Processing pair: " + mitoName + " - " + nmName);

    open(mitoDir + mitoName);
    open(nmDir + nmName);

    // Perform subtraction (note: capital 'S')
    run("Image Calculator...", "image1=[" + mitoName + "] operation=Subtract image2=[" + nmName + "] create");

    // Rename result image
    resultTitle = "Subtracted_" + mitoName;
    rename(resultTitle);

    // Save the subtracted image
    saveAs("Tiff", outputDir + resultTitle);

    // Close the original images
    selectWindow(mitoName); close();
    selectWindow(nmName); close();

    // Analyze particles on the result image
    selectWindow(resultTitle);
    getStatistics(area, mean, min, max, std, histogram);
    // don t convert if image is all empty 
    if (min!=max) {
    run("Convert to Mask");	
    } else {
    	// be sure ot have an empty Results window
    	run("Measure");
    	run("Clear Results");
    }
    run("Analyze Particles...", "size=0.0005-Infinity show=Outlines display summarize add");

    // Save the analyzed outlines
    outlinesTitle = "Drawing of " + resultTitle;
    if (isOpen(outlinesTitle)) {
        saveAs("Tiff", outputDir + "Analyzed_" + mitoName);
        close(outlinesTitle);
    }

    // Save Results table
    selectWindow("Results");
    saveAs("Results", outputDir + replace(mitoName, ".tiff", "_Results.csv"));
    run("Clear Results");

    // Save Summary table if available
    if (isOpen("Summary")) {
        selectWindow("Summary");
        saveAs("Results", outputDir + replace(mitoName, ".tiff", "_Summary.csv"));
        close("Summary");
    }

    close(resultTitle);
    
}

print("=== Subtraction and particle analysis completed successfully! ===");
//run("close all")