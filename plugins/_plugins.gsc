/*
	In this script you can load your own plugins from "\mods\<fs_game>\plugins\" directory or IWD package.

	=====

	LoadPlugin( plugins\PLUGIN_SCRIPT::ENTRY_POINT, PLUGIN_NAME, PLUGIN_AUTHOR )

	PLUGIN_SCRIPT	- Script file name without ".gsc" extension, ex. "example"
	ENTRY_POINT		- Plugin function called once a round to load script, if you
					use 'main' mod will call function main( modVersion ) from plugin file
	PLUGIN_NAME		- Name of the plugin, fox example "Extreme DR"
	PLUGIN_AUTHOR	- Plugin author's name


	NOTE!
	Plugins might be disabled via dvar "dr_usePlugins" 
*/

main()
{
	//
	// LoadPlugin( pluginScript, name, author )
	//

	/* === BEGIN === */
	LoadPlugin( plugins\_antiwallbang::init, "Anti-Wallbang", "Viking" );
	LoadPlugin( plugins\_efr::init, "Unlimit Free Run Rounds", "Rycoon" );
	LoadPlugin( plugins\_killcam::init, "Killcam", "Amnesia" );
	
	LoadPlugin( plugins\admins::init, "Admins", "quaK" );
	
	LoadPlugin( plugins\rtd::init, "Roll The Dice", "quaK" );
	LoadPlugin( plugins\simplevelometer::init, "Velocity meter", "Ohh Rexy<3" );
	LoadPlugin( plugins\ez_knife::init, "EZ Knife", "Ohh Rexy<3" );
	LoadPlugin( plugins\healthbar::init, "Healthbar", "unknown" );
	
	LoadPlugin( plugins\dev::init, "Developer(^1debug^7)", "quaK" );
	/* ==== END ==== */
}

// ===== DO NOT EDIT ANYTHING UNDER THIS LINE ===== //
LoadPlugin( pluginScript, name, author )
{
	thread [[ pluginScript ]]( game["ModVersion"] );
	print( "" + name + " ^7plugin created by " + author );
}