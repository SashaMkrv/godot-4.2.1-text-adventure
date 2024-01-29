class_name TransformText
extends Node

# process game text and return bbcode-ified text for use in game labels. 
func transformText(text: String) -> String:
	
	# if we don't, we can replace them close brackets dumb style.
	# would wind up catching the close brackets from the bbcode as well.
	var newText := text.replace("]", ">") \
	.replace("[", "[b][color=yellow]") \
	.replace(">", "[/color][/b]")
	
	print_debug(newText)
	return newText
