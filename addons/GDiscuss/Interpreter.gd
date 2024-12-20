class_name GDiscussInterpreter extends Node

@export var parentOfDialouge:NodePath
var pointers:Dictionary={}
var replace:Dictionary={}
var index:int = 0
signal next
var display
var talker:String=""
var looks:int= 0
var side:String
var shader:String=""
var fileType:String=""

var themeLocation:String="res://"

signal done
signal dialog_signal

func start(file:DialogueFile,parent = null):
	dialog_signal.connect(get_parent().emit_signal.bind("dialog_signal"))
	display = preload("res://addons/GDiscuss/DialogueDisplay.tscn").instantiate()
	if parent:parent.add_child(display)
	else:get_node(parentOfDialouge).add_child(display)
	index = 0
	clear()
	if file:
		execute(compile(file.code.replace("\t","").split("\n")))
		return true
	return false

func start_code(CODE:String="",parent = null):
	dialog_signal.connect(get_parent().emit_signal.bind("dialog_signal"))
	display = preload("res://addons/GDiscuss/DialogueDisplay.tscn").instantiate()
	if parent:parent.add_child(display)
	else:get_node(parentOfDialouge).add_child(display)
	index = 0
	clear()
	execute(compile(CODE.replace("\t","").split("\n")))

func compile(text:Array)->Array:
	pointers={}
	var temp:Array=[]
	for i in text:
		var a = removeComments(i)
		if a!="":temp.append(a)
	for i in len(temp):
		var ins = temp[i].split(" ",false)
		var keyWord = ins[0]
		if keyWord == "def":
			pointers[ins[1]+")"] = i
		elif keyWord == "val" or keyWord == "var":
			var x = ins
			pointers[x[1]] = x[2].replace("\"","")
		elif keyWord == "path":
			var x = ins
			pointers[x[1]] = x[2].replace("\"","")
			
		elif keyWord == "standin":
			replace[ins[1]] = [ins[2],ins[3]]
	#logg(str(pointers).replace(",","\n")+"\n\n")
	return temp

func execute(temp:Array):
	var temps:String=""
	var state:String = ""
	var currentSpokenText:String = ""
	index= 0
	var optionMet:bool=false
	while index < len(temp):
		if index>=len(temp) or index <0:break
		var i = temp[index]
		var data :Array= i.split(" ",false)
		if len(data)==0:continue
		var keyWord = data[0]
		index+=1
		match state:
			"":
				if keyWord == "def":
					state = "def"
			"def":
				match keyWord:
					"TEXT":
						var t:String=""
						for l in len(data)-1:
							t+=data[l+1]+" "
						currentSpokenText = t.replace("\"","")
						renderText(currentSpokenText)
					"options":
						state = "OPTIONS"
						optionMet = false
					"STATE":
						talker = data[1]
						looks= data[2].to_int()
						if len(data) > 3:side = data[3]
						else:side = "r"
						if len(data) > 4:shader = data[4]
						else: shader=""
						if len(data) > 5:fileType = data[5]
						else: fileType="png"
					"THEME":
						if len(data) > 1:display.theme = load(themeLocation+data[1]+".tres")
						else:display.theme = null
					"STOP":
						renderButton(data[1].replace("\"","")+" ",[])
						await next
				
			"OPTIONS":
					
				if keyWord == ")":
					state = ""
					await next
					#continue
				var tempInt:Array=[]
				for t in data:
					tempInt.append(t.replace("\"",""))
				
				if keyWord[0]=="\"":
					var arrInd:int = 0
					var arr1:=""
					var arr2:=[]
					for o in tempInt:
						if o==":":arrInd=1
						if arrInd==0:arr1+=str(o)+" "
						else:if o!=":":arr2.append(o)
					# Seems to all work
					var success:bool = false
					if len(arr2) == 0 or arr2[0]=="UNC":
						success = true
					elif arr2[0] == "ELSE" and !optionMet:
						success = true
					if len(arr2) == 0:
						pass
					elif arr2[0] != "ELSE" and len(arr2)>1:
						var operator=null
						var previousSuccess:bool=false
						var ignoreOp:bool = false
						for o in len(arr2):
							## SYNC
							if arr2[o] in ["OR","AND","NAND","XOR","NOR","=","==",">",">=","<","<=","RAND","!="]:
								if!ignoreOp:
									operator = arr2[o]
									continue
								else:
									ignoreOp = false
							var c = false
							match arr2[o]:
								"FLAG":
									c = arr2[o+2] in get_tree().root.get_node(pointers[arr2[o+1]]).Flags
								"VALUE":
									var tempOp = arr2[o+3]
									var val2 = value(arr2[o+4])
									temp[index+o+3] = "placeHolder_usedToBeOperator_FromVALUE"
									var val = get_tree().root.get_node(pointers[arr2[o+1]]).get(pointers[arr2[o+2]])
									ignoreOp = true
									c = operatorFunc(tempOp,val,val2)
								"TRUEVALUE":
									var tempOp = arr2[o+1]
									var val2 = value(tempOp)
									c = val2
								_:
									c = value(arr2[o])
									if c == null:continue
							print("Option %s\nCycle %s, c == %s"%[str(arr2[0]),str(o),str(c)])
							if !operator:
								previousSuccess = c
							else:
								previousSuccess = operatorFunc(operator,previousSuccess,c)
								operator = null
							
						success = previousSuccess
					if success:
						optionMet = true
						renderButton(arr1,temp[index].split(" "))
						continue
			_:
				logg("----------------NO INSTRUCTION MATCH?!?!?----------------")
	display.previousButton = null
	end()


