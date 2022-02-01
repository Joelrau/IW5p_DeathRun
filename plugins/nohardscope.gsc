/*
__________________________________________________
  /   /  ___/    __ /   ___// \ \_____/ / /  ___  \
 /   /  /__     /___   /__ / / \ \ __/ / /  /  /  /
/   /  ___/  __    /  ___// /   \ \ / / /  /  /  /
  _/  /__   /_/   /	 /__ / /     \ \ / /  /__/  /
___\____/________/\____//_/	      \_/ /________/

add this into the _plugins.gsc -> LoadPlugin( plugins\_nohardscope::init,"Anti HardScope ","Legend");
A free version made by Vistic Legend, enjoy.
*/
init(modVersion)
{
	thread onconnect();
}

onconnect()
{
	for(;;)
	{
		level waittill("connected",player);
		player thread onspawn();
	}
}

onspawn()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread nohardscope();
	}
}

nohardscope()
{
	while(isDefined(self) && isPlayer(self) && isAlive(self))
	{
		if(self isweapon() && self adsButtonPressed())
		{
			wait 0.5;
			if(isDefined(self) && isAlive(self))
			{
				self braxi\_common::clientCmd("-speed_throw");
			}
		}
		wait 0.5;
	}
}

isweapon()
{
	wep = self getcurrentweapon();
	switch(wep)
	{
		case "iw5_remington700_mp":
		case "iw5_m40a3_mp":
		case "iw5_cheytac_mp":
		return true;
	}
	return false;
}