-----------------------------------------------------------------------------------------
--
-- Score.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local widget = require "widget"
local audio = require("Laudio")
local o = require("Loptions")
local v = require("Lversion")
local ghs=display.newGroup()
local Score
local GVersion
local OKVers={
		"GAMMA 1.0.1",
	}
local Default={
		"Brownie S.",10000,
		"Go Q.",9001,
		"T. Pastry",7500,
		"Blue X.",5000,
		"H. Dew",2500,
		"D. \"Fox\" Leigh",1000,
		"M. Person",500,
		"Moorabi",250,
		"Reese C.",100,
		"E. Z. Mood",10
	}
	
function onBackBtn()
	
	if (Text) then
		for i=table.maxn(Text),1,-1 do
			local child = Text[i]
			child.parent:remove( child )
			Text[i]=nil
		end
		Text=nil
	end
	if (Sve) then
		for i=table.maxn(Sve),1,-1 do
			Sve[i]=nil
		end
		Sve=nil
	end
	for i=ghs.numChildren,1,-1 do
		local child = ghs[i]
		child.parent:remove( child )
	end
	o.DisplayOptions()
end

function Scoring(round,p1,size)
	Score=(
		p1.gp/round
	)
	Score=(
		Score*((size/10)-1)
	)
	local process=(
		p1.stats[1]+p1.stats[2]+p1.stats[3]+p1.stats[4]+p1.stats[5]+p1.stats[6]
	)
	local process=(
		process/(15+(p1.lvl*4))
	)
	Score=(
		math.floor(Score*process)
	)
	local hs=isHigh(Score,p1.name)
	return Score,hs
end

function isHigh(val,name)
	local banner=false
	if val~=nil then
		CheckScore()
		Sve={}
		local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
		for line in io.lines( path ) do
			n = tonumber(line)
			if n == nil then
				Sve[#Sve+1]=line
			else
				Sve[#Sve+1]=n
			end
		end
		local overIt=false
		for l=table.maxn(Sve),2,-2 do
			if val>Sve[l] then
				overIt=l
			end
		end
		if overIt~=false then
			banner=true
			local fh, errStr = io.open( path, "r+" )
			
			fh:write( Sve[1], "\n" )
			for z=2,(overIt-2),2 do
				fh:write( Sve[z], "\n" )
				fh:write( Sve[z+1], "\n" )
			end
			
			fh:write( name, "\n" )
			fh:write( val, "\n" )
			
			for z=overIt-1,19,2 do
				fh:write (Sve[z], "\n")
				fh:write( Sve[z+1], "\n" )
			end
			
			io.close( fh )
		end
	end
	CleanScores()
	return banner
end

function HighScores()
	--Displays high scores
	
	title=display.newText("High Scores",0,0,"MoolBoran",100)
	title.x = display.contentWidth*0.5
	title.y = 100
	title:setTextColor(125,250,125)
	ghs:insert(title)
	
	BackBtn = widget.newButton{
		label="Back",
		labelColor = { default={255,255,255}, over={0,0,0} },
		fontSize=30,
		defaultFile="cbutton.png",
		overFile="cbutton-over.png",
		width=290, height=90,
		onRelease = onBackBtn
	}
	BackBtn:setReferencePoint( display.CenterReferencePoint )
	BackBtn.x = display.contentWidth*0.5
	BackBtn.y = display.contentHeight-100
	ghs:insert(BackBtn)
	
	Sve={}
	
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	for line in io.lines( path ) do
		n = tonumber(line)
		if n == nil then
			Sve[#Sve+1]=line
		else
			Sve[#Sve+1]=n
		end
	end
	Nums={}
	for n=1,10 do
		Nums[#Nums+1] = display.newText( (n.."."),50,145+(72*#Nums),"MoolBoran", 75 )
		Nums[#Nums]:setTextColor(250,250,125)
		ghs:insert(Nums[#Nums])
	end
	
	Lines={}
	for l=1,10 do
		Lines[#Lines+1] = display.newText( ("___________________________"),135,145+(72*#Lines),"MoolBoran", 75 )
		Lines[#Lines]:setTextColor(125,125,125)
		ghs:insert(Lines[#Lines])
	end
	
	Text={}
	for t=2,21,2 do
		Text[#Text+1] = display.newText( ( (Sve[t].." - "..Sve[t+1]) ) ,140,145+(72*#Text),"MoolBoran", 75 )
		ghs:insert(Text[#Text])
	end
end

function CleanScores()

	Sve={}
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	for line in io.lines( path ) do
		n = tonumber(line)
		if n == nil then
			Sve[#Sve+1]=line
		else
			Sve[#Sve+1]=n
		end
	end
	
	local fh, errStr = io.open( path, "w+" )
	
	for z=1,21 do
		fh:write( Sve[z], "\n" )
	end
	
	io.close( fh )
	
	if (Sve) then
		for i=table.maxn(Sve),1,-1 do
			Sve[i]=nil
		end
		Sve=nil
	end
end

function CheckScore()
	--Fills in empty score file with zeros.
	GVersion=v.HowDoIVersion(true)
	local path = system.pathForFile(  "DoGScores.sco", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		local contents = fh:read( "*a" )
		if (contents) and contents~="" and contents~=" " then
			io.close( fh )
			Sve={}
			for line in io.lines( path ) do
				n = tonumber(line)
				
				if n == nil then
					Sve[#Sve+1]=line
				else
					Sve[#Sve+1]=n
				end
			end
			local saveok=false
			for i=1,table.maxn(OKVers) do
				if Sve[1]==OKVers[i] then
					saveok=true
				end
			end
			if saveok==false then
				local fh, errStr = io.open( path, "w+" )
				
				fh:write( GVersion, "\n" )
				for z=1,20 do
					fh:write( Default[z], "\n" )
				end
				io.close( fh )
			
				if (Sve) then
					for i=table.maxn(Sve),1,-1 do
						Sve[i]=nil
					end
					Sve=nil
				end
			end
		else
			local fh, errStr = io.open( path, "w+" )
			fh:write( GVersion, "\n" )
			for z=1,20 do
				fh:write( Default[z], "\n" )
			end
			io.close( fh )
		end
	else
		local fh, errStr = io.open( path, "w+" )
		fh:write( GVersion, "\n" )
		for z=1,20 do
			fh:write( Default[z], "\n" )
		end
		io.close( fh )
	end
end

