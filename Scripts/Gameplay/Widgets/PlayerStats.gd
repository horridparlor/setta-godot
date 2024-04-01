extends PlayerStats

@onready var life_label : RichTextLabel = $MarginContainer/VBoxContainer/LifeCount;
@onready var card_counts_label : RichTextLabel = $MarginContainer/VBoxContainer/CardCounts;

func update_stats(player_data : PlayerData) -> void:
	life_label.text = get_life_text(player_data);
	card_counts_label.text = get_card_counts_text(player_data);
