-- This is a scale2x glsl shader implementation from the bsnes project.
-- https://gitorious.org/bsnes/xml-shaders

video_driver_name = select(1, ...) -- Get the rendering driver name.
shading_language_version = select(2, ...) -- Get the shading language version.
sampler_type = select(3, ...) -- Get the type of samplers to use.

-- Get the type of texture2D function to use.
texture_type = "texture2DProj"
if (sampler_type == "sampler2DRect") then
	texture_type = "texture2DRectProj"	
end

videomode {
	-- Name of the video mode associated to the shader.
	name = "hw_scale2x",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
    --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the vertex shader.
	vertex_source = [[
    	void main() {
     		vec4 offsetx;
      		vec4 offsety;

      		gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

      		offsetx.x = 1.0;
      		offsetx.y = 0.0;
      		offsetx.w = 0.0;
      		offsetx.z = 0.0;
      		offsety.y = 1.0;
      		offsety.x = 0.0;
      		offsety.w = 0.0;
      		offsety.z = 0.0;

      		gl_TexCoord[0] = gl_MultiTexCoord0;         //center
      		gl_TexCoord[1] = gl_TexCoord[0] - offsetx;  //left
      		gl_TexCoord[2] = gl_TexCoord[0] + offsetx;  //right
      		gl_TexCoord[3] = gl_TexCoord[0] - offsety;  //top
      		gl_TexCoord[4] = gl_TexCoord[0] + offsety;  //bottom
    }
	]],
	-- Source of the fragment shader.
	fragment_source = [[
		#define TEXEL(x,y) ]] .. texture_type .. [[(x,y)
		
     	uniform ]] .. sampler_type .. [[ solarus_sampler;

    	void main() {
      		vec4 colD, colF, colB, colH, col, tmp;
      		vec2 sel;

      		col  = TEXEL(solarus_sampler, gl_TexCoord[0]);  //central (can be E0-E3)
      		colD = TEXEL(solarus_sampler, gl_TexCoord[1]);  //D (left)
      		colF = TEXEL(solarus_sampler, gl_TexCoord[2]);  //F (right)
      		colB = TEXEL(solarus_sampler, gl_TexCoord[3]);  //B (top)
      		colH = TEXEL(solarus_sampler, gl_TexCoord[4]);  //H (bottom)

      		sel = fract(gl_TexCoord[0].xy);       //where are we (E0-E3)? 
                                                                 //E0 is default
      		if(sel.y >= 0.5) { tmp = colB; colB = colH; colH = tmp; }  //E1 (or E3): swap B and H
      		if(sel.x >= 0.5) { tmp = colF; colF = colD; colD = tmp; }  //E2 (or E3): swap D and F 

      		if(colB == colD && colB != colF && colD != colH) {  //do the Scale2x rule
        		col = colD;
      		}

      		gl_FragColor = col;
    	}
	]]
}
