-----------------------------------------------------------------------------------------
--
-- UI.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local players=require("Lplayers")
local inv=require("Lwindow")
local audio=require("Laudio")
local gold=require("Lgold")
local col=require("Ltileevents")
local WD=require("Lprogress")
local builder=require("Lmapbuilder")
local c=require("Lcombat")
local mob=require("Lmobai")
local widget = require "widget"
local shp=require("Lshop")
local m=require("Lmovement")
local isPaused
local Map
local P1
local bkglevel
local Coins
local topthing
local portsprsnt
local portsnprsnt
local rportprsnt
local hpdprsnt
local hpdnprsnt
local mpdprsnt
local mpdnprsnt
local pwg

function Background()
	if (bkglevel) then
		display.remove(bkglevel)
		bkglevel=nil
	end
	bkglevel = display.newImage("bkgs/bkg_level.png", true)
	bkglevel.x = display.contentCenterX
	bkglevel.y = display.contentCenterY
	bkglevel:toBack()
	return bkglevel
end

function Paused()
	return isPaused
end

function UI(ready)
	if ready==true then
		PauseBtn = widget.newButton{
			defaultFile="pauseon.png",
			overFile="pauseoff.png",
			width=65, height=65,
			onRelease = Pause
		}
		PauseBtn:setReferencePoint( display.CenterReferencePoint )
		PauseBtn.x = window.x+150
		PauseBtn.y = window.y-180
		PauseBtn.xScale = 1.3
		PauseBtn.yScale = PauseBtn.xScale
		pwg:insert(PauseBtn)
	else
		if (pwg) then
			for i=pwg.numChildren,1,-1 do
				display.remove(pwg[i])
				pwg[i]=nil		
			end	
			pwg=nil
		end
		P1=players.GetPlayer()
		pwg=display.newGroup()
		isPaused=false
		
		window=display.newRect(0,0,390,166)
		window:setFillColor(100,100,100,150)
		window.x,window.y=(display.contentWidth-200), display.contentHeight+130
		window.loc=0
		window.ready=1
		pwg:insert(window)
		
		pausetxt=display.newText("Game Paused.",0,0,"MoolBoran",60)
		pausetxt.x=window.x
		pausetxt.y=window.y-90
		pwg:insert(pausetxt)
		
		pausewin=display.newRect(0,0,(#pausetxt.text)*24,38)
		pausewin:setFillColor(0,0,0,150)
		pausewin.x=pausetxt.x
		pausewin.y=pausetxt.y-15
		pwg:insert(pausewin)
		
		pausetxt:toFront()
		
		bag = display.newImageRect("bag.png", 50, 50)
		bag.x, bag.y = window.x+(25*1.28*1.5)-((390-6)/2), window.y+(25*1.28*1.5)-((166-6)/2)
		bag.xScale = 1.28*1.5
		bag.yScale = bag.xScale
		bag:addEventListener("touch",OpenBag)
		pwg:insert(bag)
		
		info = display.newImageRect("infobtn.png", 50, 50)
		info.x, info.y = bag.x+(50*bag.xScale), bag.y
		info.yScale = bag.yScale
		info.xScale = bag.xScale
		info:addEventListener("touch",OpenInfo)
		pwg:insert(info)
		
		snd = display.newImageRect("sound.png",50,50)
		snd.x,snd.y = info.x+(50*info.xScale), bag.y
		snd.xScale=bag.xScale
		snd.yScale=bag.yScale
		snd:addEventListener("touch",OpenSnd)
		pwg:insert(snd)
		
		uiexit = display.newImageRect("exit.png", 50, 50)
		uiexit.x, uiexit.y = snd.x+(50*snd.xScale), bag.y
		uiexit.yScale = bag.yScale
		uiexit.xScale = bag.xScale
		uiexit:addEventListener("touch",OpenExit)
		pwg:insert(uiexit)
		
		MapIndicators("create")
	end
end

function Pause(mute)
	local busy=inv.OpenWindow()
	local shap=shp.AtTheMall()
	local fight=c.InTrouble()
	if busy==false and shap==false and fight==false and window.ready==1 then
		portsprsnt.txt.text=(P1.portcd)
		MovePause(true)
		if isPaused==true then
			isPaused=false
	--		print "!2"
	--		print "Game resumed."
			if mute~=true then
				audio.Play(5)
			end
		elseif isPaused==false then
			isPaused=true
	--		print "!3"
			m.CleanArrows()
			gold.ShowGCounter()
			players.LetsYodaIt()
	--		print "Game paused."
			if mute~=true then
				audio.Play(6)
			end
		end
	elseif busy==true then
		local success=inv.CloseErrthang()
		if success==true then
			Pause()
		end
	end
end

function MovePause(val)
	if (pwg) then
		if not (PauseBtn) then
			timer.performWithDelay(50,MovePause)
		elseif pwg.y==0 and val~=true then
	--		print "!1"
			window.loc=0
			window.ready=1
			m.Visibility()
			gold.ShowGCounter()
			players.LetsYodaIt()
		elseif pwg.y==-216 and val~=true then
	--		print "!4"
			window.loc=1
			window.ready=1
		else
			if window.loc==0 then
				window.ready=0
				pwg.y=pwg.y-27
				PauseBtn.y=PauseBtn.y+27
				PauseBtn.x=PauseBtn.x-50
				timer.performWithDelay(50,MovePause)
			elseif window.loc==1 then
				window.ready=0
				pwg.y=pwg.y+27
				PauseBtn.y=PauseBtn.y-27
				PauseBtn.x=PauseBtn.x+50
				timer.performWithDelay(50,MovePause)
			end
		end
	end
end

function OpenBag( event )
	if event.phase=="ended" then
		inv.ToggleBag()
	end
end

function OpenExit( event )
	if event.phase=="ended" then
		inv.ToggleExit()
	end
end

function OpenSnd( event )
	if event.phase=="ended" then
		inv.ToggleSound()
	end
end

function OpenInfo( event )
	if event.phase=="ended" then
		inv.ToggleInfo()
	end
end

function MapIndicators(val)
	if val=="create" then
		portsprsnt = display.newImageRect("portalspresent.png",80,80)
		portsprsnt.x, portsprsnt.y = bag.x-16, bag.y+(50*1.28)+17
		portsprsnt.xScale,portsprsnt.yScale=0.8,0.8
		portsprsnt.isVisible=false
		pwg:insert(portsprsnt)
		
		portsnprsnt = display.newImageRect("portalsnpresent.png",80,80)
		portsnprsnt.x, portsnprsnt.y = portsprsnt.x, portsprsnt.y
		portsnprsnt.xScale,portsnprsnt.yScale=0.8,0.8
		pwg:insert(portsnprsnt)
		
		portsprsnt.txt=display.newText((P1.portcd),0,0,"Game Over",120)
		portsprsnt.txt.x,portsprsnt.txt.y=portsprsnt.x,portsprsnt.y-5
		portsprsnt.txt.isVisible=false
		pwg:insert(portsprsnt.txt)
		
		hpdprsnt = display.newImageRect("hppresent.png",80,80)
		hpdprsnt.x, hpdprsnt.y = portsprsnt.x+(80*0.8), portsprsnt.y
		hpdprsnt.xScale,hpdprsnt.yScale=0.8,0.8
		hpdprsnt.isVisible=false
		pwg:insert(hpdprsnt)
		
		hpdnprsnt = display.newImageRect("hpnpresent.png",80,80)
		hpdnprsnt.x, hpdnprsnt.y = hpdprsnt.x, portsprsnt.y
		hpdnprsnt.xScale,hpdnprsnt.yScale=0.8,0.8
		pwg:insert(hpdnprsnt)
		
		mpdprsnt = display.newImageRect("mppresent.png",80,80)
		mpdprsnt.x, mpdprsnt.y = hpdprsnt.x+(80*0.8), portsprsnt.y
		mpdprsnt.xScale,mpdprsnt.yScale=0.8,0.8
		mpdprsnt.isVisible=false
		pwg:insert(mpdprsnt)
		
		mpdnprsnt = display.newImageRect("mpnpresent.png",80,80)
		mpdnprsnt.x, mpdnprsnt.y = mpdprsnt.x, portsprsnt.y
		mpdnprsnt.xScale,mpdnprsnt.yScale=0.8,0.8
		pwg:insert(mpdnprsnt)
		
		epdprsnt = display.newImageRect("eppresent.png",80,80)
		epdprsnt.x, epdprsnt.y = mpdprsnt.x+(80*0.8), portsprsnt.y
		epdprsnt.xScale,epdprsnt.yScale=0.8,0.8
		epdprsnt.isVisible=false
		pwg:insert(epdprsnt)
		
		epdnprsnt = display.newImageRect("epnpresent.png",80,80)
		epdnprsnt.x, epdnprsnt.y = epdprsnt.x, portsprsnt.y
		epdnprsnt.xScale,epdnprsnt.yScale=0.8,0.8
		pwg:insert(epdnprsnt)
		
		msprsnt = display.newImageRect("mspresent.png",80,80)
		msprsnt.x, msprsnt.y = epdprsnt.x+(80*0.8), portsprsnt.y
		msprsnt.xScale,msprsnt.yScale=0.8,0.8
		msprsnt.isVisible=false
		pwg:insert(msprsnt)
		
		msnprsnt = display.newImageRect("msnpresent.png",80,80)
		msnprsnt.x, msnprsnt.y = msprsnt.x, portsprsnt.y
		msnprsnt.xScale,msnprsnt.yScale=0.8,0.8
		pwg:insert(msnprsnt)
	
		keynprsnt = display.newImageRect("keyno.png",80,80)
		keynprsnt.x,keynprsnt.y = msprsnt.x+(80*0.8), portsprsnt.y
		keynprsnt.xScale = 0.8
		keynprsnt.yScale = keynprsnt.xScale
		pwg:insert(keynprsnt)
		
		keyprsnt = display.newImageRect("keyget.png",80,80)
		keyprsnt.x,keyprsnt.y = keynprsnt.x, keynprsnt.y
		keyprsnt.xScale = keynprsnt.xScale
		keyprsnt.yScale =keynprsnt.xScale
		keyprsnt.isVisible=false
		pwg:insert(keyprsnt)
	end
	if val=="KEY" then
		keyprsnt.isVisible=true
		keynprsnt.isVisible=false
	end
	if val=="MP" then
		mpdprsnt.isVisible=true
		mpdnprsnt.isVisible=false
	end
	if val=="EP" then
		epdprsnt.isVisible=true
		epdnprsnt.isVisible=false
	end
	if val=="HP" then
		hpdprsnt.isVisible=true
		hpdnprsnt.isVisible=false
	end
	if val=="BP" then
		portsprsnt.isVisible=true
		portsprsnt.txt.isVisible=true
		portsnprsnt.isVisible=false
	end
	if val=="MS" then
		msprsnt.isVisible=true
		msnprsnt.isVisible=false
	end
end

function GetProfBkg()
	return profbkg
end

function CleanSlate()
	if (pwg) then
		for i=pwg.numChildren,1,-1 do
			display.remove(pwg[i])
			pwg[i]=nil		
		end	
		pwg=nil
	end
	if (bkglevel) then
		display.remove(bkglevel)
		bkglevel=nil
	end
end
