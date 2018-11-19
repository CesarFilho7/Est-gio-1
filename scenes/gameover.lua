local composer = require( "composer" )
 
local scene = composer.newScene()

local json = require( "json" ) 
local scoresTable = {}
 
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

function loadScores()
 	print( "entrei" )
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
        print( "entrei no load2" )
    end
 
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0, 0, 0 }
        print( "entrei no load3" )

    end
end

function saveScores()
 
    for i = #scoresTable, 3, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 		
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end

function gotoGame() 
	composer.gotoScene( "scenes.game", { time=120, effect="flipFadeOutIn" } )
end

function gotoMenu() 
	composer.gotoScene( "scenes.menu" )	
end

function scene:create( event )
	local sceneGroup = self.view

	loadScores()

	table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )

    saveScores()

	local backgroundMenu = display.newImageRect( "front/menu-background.png", 360, 700 )
	backgroundMenu.x = display.contentCenterX
	backgroundMenu.y = display.contentCenterY
	sceneGroup:insert(backgroundMenu)

	local highScoresHeader = display.newText(sceneGroup, "High Scores", display.contentCenterX, 130, native.systemFont, 20)
	highScoresHeader:setFillColor( black )

	for i = 1, 3 do
        if ( scoresTable[i] ) then
            local yPos = 150 + ( i * 56 )

            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 20 )
            rankNum:setFillColor( black )
            rankNum.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 20 )
            thisScore:setFillColor(black)
            thisScore.anchorX = 0
        end
    end

	local logoGameOver = display.newImageRect( "front/text-gameover.png", 200, 80 )
	logoGameOver.x = display.contentCenterX 
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
		audio.stop()
	elseif ( phase == "did" ) then
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