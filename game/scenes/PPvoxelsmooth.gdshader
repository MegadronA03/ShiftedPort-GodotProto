shader_type spatial;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform sampler2D SNORMAL_TEXTURE : hint_normal_roughness_texture, filter_nearest_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_nearest_mipmap;

void vertex() {
	POSITION = vec4(UV*2.0-1.0, 0.0, 1.0);
	
}

const float[8] BlurWeights = { 1.0/2.0, 1.0/4.0, 1.0/8.0, 1.0/16.0, 1.0/32.0, 1.0/64.0, 1.0/128.0, 1.0/256.0 };

void fragment() {
	vec3 r = vec3(0.0);
	for (int i = 0; i < 7; ++i) {
		r += textureLod(SCREEN_TEXTURE, SCREEN_UV, float(i)).xyz * BlurWeights[i];
	}
	ALBEDO = r;
	//ALBEDO = textureLod(SCREEN_TEXTURE, SCREEN_UV, ).xyz;//*texture(DEPTH_TEXTURE, SCREEN_UV).x;
	//NORMAL_MAP = textureLod(SNORMAL_TEXTURE, SCREEN_UV, 0).xyz;
	//ALBEDO = vec3(UV, 0.0);
}
