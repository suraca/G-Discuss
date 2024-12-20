@tool
extends RichTextEffect
class_name RichTextWave

var bbcode:String="bwave"



func _process_custom_fx(char_fx):
	var speed = char_fx.env.get("speed",5.)
	var t = (char_fx.get_elapsed_time() + char_fx.relative_index) * speed
	char_fx.offset.y = sin(t)*2.
	
	return true
