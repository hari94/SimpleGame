
--requires


local storyboard = require ("storyboard")
local scene = storyboard.newScene()

local background
--backround

function scene:createScene(event)

	local screenGroup=self.view

	background=display.newImageRect("restart.png",570,320)
	background.x=display.contentWidth * 0.5
	background.y=display.contentHeight * 0.5
	screenGroup:insert( background)
	
	local city2=display.newImageRect("city2.png",display.contentWidth,118)
	city2:setReferencePoint( display.BottomLeftReferencePoint )
	city2.x=0
	city2.y=display.contentHeight
	screenGroup:insert( city2)

	local score = event.params.score

	text=display.newEmbossedText( { font = native.systemFont , text = "Your Score : ".. score, fontSize=25, x = display.contentWidth/3 , y = display.contentHeight/2} )
	text:setFillColor( 255,255,255 )
	
end



function start(event)
	if event.phase == "began" then
		 storyboard.gotoScene( "thegame" ,"fade",400)
	end
end	

function scene:enterScene(event)
	storyboard.purgeScene( "thegame" )
	background:addEventListener( "touch", start) 	
end

function scene:exitScene(event)
	display.remove( text )
end

function scene:destroyScene(event)

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene







