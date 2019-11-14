// =========================================================== //

static char _Colors[][][] =
{
	{ "255 0 0", "红" },
	{ "0 255 0", "绿" },
	{ "75 100 0", "柠檬色" },
	{ "0 0 255", "蓝" },
	{ "0 255 255", "青绿色" },
	{ "255 215 0", "黄" },
	{ "255 165 0", "橙" },
	{ "128 0 128", "紫" },
	{ "255 255 255", "白" },
	{ "0 0 0", "黑" },
	{ "128 128 128", "灰" }
};

static char _Positions[][][] =
{
	{ "-1.00 0.85", "底部" },
	{ "0.10 0.90", "左下" },
	{ "0.66 0.90", "右下" },
	{ "-1.00 0.70", "中部" },
	{ "0.10 0.70", "中部偏左" },
	{ "0.66 0.70", "中部偏右" },
	{ "-1.00 0.10", "顶部" },
	{ "0.10 0.10", "左上" },
	{ "0.66 0.10", "右上" }
};

static char _SpeedDisplays[][][] =
{
	{ "0", "禁用" },
	{ "1", "显示小数" },
	{ "2", "显示整数" }
};

static char _KeysDisplays[][][] =
{
	{ "0", "禁用" },
	{ "1", "空白部为下划线" },
	{ "2", "空白部不可见" }
};

// =========================================================== //

static void SetNextPresetVal(int client, Preference pref, char[][][] values, int maxItems)
{
	char value[MAX_PREFERENCE_VALUE_LENGTH];
	pref.GetStringVal(client, value, sizeof(value));

	int oldPreset = GetPresetOrDefault(value, values, maxItems);
	int newPreset = ClampInt(++oldPreset, maxItems - 1);

	pref.SetVal(client, values[newPreset][0]);
	Call_OnPreferenceSet(client, pref, false);
}

static int GetPresetOrDefault(char[] value, char[][][] values, int maxItems, int maxlength = -1)
{
	bool shouldCopy = maxlength != -1;
	for (int i = 0; i < maxItems; i++)
	{
		if (StrEqual(value, values[i][0]))
		{
			if (shouldCopy)
				strcopy(value, maxlength, values[i][1]);

			return i;
		}
	}

	if (shouldCopy)
		strcopy(value, maxlength, "Custom");

	return -1;
}

void DisplaySimplePreferenceMenu(int client, int atItem = 0)
{
	Menu menu = new Menu(SimplePreferenceMenu_Handler);
	menu.SetTitle(MHUD_TAG_RAW ... " 普通菜单");

	for (int i = 0; i < PREF_COUNT; i++)
	{
		if (i == Pref_Speed_Display + 1 || i == Pref_Keys_Display + 1)
		{
			menu.AddItem("", "为将来使用预留", ITEMDRAW_DISABLED);
			menu.AddItem("", "为将来使用预留", ITEMDRAW_DISABLED);
		}

		Preference pref = Pref(i);

		char menuInfo[12];
		IntToString(i, menuInfo, sizeof(menuInfo));

		char display[MAX_PREFERENCE_DISPLAY_LENGTH];
		pref.GetDisplay(display, sizeof(display));

		char value[MAX_PREFERENCE_VALUE_LENGTH];
		pref.GetStringVal(client, value, sizeof(value));

		if (pref.Type == PrefType_RGBA)
		{
			GetPresetOrDefault(value, _Colors, sizeof(_Colors), sizeof(value));
		}
		else if (pref.Type == PrefType_XY)
		{
			GetPresetOrDefault(value, _Positions, sizeof(_Positions), sizeof(value));
		}
		else if (pref.Type == PrefType_Numeric)
		{
			switch (pref.Pref)
			{
				case Pref_Keys_Display:
				{
					GetPresetOrDefault(value, _KeysDisplays, sizeof(_KeysDisplays), sizeof(value));
				}
				case Pref_Speed_Display:
				{
					GetPresetOrDefault(value, _SpeedDisplays, sizeof(_SpeedDisplays), sizeof(value));
				}
			}
		}

		char menuItem[sizeof(display) + sizeof(value) + 3];
		Format(menuItem, sizeof(menuItem), "%s: %s", display, value);

		menu.AddItem(menuInfo, menuItem);
	}

	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.DisplayAt(client, atItem, MENU_TIME_FOREVER);
}

public int SimplePreferenceMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char itemInfo[12];
		menu.GetItem(param2, itemInfo, sizeof(itemInfo));

		Preference pref = Pref(StringToInt(itemInfo));

		if (pref.Type == PrefType_RGBA)
		{
			SetNextPresetVal(param1, pref, _Colors, sizeof(_Colors));
		}
		else if (pref.Type == PrefType_XY)
		{
			SetNextPresetVal(param1, pref, _Positions, sizeof(_Positions));
		}
		else if (pref.Type == PrefType_Numeric)
		{
			switch (pref.Pref)
			{
				case Pref_Keys_Display:
				{
					SetNextPresetVal(param1, pref, _KeysDisplays, sizeof(_KeysDisplays));
				}
				case Pref_Speed_Display:
				{
					SetNextPresetVal(param1, pref, _SpeedDisplays, sizeof(_SpeedDisplays));
				}
			}
		}

		DisplaySimplePreferenceMenu(param1, menu.Selection);
	}
	else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack)
	{
		DisplayPreferenceMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

// =========================================================== //