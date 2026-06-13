local shaderName = "fire"
local isShaderSupported = false

function onCreatePost()
    if shadersSupported then
        isShaderSupported = true
        initLuaShader(shaderName)
        
        runHaxeCode([[
            var shader = game.createRuntimeShader(']] .. shaderName .. [[');
            // Applies the fire over the primary game play layer (characters/stages)
            game.camGame.setFilters([new openfl.filters.ShaderFilter(shader)]);
            
            shader.setFloatArray('iResolution', [1280.0, 720.0, 0.0]);
            shader.setFloat('iTime', 0.0);
        ]])
    end
end

function onUpdate(elapsed)
    if isShaderSupported then
        -- Retrieve conductor timing to keep the fire synced cleanly with song speed
        local shaderTime = getPropertyFromClass('backend.Conductor', 'songPosition') / 1000
        
        runHaxeCode([[
            var shader = game.camGame.getFilters()[0].shader;
            if (shader != null) {
                shader.setFloat('iTime', ]] .. shaderTime .. [[);
            }
        ]])
    end
end
