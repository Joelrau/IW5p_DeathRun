#include braxi\_common;

setPlayerModel( team )
{	
	if(!isDefined(team))
		team = self.pers["team"];
	
	self detachAll();
	if( team == "allies" )
	{
		id = self braxi\_stats::getStats( "dr_character" );

		if( id >= level.numCharacters )
			id = level.numCharacters-1;
		else if( id < 0 )
			id = 0;

		self setModel( level.characterInfo[id]["model"] );
		self setViewModel( level.characterInfo[id]["handsModel"] );
		if(level.characterInfo[id]["headModel"] != "")
		{
			self attach( level.characterInfo[id]["headModel"] , "", true);
			self.headModel = level.characterInfo[id]["headModel"];
		}
		//self.voice = "american";
	}
	else if( team == "axis" )
	{
		//self setModel("mp_body_desert_tf141_assault_a");
		//self attach("head_hero_price_desert", "", true);
		//self.headModel = "head_hero_price_desert";
		//self setViewModel("viewmodel_hands_zombie");
		//self.voice = "taskforce";
		self detachAll();
		self setModel("mp_fullbody_ally_juggernaut");
		self setViewModel("viewhands_juggernaut_ally");
	}
}

setWeapon()
{
	self.pers["weapon"] = level.itemInfo[self braxi\_stats::getStats( "dr_weapon" )]["item"];
	self.pers["knife"] = level.knifeInfo[self braxi\_stats::getStats( "dr_knife" )]["item"];
	
	if ( self.pers["team"] == "allies" )
	{
		if (level.trapsDisabled == false)
		{
			self giveWeapon( self.pers["weapon"] );
			self setSpawnWeapon( self.pers["weapon"] );
			self giveMaxAmmo( self.pers["weapon"] );
			self giveWeapon( self.pers["knife"] );
		}
		else
		{
			self giveWeapon( self.pers["knife"] );
			self setSpawnWeapon( self.pers["knife"] );
		}
	}
	if( self.pers["team"] == "axis" )
	{
		self giveWeapon( self.pers["knife"] );
		self setSpawnWeapon( self.pers["knife"] );
	}
}

setHealth()
{
	self.maxhealth = 100;
	switch( self.pers["team"] )
	{
	case "allies":
		self.maxhealth = level.dvar["allies_health"];
		break;
	case "axis":
		self.maxhealth = level.dvar["axis_health"];
		break;
	}
	self.health = self.maxhealth;
}

setSpeed()
{
	speed = 1.0;
	switch( self.pers["team"] )
	{
	case "allies":
		speed = level.dvar["allies_speed"];
		break;
	case "axis":
		speed = level.dvar["axis_speed"];
		break;
	}
	self setMoveSpeedScale( speed );
}

setTeam( team )
{	
	if (self.pers["team"] != "spectator")
		if( self.pers["team"] == team )
			return;
	
	if( isAlive( self ) )
		self suicide();
		
	if( team != "spectator" )
		self.statusicon = "hud_status_dead";
	
	self.pers["team"] = team;
	self.team = team;
	self.sessionteam = team;

	menu = game["menu_team"];
	self setClientDvars( "g_scriptMainMenu", menu );
}

setSpectatePermissions()
{
	self allowSpectateTeam( "allies", true );
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "none", false );
}