@tool
extends RichTextEffect
class_name RichTextShake

var bbcode:String="bshake"


func _process_custom_fx(char_fx):
	var scaling = char_fx.env.get("size",1.)
	#var scaling := .1
	char_fx.elapsed_time
	char_fx.offset.y = randf_range(-1,1)*scaling
	char_fx.offset.x = randf_range(-1,1)*scaling
	
	return true

#
#
#
