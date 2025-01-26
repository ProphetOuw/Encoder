# Encoder
A Httpservice wrapper for encoding and decoding data. This wrapper module supports types that aren't normally supported while encoding or decoding json data, such as:
- Colorsequence
- Color3
- Numbersequence
- Enums
- And maybe all of the roblox property types.
## Installation
### Roblox
https://create.roblox.com/store/asset/140335706414339/Encoder
### Wally
```
Encoder = "prophetouw/encoder@1.1.0"
```
### Github
See the [releases](https://github.com/ProphetOuw/Encoder/releases/tag/v1) page and download the latest rbxm file.
## Tutorial
```lua
local Encoder = require(path)
--Encoding
local Data = Encoder.Encode({
    Name = "Haily"
    Color = Color3.new(1,1,1);
    Color2 = Colorsequence.new({
        ...
    })
    Position = UDim2.new(.234,0,1,0)
})
--Decoding
Data = Encoder.Decode(Data)
```
### Encoding
```lua
local dataTable = {}
local Encoded: string = Encoder.Encode(dataTable)
```
### Decoding
```lua
local jsonContent = ``
local Data: {} = Encoder.Decode(jsonContent)
```