// === Step 0: Setup ===
run("Close All");
run("Clear Results");
if (roiManager("count") != 0) roiManager("delete");

// === Step 1: Ask for main directory ===
mainDir = getDirectory("Select the main folder");
nmDir = mainDir + "NM" + File.separator;
mitoDir = mainDir + "Mitochondria" + File.separator;

// === Step 2: Create masks in NM folder ===
nmList = getFileList(nmDir);
print("Creating masks in NM...");
for (i = 0; i < nmList.length; i++) {
    name = nmList[i];
    if (endsWith(name, "/")) continue;
    open(nmDir + name);
    //run("Enhance Contrast", "saturated=0.55");
    //run("Subtract Background...", "rolling=25");
    


    run("Smooth");
    run("Smooth");
    
    setThreshold(250, 65535, "raw");
    run("Convert to Mask");
    /*run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");
    run("Erode");
    run("Dilate");*/
    run("Maximum...", "radius=5");
	run("Minimum...", "radius=5");
    run("Fill Holes");
    run("Fill Holes");

// === ADDED: Remove small particles after all processing ===
// Clear ROI Manager first
roiManager("reset");
// Analyze small particles and add them to ROI Manager
run("Analyze Particles...", "size=0-0.5 add");
// Check if any small particles were found
if (roiManager("count") > 0) {
    // Combine all ROIs into one selection
    roiManager("Combine");
    run("Convert to Mask");
    run("Invert");
    roiManager("Combine");
    // Now fill the combined selection
    run("Fill", "slice");
}
else{
	run("Invert");
}
// Clear ROI Manager for next image
roiManager("reset");
run("Select None");
    
    saveAs("Tiff", nmDir + name);
    close();
}
print("NM masks created.");

// === Step 3: Create masks in Mitochondria folder ===
mitoList = getFileList(mitoDir);
print("Creating masks in Mitochondria...");
for (i = 0; i < mitoList.length; i++) {
    name = mitoList[i];
    if (endsWith(name, "/")) continue;
    open(mitoDir + name);
        // Step 1: Pre-processing
    //run("Gaussian Blur...", "sigma=1.0"); // Reduce noise
    //run("Subtract Background...", "rolling=50 light"); // Remove background gradient
    //run("Enhance Contrast", "saturated=0.35");
    //run("Convert to Mask");
    print(mitoDir + name);
	
	
	run("Duplicate...", "title=A");
	run("Duplicate...", "title=B");
	selectImage("A");
	run("Gaussian Blur...", "sigma=0.5");
	selectImage("B");
	run("Gaussian Blur...", "sigma=7.5");
	
	imageCalculator("Subtract create 32-bit", "A","B");
	selectImage("A");
	close;
	selectImage("B");
	close;
	selectImage("Result of A");
	
	//run("Dilate");
	//run("Dilate");
	
	setAutoThreshold("Triangle dark");
	
	run("Convert to Mask");
	("Erode"); // Separate touching mitochondria
    ("Dilate"); // Restore original size
    ("Dilate"); // Restore original size
    ("Dilate"); // Restore original size
    ("Close-");
    ("Close-");
    ("Erode"); // Separate touching mitochondria
    ("Dilate"); // Restore original size
    ("Close-");
    saveAs("Tiff", mitoDir + name);
    close();
}
print("Mitochondria masks created.");

// === Step 4: Duplicate NM and Mitochondria folders ===
nm2Dir = mainDir + "NM2" + File.separator;
mito2Dir = mainDir + "Mitochondria2" + File.separator;
File.makeDirectory(nm2Dir);
File.makeDirectory(mito2Dir);

nmList = getFileList(nmDir);
mitoList = getFileList(mitoDir);
for (i = 0; i < nmList.length; i++)
    File.copy(nmDir + nmList[i], nm2Dir + nmList[i]);
for (i = 0; i < mitoList.length; i++)
    File.copy(mitoDir + mitoList[i], mito2Dir + mitoList[i]);

print("Folders duplicated to NM2 and Mitochondria2.");

// === Step 5: Invert masks in NM2 ===
nm2List = getFileList(nm2Dir);
print("Inverting masks in NM2...");
for (i = 0; i < nm2List.length; i++) {
    name = nm2List[i];
    if (endsWith(name, "/")) continue;
    open(nm2Dir + name);
    run("Invert");
    saveAs("Tiff", nm2Dir + name);
    close();
}
print("Inversion completed.");
//run("close all")
