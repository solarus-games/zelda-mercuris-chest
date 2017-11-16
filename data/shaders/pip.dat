-- This is a pip glsl shader implementation from the mari0 project.
-- http://stabyourself.net/mari0/

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
	name = "pip",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
    --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the fragment shader.
	fragment_source = [[
		#define glarebasesize 0.896
		#define green_power 0.50
		
		#define SCANLINE_SPEED 0.001
		#define SCANLINE_TRACE 0.004
		#define SCANLINE_FREQUENCY 4.0

		#define TEXEL(x,y) ]] .. texture_type .. [[(x,y)
		
		uniform ]] .. sampler_type .. [[ solarus_sampler;
        uniform int solarus_display_time;

		vec3 green = vec3(0.17, 0.62, 0.25);

		float luminance(vec3 color)
		{
			return (0.212671 * color.r) + (0.715160 * color.g) + (0.072169 * color.b);
		}

		float scanline(float ypos)
		{
			float c = mod(float(solarus_display_time)*SCANLINE_SPEED - ypos*SCANLINE_TRACE, SCANLINE_FREQUENCY);	
			return 1.0 - smoothstep(0.0, 1.0, c);
		}

		void main()
		{
			vec4 texcolor = TEXEL(solarus_sampler, gl_TexCoord[0].xy);
	
			vec4 sum = vec4(0.0);
			vec4 bum = vec4(0.0);

			vec2 glaresize = vec2(glarebasesize);
			vec2 texcoord = gl_TexCoord[0].xy;
	
			int j;
			int i;

			for (i = -2; i < 2; i++)
			{
				for (j = -1; j < 1; j++)
				{
					sum += TEXEL(solarus_sampler, texcoord + vec2(-i, j)*glaresize) * green_power;
					bum += TEXEL(solarus_sampler, texcoord + vec2(j, i)*glaresize) * green_power;            
				}
			}
	
			float a = scanline(texcoord.y);
	
			vec4 finalcolor;

			if (texcolor.r < 2.0)
			{
				finalcolor = sum*sum*sum*0.001+bum*bum*bum*0.0080 * (0.8 + 0.05 * a) + texcolor;
			}
			else
			{
				finalcolor = vec4(0.0, 0.0, 0.0, 1.0);
			}
	
			float lum = pow(luminance(finalcolor.rgb), 1.4);
	
			finalcolor.rgb = lum * green + (a * 0.03);
			finalcolor.a = 1.0;
	
			gl_FragColor = finalcolor;
		}
	]]
}
