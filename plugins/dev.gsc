//
// Plugin name: Dev
// Author: quaK
//
// Info: Only use this for testing.

init( modVersion )
{
	thread onPlayerConnect();
	thread onPlayerSpawn();
}

onPlayerConnect()
{
	while(1)
	{
		level waittill("connected", player);
	}
}

onPlayerSpawn()
{
	while(1)
	{
		level waittill("player_spawned", player);
	}
}