// =========================================================== //

void DisplayPreferenceMenu(int client)
{
	Menu menu = new Menu(PreferenceMenu_Handler);

	menu.SetTitle("插件翻译 by NEkotine&NEKO社区");

	menu.AddItem("S", "普通选项菜单");
	menu.AddItem("A", "高级选项菜单");
	menu.AddItem("T", "帮助&HUD工具");

	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int PreferenceMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char itemInfo[2];
		menu.GetItem(param2, itemInfo, sizeof(itemInfo));

		switch (itemInfo[0])
		{
			case 'S': DisplaySimplePreferenceMenu(param1);
			case 'A': DisplayAdvancedPreferenceMenu(param1);
			case 'T': DisplayPreferenceToolsMenu(param1);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

// =========================================================== //