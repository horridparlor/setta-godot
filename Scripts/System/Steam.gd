const STEAM_APP_ID : int = 3435450;

static func steam_init() -> void:
	Steam.steamInitEx(false, STEAM_APP_ID);
	if !Steam.isSteamRunning():
		return;
	System.steam_data = SteamData.new();
