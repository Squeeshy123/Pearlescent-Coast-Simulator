shader_type canvas_item;

void fragment(){
	COLOR.rgb = vec3(TIME * sin(sqrt(pow(UV.r - 0.5, 2) + pow(UV.g-0.5, 2))));
}