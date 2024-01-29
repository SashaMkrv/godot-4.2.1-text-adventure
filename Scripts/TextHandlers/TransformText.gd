class_name TransformText
extends Node

# process game text and return bbcode-ified text for use in game labels. 
func transformText(text: String) -> String:
	# Consider using regex to grab the contents of the brackets to chuck into meta tags
	var newText = String(text)
	
	# if we don't, we can replace them close brackets dumb style.
	# would wind up catching the close brackets from the bbcode as well.
	newText = newText.replace("]", ">")
	
	
	newText = newText.replace("[", "[b][color=yellow]")
	newText = newText.replace(">", "[/color][/b]")
	
	print_debug(newText)
	return newText
