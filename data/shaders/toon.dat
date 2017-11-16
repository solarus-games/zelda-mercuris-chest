-- This is a toon glsl shader implementation from
-- http://gamedev.dreamnoid.com/2009/03/11/cel-shading-en-glsl/

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
	name = "toon",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
    --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the vertex shader.
	vertex_source = [[
		void main(void)
		{
			// Front color
			gl_FrontColor = gl_Color;

			// Textures coordinates
			gl_TexCoord[0] = gl_MultiTexCoord0;

			// The position of the vertex
			gl_Position = ftransform();

		}
	]],
	-- Source of the fragment shader.
	fragment_source = [[
		#define GRADIENT_FACTOR_NUMBER 4
		
		#define TEXEL(x,y) ]] .. texture_type .. [[(x,y)
		
		uniform ]] .. sampler_type .. [[ solarus_sampler;
		
		vec4 Toon( vec4 color )
		{
			float intensity = color.x + color.y + color.z;
			
			// Toon gradient conf.
			#if GRADIENT_FACTOR_NUMBER == 2
				float factor = 1.0;
				if ( intensity < 0.9 )
					factor = 0.5;
			#else // Use the more gradient number supported by default.
				float factor = 0.5;
				if      ( intensity > 1.5 )
					factor = 1.0;
				else if ( intensity > 1.0  )
					factor = 0.8;
				else if ( intensity > 0.6 )
					factor = 0.6;
			#endif
			
			color *= vec4 ( factor, factor, factor, 1.0 );

			return color;
		}

		void main (void)
		{
			vec4 color = TEXEL(solarus_sampler, vec2( gl_TexCoord[0] ) );

			gl_FragColor = Toon( color );
		}
	]]
}
