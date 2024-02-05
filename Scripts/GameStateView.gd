class_name GameStateView
extends RefCounted

var header: String
var headerExtra: String
var description: String
var inventory: String
var prompt: String

# TODO bother to actually factory this up

func setHeader(header_: String) -> GameStateView:
    header = header_
    return self


func setHeaderExtra(headerExtra_: String) -> GameStateView:
    headerExtra = headerExtra_
    return self


func setDescription(description_: String) -> GameStateView:
    description = description_
    return self


func setInventory(inventory_: String) -> GameStateView:
    inventory = inventory_
    return self


func setPrompt(prompt_: String) -> GameStateView:
    prompt = prompt_
    return self