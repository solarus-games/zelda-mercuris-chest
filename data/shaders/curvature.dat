-- This is a curvature glsl shader implementation from the bsnes project.
-- https://gitorious.org/bsnes/xml-shaders

video_driver_name = select(1, ...) -- Get the rendering driver name.
shading_language_version = select(2, ...) -- Get the shading language version.
sampler_type = select(3, ...) -- Get the type of samplers to use.

-- Get the type of texture2D function to use.
texture_type = "texture2D"
if (sampler_type == "sampler2DRect") then
	texture_type = "texture2DRect"	
end

videomode {
	-- Name of the video mode associated to the shader.
	name = "curvature",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
    --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the vertex shader.
	vertex_source = [[
		#define ZOOM_SCALE 1.235
		
     	void main()
     	{
			gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex * vec4(ZOOM_SCALE,ZOOM_SCALE,1.0,1.0);
			gl_TexCoord[0] = gl_MultiTexCoord0;
		}
	]],
	-- Source of the fragment shader.
	fragment_source = [[
    	// Tweak this parameter for more / less distortion
    	#define distortion 1.2
    	#define BLACK_BACKGROUND
    	
		#define TEXEL(x,y) ]] .. texture_type .. [[(x,y)
    	
		uniform ]] .. sampler_type .. [[ solarus_sampler;
    	uniform vec2 solarus_io_size;

    	vec2 radialDistortion(vec2 coord) {
      		coord *= vec2(1.0) / solarus_io_size;
      		vec2 cc = coord - vec2(0.5);
      		float dist = dot(cc, cc) * distortion;
      		return (coord + cc * (1.0 + dist) * dist) * solarus_io_size;
    	}

        float corner(vec2 coord)
        {
        	//TODO optimize
        	if(coord.x < 0.0 || coord.y < 0.0 || coord.x > solarus_io_size.x || coord.y > solarus_io_size.y)
        		return 0.0;
        	return 1.0;
        }
        
    	void main(void) {	
    		vec2 xy = radialDistortion(gl_TexCoord[0].xy);
    		
      		vec4 sample = TEXEL(solarus_sampler, xy);
      		
      		#ifdef BLACK_BACKGROUND
    			sample *= vec4(vec3(corner(xy)), 1.0);
    		#endif
    		
      		gl_FragColor = sample;
    	}
	]]
}
