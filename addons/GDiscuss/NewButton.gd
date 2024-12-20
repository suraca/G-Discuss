extends Button
func setText(text:String):%Label.text=text
var focused:bool=true
#func _on_focus_entered():focused=true
#func _on_focus_exited():focused=false
#func _physics_process(delta):if focused:if Input.is_action_just_pressed("ui_accept"):emit_signal("pressed")
