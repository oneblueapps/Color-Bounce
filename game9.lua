local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
local myData = require( "mydata" )
myData.settings.currentLevel = 9
if myData.settings.currentLevel>=myData.settings.unlockedLevels then
  myData.settings.unlockedLevels=myData.settings.currentLevel
end
physics.start()
local ball
local rectHeight=screenHeight/7
local score = 10
local scoreText
local directionBall=1
physics.setGravity( 0, myData.gravity)
local leftGroup = display.newGroup()
local rightGroup = display.newGroup()
myData.shuffleTable(myData.colors)
local pink = myData.colors[1]
local yellow = myData.colors[2]
local blue = myData.colors[3]
local purple = myData.colors[4]
local t = {}
local ballColor = 3--math.random(1, 8)
local leftRect = {}
local rightRect = {}
local balls = {}
local whiteRect
local startText = "Tap the screen to play"


local function buildColors()
  t[1]=pink
  t[2]=yellow
  t[3]=blue
  t[4]=blue
  t[5]=pink
  t[6]=purple
  t[7]=purple
  --t[8]=blue
  t[1].name="pink"
  t[2].name="yellow"
  t[3].name="blue"
  t[4].name="blue"
  t[5].name="pink"
  t[6].name="purple"
  t[7].name="purple"
--  t[8].name="blue"
end
local function ballDamage ()
  transition.to(whiteRect, {alpha=0.9, time=300})
  transition.to(whiteRect, {alpha=0, time=250, delay=300})
  background:removeSelf()
  background=nil

  timer.performWithDelay(300, function()
    composer.gotoScene( "restartGame",{effect="crossFade",time=300})
  end )
end

local function buildLeftRects()
--  myData.shuffleTable(t)
  myData.shuffleTable(t)
  local xOffset = screenTop+rectHeight/2
  for i=1, #t do
      leftRect[i] = display.newRoundedRect( leftGroup, screenLeft+5, xOffset, 20, rectHeight, 5 )
      leftRect[i].fill = t[i]
      physics.addBody( leftRect[i], "static" , { friction=0.0, bounce=0.8, density=0.3 } )
      leftRect[i].name="leftRect"..t[i].name
      xOffset=xOffset+rectHeight
      i=i+1
  end
end

local function buildRightRects()
--  myData.shuffleTable(t)
  myData.shuffleTable(t)
  local xOffset = screenTop+rectHeight/2
  for i=1, #t do
      rightRect[i] = display.newRoundedRect( rightGroup, screenRight-5, xOffset, 20, rectHeight, 5 )
      rightRect[i].fill = t[i]
      physics.addBody( rightRect[i], "static" , { friction=0.0, bounce=0.8, density=2} )
      rightRect[i].name="rightRect"..t[i].name
      xOffset=xOffset+rectHeight
      i=i+1
  end
end

local function bounceBall()
  if startText.alpha==1 then
    startText.alpha=0
    ball.bodyType = "dynamic"
  end
  if directionBall == 1 then
    ball:setLinearVelocity( myData.powerX,myData.powerY, ball.x, ball.y )
  else
    ball:setLinearVelocity( -myData.powerX,myData.powerY, ball.x, ball.y )
  end
end

local function rightTransition (m)
  myData.shuffleTable(t)
--  myData.shuffleTable(t)
  transition.to( m, {time=300, x = 15, delay=100} )
  transition.to( m, {time=300, x = 0, delay=800} )
  timer.performWithDelay(500, function()
    for i=1, #t do
      rightRect[i].fill = t[i]
      rightRect[i].name=m.name..t[i].name
    end
  end )
end

local function leftTransition (m)
  myData.shuffleTable(t)
--  myData.shuffleTable(t)
  transition.to( m, {time=300, x = -15, delay=100} )
  transition.to( m, {time=300, x = 0, delay=800} )
  timer.performWithDelay(500, function()
    for i=1, #t do
      leftRect[i].fill = t[i]
      leftRect[i].name=m.name..t[i].name
    end
  end )
end

local function onCollision (event)
  local hitObj = event.other.name

  if ( event.phase == "began" ) then
        if (hitObj =="rightRect"..ball.name)then
          if myData.settings.soundOn == true then
            audio.play(scoresound)
          end
          directionBall=2
          score=score-1
          scoreText.text=score
          rightTransition(rightGroup)
        elseif (hitObj =="leftRect"..ball.name) then
          if myData.settings.soundOn == true then
            audio.play(scoresound)
          end
          directionBall=1
          score=score-1
          scoreText.text=score
          leftTransition(leftGroup)
       else
          event.target:removeSelf()
          event.target=nil
          physics.pause()
         timer.performWithDelay(50, ballDamage())

       end

  end
  if score==0 then
    physics.pause()
    composer.gotoScene( "nextGame",{effect="crossFade",time=300})
  end
end
--########################### Create Scene ####################################################################################################
function scene:create( event )

	local sceneGroup = self.view

  background = display.newRect( sceneGroup, centerX, centerY, screenWidth, screenHeight )
  background:setFillColor(0,0,0)
  background:addEventListener( "tap", bounceBall )

  local scoreCircle = display.newCircle( sceneGroup, centerX, centerY-80, 70 )
  scoreCircle.alpha=0.1

  scoreText = display.newText( sceneGroup, score, centerX, centerY-80, native.systemFont, 90 )
  scoreText.alpha=0.3

  buildColors()


  leftGroup.name="leftRect"
  rightGroup.name="rightRect"

  local bottomRect=display.newRect( sceneGroup, centerX, screenBottom+1, 400, 2 )
  physics.addBody( bottomRect, "static" )
  bottomRect:setFillColor(0,0,0)
  local topRect=display.newRect( sceneGroup, centerX, screenTop-1, 400, 2 )
  physics.addBody( topRect, "static" )
  topRect:setFillColor(0,0,0)

  ball = display.newCircle( sceneGroup, centerX, centerY, 10 )
  ball.fill = t[ballColor]
  ball.name = t[ballColor].name
  ball.isRotation=false
  physics.addBody( ball, "static", {friction=0.5, bounce=0,radius=10, density=0.5} )
  ball:addEventListener( "collision", onCollision )

  buildRightRects()
  buildLeftRects()


  sceneGroup:insert(leftGroup)
  sceneGroup:insert(rightGroup)

  whiteRect = display.newRect( sceneGroup, centerX, centerY, screenWidth, screenHeight )
  whiteRect.alpha = 0
  whiteRect:toFront()

  startText = display.newText( startText, centerX, centerY+80, "Supersonic Rocketship", 20 )
  sceneGroup:insert(startText)

end
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    composer.removeScene(composer.getSceneName( "previous" ))
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
    myData.removeAll(t,leftRect,rightRect)
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
