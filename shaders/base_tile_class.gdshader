shader_type canvas_item;

uniform float blue = 1.0; // you can assign a default value to uniforms

void vertex() {
	// Called for every vertex the material is visible on.
	  //VERTEX += vec2(cos(TIME)*100.0, sin(TIME)*100.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = vec4(0.4, 0.6, 0.9, 1.0);

	//COLOR = vec4(UV, 0.5, 1.0);

	//COLOR.b = 1.0;

	//COLOR = texture(TEXTURE, UV); // Read from texture
	//COLOR.b = blue;


	//float mult = 5.0;
	//float cicleOverTime = abs(sin(TIME * mult));
	//float circleWithOffset = abs(sin((TIME + 1.0) * (mult + 5.0)));
	//float circleWithOffset1 = abs(sin((TIME + 2.0) * (mult + 10.0)));
//
	//COLOR = vec4(cicleOverTime,circleWithOffset,circleWithOffset,1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
