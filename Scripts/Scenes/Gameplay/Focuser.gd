static func card_clicked(card : GameplayCard, gameplay : Gameplay) -> void:
	if is_invalid_click(card, gameplay):
		return;
	if gameplay.focused_card != null:
		unfocus_card(gameplay.focused_card, gameplay);
	focus_card(card, gameplay);

static func is_invalid_click(card : GameplayCard, gameplay : Gameplay) -> bool:
	if card == gameplay.focused_card:
		gameplay.Timers.start(GameplayEnums.TimerType.CardFocus, gameplay);
		return true;
	if gameplay.focus_on not in [
		GameplayEnums.FocusOn.CARD,
		GameplayEnums.FocusOn.NONE,
		GameplayEnums.FocusOn.MODAL
	]:
		true;
	return (gameplay.focused_card != null \
		and (gameplay.focused_card.focus_state != GameplayEnums.FocusState.EXAMINE \
			or card.card_data.zone != gameplay.focused_card.card_data.zone)) \
		|| card.zone in [null, gameplay.sky];

static func card_released(card : GameplayCard, gameplay : Gameplay) -> void:
	if card != gameplay.focused_card:
		return;
	gameplay.Timers.stop(GameplayEnums.TimerType.CardFocus, gameplay);
	if card.focus_state in [
		GameplayEnums.FocusState.EXAMINE,
		GameplayEnums.FocusState.INTERACT,
	]:
		unfocus_card(card, gameplay);
	else:
		examine_card(card, gameplay);

static func focus_card(card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.focus_point = gameplay.get_global_mouse_position();
	gameplay.focused_card = card;
	focus_on_card(card, gameplay);
	set_focused_zone(card.zone, gameplay);
	gameplay.Timers.start(GameplayEnums.TimerType.CardFocus, gameplay);

static func focus_on_card(card : GameplayCard, gameplay : Gameplay) -> void:
	card.Movement.focus(card);
	gameplay.focus_on = GameplayEnums.FocusOn.CARD;

static func unfocus_card(card : GameplayCard, gameplay : Gameplay) -> void:
	if card == gameplay.focused_card:
		gameplay.focused_card = null;
	card.Movement.unfocus(card, gameplay);
	card.zone.reorder_cards(gameplay);
	release_focus(gameplay);

static func release_focus(gameplay : Gameplay) -> void:
	set_focused_zone(
		gameplay.modal if gameplay.active_widget != GameplayEnums.WidgetType.NONE 
			else gameplay.hand, gameplay);
	gameplay.release_focus();

static func examine_card(card : GameplayCard, gameplay : Gameplay) -> void:
	match card.card_data.zone:
		CardEnums.Zone.FIELD:
			try_activate_card(card, gameplay);
		CardEnums.Zone.HAND:
			try_play_card(card, gameplay);
	try_activate_card(card, gameplay);

static func try_play_card(card : GameplayCard, gameplay : Gameplay) -> void:
	if !gameplay.game_state.can_play_card(card.card_data, GameplayEnums.OwningPlayer.YOU):
		unfocus_card(card, gameplay);
		return;
	card.Movement.examine(card, gameplay);

static func try_activate_card(card : GameplayCard, gameplay : Gameplay) -> void:
	unfocus_card(card, gameplay);

static func set_focused_zone(zone : Zone, gameplay : Gameplay) -> void:
	System.Children.focus(zone, gameplay);
	zone.reorder_cards(gameplay);
