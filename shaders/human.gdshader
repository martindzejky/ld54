shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);

    if (color.rgba == vec4(1.0)) {
        // only modulate the pure white color in the sprite
        color = modulate;
    }
    
    COLOR = color;
}
