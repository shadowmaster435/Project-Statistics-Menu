@tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print()
	#print(b.replace("\n", ""))
	#var a2 = a
	#var res = ""
	#
	#a2 = a.replace(" ", "")
	#for cha in (a2.length()):
		#if cha % 3 == 0:
			#res = res + " " + a2[cha]
		#else:
			#res = res + a2[cha]
	#print(res)
	#a = a.replace("  ", " ")
	#var split = a.split(" ")
#
	#var not3 = false
	#for f in split:
		#if f.length() == 0:
			#continue
		#print(f.length())
		#if fmod(f.length(), 3) != 0:
			#not3 = true
			#break



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func to_line_array(string: String):
	return string.replace("\t", "").split("\n")

func line_has_new(searcher: String, text: String):
	return text.contains("new ") and text.contains(searcher)

func isolate_function_text(script_string: String):
	var split_funcs = script_string.split("func")
	for segment in split_funcs:
		pass
	pass
	
	
func isolate_out_of_func_vars(script: GDScript):
	var prop = script.get_script_property_list()
	print(prop)
	pass