func end():
	if is_instance_valid(display):
		display.queue_free()
	clear()
	emit_signal("done")
	#logg("ENDED")

func removeComments(text:String)->String:
	if "//" in text:return text.split("//",true)[0]
	return text


func operatorFunc(op:String,val1,val2):
	if op == "OR":return val1 or val2
	elif op == "AND":return val1 and val2
	elif op == "NAND":return !(val1 and val2)
	elif op == "XOR":return (val1 != val2) and (val1 or val2)
	if op == "NOR":return !(val1 or val2)
	#elif op == "NOT":return (val1 != val2)
	elif op == ">":return val1 > val2
	elif op == "<":return val1 < val2
	elif op == "<=":return val1 <= val2
	elif op == ">=":return val1 >= val2
	elif op == "=":return val1 == val2
	elif op == "==":return val1 == val2
	elif op == "!=":return val1 != val2
	elif op == "RAND":return [val1,val2].pick_random()
	return false

func value(valuename:String,path:String=""):
	match valuename:
		"UNC":return true
		"TRUE":return true
		"true":return true
		"FALSE":return false
		"false":return false
	if valuename.is_valid_float():return valuename.to_float()
	if valuename.is_valid_int():return valuename.to_int()
	if path!="":
		if valuename in pointers:
			return get_tree().root.get_node(pointers[path]).get(pointers[valuename])
		return get_tree().root.get_node(pointers[path]).get(valuename)
	return null

func clear():
	pass
func logg(text):
	print(text)


func renderButton(text:String,goal:Array):
	var b := preload("res://addons/GDiscuss/new_button.tscn").instantiate()
	## Check for crash and a change to improve BBCode compatibility
	for i in replace:
		if value(replace[i][1],replace[i][0]):
			text = text.replace("{"+i+"}",value(replace[i][1],replace[i][0]))
	b.setText("[center]"+text)
	b.pressed.connect(press.bind(goal))
	display.ac(b)
	b.visible = true
	return b

func press(goal:Array):
	if is_instance_valid(display):
		display.clear()
		display.previousButton = null
	
	var ta:Array=[]
	for i in goal:
		ta.append(i.replace("\"",""))
	for i in len(ta):
		match ta[i]:
			"ADDFLAG":
				addFlag(ta[i+1],ta[i+2])
			"SUBFLAG":
				subFlag(ta[i+1],ta[i+2])
			"GOTO":
				index = pointers[ta[i+1]]
				#logg(temp)
			"END":
				index = 500000
				continue
			"SET":
				var v = value(ta[i+3])
				setValue([ta[i+1],ta[i+2]],v)
			"ADD":
				var v = value(ta[i+2],ta[i+1]) + value(ta[i+3])
				setValue([ta[1],ta[2]],v)
			"SUB":
				var v = value(ta[i+2],ta[i+1]) - value(ta[i+3])
				setValue([ta[1],ta[2]],v)
			"MUL":
				var v = value(ta[i+2],ta[i+1]) * value(ta[i+3])
				setValue([ta[1],ta[2]],v)
			"DIV":
				var v = 0.
				if value(ta[i+3]) != 0:
					v = value(ta[i+2],ta[i+1]) / value(ta[i+3])
				setValue([ta[1],ta[2]],v)
			"SIGNAL":
				emit_signal("dialog_signal")

	emit_signal("next")

func renderText(currentSpokenText:String):
	# changed from "[]" to "{}" for compatibility with BBCode
	for i in replace:
		# Catch crashes
		if value(replace[i][1],replace[i][0]):
			currentSpokenText = currentSpokenText.replace("{"+i+"}",value(replace[i][1],replace[i][0]))
	var ar:Array = currentSpokenText.split("[br]")
	var tempText:String=""
	currentSpokenText = currentSpokenText.replace("[br]","\n")
	display.setText(currentSpokenText)
	display.start()
	display.getImage(talker,looks,side,shader,fileType)

func addFlag(info:String,Flag:String):
	var f = get_tree().root.get_node(pointers[info])
	if "Flags" in f.get_property_list(): # This line fixes a possible crash when trying to get/set a flag on the wrong node
		if!Flag in f.Flags:f.Flags.append(Flag)

func subFlag(info:String,Flag:String):
	var f = get_tree().root.get_node(pointers[info])
	while Flag in f.Flags:f.Flags.erase(Flag)

func setValue(info:Array,value):
	get_tree().root.get_node(pointers[info[0]]).set(info[1],value)
