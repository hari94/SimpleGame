
--requires

local physics = require("physics")
physics.start( )

local storyboard = require ("storyboard")
local scene = storyboard.newScene()



function scene:createScene(event)


	local screenGroup=self.view



--backround
	background=display.newImage("bg.png")
	screenGroup:insert( background)

	ceiling = display.newImage("invisibleTile.png")
    ceiling:setReferencePoint(display.BottomLeftReferencePoint)
    ceiling.x = 0
    ceiling.y = 0
    physics.addBody(ceiling, "static", {density=.1, bounce=0.1, friction=.2})
    screenGroup:insert(ceiling)
    
    theFloor = display.newImage("invisibleTile.png")
    theFloor:setReferencePoint(display.BottomLeftReferencePoint)
    theFloor.x = 0
    theFloor.y = 340
    physics.addBody(theFloor, "static", {density=.1, bounce=0.1, friction=.2})
    screenGroup:insert(theFloor)

	city1=display.newImage("city1.png")
	city1:setReferencePoint( display.BottomLeftReferencePoint )
	city1.x=0
	city1.y=320
	city1.speed = 1
	screenGroup:insert( city1 )
	city2=display.newImage("city1.png")
	city2:setReferencePoint( display.BottomLeftReferencePoint ) 
	city2.x=480
	city2.y=320
	city2.speed = 1
	screenGroup:insert( city2 )

	city3=display.newImage("city2.png")
	city3:setReferencePoint( display.BottomLeftReferencePoint )
	city3.x=0
	city3.y=320
	city3.speed = 2
	screenGroup:insert( city3)

	city4=display.newImage("city2.png")
	city4:setReferencePoint( display.BottomLeftReferencePoint )
	city4.x=480
	city4.y=320
	city4.speed = 2
	screenGroup:insert( city4 )

--jet

	jet=display.newImage("redjet.png")

	jet.x =100
	jet.y =100
	physics.addBody( jet, "dynamic", {density=.1, friction=.2, bounce=.1,radius=12 } )
	screenGroup:insert( jet )

	mine1 = display.newImage("mine.png")
	mine1.x = 500
	mine1.y = 100
	mine1.speed = math.random(2,6)
	mine1.initY = mine1.y
	mine1.amp = math.random(20,100)
	mine1.angle = math.random(1,360)
	physics.addBody( mine1, "static", {density=.1, friction=.2, bounce=.1,radius=12 } )
	screenGroup:insert( mine1 )

	mine2 = display.newImage("mine.png")
	mine2.x = 500
	mine2.y = 100
	mine2.speed = math.random(2,6)
	mine2.initY = mine1.y
	mine2.amp = math.random(20,100)
	mine2.angle = math.random(1,360)
	physics.addBody( mine2, "static", {density=.1, friction=.2, bounce=.1,radius=12 } )
	screenGroup:insert( mine2 )

	mine3 = display.newImage("mine.png")
	mine3.x = 500
	mine3.y = 100
	mine3.speed = math.random(2,6)
	mine3.initY = mine1.y
	mine3.amp = math.random(20,100)
	mine3.angle = math.random(1,360)
	physics.addBody( mine3, "static", {density=.1, friction=.2, bounce=.1,radius=12 } )
	screenGroup:insert( mine3 )
end


function scrollCity(self,event)
	if self.x < -477 then
		self.x = 480

	else 
		self.x=self.x - self.speed
	end	
	print( self.speed )
end

function moveMines(self,event)
	if self.x < -50 then
		--self.x = display.contentWidth + 50
		self.x = 500
		self.y = math.random(50,300)
		self.speed = math.random(2,6)
	
		self.amp = math.random(20,100)
		self.angle = math.random(1,360)
	else 
		self.x=self.x - self.speed
		self.angle = self.angle + 0.1
		self.y = self.initY + math.sin(self.angle) * self.amp
	end	
end

function activateJets(self,event)
	self:applyForce(0,-1.5,self.x,self.y)
end

function touchScreen(event)
	if(event.phase == "began")then
		jet.enterFrame=activateJets
		Runtime:addEventListener("enterFrame",jet)
	end

	if(event.phase == "ended")then
		Runtime:removeEventListener( "enterFrame", jet )
	end
end

function onCollision(event)
	storyboard.gotoScene( "restart" ,"fade",400)

end

function scene:enterScene(event) 	
	
	city1.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city1 )

	city2.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city2 )

	city3.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city3 )

	city4.enterFrame = scrollCity
	Runtime:addEventListener( "enterFrame", city4 )

	mine1.enterFrame = moveMines
	Runtime:addEventListener( "enterFrame", mine1 )

	mine2.enterFrame = moveMines
	Runtime:addEventListener( "enterFrame", mine2 )

	mine3.enterFrame = moveMines
	Runtime:addEventListener( "enterFrame", mine3 )

	Runtime:addEventListener( "touch" , touchScreen )

	Runtime:addEventListener( "collision" , onCollision )	
end

function scene:exitScene(event)
	Runtime:removeEventListener( "touch" , touchScreen )
	Runtime:removeEventListener( "enterFrame", city1 )
	Runtime:removeEventListener( "enterFrame", city2 )
	Runtime:removeEventListener( "enterFrame", city3 )
	Runtime:removeEventListener( "enterFrame", city4 )
	Runtime:removeEventListener( "enterFrame", jet )
	Runtime:removeEventListener( "enterFrame", mine1 )
	Runtime:removeEventListener( "enterFrame", mine2 )
	Runtime:removeEventListener( "enterFrame", mine3 )
end

function scene:destroyScene(event)

end


scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
