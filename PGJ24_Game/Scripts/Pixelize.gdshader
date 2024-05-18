shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
const int PixelSize = 4;

void fragment() {
	float x = float(int(FRAGCOORD.x) % PixelSize);
	float y = float(int(FRAGCOORD.y) % PixelSize);
	
	x = FRAGCOORD.x + floor(float(PixelSize) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(PixelSize) / 2.0) - y;
	
	ALBEDO = texture(SCREEN_TEXTURE, vec2(x,y) / VIEWPORT_SIZE).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
