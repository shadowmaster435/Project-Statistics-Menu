@tool
extends Control

var extends_tree

func _ready():
	for child in get_children():
		child.queue_free()
	var tr = ExtendsTree.new()
	add_child(tr)
	extends_tree = tr
	#extends_tree.size = size

func _process(delta):
	extends_tree.set_size.call_deferred(size)
	pass

class ExtendsTree extends GraphEdit:

	var current_height = 0
	var current_width = 0

	var nodes = {}
	var multibranches = {}
	var extension_depths = {}
	
	func generate():
		multibranches.clear()
		nodes.clear()
		current_height = 0
		current_width = 0
		var ext = StatCollectorGlobals.class_extensions
		
		for child in get_children():
			child.queue_free()
			
		for entry_key in ext:
			var node = TreeNode.new()
			node.text = entry_key
			add_child(node)
			nodes[entry_key] = node
			node.size = Vector2(32, 32)
			
		var node_depths = {}
		
		for entry_key in ext:
			make_node(entry_key)  
			var depth = get_extends_depth(entry_key)
			if node_depths.has(depth):
				node_depths[depth].append(entry_key)
			else: 
				node_depths[depth] = [entry_key]
		
		for depth_index in node_depths:
			var entry = node_depths[depth_index]
			for node_name_index in entry.size():
				var node_name = entry[node_name_index] 
				var node = nodes[node_name]
				var offset_leng = 512
				var odd_offest = 0 if entry.size() % 2 == 1 else offset_leng / 2 
				node.position_offset = Vector2(((offset_leng * node_name_index) + odd_offest) - (max(entry.size() - 1, 0) * offset_leng / 2),depth_index * 256)
	
	func get_extends_depth(scr_name: String, current_depth: int = 0):
		var depth = 0
		var current_child = get_child_script(scr_name)
		if current_child == null:  
			return current_depth
		else:    
			depth = get_extends_depth(get_child_name(scr_name), current_depth + 1)
		return depth
	
	func get_child_script(scr_name: String):  
		return multibranches.get(scr_name, [null, null])[1]
	func get_child_name(scr_name: String): 
		return StatCollectorGlobals.class_extensions.get(scr_name, [null])[0]
	func is_base_type(scr: Script, entry_name):
		return scr.get_instance_base_type() == entry_name
	
	func make_node(entry_key: String, current_h_ofs : int = 0):
		var ext = StatCollectorGlobals.class_extensions
		var entry = ext[entry_key]
		var extended = entry[0]
		var scr = load(entry[1]) as Script 
		
		var node = nodes[entry_key]
		var added_h = 0
		var first_arr = false
		if extended != scr.get_instance_base_type():
			if not first_arr: 
				multibranches[entry_key] = [null, null, null] 
				multibranches[entry_key][0] = [node]
				first_arr = false
			else:   
				multibranches[entry_key][0].append(node)
			multibranches[entry_key][1] = scr 
			multibranches[entry_key][2] = extended
		if extended != scr.get_instance_base_type():
			if extended != "null":
				make_node(extended, added_h)
				node.connected.append(nodes[extended])
			else:
				node.connected.append(nodes[entry_key])
	 
	func _process(delta):
		if Input.is_action_just_pressed("ui_accept"):
			generate()


class TreeNode extends GraphElement:

	var connected : Array[TreeNode] = []
	var text = ""
	var color : Color = Color(0,0,0,1)
	var text_color : Color = Color(1,1,1,1)
	var label : Label
	const size_scalar = 4


	func _draw():
		
		for node in connected:
			var line_scalar = (scale.x / get_parent().zoom)
			draw_line(Vector2.ZERO, ((node.position - position) / get_parent().zoom) / size_scalar, color, 16 / line_scalar)
		draw_rect(Rect2((label.size / -2) - Vector2(4, 4), label.size + Vector2(4, 4)), color)
		
		pass
	func _init():
		var label = Label.new()
		add_child(label)
		self.label = label
		#label.size.x = 4
		#label.size.y = 4
	

	func _process(delta):
		var scalar = 4
	
		scale = Vector2(size_scalar, size_scalar) * get_parent().zoom 
		label.position.x = label.size.x / -2
		label.position.y = label.size.y / -2
		label.z_index = z_index + 1
		label.text = text
		label.modulate = text_color
		queue_redraw()
