shader_type spatial;
//render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
//render_mode unshaded;
//uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_nearest_mipmap;
//uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear;
//varying float clen;

void vertex() {
	UV = (UV - 0.5) * 2.0;
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	if (length(UV) > 1.0) discard;
	ALBEDO = vec3(1.0);
	//float sdepth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	//sdepth = sdepth * 2.0 - 1.0;
	//sdepth = PROJECTION_MATRIX[3][2] / (sdepth + PROJECTION_MATRIX[2][2]);
	//sdepth += (VERTEX.z * 0.5);
	//sdepth *= 0.125;
	//ALBEDO = vec3(sdepth);
	//ALBEDO = vec3(SCREEN_UV.xy, 0.0);
	//ALBEDO = vec3(UV,1.0);
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	vec2 uvmp;
	uvmp.x = UV.x;
	uvmp.y = -UV.y;
	uvmp = ((uvmp)*0.5)+0.5;
	float clen = length(UV);
	float ndepth = -sqrt(1.0-clen*clen)*0.5;
	vec3 nnmp = vec3(uvmp, 0.5-(ndepth));
	NORMAL_MAP = nnmp;
	//ALBEDO = nnmp;
	ndepth += -VERTEX.z;
	DEPTH = (PROJECTION_MATRIX[3][2] - PROJECTION_MATRIX[2][2] * ndepth) / ndepth;
}