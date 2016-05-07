-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( false )
local loadsheet = graphics.newImageSheet( "spriteload.png", { width=50, height=50, numFrames=8 } )
local startup=require("Lstartup")
local menu = require("Lmenu")
local widget = require "widget"
local physics = require "physics"
local bin = require("Lgarbage")
local v=require("Lversion")
local GVersion=v.HowDoIVersion(false)
local loadbkg
local load1
local loadtxt

	print "C U B 3 D :  DUNGEONS OF GAL'DARAH"
	print ("Version: "..GVersion)
	
	
	physics.start()
	physics.setGravity(0,30)
	menu.ShowMenu()
	timer.performWithDelay(100,menu.ReadySetGo)
--	startup.Startup()
--	bin.Font()
	