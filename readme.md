## BarcodeReader
Reading EAN/UPC Barcodes
### Description
Script loads periodically all images inside the 'resources' folder.
If there are codes successfully found in one of the images, the content
and coordinates of the codes are printed.
Configuring any code reader requires always the following steps:
1. Creating CodeReader
2. Creating Decoder
3. Creating Symbology (if applicable)
4. Setting Symbology to Decoder (if applicable)
5. Setting Decoder to CodeReader
### How to Run
The sample can be run using the SIM4000 emulator. The result is printed to the
console. The ImageView shows the images and marks the found codes.
Additional images with barcodes can be placed in the resource folder.
### More Information
See also Sample CodeReader for reading QR code

### Topics
Algorithm, Image-2D, Code-Reading, Sample, SICK-AppSpace