local sheetOptions =
{
    -- El array frames contiene todos los cuadros de la animación.
    frames = 
    {
        { -- 1) frame 1
            x = 0,
            y = 0,
            width = 120, -- asumimos que el ancho de la imagen es 120
            height = 120, -- asumimos que el alto de la imagen es 120
        },
        { -- 2) frame 2
            x = 0,
            y = 0,
            width = 120,
            height = 120,
        },
        { -- 3) frame 3
            x = 0,
            y = 0,
            width = 120,
            height = 120,
        },
    },

    -- El array sequenceData contiene la información de las secuencias de animación.
    sequenceData = 
    {
        {
            name = "volar",
            start = 1,
            count = 3,
            time = 800, -- puedes ajustar este valor para hacer la animación más rápida o más lenta
            loopCount = 0, -- Loop infinito
            loopDirection = "forward"
        }
    }
}

return sheetOptions