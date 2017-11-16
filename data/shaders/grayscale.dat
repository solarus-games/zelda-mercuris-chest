-- This is a grayscale glsl shader implementation.

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
	name = "grayscale",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
    --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the fragment shader.
	fragment_source = [[
		#define BIAS_GRAY
		
		#define TEXEL(x,y) ]] .. texture_type .. [[(x,y)
		
		uniform ]] .. sampler_type .. [[ solarus_sampler;

		void main() {
        	vec3 texel = TEXEL(solarus_sampler, gl_TexCoord[0].xy).rgb;
        	gl_FragColor = vec4(texel.x,texel.y,texel.z, 1.0);

			#ifdef BIAS_GRAY
				gl_FragColor.rgb = vec3(dot(texel.rgb, vec3(.2382, .6797, .082)));
			#else
        		gl_FragColor.rgb = vec3(max(max(texel.r,max(texel.g,texel.b))-0.3, 0.0));
			#endif
		}
	]]
}
