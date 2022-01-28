//
// Plugin name: Quickdraw
// Author: quaK
//

init( modVersion )
{
	setDvar("perk_quickDrawSpeedScale", 1.3);
	
	thread onPlayerSpawned();
}

onPlayerSpawned()
{
	while( 1 )
	{
		level waittill( "jumper", player );
		player thread quickdraw();
	}
}

quickdraw()
{
	wait .1;
	self maps\mp\_utility::givePerk("specialty_quickdraw", 0);
}