-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local galhoTable = {}
local collisionFilter1 = { groupIndex = -1 }

local physics = require("physics")
physics.start()
physics.setDrawMode( "hybrid" )
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

local musica = audio.loadStream( "musica.mp3")
--audio.play(musica)

--plataforma invisivel da esquerda
local plataforma1 = display.newRect(display.contentWidth - 287, display.contentHeight - 100, 50,15)
physics.addBody(plataforma1, "static", {density=3.0, friction=0.5, bounce=0, filter = collisionFilter1})
--plataforma invisivel da direita
local plataforma2 = display.newRect( display.contentWidth - 32, display.contentHeight - 100, 50, 15) --(display.contentWidth - 32) posição x, depois posição y, largura do objeto, altura do objeto 
physics.addBody(plataforma2, "static", {density=3.0, friction=0.5, bounce=0, filter = collisionFilter1})

-- criação do background
local background = display.newImageRect( "background.png", 360, 670 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Parede invisivel da Esquerda
local paredeLateralEsquerda = display.newRect(0, 240, 40, display.contentHeight )
physics.addBody(paredeLateralEsquerda, "static", ({density=3.0, friction=0.5, bounce=0, filter =  collisionFilter1}))
-- Parede invisivel da Direita
local paredeLateralDireita = display.newRect(320, 240, 40, display.contentHeight )
physics.addBody(paredeLateralDireita, "static", ({density=3.0, friction=0.5, bounce=0, filter = collisionFilter1}))

-- Duplicando a imagem da árvora para poder fazer a animação no cenário
local arvore = display.newImage( "tree2.png")
arvore.x = 160
arvore.y = display.contentHeight / 2
arvore.xScale = 0.47
arvore.yScale = 1

local arvore2 = display.newImage( "tree2.png" )
arvore2.x = 160
arvore2.y =  0
arvore2.xScale = 0.47
arvore2.yScale = 1

-- Junção das imagens 
local contador = 0 
function move(event)
	contador =  5
	arvore.y = arvore.y + contador
	arvore2.y = arvore2.y + contador
	
	if arvore.y > display.contentHeight then
		arvore.y = 0
	end
	if (arvore2.y >  display.contentHeight) then
		arvore2.y = 0
	end
end

-- Criando o número que vai ser a pontuação
local contadorAltura = display.newText( "0", display.contentCenterX, 10, native.systemFont, 30 )
contadorAltura:setFillColor( black )

local pastTime = 000  -- 10 minutes * 60 seconds

-- Função que conta o tempo (Pontuação)
function updateTime( event ) 
    pastTime = pastTime + 1
    contadorAltura.text = pastTime
end

local countDownTimer = timer.performWithDelay( 600, updateTime, pastTime )

-- Configurando altura, largura do sprite e o número de frames
local sheetOptions  = {width = 100, height = 100, numFrames = 10}
local sheet = graphics.newImageSheet( "spritecesar4.png", sheetOptions )

-- Definindo a animação 
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
player.y = 363
player.width =20
player.height =30
player.xScale = 1.1
player.yScale = 1.1
player: rotate(270)
player:play()

physics.addBody( player, "dynamic", {density=1.53,bounce=0, friction= 0} )

local direita = true
function touchAction( event )
 	-- indica que um toque começou na tela.
    if ( event.phase == "began" and (player.x >= 279 or player.x <= 36)) then
    	local vx, vy = player:getLinearVelocity()
        player:setLinearVelocity( 0, vy )
        

        if (direita == true) then
        	--altura e direção do pulo
        	local jump = audio.loadStream( "jump.mp3")
			--audio.play(jump)
        	player:applyLinearImpulse( -18, -2.5, player.x, player.y )
        	direita = false
       		player:setSequence( "RunLeft" )
        	player:play()
        	player:rotate(180)	
       	else if (direita == false) then
        	local jump = audio.loadStream( "jump.mp3")
			--audio.play(jump)
       		direita = true
       		player:setSequence( "RunRight" )
        	player:applyLinearImpulse( 18, -2.5, player.x, player.y )
       		player:play()
       		player:rotate(180)
       		end
    	end
	end
	return true
end

function criarGalho(event)
	
   	local whereFrom = math.random(2)

	    if ( whereFrom == 1 ) then
	    	local novoGalho = display.newImageRect("galho1.png", 110, 70)
	    	physics.addBody( novoGalho, "dynamic", {density = -2, friction = 0, bounce = 0, filter = collisionFilter1})
		   	table.insert( galhoTable, novoGalho)
			novoGalho.myName = "galho"
			novoGalho.x = display.contentCenterX + 110
			novoGalho.y = -100
			novoGalho:setLinearVelocity(0, -100)
		else
		 	local novoGalho = display.newImageRect("galho2.png", 90, 70)
		 	physics.addBody( novoGalho, "dynamic", {density = -2, friction = 0, bounce = 0, filter = collisionFilter1})
		   	table.insert( galhoTable, novoGalho)
			novoGalho.myName = "galho"
			novoGalho.x = display.contentCenterX - 110
			novoGalho.y = -100
			novoGalho:setLinearVelocity(0, -100)
		end
end


-- Cria um galho a cada 1s = 1000
local geradorDeGalho = timer.performWithDelay( 700, criarGalho, pastTime)

Runtime:addEventListener( "touch", touchAction )	
Runtime:addEventListener( "enterFrame", move);