local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local myData = require( "mydata" )
local loadsave = require( "loadsave" )
local appodeal = require( "plugin.appodeal" )

local function handleCancelButtonEvent( event )
    if ( "ended" == event.phase ) then
      --  composer.removeScene( "levels" )
        composer.gotoScene( "menu", { effect="crossFade", time=200 } )
    end
end

local function onSwitchSound( event )
    local switch = event.target
    myData.settings.soundOn=switch.isOn
end

local function onSwitchMusic( event )
    local switch = event.target
    myData.settings.musicOn=switch.isOn
    if switch.isOn==true then
      playBackgroundMusic = audio.play(backgroundMusic,{loops=-1,channel=1})
    else
      audio.stop(playBackgroundMusic)
      playBackgroundMusic=nil

    end
end


function scene:create( event )
    local sceneGroup = self.view

    local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
    background:setFillColor( 0 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local topRect = display.newRect( sceneGroup, centerX, screenTop+30, screenWidth, 60 )
    topRect:setFillColor(0.07, 0.17, 0.69)
    local topText = display.newText( "OPTIONS", centerX, screenTop+30, "Supersonic Rocketship",30 )
    sceneGroup:insert(topText)
    local backButton = display.newImage( sceneGroup, "images/backButton.png", screenLeft+30, screenTop+30)
    backButton.width=40
    backButton.height=40
    backButton:addEventListener("touch", handleCancelButtonEvent)

    local checkboxSoundButton = widget.newSwitch(
    {
      --  x = screenLeft+100,
      --  y=centerY,
        top=screenTop+100,
        left=screenRight-130,
        style = "checkbox",
        id = "CheckboxSound",
        initialSwitchState=myData.settings.soundOn,
        onPress = onSwitchSound
    }
    )
    sceneGroup:insert(checkboxSoundButton)
    local soundText = display.newText( "Sound",checkboxSoundButton.x-80,checkboxSoundButton.y,"Supersonic Rocketship",26 )
    sceneGroup:insert(soundText)

    local checkboxMusicButton = widget.newSwitch(
    {
      --  x = screenLeft+100,
      --  y=centerY,
        top=screenTop+160,
        left=screenRight-130,
        style = "checkbox",
        id = "CheckboxMusic",
        initialSwitchState=myData.settings.musicOn,
        onPress = onSwitchMusic
    }
    )
    sceneGroup:insert(checkboxMusicButton)
    local musicText = display.newText( "Music",checkboxMusicButton.x-80,checkboxMusicButton.y,"Supersonic Rocketship",26 )
    sceneGroup:insert(musicText)

end

function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "did" ) then
      composer.removeHidden()

    end
end

function scene:hide( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
      loadsave.saveTable( myData.settings, "settings.json" )

    elseif ( phase == "did" ) then

    end
end

function scene:destroy( event )
    local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
