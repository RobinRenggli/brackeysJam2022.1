shader_type canvas_item;

void fragment() {
	
	float uv_height = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 reflected_screenuv = vec2(SCREEN_UV.x, SCREEN_UV.y - uv_height);
	
	COLOR = texture(SCREEN_TEXTURE, reflected_screenuv);
}