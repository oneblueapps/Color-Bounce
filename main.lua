display.setStatusBar( display.HiddenStatusBar )
local composer = require( "composer" )
local appodeal = require( "plugin.appodeal" )
local myData = require ("mydata")
local loadsave = require( "loadsave" )
local testAds = false

centerX = display.contentCenterX
centerY = display.contentCenterY
screenLeft = display.screenOriginX
screenWidth = display.contentWidth - screenLeft * 2
screenRight = screenLeft + screenWidth
screenTop = display.screenOriginY
screenHeight = display.contentHeight - screenTop * 2
screenBottom = screenTop + screenHeight
display.contentWidth = screenWidth
display.contentHeight = screenHeight

local function adListener( event )

    if ( event.phase == "init" ) then  -- Successful initialization
      print( event.isError )
      appodeal.show("banner")
    elseif (event.phase =="playbackEnded") and (event.type=="rewardedVideo") then
        myData.settings.unlockedLevels=myData.settings.unlockedLevels+1
        loadsave.saveTable( myData.settings, "settings.json" )
        composer.removeScene( "levels" )
        composer.gotoScene( "levels")
    --  elseif (event.phase =="playbackEnded") and (event.type=="rewardedVideo")and(event.data.placement=="playVideoButton2") then

  end
end

if (system.getInfo("platform") == "android") or (system.getInfo("platform") == "macos") then
    appodeal.init( adListener, { appKey="5b7f07ec17241e7330a49287acc61eef5478fc96e541f551",testMode=testAds } )
  elseif (system.getInfo("platform") == "ios") then
      appodeal.init( adListener, { appKey="dfea1f617926c590e4ecc523596fa9f4a0655dce194091d4",testMode=testAds } )
end

scoresound = audio.loadSound( "sounds/wall.mp3")
jump = audio.loadSound( "sounds/jump.wav" )
backgroundMusic = audio.loadStream( "sounds/music.mp3" )
if myData.settings.musicOn==true then
  playBackgroundMusic = audio.play( backgroundMusic, {loops=-1,channel=1})
end


local function onKeyEvent( event )
   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
      if ( composer.getSceneName( "current" ) == "menu" ) then
        local function onComplete(event)
                  if(event.index == 1) then
                            native.requestExit()
                  elseif(event.index == 2) then
                    local options =
                      {
                         androidAppPackageName = "com.oneblueapps.colorbounce",
                         supportedAndroidStores = { "google" },
                      }
                    --  googleAnalytics.logEvent( "userAction", "button press", "Rate Button on Exit")
                      native.showPopup( "appStore", options )
                  end
              end
              local alert = native.showAlert( "Exit?", "Are you sure you want to exit this app?", { "Yes","Rate app","No"},onComplete )

      elseif ( composer.isOverlay ) then
            composer.hideOverlay()
      elseif ( composer.getSceneName( "current" ) == "levels" ) then
            composer.gotoScene( "menu", { effect="crossFade", time=200 } )
      elseif ( composer.getSceneName( "current" ) == "options" ) then
            composer.gotoScene( "menu", { effect="crossFade", time=200 } )
      elseif (composer.getSceneName( "current" ) == "game"..myData.settings.currentLevel)
        or (composer.getSceneName( "current" ) == "nextGame")
        or (composer.getSceneName( "current" ) == "restartGame") then
            composer.gotoScene( "levels", { effect="crossFade", time=200 } )
      end
    return true
   end
   return false
end
if (system.getInfo("platform") == "android") then
  Runtime:addEventListener( "key", onKeyEvent )
end

composer.gotoScene( "menu", { effect="crossFade", time=300 })
