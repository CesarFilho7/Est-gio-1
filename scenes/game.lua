local composer = require( "composer" )
local groupGame = display.newGroup()
local scene = composer.newScene()

local background
local contadorBanana = 0
local contadorBananaText


function scene:create( event )
	local sceneGroup = self.view
	sceneGroup:insert(groupGame)

	local galhoTable = {}
	local bananaTable = {}
	local collisionFilter1 = { groupIndex = -1 }

	local physics = require("physics")
	physics.start()
	--physics.setDrawMode( "hybrid" )
	display.setStatusBar( display.HiddenStatusBar )
	system.activate( "multitouch" )

	local musica = audio.loadStream( "game-musica.mp3")
	audio.play(musica, {channel = 2, loops = -1})

	--plataforma invisivel da esquerda
	local plataforma1 = display.newRect(display.contentWidth - 287, display.contentHeight - 105, 50,15)
	physics.addBody(plataforma1, "static", {density=3.0, friction=1.0, bounce=0, filter = collisionFilter1})
	groupGame:insert(plataforma1)
	--plataforma invisivel da direita
	local plataforma2 = display.newRect( display.contentWidth - 32, display.contentHeight - 105, 50, 15) --(display.contentWidth - 32) posição x, depois posição y, largura do objeto, altura do objeto 
	physics.addBody(plataforma2, "static", {density=3.0, friction=1.0, bounce=0, filter = collisionFilter1})
	groupGame:insert(plataforma2)

	-- criação do background
	background = display.newImageRect( "front/background.png", 360, 700 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	groupGame:insert(background)

	-- Parede invisivel da Esquerda
	local paredeLateralEsquerda = display.newRect(0, 240, 40, display.contentHeight )
	physics.addBody(paredeLateralEsquerda, "static", ({density=3.0, friction=1.0, bounce=0, filter =  collisionFilter1}))
	groupGame:insert(paredeLateralEsquerda)

	-- Parede invisivel da Direita
	local paredeLateralDireita = display.newRect(320, 240, 40, display.contentHeight )
	physics.addBody(paredeLateralDireita, "static", ({density=3.0, friction=1.0, bounce=0, filter = collisionFilter1}))
	groupGame:insert(paredeLateralDireita)

	-- Duplicando a imagem da árvora para poder fazer a animação no cenário
	local arvore = display.newImage( "front/tree2.png")
	arvore.x = 160
	arvore.y = display.contentHeight / 2
	arvore.xScale = 0.47
	arvore.yScale = 1
	groupGame:insert(arvore)


	local arvore2 = display.newImage( "front/tree2.png" )
	arvore2.x = 160
	arvore2.y =  0
	arvore2.xScale = 0.47
	arvore2.yScale = 1
	groupGame:insert(arvore2)


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
	-- Criando o contador de bananas coletadas
	local bananaPontuacao = display.newImageRect(groupGame, "front/bananas.png", 30, 20)
	bananaPontuacao.x = display.contentCenterX - 12
	bananaPontuacao.y = 2

	contadorBananaText = display.newText(contadorBanana, display.contentCenterX + 28, 2, native.systemFont, 20)
	contadorBananaText:setFillColor(black)

	-- Criando o número que vai ser a pontuação
	--local contadorAltura = display.newText( "0", display.contentCenterX -48, 2, native.systemFont, 20 )
	--contadorAltura:setFillColor( black )
	--local pontos = display.newText( "pontos:", display.contentCenterX -95, 2, native.systemFont, 16 )
	--pontos:setFillColor( black )
	--groupGame:insert(contadorAltura)
	--groupGame:insert(pontos)
	groupGame:insert(contadorBananaText)

		--local pastTime = 000  -- 10 minutes * 60 seconds

		-- Função que conta o tempo (Pontuação)
		function updateTime( event ) 
		    --pastTime = pastTime + 1
		    --contadorAltura.text = pastTime
		end

		--local contadorDeTempo = timer.performWithDelay( 100, updateTime, pastTime )

	-- Configurando altura, largura do sprite e o número de frames
	local sheetOptions  = {width = 100, height = 100, numFrames = 10}
	local sheet = graphics.newImageSheet( "front/spritecesinha4.png", sheetOptions )

	-- Definindo a animação 
	local sequences = {
		{
			name = "RunRight",
			frames = {1,2,3,4,5},
			time = 300,
			loopCount = 0,
		},

		{
			name = "RunLeft",
			frames = {6,7,8,9,10},
			time = 300,
			loopCount = 0,
		}
	}

	local player = display.newSprite( sheet, sequences )

	-- definindo a posição do meu personagem
	player.x = 281
	player.y = 361
	player.width =20
	player.height =30
	player.xScale = 1.1
	player.yScale = 1.1
	player: rotate(270)
	player:play()
	groupGame:insert(player)

	physics.addBody( player, "dynamic", {density=1.52,bounce=0, friction=0} )
	player.name = "player"

	local direita = true
	function touchAction( event )
	 	-- indica que um toque começou na tela.
	    if ( event.phase == "began" and (player.x >= 279 or player.x <= 36)) then
	    	local vx, vy = player:getLinearVelocity()
	        player:setLinearVelocity( 0, vy )
	        
	        if (direita == true) then
	        	--altura e direção do pulo
	        	local jump = audio.loadStream( "jump.mp3")
				audio.play(jump, {channel = 3})
				audio.setVolume( 0.05 , {channel = 3} )
	        	player:applyLinearImpulse( -18, -2.3, player.x, player.y )
	        	direita = false
	       		player:setSequence( "RunLeft" )
	        	player:play()
	        	player:rotate(180)	
	       	else if (direita == false) then
	        	local jump = audio.loadStream( "jump.mp3")
				audio.play(jump, {channel = 4})
				audio.setVolume( 0.05 , {channel = 4} )
	       		direita = true
	       		player:setSequence( "RunRight" )
	        	player:applyLinearImpulse( 18, -2.3, player.x, player.y )
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
	    	local novoGalho = display.newImageRect("front/galho1.png", 110, 70)
	    	physics.addBody( novoGalho, "dynamic", {radius = 18, density = -5, friction=0, bounce=0, filter = collisionFilter1})
		   	table.insert( galhoTable, novoGalho)
			novoGalho.name = "galho"
			novoGalho.x = display.contentCenterX + 110
			novoGalho.y = -130
			novoGalho:setLinearVelocity(0, -100)
			groupGame:insert(novoGalho)
		else
		 	local novoGalho = display.newImageRect("front/galho2.png", 90, 70)
		 	physics.addBody( novoGalho, "dynamic", {radius = 18, density = -5, friction=0, bounce=0, filter = collisionFilter1})
		   	table.insert( galhoTable, novoGalho)
			novoGalho.name = "galho"
			novoGalho.x = display.contentCenterX - 110
			novoGalho.y = -130
			novoGalho:setLinearVelocity(0, -100)
			groupGame:insert(novoGalho)

		end
	end

	function endGame()
		composer.setVariable( "finalScore", contadorBanana )
   	 	composer.gotoScene( "scenes.gameover", { time=600, effect="crossFade" } )
	end

	function gerarBanana(event)
	   	local whereFrom = math.random(2)
		local banana = display.newImageRect("front/banana.png", 30, 20)
    	physics.addBody( banana, "dynamic", {isSensor = true, friction=0, bounce=0, filter = collisionFilter1})
	   	table.insert( bananaTable, banana)
		banana.name = "banana"
		banana.y = -100
		groupGame:insert(banana)

	    if ( whereFrom == 1 ) then
			banana.x = display.contentCenterX + 41
			banana:setLinearVelocity(0, 200)
		else
			banana.x = display.contentCenterX - 41
			banana:setLinearVelocity(0, 50)
		end
	end



	-- Cria um galho a cada 1s = 1000
	geradorDeGalho = timer.performWithDelay(900, criarGalho, -1)
	-- Gera a banana aleatoriamente 
	geradorDeBanana = timer.performWithDelay( 1200, gerarBanana, -1)
	-- Clicando no background o player pula
	background:addEventListener( "touch", touchAction )
	-- Loop infinito da árvore descendo
	moveLoop = timer.performWithDelay(1, move, -1)

	function onCollision ( event )
		if (event.phase == "began") then
			local obj1 = event.object1
			local obj2 = event.object2

			if((obj1.name == "player" and obj2.name == "galho" or obj1.name == "galho" and obj2.name == "player")) then
				composer.gotoScene("scenes.gameover")	
			else if (obj1.name == "player" and obj2.name == "banana") then
				local coletandoBanana = audio.loadStream( "coletandoBanana.mp3")
				audio.play(coletandoBanana, {channel = 5})
				audio.setVolume( 1.0 , {channel = 5} )
				display.remove( obj2 )
				contadorBanana = contadorBanana + 10
				contadorBananaText.text = contadorBanana 			
			end
			end
		end
	end

	Runtime:addEventListener( "collision", onCollision )
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		timer.cancel(moveLoop)
		timer.cancel(geradorDeGalho)
		timer.cancel(geradorDeBanana)
		audio.stop(2)
	elseif ( phase == "did" ) then
		Runtime:removeEventListener( "collision", onCollision )
		background:addEventListener( "touch", touchAction )
		display.remove(groupGame)
	end
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("menu")
		composer.removeScene("scenes.gameover")
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