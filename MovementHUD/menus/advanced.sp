// =========================================================== //

static int _AdvancedOptions[] =
{	
	Pref_Speed_Position,
	Pref_Speed_Normal_Color,
	Pref_Speed_Perf_Color,
	Pref_Keys_Position,
	Pref_Keys_Normal_Color,
	Pref_Keys_Overlap_Color
	
	
	
	
	
	
};

// =========================================================== //

void DisplayAdvancedPreferenceMenu(int client, int atItem = 0)
{
	Menu menu = new Menu(AdvancedPreferenceMenu_Handler);
	menu.SetTitle(MHUD_TAG_RAW ... " 高级选项");

	for (int i = 0; i < sizeof(_AdvancedOptions); i++)
	{
		int pref = _AdvancedOptions[i];

		char menuInfo[12];
		IntToString(pref, menuInfo, sizeof(menuInfo));

		char display[MAX_PREFERENCE_DISPLAY_LENGTH];
		Pref(pref).GetDisplay(display, sizeof(display));

		char value[MAX_PREFERENCE_VALUE_LENGTH];
		Pref(pref).GetStringVal(client, value, sizeof(value));

		char menuItem[sizeof(display) + sizeof(value) + 3];
		Format(menuItem, sizeof(menuItem), "%s: %s", display, value);

		menu.AddItem(menuInfo, menuItem);
	}

	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.DisplayAt(client, atItem, MENU_TIME_FOREVER);
}

public int AdvancedPreferenceMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char itemInfo[12];
		menu.GetItem(param2, itemInfo, sizeof(itemInfo));

		Preference pref = Pref(StringToInt(itemInfo));
		ExpectInputForClient(param1, pref.Pref, menu.Selection);

		char display[MAX_PREFERENCE_DISPLAY_LENGTH];
		pref.GetDisplay(display, sizeof(display));

		MHud_Print(param1, true, "输入一个值来 <\x05%s\x01>", display);

		switch (pref.Type)
		{
			case PrefType_XY:
			{
				MHud_Print(param1, false, "请遵循以下格式 : \x07<X> \x04<Y>\x01 - 格式: 0.5 0.8");
			}
			case PrefType_RGBA:
			{
				MHud_Print(param1, false, "请遵循以下格式 : \x07<R> \x04<G> \x0B<B>\x01 - 格式: 255 0 255");
			}
		}

		MHud_Print(param1, false, "如果想要取消, 输入 \"\x05cancel\x01\" 来取消");
		MHud_Print(param1, false, "想要重置, 输入 \"\x05reset\x01\" 来重置");
		MHud_Print(param1, false, "输入会在 \x05%.2f\x01 秒后取消", INPUT_TIMEOUT);

		Call_OnExpectingInput(param1, pref);
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