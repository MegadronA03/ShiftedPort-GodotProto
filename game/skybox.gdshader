shader_type sky;
uniform samplerCube skyBox : filter_linear;
uniform vec3 offset;

void sky() {
	//vec3 aeye = abs(EYEDIR);
	//float meye = max(max(aeye.x,aeye.y),aeye.z);
	//vec3 oaeye = abs(EYEDIR) + ((1.0/offset) * meye);
	//float omeye = max(max(oaeye.x,oaeye.y),oaeye.z);
	
	//COLOR = vec3(omeye);
	//COLOR = texture(skyBox, (EYEDIR + offset * omeye)).rgb;
	COLOR = texture(skyBox, EYEDIR).rgb;
}
