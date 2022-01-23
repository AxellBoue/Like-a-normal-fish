    shader_type canvas_item;
	
	uniform float contrast : hint_range(0.5, 8);
	uniform float hue_modif : hint_range(0, 360);
	
	vec3 applyHue(vec3 aColor, float aHue)
{
    float angle = radians(aHue);
    vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(angle);
    //Rodrigues' rotation formula
    return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1.0 - cosAngle);
}
	
    void fragment() {
        // recup texture écran
		vec3 screen_pixel = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
		vec4 c = vec4(screen_pixel.rgb,1);
		// apply contrast
		c.rgb = (c.rgb - 0.5f) * (contrast) + 0.5f;
		// apply hue
		c.rgb = applyHue(c.rgb,hue_modif);
		// affiche le resultat
        COLOR = c;
    }