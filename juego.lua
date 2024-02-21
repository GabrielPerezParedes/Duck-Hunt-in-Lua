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
 
function destruir(self, event)
    if event.phase == "ended" then
        valor_puntaje = valor_puntaje + self.puntaje
        puntaje.text = "SCORE:" .. valor_puntaje
            --sumar puntaje
            --destruir 
            self:removeSelf( )
    end
    return true
end

function crearFrutas()
        print("CREANDO FRUTA")
        local fruta = display.newImageRect(grupoPersonajes, carpeta_recursos.."f1.png", 30,30)
        fruta.x = math.random(35, CW-35); fruta.y = math.random(35, CH-35)
        fruta.puntaje = math.random(1,50)
        transition.to(fruta, {x=math.random(0,CW), y=math.random(0,CH), time=2000})
=        fruta.touch = destruir
        fruta:addEventListener( "touch", fruta )
        return fruta
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
    fondo = display.newImageRect(grupoFondo,  carpeta_recursos .. "5.jpg", CW, CH)
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
        timer.performWithDelay( 1000, crearFrutas, event.params.dificultad )
         
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