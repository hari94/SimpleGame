local physics = require "physics"
physics.start()

local device = require "device"

local sprite = require "sprite"
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local mines
local jetReady
local textOptions = 
{	
	x = 0.8 * display.contentWidth,
	y = 0.1 * display.contentHeight,
	text = "Score : 0",
	font = native.systemFont,
	fontSize = 16
}
-- background

function scene:createScene(event)

	local screenGroup = self.view

	local background = display.newImageRect("bgm.png",570,320)
	background.x=display.contentWidth * 0.5
	background.y=display.contentHeight * 0.5
	screenGroup:insert(background)

	city1 = display.newImageRect("city1.png",display.contentWidth,240)
	city1:setReferencePoint( display.BottomLeftReferencePoint )
	city1.x=0
	city1.y=display.contentHeight
	city1.speed=2
	screenGroup:insert(city1)

	city2 = display.newImageRect("city1.png",display.contentWidth,240)
	city2:setReferencePoint( display.BottomLeftReferencePoint )
	city2.x=display.contentWidth
	city2.y=display.contentHeight
	city2.speed=2
	screenGroup:insert(city2)

	city3 = display.newImageRect("city2.png",display.contentWidth,118)
	city3:setReferencePoint( display.BottomLeftReferencePoint )
	city3.x=0
	city3.y=display.contentHeight
	city3.speed=3
	screenGroup:insert(city3)

	city4 = display.newImageRect("city2.png",display.contentWidth,118)
	city4:setReferencePoint( display.BottomLeftReferencePoint )
	city4.x=display.contentWidth
	city4.y=display.contentHeight
	city4.speed=3
	screenGroup:insert(city4)

	scoreText = display.newText( textOptions )
	scoreText:setFillColor( 255,0,0 )
	screenGroup:insert( scoreText )
	score = 0

	
	mines = {}

	for i=1, 3 do
		mines[i] = display.newImage( "mine.png")
		mines[i].x = display.contentWidth + 50
		mines[i].y = math.random( 0.25 * display.contentHeight,0.75 * display.contentHeight)
		mines[i].initY = mines[i].y
		mines[i].speed = math.random(2,6)
		mines[i].angle = math.random(1,360)
		mines[i].amp = math.random(display.contentHeight * 0.05,display.contentHeight * 0.3)
		physics.addBody( mines[i], "static", {density=.1, friction=.2, bounce=.1 } )
		
	end
	

	jetSpriteSheet = sprite.newSpriteSheet("jet.png",50,17)
	jetSprites = sprite.newSpriteSet(jetSpriteSheet,1,4)
	sprite.add(jetSprites,"jet",1,4,1000,0)
	jet = sprite.newSprite(jetSprites)
	jet.x = -50
	jet.y = 50
	jet.isCollided=false
	jet:prepare("jets")
	jet:play()	
	physics.addBody( jet, "static", {density=.1, friction=.2, bounce=.1,radius=12 } )

	jetIntro = transition.to( jet, {time = 2000 , x = 100 , y = 50 , onComplete = jetReady} )
	screenGroup:insert(jet)

	botEdge = display.newImage("invisibleTile.png")
	botEdge.x = 50
	botEdge.y = 1.05* display.contentHeight
	physics.addBody( botEdge, "static", {density=.1, friction=.2, bounce=.1 } )
	screenGroup:insert(botEdge)	

	topEdge = display.newImage("invisibleTile.png")
	topEdge.x = 50
	topEdge.y = -30
	physics.addBody( topEdge, "static", {density=.1, friction=.2, bounce=.1 } )
	screenGroup:insert(topEdge)	

	explosionSpriteSheet = sprite.newSpriteSheet("explosion.png",24,23)
	explosionSprites = sprite.newSpriteSet(explosionSpriteSheet,1,8)
	sprite.add(explosionSprites,"explosions",1,8,1000,1)
	explosion = sprite.newSprite(explosionSprites)
	explosion.x = -50
	explosion.y = -50--	
	explosion.isVisible=false
	explosion:prepare("explosions")	
	screenGroup:insert(explosion)

end

function scrollCity(self,event)
	if (self.x < -1 * (display.contentWidth - 5)) then
		self.x = display.contentWidth
	else 
		self.x= self.x - self.speed
	end
end

function moveJet(self,event)
	self:applyForce(0, -1.5, self.x, self.y)
	
end

function jetReady()
	jet.bodyType="dynamic"
	score = 1
end	
function onTouch(event)
	if (event.phase == "began") then
		jet.enterFrame = moveJet
		Runtime:addEventListener("enterFrame",jet)			
	end	

	if (event.phase == "ended") then		
		Runtime:removeEventListener("enterFrame",jet)					
	end	
end

local moveMines = function(self,event)

	if(self.x < -50) then		
		self.x = display.contentWidth + 50
		self.y = math.random( 0.25 * display.contentHeight,0.75 * display.contentHeight)		
		self.speed = math.random(2,6)
		self.angle = math.random(1,360)
		self.amp = math.random(20,100)		
	else
		self.x = self.x - self.speed
		self.angle = self.angle + .1
		self.y = self.initY + math.sin(self.angle) * self.amp
		
	end		
end	

local explode = function()
    explosion.x = jet.x
    explosion.y = jet.y
    jet.isVisible = false    
    explosion.isVisible = true
    explosion:play()
    local soundID = audio.loadSound ( "explosion.ogg" )
	
    local comp=audio.play( soundID )
	
end

function gameOver()
	storyboard.gotoScene("restart",{ effect="fade", time=400, params = {score = score}})
end
function onCollision(event)
	if event.phase == "began" then			
		if jet.isCollided == false then
			jet.isCollided = true
			jet.bodyType = "static"
			explode()

			timer.performWithDelay( 2000, gameOver ,1 )
		end
        
	end
end

function incScore(self,event)
	if jet.isCollided == false and score > 0 then
		score = score + 1
		self.text = "Score : " .. score
	end	

end	

function scene:enterScene(event)

	storyboard.purgeScene("start")
	storyboard.purgeScene("restart")

	city1.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city1 )

	city2.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city2 )

	city3.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city3 )

	city4.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city4 )

	for i=1 , 3 do
		mines[i].enterFrame = moveMines
		Runtime:addEventListener( "enterFrame", mines[i] )		
	end

	scoreText.enterFrame = incScore
	Runtime:addEventListener( "enterFrame", scoreText)

	Runtime:addEventListener( "touch", onTouch )
	Runtime:addEventListener( "collision", onCollision )
	
end

function scene:exitScene(event)
	
	Runtime:removeEventListener( "enterFrame", city1 )	
	Runtime:removeEventListener( "enterFrame", city2 )
	Runtime:removeEventListener( "enterFrame", city3 )
	Runtime:removeEventListener( "enterFrame", city4 )
	for i=1 , 3 do
		Runtime:removeEventListener( "enterFrame", mines[i] )				
		display.remove(mines[i])
		mines.i=nil
	end
	Runtime:removeEventListener( "enterFrame", score )
	Runtime:removeEventListener( "touch", onTouch )
	Runtime:removeEventListener( "collision", onCollision )

	display.remove( city1 )
	city1 = nil
	display.remove( city2 )
	city2 = nil
	display.remove( city3 )
	city3 = nil
	display.remove( city4 )
	city4 = nil
end

function scene:destroyScene(event)
	
end


scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene