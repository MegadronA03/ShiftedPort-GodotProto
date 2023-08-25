shader_type sky;
uniform sampler3D noise: filter_linear;

void sky() {
	COLOR = vec3(0.0);
	float t = TIME*0.25;
	COLOR += texture(noise,EYEDIR.xyz+vec3(0.0,-t*0.015,0.0)).xyz*0.25;
	COLOR += texture(noise,EYEDIR.xyz*0.5+vec3(0.0,t*0.017,0.0)).xyz*0.25;
	COLOR += texture(noise,EYEDIR.xyz*0.25+vec3(0.0,-t*0.016,0.0)).xyz*0.25;
	COLOR += texture(noise,EYEDIR.xyz*0.125+vec3(0.0,t*0.03125,0.0)).xyz*0.25;
	//COLOR = pow(COLOR,vec3(4.0))*3.0;
	COLOR *= COLOR;
	COLOR *= COLOR;
	COLOR *= 3.0;
	COLOR.r = floor(COLOR.r*8.0)*0.14285714285714285714285714285714;
	COLOR.g = floor(COLOR.g*8.0)*0.14285714285714285714285714285714;
	COLOR.b = floor(COLOR.b*4.0)*0.33333333333333333333333333333333;
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
}
