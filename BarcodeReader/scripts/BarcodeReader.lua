
--Start of Global Scope---------------------------------------------------------

local ImageInputPath = 'resources/'

-- Creating image provider
local provider = Image.Provider.Directory.create()
provider:setPath(ImageInputPath)
provider:setCycleTime(3000)

-- Creating viewer instance and decoration
local viewer = View.create()

local regionDecoration = View.ShapeDecoration.create():setLineColor(0, 255, 0) -- green

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

---Declaration of the 'main' function as an entry point for the event loop
local function main()
  provider:start()
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

---@param img Image
---@param supplements SensorData
local function handleNewImage(img, supplements)
  print('=====================================')
  -- Retrieving the file name from the supplementary data
  local origin = SensorData.getOrigin(supplements)
  print("Image: '" .. origin .. "'")
  -- Adding the actual image to the viewer
  viewer:addImage(img)

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
    viewer:addShape(region, regionDecoration)
  end
  -- Presenting viewer to the user interface
  viewer:present()
end
Image.Provider.Directory.register(provider, 'OnNewImage', handleNewImage)

--End of Function and Event Scope------------------------------------------------
