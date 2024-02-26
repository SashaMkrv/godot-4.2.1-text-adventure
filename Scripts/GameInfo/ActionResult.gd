extends Resource

# oh no, wait this can result in a circular dep as well.
# object w actionresult w replace self with otherobject w actionresult replacing self with object

# plus this is treading further into OOP with bad hassle for flavour. chucking all the story prog logic as far down as possible actually sounds not great? but hwo to birng it further up :( I miss components. well. w/o needing to impl them myself.

@export var actionType := &"LOOK"

@export var replaceSelf := false
@export var replaceSelfWith : Array[GameObject]

@export var resultDescription : String

