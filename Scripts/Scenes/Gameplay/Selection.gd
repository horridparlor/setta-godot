static func set_selection(
	selection_type : GameplayEnums.SelectionType, gameplay : Gameplay
) -> void:
	gameplay.selection_type = selection_type;
	update_selectable(gameplay);

static func update_selectable(gameplay : Gameplay) -> void:
	var card : GameplayCard;
	for instance_id in gameplay.cards:
		card = gameplay.cards[instance_id];
		card.Core.control_glow(GameplayEnums.GlowState.GLOW, card, gameplay);
	gameplay.Widgets.control_showcases_glow(
		GameplayEnums.GlowState.SHUTTER if gameplay.is_selecting() \
		else GameplayEnums.GlowState.GLOW,
		gameplay);
	update_action_hint(gameplay);

static func update_action_hint(gameplay : Gameplay) -> void:
	var hint : String;
	match gameplay.selection_type:
		GameplayEnums.SelectionType.TRIBUTE:
			hint = gameplay.HINT_TRIBUTE % [gameplay.actions_left];
	gameplay.action_hint.set_text(hint); 
