# ModeLua
Here's my tiny "from class to lua code" software. It uses Löve2D v11.1 ( https://love2d.org/ )

Drag classes in the canvas, drag attributes and functions in the classes, double click to rename, then press the generate button. One file per class will be created, containing my simple implementation of class in Lua : every file will return a factory function and can be used like that :

```lua
local MyClassFactory = require("myClass")

local MyInstance = MyClassFactory()
```

