extends CopyBars

@onready var first_copy_active : Panel = $Active/FirstCopy;
@onready var second_copy_active : Panel = $Active/SecondCopy;
@onready var third_copy_active : Panel = $Active/ThirdCopy;

@onready var first_copy_inactive : Panel = $Inactive/FirstCopy;
@onready var second_copy_inactive : Panel = $Inactive/SecondCopy;
@onready var third_copy_inactive : Panel = $Inactive/ThirdCopy;

@onready var one_of_one_active : Panel = $OneOfOne/OneOfOneActive
@onready var one_of_one_inactive : Panel = $OneOfOne/OneOfOneInactive
@onready var ace_copy_active : Panel = $OneOfOne/AceCopyActive;

func set_bars(copies : int, max_copies : int, is_ace : bool) -> void:
	for bar in get_bars():
		bar.visible = false;
	if max_copies == 1:
		if copies > 0:
			if is_ace:
				ace_copy_active.visible = true;
			else:	
				one_of_one_active.visible = true;
		else:
			one_of_one_inactive.visible = true;
		return;
	if copies > 0:
		first_copy_active.visible = true;
	else:
		first_copy_inactive.visible = true;
	if copies > 1:
		second_copy_active.visible = true;
	else:
		second_copy_inactive.visible = true;
	if copies > 2:
		third_copy_active.visible = true;
	else:
		third_copy_inactive.visible = true;
		

func get_bars() -> Array:
	return [
		first_copy_active,
		first_copy_inactive,
		second_copy_active,
		second_copy_inactive,
		third_copy_active,
		third_copy_inactive,
		one_of_one_active,
		one_of_one_inactive,
		ace_copy_active
	];
