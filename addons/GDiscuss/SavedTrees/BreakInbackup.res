RSRC                 	   Resource            ��������   DialogueFile                                                   resource_local_to_scene    resource_name    script    code       Script    res://GDiscuss/DialogueFile.gd ��������      local://Resource_4l0cp       	   Resource                       X  path global "GlobalInfo"

standin name global currentName

def start0(
STATE TheDirector 2 RIGHT
TEXT "Here we can see the[wave] stunning[/wave] beuty of the painting in question. Before we interrogate it's every meaning, I would first like to invite you all to apreciate the pure skill this piece took."
options
	"Next" :  UNC
		SIGNAL GOTO start1()
)
def start1(
STATE TheDirector 1 RIGHT
TEXT "The brush strokes provide intricate details, and give a texture and movement to the painting that was completely unique when it was first created."
options
	"Next" :  UNC
		GOTO start2()
)
def start2(
STATE TheDirector 1 RIGHT
TEXT "Entitled: 'The self recursive', this painting was the artist's rendition of their own mind. Chaotic, but beutiful, the metaphores and imigery have been thoroughly studied by all but a few artists in the continent."
options
	"Next" :  UNC
		GOTO start3()
)
def start3(
STATE TheDirector 2 RIGHT
TEXT "But, the reason why you are all here: The secret in the painting. We all know that Arpegius enjoyed puzzles, and was an acclaimed puzzler in their spare time."
options
	"Next" :  UNC
		SIGNAL GOTO start4()
)
def start4(
STATE TheDirector 2 RIGHT
TEXT "So what do we know? We know that the artist claimed this was their magnum opus of both art and puzzles. We know that the answer should be in nothing but the painting. Unfortunatly. That's it."
options
	"Next" :  UNC
		GOTO Julie1()
)
def Julie1(
STATE Icon 0 LEFT "Null" svg
THEME julieTheme
TEXT "So that's it? We just have to look at the painting?"
options
	"Next" :  UNC
		GOTO Julie2() 
)
def Julie2(
STATE TheDirector 0 RIGHT
THEME
TEXT "I'm afraid so."
options
	"Next" :  UNC
		GOTO Julie3() 
)
def Julie3(
STATE Icon 0 LEFT "Null" svg
THEME julieTheme
TEXT "[font_size=60][wave]Great! Let's do it![/wave][/font_size][br][font_size=25]Come on [name]!"
options
	"Let's go!" :  UNC
		END
)



 RSRC