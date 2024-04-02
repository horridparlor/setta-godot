extends Node

enum OwningPlayer {
	YOU,
	OPPONENT
}

static func get_owning_players() -> Array:
	return [OwningPlayer.YOU, OwningPlayer.OPPONENT]

enum TurnPhase {
	ATTACK_PHASE,
	DRAW_PHASE,
	MAIN_PHASE,
	NONE,
}

enum DecklistType {
	PLAYER_MADE,
	PREMADE,
}

enum FocusState {
	EXAMINE,
	INTERACT,
	NONE,
	WAITING
}

enum GlowState {
	GLOW,
	SHUTTER
}

enum WidgetType {
	EXTRA_DECK,
	NONE,
}

enum FocusOn {
	ATTACK,
	CARD,
	MODAL,
	NONE,
}

enum TimerType {
	CardFocus,
	ZoneFocus
}

enum ZoneType {
	ROW,
	SCROLL
}
