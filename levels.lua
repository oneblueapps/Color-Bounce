local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local myData = require( "mydata" )
local loadsave = require( "loadsave" )
local appodeal = require( "plugin.appodeal" )

local starVertices = { 0,-8,1.763,-2.427,7.608,-2.472,2.853,0.927,4.702,6.472,0.0,3.0,-4.702,6.472,-2.853,0.927,-7.608,-2.472,-1.763,-2.427 }

local function handleCancelButtonEvent( event )
    if ( "ended" == event.phase ) then
      --  composer.removeScene( "levels" )
        composer.gotoScene( "menu", { effect="crossFade", time=200 } )
    end
end
-- Button handler to go to the selected level
local function handleLevelSelect( event )
    if ( "ended" == event.phase ) then
        myData.settings.currentLevel = event.target.id
        appodeal.hide("banner")
        composer.removeScene( "game"..myData.settings.currentLevel, false )
        composer.gotoScene( "game"..myData.settings.currentLevel, { effect="crossFade", time=200 } )
    end
end

local function unlockLevel (event)
  if ( "ended" == event.phase ) then
    appodeal.show("rewardedVideo")
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
    local topText = display.newText( "LEVELS", centerX, screenTop+30, "Supersonic Rocketship",30 )
    sceneGroup:insert(topText)
    local backButton = display.newImage( sceneGroup, "images/backButton.png", screenLeft+30, screenTop+30)
    backButton.width=40
    backButton.height=40
    backButton:addEventListener("touch", handleCancelButtonEvent)

    local levelSelectGroup = widget.newScrollView({
      --  y = screenTop,
        width = screenWidth,
        height = 330,
        scrollWidth = screenWidth,
        scrollHeight = 340,
        horizontalScrollDisabled = true,
        isBounceEnabled =false,
        backgroundColor = {0,0,0}
    })

    -- 'xOffset', 'yOffset' and 'cellCount' are used to position the buttons in the grid.
    local xOffset = levelSelectGroup.width/8
    local yOffset = 40
    local cellCount = 1

    -- Define the array to hold the buttons
    local buttons = {}

    -- Read 'maxLevels' from the 'myData' table. Loop over them and generating one button for each.
for i = 1, myData.maxLevels do
        -- Create a button
        buttons[i] = widget.newButton({
            label = tostring( i ),
            id = tostring( i ),
            onEvent = handleLevelSelect,
            emboss = false,
            shape="roundedRect",
            width = screenWidth/6,
            height = levelSelectGroup.width/6.5,
            font = "Supersonic Rocketship",
            fontSize = 34,
            labelColor = { default = { 1, 1, 1 }, over = { 0.5, 0.5, 0.5 } },
            cornerRadius = 8,
            labelYOffset = -2,
            fillColor = { default={ 0, 0.5, 1, 1 }, over={ 0.5, 0.75, 1, 1 } },
        })
        -- Position the button in the grid and add it to the scrollView
        buttons[i].x = xOffset
        buttons[i].y = yOffset
        levelSelectGroup:insert( buttons[i] )

        -- If the level is locked, disable the button and fade it out.
        if ( myData.settings.unlockedLevels == nil ) then
            myData.settings.unlockedLevels = 1
        end
        if ( i <= myData.settings.unlockedLevels ) then
            buttons[i]:setEnabled( true )
            buttons[i].alpha = 1.0
        else
            buttons[i]:setEnabled( false )
            buttons[i].alpha = 0.5
        end

        -- Generate stars earned for each level, but only if:
        -- a. The 'levels' table exists
        -- b. There is a 'stars' value inside of the 'levels' table
        -- c. The number of stars is greater than 0 (no need to draw zero stars).


        local star = {}
        if ( myData.settings.levels[i] and myData.settings.levels[i].stars and myData.settings.levels[i].stars > 0 ) then
            for j = 1, myData.settings.levels[i].stars do
                star[j] = display.newPolygon( 0, 0, starVertices )
                star[j]:setFillColor( 1, 0.9, 0 )
                star[j].strokeWidth = 1
                star[j]:setStrokeColor( 1, 0.8, 0 )
                star[j].x = buttons[i].x + (j * 16)+4
                star[j].y = buttons[i].y + 18
                levelSelectGroup:insert( star[j] )
            end
        end

        -- Compute the position of the next button.
        -- This tutorial draws 5 buttons across.
        -- It also spaces based on the button width and height + initial offset from the left.
        xOffset = xOffset + levelSelectGroup.width/4
        cellCount = cellCount + 1
        if ( cellCount > 4 ) then
            cellCount = 1
            xOffset = levelSelectGroup.width/8
            yOffset = yOffset + 65
        end
    end

    -- Place the scrollView into the scene and center it.
    sceneGroup:insert( levelSelectGroup )
    levelSelectGroup.x = centerX
    levelSelectGroup.y = screenTop+264

  if appodeal.isLoaded("rewardedVideo") and myData.settings.unlockedLevels<20 then
    local padlock = display.newImage("images/padlock.png")
    levelSelectGroup:insert( padlock )
    padlock:translate(buttons[myData.settings.unlockedLevels+1].x,buttons[myData.settings.unlockedLevels+1].y)
    padlock.height=buttons[myData.settings.unlockedLevels+1].height
    padlock.width=buttons[myData.settings.unlockedLevels+1].width
    padlock.fill.effect = "filter.brightness"
    transition.to( padlock, {time=1500, xScale=1.15, yScale=1.15, iterations=999} )
    transition.to(padlock.fill.effect,
    {
      intensity = 0.5,
      iterations=999,
      time=1500
    })
    padlock:addEventListener("touch",unlockLevel)
  end
local scoreText = display.newText( sceneGroup, myData.settings.passedLevels.."/20", centerX, screenTop+88, "Supersonic Rocketship", 26 )
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
