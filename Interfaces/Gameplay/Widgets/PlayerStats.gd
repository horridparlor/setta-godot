extends Control
class_name PlayerStats

const CARD_COUNTS_BBCODE : String = "[center][i]Hand:[/i] %s [i]| Deck:[/i] [b]%s[/b][/center]";
const LIFE_LENGTH : int = 4;

func update_stats(player_data: PlayerData) -> void:
	pass;

func get_life_text(player_data : PlayerData) -> String:
	return "[center]" + System.Ints.to_standard_string(player_data.life, LIFE_LENGTH);

func get_card_counts_text(player_data : PlayerData) -> String:
	return CARD_COUNTS_BBCODE % [player_data.count_hand(), player_data.count_deck()];
