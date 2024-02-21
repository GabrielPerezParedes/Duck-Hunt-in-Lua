local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local fondo
 local puntaje
 local vidas = 5
 local dificultad = 30
 local valor_puntaje = 0
 local grupoFondo, grupoPersonajes, grupoControles, grupoInterfaz
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local contador = 0  -- Crea un contador global
local contadorImagenes = 0 -- Contador de imágenes mostradas
local espacioEntreImagenes = 120 -- Espacio entre cada imagen, ajusta según el tamaño de tus imágenes


function destruir(self, event)
    if event.phase == "ended" then
        valor_puntaje = valor_puntaje + self.puntaje
        puntaje.text = "SCORE:" .. valor_puntaje
        --sumar puntaje
        --destruir 
        self:removeSelf( )
        contador = contador + 1  -- Incrementa el contador
        print("Contador: " .. contador)  -- Imprime el valor del contador
        crearPato()  -- Crea un nuevo pato
    end
    return true
end

local direcciones = {
    {angulo = 150},  -- Arriba izquierda
    {angulo = 30},  -- Arriba derecha
    {angulo = 170},  -- Abajo izquierda
    {angulo = 10}  -- Abajo derecha
}

-- Crea una línea invisible en el medio de la pantalla
local lineaMedia = display.newLine(0, CH/2, CW, CH/2)
lineaMedia.isVisible = false

local find = display.newImage(carpeta_recursos.."find.png")
find.isVisible = false -- Oculta la imagen hasta que sea necesario mostrarla

------SHEETS------
-----dogSniff
local dog_sniff={
    width=125,
    height=130,
    numFrames=5,
    sheetContentWidth=625,
    sheetContentHeight=130
 }

 local sniff = graphics.newImageSheet( carpeta_recursos.."dog_sheet_sniff.png", dog_sniff)

 local sequenceData = {name = "normalRun", start=1,count=5,time=500}

 -----dogjump
local dog_jump={
    width=125,
    height=130,
    numFrames=2,
    sheetContentWidth=250,
    sheetContentHeight=130
 }

 local jump = graphics.newImageSheet( carpeta_recursos.."dog-sheet-jump.png", dog_jump)

 local sequenceData = {name = "normalRun", start=1,count=2,time=200}

-----izquierda
local duck_sheet_left={
    width=127,
    height=131,
    numFrames=3,
    sheetContentWidth=382,
    sheetContentHeight=131
 }

 local duck_left = graphics.newImageSheet( carpeta_recursos.."left.png", duck_sheet_left )

 local sequenceData = {name = "normalRun", start=1,count=3,time=300}
-----derecha
 local duck_sheet_right={
    width=127,
    height=131,
    numFrames=3,
    sheetContentWidth=382,
    sheetContentHeight=131
 }

 local duck_right = graphics.newImageSheet( carpeta_recursos.."right.png", duck_sheet_right )

 local sequenceData = {name = "normalRun", start=1,count=3,time=300}

 -----derechaArriba

 local duck_sheet_top_right={
    width=127,
    height=131,
    numFrames=3,
    sheetContentWidth=382,
    sheetContentHeight=131
 }

 local duck_top_right = graphics.newImageSheet( carpeta_recursos.."top-right.png", duck_sheet_top_right )

 local sequenceData = {name = "normalRun", start=1,count=3,time=300}

  -----izquierdaArriba

  local duck_sheet_top_left={
    width=127,
    height=131,
    numFrames=3,
    sheetContentWidth=382,
    sheetContentHeight=131
 }

 local duck_top_left = graphics.newImageSheet( carpeta_recursos.."top-left.png", duck_sheet_top_left )

 local sequenceData = {name = "normalRun", start=1,count=3,time=300}

 -----------------------------------------------------------------------------------
-- Aumenta el tiempo de la animación "sniff" a 1000 (antes era 500)
local sequences = {
    { name="sniff", sheet=sniff, start=1, count=5, time=1000 },
    { name="jump", sheet=jump, start=1, count=2, time=400 } -- Aumenta el tiempo de la animación "jump" a 400 (antes era 200)
}

local dog = display.newSprite(sniff, sequences)
dog.x = 0
dog.y = display.contentCenterY

local function startJump()
    dog:setSequence("jump")
    dog:play()
end

local function showFind()
    find.isVisible = true
    timer.performWithDelay(1000, startJump) -- Aumenta el retraso a 1000 (antes era 500)
end

