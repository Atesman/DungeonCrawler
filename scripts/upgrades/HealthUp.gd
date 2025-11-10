extends Upgrade

const UPGRADE_TYPE := Type.INSTANT

var health_amount: int


func _init(character: Node, _name: String, init_data: Array = []):
	super(character, _name, init_data)
	upgrade_type = UPGRADE_TYPE


func _handle_init_data(data: Array):
	health_amount = data[0]


func _connect_signals():
	pass


func fire():
	upgrade_owner.change_max_hp(health_amount)
	upgrade_owner.heal(health_amount)
	#add to list of obtained upgrades