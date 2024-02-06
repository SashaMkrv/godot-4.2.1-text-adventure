class_name DrawMap
extends GraphEdit

@export var connections: RoomConnections : set = connectionsSet
@export var roomNodeScene: PackedScene

var currentRoomsSet : Array[Room]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateNodes(connections, null)

func connectionsSet(newData: RoomConnections) -> void:
	if not is_node_ready():
		connections = newData
		return
	else:
		updateNodes(newData, connections)
		connections = newData


func updateNodes(newData: RoomConnections, oldData: RoomConnections) -> void:
	if newData == null:
		clearView()
		currentRoomsSet = []
		return
	
	if oldData == null:
		currentRoomsSet = getRoomsFromConnections(newData)
		updateNodesBasedOn(currentRoomsSet)
		return
	
	else:
		currentRoomsSet = getRoomsFromConnections(newData)
		updateNodesBasedOn(currentRoomsSet)
		return


func getRoomsFromConnections(connectionData: RoomConnections) -> Array[Room]:
	var rooms : Array[Room] = []
	for connection in connectionData.connections:
		var fromRoom := connection.fromRoom
		var toRoom := connection.toRoom
		if not fromRoom in rooms:
			rooms.append(fromRoom)
		if not toRoom in rooms:
			rooms.append(toRoom)
	return rooms


func clearView() -> void:
	for child in getRoomNodes():
		child.queue_free()


func getRoomNodes() -> Array[RoomNode]:
	var unassignedResults := get_children()\
	.map(func(node: Node) -> RoomNode: return node as RoomNode)\
	.filter(func(node: RoomNode) -> bool: return node != null)

	var results : Array[RoomNode]
	# TODO the assign func doesn't count as assigning :S
	results.assign(unassignedResults)
	return results


func updateNodesBasedOn(newRooms: Array[Room]) -> void:
	var roomNodes := getRoomNodes()
	var deletables : Array[Node] = []

	for node in roomNodes:
		if not node.roomData in newRooms:
			deletables.append(node)

	for deletable in deletables:
		deletable.queue_free()
	
	# make another call to get the kids because i theoretically just killed a bunch
	# not sure if the almost ghosts are keen to give up info...
	# TODO this is something i should know about the node lifecycle.
	var mappedRooms := getRoomNodes().map(func(node: RoomNode) -> Room: return node.roomData)

	for room in newRooms:
		if not room in mappedRooms:
			var newNode := createNewRoomNodeFor(room)
			add_child(newNode)


func createNewRoomNodeFor(room: Room) -> RoomNode:
	var newRoom := roomNodeScene.instantiate() as RoomNode
	newRoom.roomData = room

	return newRoom