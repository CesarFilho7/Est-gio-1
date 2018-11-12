local composer = require( "composer" )
 
local scene = composer.newScene()
local groupGameOver = display.newGroup()
 
local contador = 0 

function scene:create( event )
	print( 'CRIANDO GAMEOVER' )

	local logo = display.newImageRect( "front/logo-menu.png", 320, 250 )
	logo.x = display.contentCenterX + 10
	logo.y = display.contentCenterY - 60
	groupGameOver:insert( logo )

	local start = display.newImageRect( "front/start-button.png", 200, 250 )
	start.x = display.contentCenterX
	start.y = display.contentCenterY + 120
	groupGameOver:insert( start )

	function gotoGame() 
		audio.pause( {channel = 1} )
		composer.gotoScene( "scenes.game" )
		
	end
	start:addEventListener( "tap", gotoGame )

	function buttonAnimation()
		if(contador >= 0 and contador < 5) then
			start.xScale = 1.1
			start.yScale = 1.1
			contador = contador + 1
		else if(contador >= 5) then
			start.xScale = 1
			start.yScale = 1
			contador = contador + 1
			if(contador >= 10) then
				contador = 0
			end
		end
		end
	end
	buttonAnimationLoop = timer.performWithDelay( "100", buttonAnimation, -1 )
	print( 'final criando' )
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.stop(1)
		display.remove(groupGameOver)
		timer.cancel(buttonAnimationLoop)

	elseif ( phase == "did" ) then
		
	end
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("scenes.menu")
		composer.removeScene("scenes.game")
		-- Code here runs when the scene is still off screen (but is about to come on screen)
 
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
 
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
 
return scene