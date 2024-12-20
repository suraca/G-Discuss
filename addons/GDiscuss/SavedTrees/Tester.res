RSRC                 	   Resource            ��������   DialogueFile                                                   resource_local_to_scene    resource_name    script    code       Script    res://GDiscuss/DialogueFile.gd ��������      local://Resource_f7jcx       	   Resource                       ?  //To read the docs, load the dialogue file called "docs"

//path is a path where flags and values are stored (In an array called FLAGS in this global script)
path main_path "Node2D"
val testint "testint"

standin name main_path currentName

def speechOne(
// Name, state
STATE Steven 2 Right
TEXT "Hello [name]"
STOP "next"
TEXT "Good to see you"
options
	"Hello Sue" :  UNC
		GOTO speechTwo() // GOTO initiates the next dialogue in the sequence
	"You killed Steve" :  FLAG main_path "Evidence1" OR FLAG main_path "Evidence2"
		ADDFLAG main_path "an_added_flag" GOTO speechThree()
)

def speechTwo(
STATE Steven 2 LEFT
TEXT "Bye Steve"
options
	"Bye, Sue" :  UNC
		END
)

def speechThree(
STATE Steven 2 Right
TEXT [font_size=50][shake]"You know?!?!"
options
	"Yes" :  UNC
		END
	"Value  > 5" : VALUE main_path testint > 4
		END
) RSRC