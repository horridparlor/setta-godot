static func card_clicked(card : GameplayCard, gameplay : Gameplay) -> void:
	if is_invalid_click(card, gameplay):
		return;
	if gameplay.focused_card != null:
		unfocus_card(gameplay.focused_card, gameplay);
	focus_card(card, gameplay);

static func is_invalid_click(card : GameplayCard, gameplay : Gameplay) -> bool:
	if card == gameplay.focused_card:
		gameplay.card_focus_timer.start();
		return true;
	return (gameplay.focused_card != null \
		and (gameplay.focused_card.focus_state != GameplayEnums.FocusState.EXAMINE \
			or card.card_data.zone != gameplay.focused_card.card_data.zone)) \
		|| card.zone in [null, gameplay.sky];

static func card_released(card : GameplayCard, gameplay : Gameplay) -> void:
	if card != gameplay.focused_card:
		return;
	gameplay.card_focus_timer.stop();
	if card.focus_state in [
		GameplayEnums.FocusState.EXAMINE,
		GameplayEnums.FocusState.INTERACT
	]:
		unfocus_card(card, gameplay);
	else:
		examine_card(card, gameplay);

static func focus_card(card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.focus_point = gameplay.get_global_mouse_position();
	gameplay.focused_card = card;
	card.Movement.focus(card);
	set_focused_zone(card.zone, gameplay);
	gameplay.card_focus_timer.start();

static func unfocus_card(card : GameplayCard, gameplay : Gameplay) -> void:
	if card == gameplay.focused_card:
		gameplay.focused_card = null;
	card.Movement.unfocus(card, gameplay);
	set_focused_zone(gameplay.hand, gameplay);

static func examine_card(card : GameplayCard, gameplay : Gameplay) -> void:
	match card.card_data.zone:
		CardEnums.Zone.HAND:
			try_play_card(card, gameplay);

static func try_play_card(card : GameplayCard, gameplay : Gameplay) -> void:
	if !gameplay.game_state.can_play_card(card.card_data, GameplayEnums.OwningPlayer.YOU):
		return;
	card.Movement.examine(card, gameplay);

static func set_focused_zone(zone : Zone, gameplay : Gameplay) -> void:
	System.Children.focus(zone, gameplay);
	zone.reorder_cards(gameplay);
