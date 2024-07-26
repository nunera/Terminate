getgenv().key = Enum.KeyCode.X
getgenv().message = "/e death."

getgenv().chatToActivate = false -- if false, it will only activate when key is pressed

getgenv().teleportPlayer = true -- if true, it will teleport player instead of camera
getgenv().cooldown = .4
getgenv().automatic = true
getgenv().distance = 2
getgenv().whitelist = {
  
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/nunera/Terminate/main/Script.lua"))()
