extends GameplayCard

@onready var effect_label: RichTextLabel = $Stats/EffectText;
@onready var artwork: Sprite2D = $Frame/ArtFrame/Artwork;
@onready var name_label : RichTextLabel = $Stats/CardName;
@onready var level_label : Label = $Monster/Level/LevelFrame/Level;
@onready var atk_label : Label = $Monster/Attack/AttackFrame/Atk;
@onready var def_label : Label = $Monster/Defense/DefenseFrame/Def;
@onready var attribute_sprite : Sprite2D = $Attribute/AttributeFrame/Attribute;

const Core : GDScript = preload("res://Prefabs/Gameplay/GameplayCard/Core.gd");
const Movement : GDScript = preload("res://Prefabs/Gameplay/GameplayCard/Movement.gd");

func _ready():
	self.scale = BASE_SCALE_HAND;

func _on_button_pressed():
	emit_signal("pressed", self);

func _on_button_released():
	emit_signal("released", self);
	
func _process(delta : float):
	Movement.movement_frame(delta, self);

func despawn(gameplay : Gameplay):
	is_despawned = true;
	gameplay.cards.erase(self);
	shutter(gameplay.random);
	gameplay.sky.push_card(self, gameplay);
	_on_button_released();
	Movement.unfocused(self);
	fix_despawn_point();

func fix_despawn_point():
	origin_point = DESPAWN_POINT;
	origin_point.y = origin_point.y if position.y >= 0 else -origin_point.y;
	if abs(position.x) <= DESPAWN_ORIGO_RANGE:
		origin_point.x = 0;
	else:
		origin_point.x *= abs(position.x) / DESPAWN_WIND_RESISTANCE;
		origin_point.x = origin_point.x if position.x >= 0 else -origin_point.x;
	is_moving = true;
