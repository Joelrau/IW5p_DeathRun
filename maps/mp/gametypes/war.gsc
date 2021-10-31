main()
{
	print( "Warning: g_gametype is "+getDvar("g_gametype")+", should be deathrun!" );
	print( "Trying to load correct gametype!" );

	setDvar( "g_gametype", "deathrun" );
	setDvar( "ui_gametype", "deathrun" );
	
	level.callbackStartGameType = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerConnect = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerDisconnect = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerDamage = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerKilled = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackCodeEndGame = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerLastStand = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerMigrated = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackHostMigration = maps\mp\gametypes\_callbacksetup::callbackVoid;
	
	map_restart();
}