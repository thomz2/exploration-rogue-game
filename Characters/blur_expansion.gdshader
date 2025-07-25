shader_type canvas_item;

uniform float radius = 1.0; // Raio da expansão
uniform float blur_size = 1.2; // quanto expande a aura
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 0.8); // Cor da sombra
uniform bool enable_blur = true;
uniform int samples = 32;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float alpha_sum = 0.0;
    float step_angle = 6.2831 / float(samples); // 2*PI

    // Expande a silhueta em todas as direções
    for (int i = 0; i < samples; i++) {
        float angle = step_angle * float(i);
        vec2 offset = vec2(cos(angle), sin(angle)) * blur_size * TEXTURE_PIXEL_SIZE;
        alpha_sum += texture(TEXTURE, UV + offset).a;
    }

    alpha_sum /= float(samples);

    vec4 tex = texture(TEXTURE, UV);

    // Combina a aura + sprite original
    COLOR = tex + vec4(color.rgb, color.a * (1.0 - tex.a) * alpha_sum);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