dog:setSequence("sniff")
dog:play()
timer.performWithDelay(1000, showFind) -- Aumenta el retraso a 1000 (antes era 500)

 -----CREAR LOS PATOS
 function crearPato()
    print("CREANDO PATO")

    -- Usa el contador para determinar la dirección del pato
    local direccion = direcciones[(contador % #direcciones) + 1]

    -- Selecciona la hoja de sprites dependiendo del ángulo de la dirección
    local duck_sheet
    if direccion.angulo == 150 then
        duck_sheet = duck_top_left
    elseif direccion.angulo == 30 then
        duck_sheet = duck_top_right
    elseif direccion.angulo == 170 then
        duck_sheet = duck_left
    else
        duck_sheet = duck_right
    end

    local pato = display.newSprite( grupoPersonajes, duck_sheet, sequenceData )

    pato:play()
    pato.x = CW/2; pato.y = CH/2  -- Cambia las coordenadas iniciales a las del centro de la pantalla
    pato.puntaje = math.random(1,50)

            -- Agrega una propiedad para rastrear la dirección del pato
    if direccion.angulo == 150 then
        pato.direccion = "top_left"
    elseif direccion.angulo == 30 then
        pato.direccion = "top_right"
    elseif direccion.angulo == 170 then
        pato.direccion = "left"
    else
        pato.direccion = "right"
    end
    
    -- Calcula las coordenadas x e y basadas en el ángulo
    local radianes = math.rad(direccion.angulo)
    local distancia = math.max(CW, CH)  -- Asegura que los patos lleguen hasta el borde de la pantalla
    local x = CW/2 + distancia * math.cos(radianes)
    local y = CH/2 - distancia * math.sin(radianes)
    
    -- Ajusta las coordenadas x e y para que no se pasen del borde de la pantalla
    x = math.max(0, math.min(CW, x))
    y = math.max(0, math.min(CH, y))
    
    transition.to(pato, {x=x, y=y, time=2000, onComplete=function()
        -- Calcula el ángulo de rebote
        local anguloRebote = (direccion.angulo > 180) and (direccion.angulo - 180) or (direccion.angulo + 180)
        local radianesRebote = math.rad(anguloRebote)
        local xRebote = CW/2 + distancia * math.cos(radianesRebote)
        local yRebote = CH/2 - distancia * math.sin(radianesRebote)
        
        -- Ajusta las coordenadas x e y para que no se pasen del borde de la pantalla
        xRebote = math.max(0, math.min(CW, xRebote))
        yRebote = math.max(0, math.min(CH, yRebote))
        
        transition.to(pato, {x=xRebote, y=yRebote, time=2000})
    end})
    pato.touch = destruir
    pato:addEventListener( "touch", pato )
    return pato
end

-- Mueve la definición de 'distancia' al ámbito global
local distancia = math.max(CW, CH)  -- Asegura que los patos lleguen hasta el borde de la pantalla

-- Agrega un listener para el evento "enterFrame" que verifica si un pato ha cruzado la línea media
Runtime:addEventListener("enterFrame", function()
    for i = grupoPersonajes.numChildren, 1, -1 do
        local pato = grupoPersonajes[i]
        if pato.y > lineaMedia.y then
            -- El pato ha cruzado la línea media, así que cambia su dirección
            local direccion = direcciones[(contador % #direcciones) + 1]
            local radianes = math.rad(direccion.angulo)
            local x = CW/2 + distancia * math.cos(radianes)
            local y = CH/2 - distancia * math.sin(radianes)
            
            -- Calcula el ángulo de rebote
            local anguloRebote
            if pato.direccion == "top_left" or pato.direccion == "top_right" then
                anguloRebote = (direccion.angulo > 90) and (direccion.angulo - 90) or (direccion.angulo + 90)
            else
                anguloRebote = (direccion.angulo > 180) and (direccion.angulo - 180) or (direccion.angulo + 180)
            end
            local radianesRebote = math.rad(anguloRebote)
            local xRebote = CW/2 + distancia * math.cos(radianesRebote)
            local yRebote = CH/2 - distancia * math.sin(radianesRebote)
            
            -- Ajusta las coordenadas x e y para que no se pasen del borde de la pantalla
            xRebote = math.max(0, math.min(CW, xRebote))
            yRebote = math.max(0, math.min(CH, yRebote))
            
            -- Cambia la hoja de sprites del pato a su opuesto
            if pato.direccion == "left" then
                pato:setSequence("right")
                pato.direccion = "right"
            elseif pato.direccion == "right" then
                pato:setSequence("left")
                pato.direccion = "left"
            elseif pato.direccion == "top_left" then
                pato:setSequence("top_right")
                pato.direccion = "top_right"
            elseif pato.direccion == "top_right" then
                pato:setSequence("top_left")
                pato.direccion = "top_left"
            end
            pato:play()

            transition.to(pato, {x=xRebote, y=yRebote, time=2000})
        end
    end
end)

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    grupoFondo = display.newGroup( )
    sceneGroup:insert(grupoFondo)
    grupoPersonajes = display.newGroup( )
    sceneGroup:insert(grupoPersonajes)
    grupoInterfaz = display.newGroup()
    sceneGroup:insert( grupoInterfaz)
    -- Code here runs when the scene is first created but has not yet appeared on screen
    fondo = display.newImageRect(grupoFondo,  carpeta_recursos .. "fondoJuego.png", CW, CH)
    fondo.x = CW/2; fondo.y= CH/2

    --for i=1,vidas,1 do
        --local imagen_vida = display.newImageRect(grupoInterfaz,  carpeta_recursos.. "win.png", 15, 21)
        --imagen_vida.y = CH/20; imagen_vida.x = CW  -(20 * i)
    --end

    puntaje = display.newText(grupoInterfaz,"SCORE: "  .. valor_puntaje, 0, CH/20, "arial bold", 20 )
    puntaje.anchorX = 0



end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        -- local f1 = crearFrutas()
        -- sceneGroup:insert(f1)
        --for i=1, dificultad,1 do
        timer.performWithDelay( 1000, crearPato, 1 )
         
        --end
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene