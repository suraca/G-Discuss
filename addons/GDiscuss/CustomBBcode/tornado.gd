@tool
extends RichTextEffect
class_name RichTextTornado

var bbcode:String="tornado"



func _process_custom_fx(char_fx):
	var speed = char_fx.get("speed",10.)
	var t = char_fx.get_elapsed_time()*speed + PI
	var t2 = char_fx.get_elapsed_time()*speed
	char_fx.offset.y = sin(t)*2.
	char_fx.offset.x = sin(t2)*2.
	
	return false
