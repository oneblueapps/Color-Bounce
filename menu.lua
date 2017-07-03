local composer = require( "composer" )
local scene = composer.newScene()
local appodeal = require( "plugin.appodeal" )
local myData = require("mydata")
local color = {}
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

local function goToLevels ()
	myData.removeAll(color,t,title,title2)
	composer.gotoScene("levels", { effect="crossFade", time=200 })
end

local function rateourapp( event )

        if (system.getInfo("platform") == "android") then
		      local options =
		        {
   		         androidAppPackageName = "com.oneblueapps.colorbounce",
   		         supportedAndroidStores = { "google" },
		        }
						native.showPopup( "appStore", options )
          else
            local options =
  		        {
     		          iOSAppId = "1230955852",
  		        }
					native.showPopup( "appStore", options )
				end
end

local function rateapp(event)
	alert = native.showAlert( "RATE OUR APP 5 STARS", "Thank YOU!", { "RATE 5 STARS", "Later" }, rateourapp )
end

local function goToPrivacyPolicy( event )
  if "clicked" == event.action then
      local i = event.index
      if 1 == i then
		       system.openURL( "http://web-c.pl/oneblueapps/" )
      elseif 2 == i then
			     native.cancelAlert( alert )
        end
    end
end

local function privacyPolicy(event)
  if event.phase == "ended" then
    alert = native.showAlert( "Privacy Policy", "We use device identifiers to personalise ads and more.", { "See detalis", "OK" }, goToPrivacyPolicy )
  end
end

local function goToOptions (event)
	if event.phase == "ended" then
		composer.gotoScene( "options", { effect="crossFade", time=200})
	end
end

--############## Create scene ######################################################################################
function scene:create( event )

	local sceneGroup = self.view


  local background = display.newRect( sceneGroup, centerX, centerY, screenWidth, screenHeight )
  background:setFillColor(0,0,0)

	for i=1, 5 do
		title[i] = display.newText( myData.t[i], 76+i*27, centerY-160, "Supersonic Rocketship",40 )
		sceneGroup:insert(title[i])
		title[i].fill=color[i]
		i=i+1
	end
	for i=1, 6 do
		title2[i] = display.newText( myData.t[i+5], 66+i*27, centerY-120, "Supersonic Rocketship",40 )
		sceneGroup:insert(title2[i])
		title2[i].fill=color[i]
		i=i+1
	end

	bouncingText()
	timer.performWithDelay(2000, bouncingText,0)
	bouncingText2()
	timer.performWithDelay(2000, bouncingText2,0)

	 local startButton = display.newImage( sceneGroup,"images/playButton.png", centerX, centerY+20 )
	 startButton.width=screenWidth/3.5
	 startButton.height=startButton.width
	 myData.animationButton(startButton)
	 startButton:addEventListener("tap", goToLevels)

	 local rateButton = display.newImage( sceneGroup, "images/rateButton.png", centerX, screenBottom-120)
	 rateButton.width=40
	 rateButton.height=rateButton.width
	 rateButton:addEventListener("tap", rateourapp)

	 local privacyPolicyButton = display.newImage(sceneGroup, "images/info.png",centerX+60, screenBottom-120)
	 privacyPolicyButton.width=40
	 privacyPolicyButton.height=40
	 privacyPolicyButton:addEventListener("touch", privacyPolicy)

	 local optionsButton = display.newImage(sceneGroup, "images/optionsButton.png",centerX-60, screenBottom-120)
	 optionsButton.width=40
	 optionsButton.height=40
	 optionsButton:addEventListener("touch", goToOptions)


	 function checkMemory()
		collectgarbage( "collect" )
		local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
		print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
 end
 timer.performWithDelay( 1000, checkMemory, 0 )

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		--Code here runs when the scene is entirely on screen
			composer.removeHidden()
	end
end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then


	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
