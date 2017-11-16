-- This is a 5xBR-v3.8b glsl shader implementation from the libretro/common-shaders project.
-- https://github.com/libretro/common-shaders/tree/master/xbr
-- It was converted from CG script by the cg2glsl tool here
-- https://github.com/libretro/RetroArch/blob/master/tools/cg2glsl.py

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
	name = "xBR-v3.8b",
	-- Default scale of the window compared to the quest_size.
	default_window_scale = 2,
	-- Set the validity range of the shader.
        --TODO check the real validity range.
	is_shader_valid = video_driver_name == "opengl",
	-- Source of the vertex shader.
	vertex_source = [[
            #if __VERSION__ >= 130
            #define COMPAT_VARYING out
            #else
            #define COMPAT_VARYING varying
            #endif

            #ifdef GL_ES
            #define COMPAT_PRECISION mediump
            #else
            #define COMPAT_PRECISION
            #endif
            COMPAT_VARYING     vec4 VARt7;
            COMPAT_VARYING     vec4 VARt6;
            COMPAT_VARYING     vec4 VARt5;
            COMPAT_VARYING     vec4 VARt4;
            COMPAT_VARYING     vec4 VARt3;
            COMPAT_VARYING     vec4 VARt2;
            COMPAT_VARYING     vec4 VARt1;
            COMPAT_VARYING     vec2 _texCoord1;
            COMPAT_VARYING     vec4 _color1;
            COMPAT_VARYING     vec4 _position1;
            struct input_dummy {
                vec2 _video_size;
                vec2 _texture_size;
                vec2 _output_dummy_size;
            };
            struct out_vertex {
                vec4 _position1;
                vec4 _color1;
                vec2 _texCoord1;
                vec4 VARt1;
                vec4 VARt2;
                vec4 VARt3;
                vec4 VARt4;
                vec4 VARt5;
                vec4 VARt6;
                vec4 VARt7;
            };
            out_vertex _ret_0;
            input_dummy _IN1;
            vec4 TexCoord;
            COMPAT_VARYING vec4 COL0;
            COMPAT_VARYING vec4 TEX0;

            void main()
            {
                out_vertex _OUT;
                vec2 _ps;
                TexCoord = gl_MultiTexCoord0;
                _OUT._position1 = gl_ModelViewProjectionMatrix * gl_Vertex;
                _ps = vec2(1.00000000E+00);
                _OUT.VARt1 = TexCoord.xxxy + vec4(float(float(-_ps.x)), 0.00000000E+00, float(float(_ps.x)), float(float((-2.00000000E+00*_ps.y))));
                _OUT.VARt2 = TexCoord.xxxy + vec4(float(float(-_ps.x)), 0.00000000E+00, float(float(_ps.x)), float(float(-_ps.y)));
                _OUT.VARt3 = TexCoord.xxxy + vec4(float(float(-_ps.x)), 0.00000000E+00, float(float(_ps.x)), 0.00000000E+00);
                _OUT.VARt4 = TexCoord.xxxy + vec4(float(float(-_ps.x)), 0.00000000E+00, float(float(_ps.x)), float(float(_ps.y)));
                _OUT.VARt5 = TexCoord.xxxy + vec4(float(float(-_ps.x)), 0.00000000E+00, float(float(_ps.x)), float(float((2.00000000E+00*_ps.y))));
                _OUT.VARt6 = TexCoord.xyyy + vec4(float(float((-2.00000000E+00*_ps.x))), float(float(-_ps.y)), 0.00000000E+00, float(float(_ps.y)));
                _OUT.VARt7 = TexCoord.xyyy + vec4(float(float((2.00000000E+00*_ps.x))), float(float(-_ps.y)), 0.00000000E+00, float(float(_ps.y)));
                _ret_0._position1 = _OUT._position1;
                _ret_0._color1 = gl_Color;
                _ret_0._texCoord1 = TexCoord.xy;
                VARt1 = _OUT.VARt1;
                VARt2 = _OUT.VARt2;
                VARt3 = _OUT.VARt3;
                VARt4 = _OUT.VARt4;
                VARt5 = _OUT.VARt5;
                VARt6 = _OUT.VARt6;
                VARt7 = _OUT.VARt7;
                gl_Position = _OUT._position1;
                COL0 = gl_Color;
                TEX0.xy = TexCoord.xy;
            }
	]],
	-- Source of the fragment shader.
	fragment_source = [[
            uniform ]] .. sampler_type .. [[ solarus_sampler;

            #if __VERSION__ >= 130
            #define COMPAT_VARYING in
            #define COMPAT_TEXTURE texture
            out vec4 FragColor;
            #else
            #define COMPAT_VARYING varying
            #define FragColor gl_FragColor
            #define COMPAT_TEXTURE ]] .. texture_type .. [[ 
            #endif

            #ifdef GL_ES
            #ifdef GL_FRAGMENT_PRECISION_HIGH
            precision highp float;
            #else
            precision mediump float;
            #endif
            #define COMPAT_PRECISION mediump
            #else
            #define COMPAT_PRECISION
            #endif
            COMPAT_VARYING     vec4 VARt7;
            COMPAT_VARYING     vec4 VARt6;
            COMPAT_VARYING     vec4 VARt5;
            COMPAT_VARYING     vec4 VARt4;
            COMPAT_VARYING     vec4 VARt3;
            COMPAT_VARYING     vec4 VARt2;
            COMPAT_VARYING     vec4 VARt1;
            COMPAT_VARYING     vec2 _texCoord;
            COMPAT_VARYING     vec4 _color;
            struct input_dummy {
                vec2 _video_size;
                vec2 _texture_size;
                vec2 _output_dummy_size;
            };
            struct out_vertex {
                vec4 _color;
                vec2 _texCoord;
                vec4 VARt1;
                vec4 VARt2;
                vec4 VARt3;
                vec4 VARt4;
                vec4 VARt5;
                vec4 VARt6;
                vec4 VARt7;
            };
            vec4 _ret_0;
            float _TMP58;
            vec3 _TMP50;
            vec3 _TMP48;
            vec3 _TMP46;
            vec3 _TMP44;
            vec3 _TMP49;
            vec3 _TMP47;
            vec3 _TMP45;
            vec3 _TMP43;
            vec4 _TMP42;
            vec4 _TMP35;
            vec4 _TMP34;
            vec4 _TMP59;
            bvec4 _TMP33;
            bvec4 _TMP32;
            bvec4 _TMP31;
            bvec4 _TMP30;
            bvec4 _TMP29;
            bvec4 _TMP28;
            bvec4 _TMP27;
            vec4 _TMP20;
            vec4 _TMP19;
            vec4 _TMP18;
            vec4 _TMP17;
            vec4 _TMP16;
            vec4 _TMP15;
            vec4 _TMP14;
            vec4 _TMP13;
            vec4 _TMP12;
            vec4 _TMP11;
            vec4 _TMP10;
            vec4 _TMP9;
            vec4 _TMP8;
            vec4 _TMP7;
            vec4 _TMP6;
            vec4 _TMP5;
            vec4 _TMP4;
            vec4 _TMP3;
            vec4 _TMP2;
            vec4 _TMP1;
            vec4 _TMP0;
            out_vertex _VAR1;
            input_dummy _IN1;
            vec2 _x0074;
            vec4 _r0118;
            vec4 _r0128;
            vec4 _r0138;
            vec4 _r0148;
            vec4 _r0158;
            vec4 _r0168;
            vec4 _TMP179;
            vec4 _a0182;
            vec4 _TMP185;
            vec4 _a0188;
            vec4 _TMP191;
            vec4 _a0194;
            vec4 _TMP197;
            vec4 _a0200;
            vec4 _TMP203;
            vec4 _a0206;
            vec4 _TMP209;
            vec4 _a0212;
            vec4 _TMP215;
            vec4 _a0218;
            vec4 _x0220;
            vec4 _TMP221;
            vec4 _x0228;
            vec4 _TMP229;
            vec4 _x0236;
            vec4 _TMP237;
            vec4 _TMP245;
            vec4 _a0248;
            vec4 _TMP249;
            vec4 _a0252;
            vec4 _TMP253;
            vec4 _a0256;
            vec4 _TMP257;
            vec4 _a0260;
            vec4 _TMP261;
            vec4 _a0264;
            vec4 _TMP267;
            vec4 _a0270;
            vec4 _TMP271;
            vec4 _a0274;
            vec4 _TMP275;
            vec4 _a0278;
            vec4 _TMP279;
            vec4 _a0282;
            vec4 _TMP283;
            vec4 _a0286;
            vec4 _TMP287;
            vec4 _a0290;
            vec4 _TMP291;
            vec4 _a0294;
            vec4 _TMP295;
            vec4 _a0298;
            vec4 _TMP299;
            vec4 _a0302;
            vec4 _TMP303;
            vec4 _a0306;
            vec4 _TMP307;
            vec4 _a0310;
            float _t0316;
            float _t0318;
            float _t0320;
            float _t0322;
            float _t0324;
            float _t0326;
            float _t0328;
            float _t0330;
            vec4 _r0332;
            vec4 _TMP341;
            vec4 _a0344;
            COMPAT_VARYING vec4 TEX0;
             
            void main()
            {
                bvec4 _edr;
                bvec4 _edr_left;
                bvec4 _edr_up;
                bvec4 _px;
                bvec4 _interp_restriction_lv1;
                bvec4 _interp_restriction_lv2_left;
                bvec4 _interp_restriction_lv2_up;
                vec4 _fx;
                vec4 _fx_left;
                vec4 _fx_up;
                vec2 _fp;
                vec3 _A11;
                vec3 _B11;
                vec3 _C1;
                vec3 _A2;
                vec3 _B2;
                vec3 _C;
                vec3 _D;
                vec3 _E;
                vec3 _F;
                vec3 _G;
                vec3 _H;
                vec3 _I;
                vec3 _G5;
                vec3 _H5;
                vec3 _I5;
                vec3 _A0;
                vec3 _D0;
                vec3 _G0;
                vec3 _C4;
                vec3 _F4;
                vec3 _I4;
                vec4 _b1;
                vec4 _c1;
                vec4 _e1;
                vec4 _i4;
                vec4 _i5;
                vec4 _h5;
                vec4 _fx45;
                vec4 _fx30;
                vec4 _fx60;
                vec4 _maximo;
                vec4 _pixel;
                vec3 _res;
                float _mx;
                _x0074 = TEX0.xy;
                _fp = fract(_x0074);
                _TMP0 = COMPAT_TEXTURE(solarus_sampler, VARt1.xw);
                _A11 = vec3(float(_TMP0.x), float(_TMP0.y), float(_TMP0.z));
                _TMP1 = COMPAT_TEXTURE(solarus_sampler, VARt1.yw);
                _B11 = vec3(float(_TMP1.x), float(_TMP1.y), float(_TMP1.z));
                _TMP2 = COMPAT_TEXTURE(solarus_sampler, VARt1.zw);
                _C1 = vec3(float(_TMP2.x), float(_TMP2.y), float(_TMP2.z));
                _TMP3 = COMPAT_TEXTURE(solarus_sampler, VARt2.xw);
                _A2 = vec3(float(_TMP3.x), float(_TMP3.y), float(_TMP3.z));
                _TMP4 = COMPAT_TEXTURE(solarus_sampler, VARt2.yw);
                _B2 = vec3(float(_TMP4.x), float(_TMP4.y), float(_TMP4.z));
                _TMP5 = COMPAT_TEXTURE(solarus_sampler, VARt2.zw);
                _C = vec3(float(_TMP5.x), float(_TMP5.y), float(_TMP5.z));
                _TMP6 = COMPAT_TEXTURE(solarus_sampler, VARt3.xw);
                _D = vec3(float(_TMP6.x), float(_TMP6.y), float(_TMP6.z));
                _TMP7 = COMPAT_TEXTURE(solarus_sampler, VARt3.yw);
                _E = vec3(float(_TMP7.x), float(_TMP7.y), float(_TMP7.z));
                _TMP8 = COMPAT_TEXTURE(solarus_sampler, VARt3.zw);
                _F = vec3(float(_TMP8.x), float(_TMP8.y), float(_TMP8.z));
                _TMP9 = COMPAT_TEXTURE(solarus_sampler, VARt4.xw);
                _G = vec3(float(_TMP9.x), float(_TMP9.y), float(_TMP9.z));
                _TMP10 = COMPAT_TEXTURE(solarus_sampler, VARt4.yw);
                _H = vec3(float(_TMP10.x), float(_TMP10.y), float(_TMP10.z));
                _TMP11 = COMPAT_TEXTURE(solarus_sampler, VARt4.zw);
                _I = vec3(float(_TMP11.x), float(_TMP11.y), float(_TMP11.z));
                _TMP12 = COMPAT_TEXTURE(solarus_sampler, VARt5.xw);
                _G5 = vec3(float(_TMP12.x), float(_TMP12.y), float(_TMP12.z));
                _TMP13 = COMPAT_TEXTURE(solarus_sampler, VARt5.yw);
                _H5 = vec3(float(_TMP13.x), float(_TMP13.y), float(_TMP13.z));
                _TMP14 = COMPAT_TEXTURE(solarus_sampler, VARt5.zw);
                _I5 = vec3(float(_TMP14.x), float(_TMP14.y), float(_TMP14.z));
                _TMP15 = COMPAT_TEXTURE(solarus_sampler, VARt6.xy);
                _A0 = vec3(float(_TMP15.x), float(_TMP15.y), float(_TMP15.z));
                _TMP16 = COMPAT_TEXTURE(solarus_sampler, VARt6.xz);
                _D0 = vec3(float(_TMP16.x), float(_TMP16.y), float(_TMP16.z));
                _TMP17 = COMPAT_TEXTURE(solarus_sampler, VARt6.xw);
                _G0 = vec3(float(_TMP17.x), float(_TMP17.y), float(_TMP17.z));
                _TMP18 = COMPAT_TEXTURE(solarus_sampler, VARt7.xy);
                _C4 = vec3(float(_TMP18.x), float(_TMP18.y), float(_TMP18.z));
                _TMP19 = COMPAT_TEXTURE(solarus_sampler, VARt7.xz);
                _F4 = vec3(float(_TMP19.x), float(_TMP19.y), float(_TMP19.z));
                _TMP20 = COMPAT_TEXTURE(solarus_sampler, VARt7.xw);
                _I4 = vec3(float(_TMP20.x), float(_TMP20.y), float(_TMP20.z));
                _TMP58 = dot(vec3(float(_B2.x), float(_B2.y), float(_B2.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0118.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_D.x), float(_D.y), float(_D.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0118.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_H.x), float(_H.y), float(_H.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0118.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_F.x), float(_F.y), float(_F.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0118.w = float(_TMP58);
                _b1 = vec4(float(_r0118.x), float(_r0118.y), float(_r0118.z), float(_r0118.w));
                _TMP58 = dot(vec3(float(_C.x), float(_C.y), float(_C.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0128.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_A2.x), float(_A2.y), float(_A2.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0128.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_G.x), float(_G.y), float(_G.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0128.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_I.x), float(_I.y), float(_I.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0128.w = float(_TMP58);
                _c1 = vec4(float(_r0128.x), float(_r0128.y), float(_r0128.z), float(_r0128.w));
                _TMP58 = dot(vec3(float(_E.x), float(_E.y), float(_E.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0138.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_E.x), float(_E.y), float(_E.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0138.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_E.x), float(_E.y), float(_E.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0138.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_E.x), float(_E.y), float(_E.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0138.w = float(_TMP58);
                _e1 = vec4(float(_r0138.x), float(_r0138.y), float(_r0138.z), float(_r0138.w));
                _TMP58 = dot(vec3(float(_I4.x), float(_I4.y), float(_I4.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0148.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_C1.x), float(_C1.y), float(_C1.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0148.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_A0.x), float(_A0.y), float(_A0.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0148.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_G5.x), float(_G5.y), float(_G5.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0148.w = float(_TMP58);
                _i4 = vec4(float(_r0148.x), float(_r0148.y), float(_r0148.z), float(_r0148.w));
                _TMP58 = dot(vec3(float(_I5.x), float(_I5.y), float(_I5.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0158.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_C4.x), float(_C4.y), float(_C4.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0158.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_A11.x), float(_A11.y), float(_A11.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0158.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_G0.x), float(_G0.y), float(_G0.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0158.w = float(_TMP58);
                _i5 = vec4(float(_r0158.x), float(_r0158.y), float(_r0158.z), float(_r0158.w));
                _TMP58 = dot(vec3(float(_H5.x), float(_H5.y), float(_H5.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0168.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_F4.x), float(_F4.y), float(_F4.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0168.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_B11.x), float(_B11.y), float(_B11.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0168.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_D0.x), float(_D0.y), float(_D0.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0168.w = float(_TMP58);
                _h5 = vec4(float(_r0168.x), float(_r0168.y), float(_r0168.z), float(_r0168.w));
                _fx = vec4( 1.00000000E+00, -1.00000000E+00, -1.00000000E+00, 1.00000000E+00)*_fp.y + vec4( 1.00000000E+00, 1.00000000E+00, -1.00000000E+00, -1.00000000E+00)*_fp.x;
                _fx_left = vec4( 1.00000000E+00, -1.00000000E+00, -1.00000000E+00, 1.00000000E+00)*_fp.y + vec4( 5.00000000E-01, 2.00000000E+00, -5.00000000E-01, -2.00000000E+00)*_fp.x;
                _fx_up = vec4( 1.00000000E+00, -1.00000000E+00, -1.00000000E+00, 1.00000000E+00)*_fp.y + vec4( 2.00000000E+00, 5.00000000E-01, -2.00000000E+00, -5.00000000E-01)*_fp.x;
                _a0182 = _b1.wxyz - _b1;
                _TMP179 = abs(_a0182);
                _TMP27 = bvec4(_TMP179.x < 1.50000000E+01, _TMP179.y < 1.50000000E+01, _TMP179.z < 1.50000000E+01, _TMP179.w < 1.50000000E+01);
                _a0188 = _b1.zwxy - _b1.yzwx;
                _TMP185 = abs(_a0188);
                _TMP28 = bvec4(_TMP185.x < 1.50000000E+01, _TMP185.y < 1.50000000E+01, _TMP185.z < 1.50000000E+01, _TMP185.w < 1.50000000E+01);
                _a0194 = _e1 - _c1.wxyz;
                _TMP191 = abs(_a0194);
                _TMP29 = bvec4(_TMP191.x < 1.50000000E+01, _TMP191.y < 1.50000000E+01, _TMP191.z < 1.50000000E+01, _TMP191.w < 1.50000000E+01);
                _a0200 = _b1.wxyz - _i4;
                _TMP197 = abs(_a0200);
                _TMP30 = bvec4(_TMP197.x < 1.50000000E+01, _TMP197.y < 1.50000000E+01, _TMP197.z < 1.50000000E+01, _TMP197.w < 1.50000000E+01);
                _a0206 = _b1.zwxy - _i5;
                _TMP203 = abs(_a0206);
                _TMP31 = bvec4(_TMP203.x < 1.50000000E+01, _TMP203.y < 1.50000000E+01, _TMP203.z < 1.50000000E+01, _TMP203.w < 1.50000000E+01);
                _a0212 = _e1 - _c1.zwxy;
                _TMP209 = abs(_a0212);
                _TMP32 = bvec4(_TMP209.x < 1.50000000E+01, _TMP209.y < 1.50000000E+01, _TMP209.z < 1.50000000E+01, _TMP209.w < 1.50000000E+01);
                _a0218 = _e1 - _c1;
                _TMP215 = abs(_a0218);
                _TMP33 = bvec4(_TMP215.x < 1.50000000E+01, _TMP215.y < 1.50000000E+01, _TMP215.z < 1.50000000E+01, _TMP215.w < 1.50000000E+01);
                _interp_restriction_lv1 = bvec4(_e1.x != _b1.w && _e1.x != _b1.z && (!_TMP27.x && !_TMP28.x || _TMP29.x && !_TMP30.x && !_TMP31.x || _TMP32.x || _TMP33.x), _e1.y != _b1.x && _e1.y != _b1.w && (!_TMP27.y && !_TMP28.y || _TMP29.y && !_TMP30.y && !_TMP31.y || _TMP32.y || _TMP33.y), _e1.z != _b1.y && _e1.z != _b1.x && (!_TMP27.z && !_TMP28.z || _TMP29.z && !_TMP30.z && !_TMP31.z || _TMP32.z || _TMP33.z), _e1.w != _b1.z && _e1.w != _b1.y && (!_TMP27.w && !_TMP28.w || _TMP29.w && !_TMP30.w && !_TMP31.w || _TMP32.w || _TMP33.w));
                _interp_restriction_lv2_left = bvec4(_e1.x != _c1.z && _b1.y != _c1.z, _e1.y != _c1.w && _b1.z != _c1.w, _e1.z != _c1.x && _b1.w != _c1.x, _e1.w != _c1.y && _b1.x != _c1.y);
                _interp_restriction_lv2_up = bvec4(_e1.x != _c1.x && _b1.x != _c1.x, _e1.y != _c1.y && _b1.y != _c1.y, _e1.z != _c1.z && _b1.z != _c1.z, _e1.w != _c1.w && _b1.w != _c1.w);
                _x0220 = ((_fx + vec4( 2.00000003E-01, 2.00000003E-01, 2.00000003E-01, 2.00000003E-01)) - vec4( 1.50000000E+00, 5.00000000E-01, -5.00000000E-01, 5.00000000E-01))/vec4( 4.00000006E-01, 4.00000006E-01, 4.00000006E-01, 4.00000006E-01);
                _TMP59 = min(vec4( 1.00000000E+00, 1.00000000E+00, 1.00000000E+00, 1.00000000E+00), _x0220);
                _TMP221 = max(vec4( 0.00000000E+00, 0.00000000E+00, 0.00000000E+00, 0.00000000E+00), _TMP59);
                _x0228 = ((_fx_left + vec4( 1.00000001E-01, 2.00000003E-01, 1.00000001E-01, 2.00000003E-01)) - vec4( 1.00000000E+00, 1.00000000E+00, -5.00000000E-01, 0.00000000E+00))/vec4( 2.00000003E-01, 4.00000006E-01, 2.00000003E-01, 4.00000006E-01);
                _TMP59 = min(vec4( 1.00000000E+00, 1.00000000E+00, 1.00000000E+00, 1.00000000E+00), _x0228);
                _TMP229 = max(vec4( 0.00000000E+00, 0.00000000E+00, 0.00000000E+00, 0.00000000E+00), _TMP59);
                _x0236 = ((_fx_up + vec4( 2.00000003E-01, 1.00000001E-01, 2.00000003E-01, 1.00000001E-01)) - vec4( 2.00000000E+00, 0.00000000E+00, -1.00000000E+00, 5.00000000E-01))/vec4( 4.00000006E-01, 2.00000003E-01, 4.00000006E-01, 2.00000003E-01);
                _TMP59 = min(vec4( 1.00000000E+00, 1.00000000E+00, 1.00000000E+00, 1.00000000E+00), _x0236);
                _TMP237 = max(vec4( 0.00000000E+00, 0.00000000E+00, 0.00000000E+00, 0.00000000E+00), _TMP59);
                _a0248 = _e1 - _c1;
                _TMP245 = abs(_a0248);
                _a0252 = _e1 - _c1.zwxy;
                _TMP249 = abs(_a0252);
                _a0256 = _c1.wxyz - _h5;
                _TMP253 = abs(_a0256);
                _a0260 = _c1.wxyz - _h5.yzwx;
                _TMP257 = abs(_a0260);
                _a0264 = _b1.zwxy - _b1.wxyz;
                _TMP261 = abs(_a0264);
                _TMP34 = _TMP245 + _TMP249 + _TMP253 + _TMP257 + 4.00000000E+00*_TMP261;
                _a0270 = _b1.zwxy - _b1.yzwx;
                _TMP267 = abs(_a0270);
                _a0274 = _b1.zwxy - _i5;
                _TMP271 = abs(_a0274);
                _a0278 = _b1.wxyz - _i4;
                _TMP275 = abs(_a0278);
                _a0282 = _b1.wxyz - _b1;
                _TMP279 = abs(_a0282);
                _a0286 = _e1 - _c1.wxyz;
                _TMP283 = abs(_a0286);
                _TMP35 = _TMP267 + _TMP271 + _TMP275 + _TMP279 + 4.00000000E+00*_TMP283;
                _edr = bvec4(_TMP34.x < _TMP35.x && _interp_restriction_lv1.x, _TMP34.y < _TMP35.y && _interp_restriction_lv1.y, _TMP34.z < _TMP35.z && _interp_restriction_lv1.z, _TMP34.w < _TMP35.w && _interp_restriction_lv1.w);
                _a0290 = _b1.wxyz - _c1.zwxy;
                _TMP287 = abs(_a0290);
                _a0294 = _b1.zwxy - _c1;
                _TMP291 = abs(_a0294);
                _edr_left = bvec4((2.00000000E+00*_TMP287).x <= _TMP291.x && _interp_restriction_lv2_left.x && _edr.x, (2.00000000E+00*_TMP287).y <= _TMP291.y && _interp_restriction_lv2_left.y && _edr.y, (2.00000000E+00*_TMP287).z <= _TMP291.z && _interp_restriction_lv2_left.z && _edr.z, (2.00000000E+00*_TMP287).w <= _TMP291.w && _interp_restriction_lv2_left.w && _edr.w);
                _a0298 = _b1.wxyz - _c1.zwxy;
                _TMP295 = abs(_a0298);
                _a0302 = _b1.zwxy - _c1;
                _TMP299 = abs(_a0302);
                _edr_up = bvec4(_TMP295.x >= (2.00000000E+00*_TMP299).x && _interp_restriction_lv2_up.x && _edr.x, _TMP295.y >= (2.00000000E+00*_TMP299).y && _interp_restriction_lv2_up.y && _edr.y, _TMP295.z >= (2.00000000E+00*_TMP299).z && _interp_restriction_lv2_up.z && _edr.z, _TMP295.w >= (2.00000000E+00*_TMP299).w && _interp_restriction_lv2_up.w && _edr.w);
                _fx45 = vec4(float(_edr.x), float(_edr.y), float(_edr.z), float(_edr.w))*_TMP221;
                _fx30 = vec4(float(_edr_left.x), float(_edr_left.y), float(_edr_left.z), float(_edr_left.w))*_TMP229;
                _fx60 = vec4(float(_edr_up.x), float(_edr_up.y), float(_edr_up.z), float(_edr_up.w))*_TMP237;
                _a0306 = _e1 - _b1.wxyz;
                _TMP303 = abs(_a0306);
                _a0310 = _e1 - _b1.zwxy;
                _TMP307 = abs(_a0310);
                _px = bvec4(_TMP303.x <= _TMP307.x, _TMP303.y <= _TMP307.y, _TMP303.z <= _TMP307.z, _TMP303.w <= _TMP307.w);
                _TMP42 = max(_fx30, _fx60);
                _maximo = max(_TMP42, _fx45);
                _t0316 = float(_px.x);
                _TMP43 = _H + _t0316*(_F - _H);
                _t0318 = float(_maximo.x);
                _TMP44 = _E + _t0318*(_TMP43 - _E);
                _t0320 = float(_px.y);
                _TMP45 = _F + _t0320*(_B2 - _F);
                _t0322 = float(_maximo.y);
                _TMP46 = _E + _t0322*(_TMP45 - _E);
                _t0324 = float(_px.z);
                _TMP47 = _B2 + _t0324*(_D - _B2);
                _t0326 = float(_maximo.z);
                _TMP48 = _E + _t0326*(_TMP47 - _E);
                _t0328 = float(_px.w);
                _TMP49 = _D + _t0328*(_H - _D);
                _t0330 = float(_maximo.w);
                _TMP50 = _E + _t0330*(_TMP49 - _E);
                _TMP58 = dot(vec3(float(_TMP44.x), float(_TMP44.y), float(_TMP44.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0332.x = float(_TMP58);
                _TMP58 = dot(vec3(float(_TMP46.x), float(_TMP46.y), float(_TMP46.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0332.y = float(_TMP58);
                _TMP58 = dot(vec3(float(_TMP48.x), float(_TMP48.y), float(_TMP48.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0332.z = float(_TMP58);
                _TMP58 = dot(vec3(float(_TMP50.x), float(_TMP50.y), float(_TMP50.z)), vec3( 1.43593750E+01, 2.81718750E+01, 5.47265625E+00));
                _r0332.w = float(_TMP58);
                _pixel = vec4(float(_r0332.x), float(_r0332.y), float(_r0332.z), float(_r0332.w));
                _a0344 = _pixel - _e1;
                _TMP341 = abs(_a0344);
                _res = _TMP44;
                _mx = _TMP341.x;
                if (_TMP341.y > _TMP341.x) { 
                    _res = _TMP46;
                    _mx = _TMP341.y;
                } 
                if (_TMP341.z > _mx) { 
                    _res = _TMP48;
                    _mx = _TMP341.z;
                } 
                if (_TMP341.w > _mx) { 
                    _res = _TMP50;
                } 
                _ret_0 = vec4(float(_res.x), float(_res.y), float(_res.z), 1.00000000E+00);
                FragColor = _ret_0;
            }
	]]
}
