extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func gen_cloud_node_from_text(node_name: String, searcher_text: String, text: String):
	var node = CloudNode.new()
	node.text = node_name
	pass

func get_script_ref_count(script: GDScript):
	var functions = script.get_reference_count()


func search_call_functions(searcher_text: String, text: String):
	pass

#region Classes
class TextReferenceCloud extends GraphEdit:


	var nodes = {}
	var gen = false



	func gen_node_cloud():
		for node_name in nodes:
			nodes[node_name].queue_free()
		nodes.clear()
		for i in 10:
			var node = CloudNode.new()
			var pos = (Vector2.from_angle(deg_to_rad(360 * (i / 10.0)))) * 512
			node.position_offset = pos
			add_child(node)
			nodes[i] = node
		for node_i in nodes:
			var node = nodes[node_i] as CloudNode
			for i in 3:
				var r = randf()
				
				if r < 0.25:
					var rand = randi_range(0, 9)
					while rand == node_i:
						rand = randi_range(0, 9)
					node.connected.append(nodes[rand])
			node.color = Color(randf(), randf(), 0)
			node.text = str(node_i)
				

	func _ready():
		gen = true

	func _process(delta):
		if gen or Input.is_action_just_pressed("ui_accept"):
			gen_node_cloud()
			gen = false


class CloudNode extends GraphElement:


	var connected : Array[CloudNode] = []
	var text = ""
	var color : Color = Color(0,0,0,1)
	var text_color : Color = Color(1,1,1,1)
	var label : Label
	const size_scalar = 1


	func _draw():
		for node in connected:
			var line_scalar = (scale.x / get_parent().zoom)
			draw_line(Vector2.ZERO, ((node.position - position) / get_parent().zoom) / (max(connected.size() * size_scalar, 1.0)), color, 4 / line_scalar)
		draw_circle(Vector2.ZERO, 64, color)
		
	func _ready():
		var label = Label.new()
		add_child(label)
		self.label = label

	func _process(delta):
		var scalar = max(connected.size() * size_scalar, 1.0)
		scale = Vector2(scalar, scalar) * get_parent().zoom 
		label.position.x = label.size.x / -2
		label.position.y = label.size.y / -2
		label.z_index = z_index + 1
		label.text = text
		label.modulate = text_color
		queue_redraw()
#endregion
