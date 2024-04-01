extends Node2D
class_name CardStand

signal pressed(widget_type);
signal released(widget_type);

var showcase_card : GameplayCard;
var widget_type : GameplayEnums.WidgetType;

func set_showcase_card(init_data : CardInitData) -> GameplayCard:
	showcase_card = System.Instance.load_child(SystemEnums.get_card_path(), self);
	showcase_card.random = init_data.random;
	showcase_card.card_data = System.CardData.default(init_data);
	showcase_card.Sleeves.show_sleeve(showcase_card);
	showcase_card.scale = showcase_card.BASE_SCALE_SHOWCASE;
	showcase_card.Core.control_glow(GameplayEnums.GlowState.GLOW, showcase_card);
	return showcase_card;

func control_glow(glow_state : GameplayEnums.GlowState, random : RandomNumberGenerator) -> void:
	pass;
