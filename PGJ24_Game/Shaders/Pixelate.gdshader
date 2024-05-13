shader_type canvas_item;

uniform float pixelSize : hint_range(2, 16, 2) = 4;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec2 iRes = 1.0 / SCREEN_PIXEL_SIZE;
	
	float OnePixelSizeX = 1.0 / iRes.x;
	float OnePixelSizeY = 1.0 / iRes.y;
	
	float cellSizeX = float(pixelSize) * OnePixelSizeX;
	float cellSizeY = float(pixelSize) * OnePixelSizeY;
	
	float x = cellSizeX + floor(UV.x / cellSizeX);
	float y = cellSizeY + floor(UV.y / cellSizeY);
	
	COLOR = texture(SCREEN_TEXTURE, vec2(x,y));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
