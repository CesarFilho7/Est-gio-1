-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here


local physics = require("physics")
physics.start()
--physics.setDrawMode( "hybrid" )
--physics.setGravity( 0, 0 )

display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

local Height = 0

--plataforma da esquerda
local plataforma1 = display.newRect(display.contentWidth - 287, display.contentHeight - 115, 25,15)
physics.addBody(plataforma1, "static", {density=3.0, friction=0.5, bounce=0})

--plataforma da direita
local plataforma2 = display.newRect( display.contentWidth - 32, display.contentHeight - 115, 25, 15) --(display.contentWidth - 32) posição x, depois posição y, largura do objeto, altura do objeto 
physics.addBody(plataforma2, "static", {density=3.0, friction=0.5, bounce=0})

local background = display.newImageRect( "background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local contadorAltura = display.newText( Height, display.contentCenterX, 22, native.systemFont, 30 )
contadorAltura:setFillColor( 0, 0, 0 )

local paredeLateralEsquerda = display.newRect(0, 240, 40, display.contentHeight )
physics.addBody(paredeLateralEsquerda, "static", ({density=3.0, friction=0.5, bounce=0}))

local paredeLateralDireita = display.newRect(320, 240, 40, display.contentHeight )
physics.addBody(paredeLateralDireita, "static", ({density=3.0, friction=0.5, bounce=0}))

local arvore = display.newImageRect( "tree.png", 360, 570)
arvore.x = display.contentCenterX
arvore.y = display.contentCenterY

-- local arvore2 = display.newImageRect( "tree2.png" 360, 570 )




-- configurando altura, largura do sprite e o num de frames
local sheetOptions  = {width = 100, height = 100, numFrames = 10}
local sheet = graphics.newImageSheet( "spritecesar4.png", sheetOptions )

--definindo a animação 
local sequences = {
	{
		name = "RunRight",
		frames = {1,2,3,4,5},
		time = 450,
		loopCount = 0,
	},

	{
		name = "RunLeft",
		frames = {6,7,8,9,10},
		time = 450,
		loopCount = 0,
	}
}



local player = display.newSprite( sheet, sequences )

-- definindo a posição do meu personagem
player.x = 281
player.y = 345
player.width =20
player.height =30
player.xScale = 1.2
player.yScale = 1.2
player: rotate(270)
player:play()

physics.addBody( player, "dynamic", {density=1.53,bounce=0, friction= 0} )

local direita = true
function touchAction( event )
 	-- indica que um toque começou na tela.
    if ( event.phase == "began" ) then
    	local vx, vy = player:getLinearVelocity()
        player:setLinearVelocity( vx, 0 )
        

        if (direita == true) then
        	--altura e direção do pulo
        	player:applyLinearImpulse( -6, -7, player.x, player.y )
        	direita = false
       		player:setSequence( "RunLeft" )
        	player:play()
        	player:rotate(180)	
       	else if (direita == false) then
       		direita = true
       		player:setSequence( "RunRight" )
        	player:applyLinearImpulse( 6, -7, player.x, player.y )
       		player:play()
       		player:rotate(180)
       		end
    	end
	end
	return true
end
Runtime:addEventListener( "touch", touchAction )


