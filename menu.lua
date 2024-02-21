local composer = require( "composer" )
 
local scene = composer.newScene()
 

 local fondo, boton_play
 local vidas = 3

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 function ir_juego(e)
    if e.phase == "ended" then
        local options =
        {
            effect = "zoomInOut",
            time = 500,
            params = {
                dificultad = 20
            }
        }
        composer.gotoScene( "juego" , options )
    end
 
 end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    fondo = display.newImageRect(sceneGroup,  carpeta_recursos .. "fondoMenu.png", CW, CH)
    --fondo.x = CW/2; fondo.y= CH/2
    fondo.anchorX = 0; fondo.anchorY=0

    boton_play = display.newImageRect(sceneGroup, carpeta_recursos.."bu.png", 50, 70)
    boton_play.x = CW/2.05; boton_play.y = CH/1.7

 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        boton_play:addEventListener("touch", ir_juego)
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