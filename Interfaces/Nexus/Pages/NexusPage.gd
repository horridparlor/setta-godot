extends Node2D
class_name NexusPage

var nexus_page : NexusEnums.NexusPage;
var is_active : bool;

func init(page : NexusEnums.NexusPage, random : RandomNumberGenerator) -> void:
	nexus_page = page;
	initialize(random);
	is_active = true;

func initialize(random : RandomNumberGenerator) -> void:
	pass;

func is_before(other_page : NexusPage) -> bool:
	return NexusEnums.get_nexus_page_index(nexus_page) \
		< NexusEnums.get_nexus_page_index(other_page.nexus_page);

func toggle_active(value : bool = true) -> void:
	is_active = value;
