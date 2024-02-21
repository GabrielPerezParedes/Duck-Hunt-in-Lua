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
    {angulo = 90},  -- Arriba centro
    {angulo = 30},  -- Arriba derecha
    {angulo = 170},  -- Abajo izquierda
    {angulo = 10}  -- Abajo derecha
}

-- Crea una línea invisible en el medio de la pantalla
local lineaMedia = display.newLine(0, CH/2, CW, CH/2)
lineaMedia.isVisible = false

function crearPato()
    print("CREANDO PATO")
    local pato = display.newImageRect(grupoPersonajes, carpeta_recursos.."0.png", 100,100)
    pato.x = CW/2; pato.y = CH/2  -- Cambia las coordenadas iniciales a las del centro de la pantalla
    pato.puntaje = math.random(1,50)
    
    -- Usa el contador para determinar la dirección del pato
    local direccion = direcciones[(contador % #direcciones) + 1]
    
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
            local anguloRebote = (direccion.angulo > 180) and (direccion.angulo - 180) or (direccion.angulo + 180)
            local radianesRebote = math.rad(anguloRebote)
            local xRebote = CW/2 + distancia * math.cos(radianesRebote)
            local yRebote = CH/2 - distancia * math.sin(radianesRebote)
            
            -- Ajusta las coordenadas x e y para que no se pasen del borde de la pantalla
            xRebote = math.max(0, math.min(CW, xRebote))
            yRebote = math.max(0, math.min(CH, yRebote))
            
            transition.to(pato, {x=xRebote, y=yRebote, time=2000})
        end
    end
end)


---------objeto ensquina superior derecha
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "did" ) then
        timer.performWithDelay( 1000, crearPato, event.params.dificultad )
    end
end

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

    for i=1,vidas,1 do
        local imagen_vida = display.newImageRect(grupoInterfaz,  carpeta_recursos.. "win.png", 15, 21)
        imagen_vida.y = CH/20; imagen_vida.x = CW  -(20 * i)
    end

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