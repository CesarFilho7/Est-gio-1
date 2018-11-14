local composer = require( "composer" )
 
local scene = composer.newScene()
 
function gotoGame() 
	audio.pause( {channel = 1} )
	composer.gotoScene( "scenes.game" )
end

function gotoMenu() 
	composer.gotoScene( "scenes.menu" )	
end

function scene:create( event )
	local sceneGroup = self.view

	local backgroundMenu = display.newImageRect( "front/menu-background.png", 360, 700 )
	backgroundMenu.x = display.contentCenterX
	backgroundMenu.y = display.contentCenterY
	sceneGroup:insert(backgroundMenu)

	local logoGameOver = display.newImageRect( "front/text-gameover.png", 200, 80 )
	logoGameOver.x = display.contentCenterX + 10
	logoGameOver.y = display.contentCenterY - 175
	sceneGroup:insert(logoGameOver)

	local jogarNovamente = display.newImageRect( "front/jogarnovamente2-button.png", 50, 50 )
	jogarNovamente.x = display.contentCenterX - 65
	jogarNovamente.y = display.contentCenterY + 145
	sceneGroup:insert(jogarNovamente)

	local inicio = display.newImageRect( "front/inicio-button.png", 50, 50 )
	inicio.x = display.contentCenterX + 65
	inicio.y = display.contentCenterY + 145
	sceneGroup:insert(inicio)
	
	jogarNovamente:addEventListener( "tap", gotoGame )
	inicio:addEventListener( "tap", gotoMenu )
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		audio.stop(1)
		composer.removeScene( "scenes.gameover" )
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