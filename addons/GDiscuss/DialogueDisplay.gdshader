shader_type canvas_item;


void fragment() {
	float v = sin(UV.x*PI) * sin(UV.y*PI);
	
	v +=.48;
	v = (v-.5)*150. +.5;
	COLOR.a *=v;
	
}
