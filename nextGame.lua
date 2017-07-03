local composer = require( "composer" )
local scene = composer.newScene()
local myData = require( "mydata" )
local appodeal = require( "plugin.appodeal" )
local loadsave = require( "loadsave" )
local color = {}
local l = myData.settings.currentLevel
if ( myData.settings.levels[l]==nil) then-- and (myData.settings.levels[l].stars==nil)) and (myData.settings.levels[l].stars<1 )) then
  if l>=myData.settings.unlockedLevels and l<myData.maxLevels then
   myData.settings.unlockedLevels=l+1
  end

 myData.settings.levels[l] = {}
 myData.settings.levels[l].stars=1
 myData.settings.passedLevels = myData.settings.passedLevels+1
  loadsave.saveTable( myData.settings, "settings.json" )
end
color[1]=myData.colors[1]
color[2]=myData.colors[2]
color[3]=myData.colors[3]
color[4]=myData.colors[4]
color[5]=myData.colors[1]
color[6]=myData.colors[2]

local title = {}
local title2 = {}

local function bouncingText()
	local function transBack ()
			for i=1, #title do
				transition.to( title[i], {time=400, y=centerY-160, delay=150*i} )
				i=i+1
			end
	end
	for i=1, #title do
		transition.to( title[i], {time=400, y=centerY-180, delay=150*i, onComplete=transBack} )
		i=i+1
	end
end

local function bouncingText2()
	local function transBack ()
			for i=1, #title2 do
				transition.to( title2[i], {time=400, y=centerY-120, delay=150*i} )
				i=i+1
			end
	end
	for i=1, #title2 do
		transition.to( title2[i], {time=400, y=centerY-100, delay=150*i, onComplete=transBack} )
		i=i+1
	end
end

local function goToLevels (event)
  if ( "ended" == event.phase ) then
    appodeal.hide("banner")
    myData.removeAll(color,t,title,title2)
  	if myData.settings.currentLevel<myData.maxLevels then
  		composer.gotoScene("game"..myData.settings.currentLevel+1, { effect="crossFade", time=200 })
  	else
  		composer.gotoScene( "levels", { effect="crossFade", time=200 })
  	end
  end
end

local function handleCancelButtonEvent( event )
    if ( "ended" == event.phase ) then
      myData.removeAll(color,t,title,title2)
      composer.gotoScene( "levels", { effect="crossFade", time=333 } )
    end
end
--############## Create scene ######################################################################################
function scene:create( event )

	local sceneGroup = self.view


  local background = display.newRect( sceneGroup, centerX, centerY, screenWidth, screenHeight )
  background:setFillColor(0,0,0)

	local backButton = display.newImage( sceneGroup, "images/backButton.png", screenLeft+30, screenTop+30)
	backButton.width=40
	backButton.height=40
	backButton:addEventListener("touch", handleCancelButtonEvent)

	for i=1, 5 do
		title[i] = display.newText( myData.t[i], 76+i*27, centerY-160, "Supersonic Rocketship",40 )
		title[i].fill=color[i]
		sceneGroup:insert(title[i])
		i=i+1
	end
	for i=1, 6 do
		title2[i] = display.newText( myData.t[i+5], 66+i*27, centerY-120, "Supersonic Rocketship",40 )
		title2[i].fill=color[i]
		sceneGroup:insert(title2[i])
		i=i+1
	end

	bouncingText()
	timer.performWithDelay(2000, bouncingText,0)
	bouncingText2()
	timer.performWithDelay(2000, bouncingText2,0)

	local scoreText = display.newText( sceneGroup, myData.settings.currentLevel.."/20", centerX, centerY-30, "Supersonic Rocketship", 34 )

	local competeText = display.newText( sceneGroup,"COMPLETED", centerX, centerY+20, "Supersonic Rocketship",34 )

	local restartButton = display.newImage( sceneGroup, "images/nextButton.png", centerX, centerY+110)
	restartButton.width=90
	restartButton.height=restartButton.width
  myData.animationButton(restartButton)
	restartButton:addEventListener("touch", goToLevels)
	--transition.to( restartButton, {time=1000, xScale=1.15, yScale=1.15, iterations=999} )
  myData.animationButton(restartButton)
	sceneGroup:insert(restartButton)



end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		appodeal.show("banner")
	elseif ( phase == "did" ) then
    myData.showAds()
    composer.removeHidden()
	end
end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

	end
end

function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
return scene
