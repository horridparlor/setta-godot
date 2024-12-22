extends CardScene
class_name NexusPage

var nexus_page : NexusEnums.NexusPages;
var is_active : bool;

func init(page : NexusEnums.NexusPages) -> void:
	nexus_page = page;
	initialize();
	is_active = true;

func initialize() -> void:
	pass;

func is_before(other_page : NexusPage) -> bool:
	return NexusEnums.get_nexus_page_index(nexus_page) \
		< NexusEnums.get_nexus_page_index(other_page.nexus_page);

func toggle_active(value : bool = true) -> void:
	is_active = value;
	on_toggle_active();

func on_toggle_active() -> void:
	pass;
