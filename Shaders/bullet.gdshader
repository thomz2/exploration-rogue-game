shader_type canvas_item;

uniform bool white_override = false;
uniform float whiteness : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 white = vec4(1.0, 1.0, 1.0, tex_color.a);
	COLOR = mix(tex_color, white, whiteness);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
