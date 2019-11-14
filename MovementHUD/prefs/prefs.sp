// =========================================================== //

static char Preference_Names[PREF_COUNT][MAX_PREFERENCE_NAME_LENGTH] =
{
	"mhud_speed_display",
	"mhud_speed_position",
	"mhud_speed_normal_color",
	"mhud_speed_perf_color",
	"mhud_keys_display",
	"mhud_keys_position",
	"mhud_keys_normal_color",
	"mhud_keys_overlap_color"
};

static char Preference_Defaults[PREF_COUNT][MAX_PREFERENCE_VALUE_LENGTH] =
{
	"0",
	"-1.00 0.70",
	"255 255 255",
	"0 255 0",
	"0",
	"-1.00 0.80",
	"255 255 255",
	"255 0 0"
};

static char Preference_Displays[PREF_COUNT][MAX_PREFERENCE_DISPLAY_LENGTH] =
{
	"速度是否显示",
	"速度位置",
	"速度颜色",
	"速度冲突颜色",
	"按键是否显示",
	"按键位置",
	"按键颜色",
	"按键冲突颜色"
};

static int Preference_Types[PREF_COUNT] =
{
	PrefType_Numeric,
	PrefType_XY,
	PrefType_RGBA,
	PrefType_RGBA,
	PrefType_Numeric,
	PrefType_XY,
	PrefType_RGBA,
	PrefType_RGBA
};

static int Preference_Limits[PREF_COUNT] =
{
	2,
	-1,
	-1,
	-1,
	2,
	-1,
	-1,
	-1
};

// =========================================================== //

Preference Pref(int pref)
{
	return g_Prefs.GetPreference(pref);
}

Preferences InitPrefs()
{
	Preferences prefs = new Preferences();
	for (int i = 0; i < PREF_COUNT; i++)
	{
		prefs.CreatePreference(Preference_Names[i],
								Preference_Displays[i],
								Preference_Defaults[i],
								Preference_Types[i],
								Preference_Limits[i]);
	}

	return prefs;
}

void InitPrefsForClient(int client, Preferences prefs)
{
	for (int i = 0; i < prefs.Length; i++)
	{
		Pref(i).Init(client);
	}

	Call_OnPreferencesLoaded(client);
}

// =========================================================== //