extends GlowNode
class_name PageButton

signal pressed(_self);

const TITLE_ACTIVE_OPACITY : float = 1.0;
const TITLE_INACTIVE_OPACITY : float = 0.8;

var nexus_page : NexusEnums.NexusPage;

func init(page: NexusEnums.NexusPage, sprite_path : String) -> void:
	pass;

func toggle_active(state : bool = true) -> void:
	pass;
