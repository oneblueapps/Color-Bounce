local appodeal = require ("plugin.appodeal")
local loadsave = require( "loadsave" )
local M = {}
M.maxLevels = 20
M.gravity = 55
M.powerX = 150
M.powerY = -450
adsFrequency = 0

M.colors = {}
M.colors[1] = { 1, 0, 0.5}
M.colors[2] = {0.92, 0.86, 0.09}
M.colors[3] = {0.61, 0.15, 0.77}
M.colors[4] = {0.15, 0.69, 0.87}

M.t = {"C","O","L","O","R","B","O","U","N","C","E"}


M.settings = loadsave.loadTable( "settings.json" )



local function shuffleTable( t )
    local rand = math.random
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function removeAll (t,title,title2,leftRect,rightRect,color,buttons)
  if t~=nil then
    for i = #t, 1, -1 do
      table.remove(t,i)
    end
  end
  if title~=nil then
    for i = #title, 1, -1 do
  		table.remove(title,i)
  	end
  end
  if title2~=nil then
  	for i = #title2,1, -1 do
  		table.remove(title2,i)
  	end
  end
  if leftRect~=nil then
    for i = #leftRect, 1, -1 do
  		table.remove(leftRect,i)
  	end
  end
  if rightRect~=nil then
    for i = #rightRect, 1, -1 do
  		table.remove(rightRect,i)
  	end
  end
  if color~=nil then
    for i = #color, 1, -1 do
  		table.remove(color,i)
  	end
  end
  if buttons~=nil then
    for i = #buttons, 1, -1 do
  		table.remove(buttons,i)
  	end
  end
end

local function animationButton(target)
  local function downSize ()
    transition.to(target, {time=800, xScale=1, yScale=1, onComplete=animationButton} )
  end
  transition.to(target,{time=800, xScale=1.15, yScale=1.15, onComplete=downSize} )
end

local function brightnessButton (target)
   local function downBrightness (target)
     transition.to(target.fill.effect,{intensity = 0.1,time=800})--,onComplete=brightnessButton})
   end
  transition.to(target.fill.effect,{intensity = 0.3,time=800,onComplete=downBrightness(target)})
end

local function fitImage( displayObject, fitWidth, fitHeight, enlarge )
	local scaleFactor = fitHeight / displayObject.height
	local newWidth = displayObject.width * scaleFactor
	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
	displayObject:scale( scaleFactor, scaleFactor )
end

local function showAds ()
  adsFrequency = adsFrequency+1
  if adsFrequency%5==0 and adsFrequency%2==1 then
    if appodeal.isLoaded("interstitial")then
      appodeal.show("interstitial")
    elseif appodeal.isLoaded("video") then
      appodeal.show("video")
    end
  elseif adsFrequency%10==0 then
    if appodeal.isLoaded("video")then
      appodeal.show("video")
    elseif appodeal.isLoaded("interstitial") then
      appodeal.show("interstitial")
    end
  end
end

M.animationButton = animationButton
M.brightnessButton = brightnessButton
M.fitImage = fitImage
M.shuffleTable = shuffleTable
M.removeAll = removeAll
M.showAds = showAds

-- These lines are just here to pre-populate the table.
-- In reality, your app would likely create a level entry when each level is unlocked and the score/stars are saved.
-- Perhaps this happens at the end of your game level, or in a scene between game levels.
--   M.settings.levels = {}
  -- M.settings.levels[1] = {}
  -- M.settings.levels[1].stars = 0
-- M.settings.levels[1].score = 3833
-- M.settings.levels[2] = {}
-- M.settings.levels[2].stars = 2
-- M.settings.levels[2].score = 4394
-- M.settings.levels[3] = {}
-- M.settings.levels[3].stars = 1
-- M.settings.levels[3].score = 8384
-- M.settings.levels[4] = {}
-- M.settings.levels[4].stars = 0
-- M.settings.levels[4].score = 10294
-- levels data members:
--      .stars -- Stars earned per level
--      .score -- Score for the level



  if ( M.settings == nil ) then
    M.settings = {}
    M.settings.currentLevel = 1
    M.settings.unlockedLevels = 1
    M.settings.passedLevels=0
    M.settings.soundOn = true
    M.settings.musicOn = true
    M.settings.levels = {}
    loadsave.saveTable( M.settings, "settings.json" )
  end

  if ( M.settings.levels == nil ) then
    M.settings.levels = {}
    --myData.settings.currentLevel = 1
  --  M.settings.unlockedLevels = 1
    M.settings.passedLevels=M.settings.unlockedLevels - 1
    for i=1, M.settings.passedLevels, 1 do
      M.settings.levels[i] = {}
      M.settings.levels[i].stars=1
    end
    loadsave.saveTable( M.settings, "settings.json" )
  end

return M
