    shader_type canvas_item;
	
	// couleur produit
	uniform vec4 modif_color : hint_color;
	uniform vec4 blanc : hint_color;
	uniform float intensity : hint_range(0, 1);
	// niveaux
	uniform float inWhite : hint_range(0, 1);
	
    void fragment() {
        // recup texture écran
		vec3 screen_pixel = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
		vec4 c = vec4(screen_pixel.rgb,1);
		// applique couleur avec intensie
		vec4 m = mix(blanc,modif_color,intensity);
		c.r = clamp(c.r * m.r,0,1);
		c.g = clamp(c.g * m.g,0,1);
		c.b = clamp(c.b * m.b,0,1);
		// applique niveaux
		float new_inwhite = mix(1,inWhite,intensity);
		c.r = (pow(c.r * 255.0 / new_inwhite, 1.0) ) / 255.0;
		c.g = (pow(c.g * 255.0 / new_inwhite, 1.0) ) / 255.0;
		c.b = (pow(c.b * 255.0 / new_inwhite, 1.0) ) / 255.0;
		// applque resultat
        COLOR = c;
    }