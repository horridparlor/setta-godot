const Actions : GDScript = preload("res://Scripts/Scenes/Gameplay/Widgets/Actions.gd");

static func fill_card_stands(
	owning_player : GameplayEnums.OwningPlayer,
	init_data : CardInitData,
	gameplay : Gameplay
) -> void:
	match owning_player:
		GameplayEnums.OwningPlayer.YOU:
			fill_your_stands(init_data, gameplay);
		GameplayEnums.OwningPlayer.OPPONENT:
			fill_opponents_stands(init_data, gameplay);

static func fill_your_stands(init_data : CardInitData, gameplay : Gameplay) -> void:
	fill_stands([
		gameplay.extra_deck_stand	
	], init_data, gameplay);
	
static func fill_opponents_stands(init_data : CardInitData, gameplay : Gameplay) -> void:
	fill_stands([
	], init_data, gameplay);
	
static func fill_stands(stands : Array, init_data : CardInitData, gameplay : Gameplay) -> void:
	var stand : CardStand;
	var card : GameplayCard;
	for s in stands:
		stand = s;
		card = stand.set_showcase_card(init_data, gameplay);
		gameplay.cards[card.card_data.instance_id] = card;

static func control_showcase_glow(
	showcase : CardStand,
	glow_state : GameplayEnums.GlowState
) -> void:
	showcase.control_glow(glow_state);

static func get_showcases(gameplay : Gameplay) -> Array:
	var showcases : Array;
	for widget_type in [
		GameplayEnums.WidgetType.EXTRA_DECK
	]:
		showcases.append(get_card_stand(widget_type, gameplay));
	return showcases;

static func control_showcases_glow(
	glow_state : GameplayEnums.GlowState, gameplay : Gameplay
) -> void:
	var showcase : CardStand;
	control_interface_nodes_glow(glow_state, gameplay);
	for s in get_showcases(gameplay):
		showcase = s;
		if showcase.widget_type == gameplay.active_widget:
			continue;
		control_showcase_glow(showcase, glow_state);

static func control_interface_nodes_glow(
	glow_state : GameplayEnums.GlowState, gameplay : Gameplay
) -> void:
	if gameplay.active_widget != GameplayEnums.WidgetType.NONE:
		glow_state = GameplayEnums.GlowState.SHUTTER;
	gameplay.player_stats.control_glow(glow_state);

static func get_card_stand(
	widget_type : GameplayEnums.WidgetType,
	gameplay : Gameplay
) -> CardStand:
	match widget_type:
		GameplayEnums.WidgetType.EXTRA_DECK:
			return gameplay.extra_deck_stand;
	return null;

static func widget_pressed(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	Actions.widget_pressed(widget_type, gameplay);

static func widget_released(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	Actions.widget_released(widget_type, gameplay);

static func zone_focus_timeout(gameplay : Gameplay) -> void:
	Actions.zone_focus_timeout(gameplay);
