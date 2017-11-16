-- This is a heavybloom glsl shader implementation from the bsnes project.
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
	name = "heavybloom",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
    --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the fragment shader.
	fragment_source = [[
      	#define glarebasesize 0.42
      	#define power 0.35 // 0.50 is good
      	
		#define TEXEL(x,y) ]] .. texture_type .. [[(x,y)
		
     	uniform ]] .. sampler_type .. [[ solarus_sampler;
		uniform vec2 solarus_io_size;

      	void main()
      	{
         	vec4 sum = vec4(0.0);
         	vec4 bum = vec4(0.0);
         	vec2 texcoord = vec2(gl_TexCoord[0]);
         	int j;
         	int i;

         	vec2 glaresize = vec2(glarebasesize) / solarus_io_size;

         	for(i = -2; i < 5; i++)
         	{
            	for (j = -1; j < 1; j++)
            	{
               		sum += TEXEL(solarus_sampler, texcoord + vec2(-i, j)*glaresize) * power;
               		bum += TEXEL(solarus_sampler, texcoord + vec2(j, i)*glaresize) * power;            
            	}
         	}

         	if (TEXEL(solarus_sampler, texcoord).r < 2.0)
         	{
            	gl_FragColor = sum*sum*sum*0.001+bum*bum*bum*0.0080 + ]] .. texture_type .. [[(solarus_sampler, texcoord);
         	}
      	}
	]]
}
