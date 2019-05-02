--[[----------------------------------------------------------------------------

  Application Name:
  BarcodeReader

  Summary:
  Reading EAN/UPC Barcodes

  Description:
  Script loads periodically all images inside the 'resources' folder.
  If there are codes successfully found in one of the images, the content
  and coordinates of the codes are printed.
  Configuring any code reader requires always the following steps:
  1. Creating CodeReader
  2. Creating Decoder
  3. Creating Symbology (if applicable)
  4. Setting Symbology to Decoder (if applicable)
  5. Setting Decoder to CodeReader

  How to run:
  The sample can be run using the SIM4000 emulator. The result is printed to the
  console. The ImageView shows the images and marks the found codes.
  Additional images with barcodes can be placed in the resource folder.

  More Information:
  See also Sample CodeReader for reading QR codes

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

local ImageInputPath = 'resources/'

-- Creating image provider
local provider = Image.Provider.Directory.create()
provider:setPath(ImageInputPath)
provider:setCycleTime(3000)

-- Creating viewer instance and decoration
local viewer = View.create()
viewer:setID('viewer2D')

local regionDecoration = View.ShapeDecoration.create()
regionDecoration:setLineColor(0, 255, 0) -- green

-- Creating code reader
local codeReader = Image.CodeReader.create()
-- Creating barcode decoder
local decoder = Image.CodeReader.Barcode.create()
-- Creating UPC symbology
local symbology = Image.CodeReader.Barcode.UPC.create()

-- Appending created UPC symbology to barcode decoder
Image.CodeReader.Barcode.setSymbology(decoder, 'Append', symbology)
-- Appending barcode decoder to code reader
Image.CodeReader.setDecoder(codeReader, 'Append', decoder)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

--Declaration of the 'main' function as an entry point for the event loop
--@main()
local function main()
  provider:start()
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--@handleNewImage(img:Image, supplements:SensorData)
local function handleNewImage(img, supplements)
  print('=====================================')
  -- Retrieving the file name from the supplementary data
  local origin = SensorData.getOrigin(supplements)
  print("Image: '" .. origin .. "'")
  -- Adding the actual image to the viewer
  viewer:add(img)

  -- Calling the decoder which returns all found codes
  local codes = Image.CodeReader.decode(codeReader, img)

  print('Codes found: ' .. #codes)

  -- Iterating through the decoding results
  for i = 1, #codes do
    -- Retrieving the content and type of the code
    local content = Image.CodeReader.Result.getContent(codes[i])
    local type = Image.CodeReader.Result.getSubType(codes[i])
    -- Retrieving the coordinates of the code
    local region = Image.CodeReader.Result.getRegion(codes[i])
    local cog = Shape.getCenterOfGravity(region)
    local cx, cy = Point.getXY(cog)
    local str = string.format('%s - CX: %s, CY: %s, Type: %s, Content: "%s"', i, cx, cy, type, content)
    print(str)
    -- Adding the region to the viewer
    viewer:add(region, regionDecoration)
  end
  -- Presenting viewer to the user interface
  viewer:present()
end
Image.Provider.Directory.register(provider, 'OnNewImage', handleNewImage)

--End of Function and Event Scope------------------------------------------------
