#include braxi\_common;
#include braxi\_clientdvar;

init()
{
	level waittill( "game over" );
	saveAllStats();
}

setupStats()
{
	if ( self getStats( "dr_stats", "int" ) != 1 || self braxi\_rank::_getPlayerData( "experience" ) < self getStats( "saved_experience" ) )
	{
		self setStats( "dr_stats", 1 );
		self setStats( "dr_character", 0 );
		self setStats( "dr_weapon", 0 );
		self setStats( "dr_knife", 0 );
		self setStats( "dr_spray", 0 );
		
		self setStats( "saved_experience", self braxi\_rank::_getPlayerData( "experience" ) );
		self setStats( "saved_prestige", self braxi\_rank::_getPlayerData( "prestige" ) );
	}
	
	// reset warns on setup
	self setStats( "warns", 0 );
}

setStats( what, value )
{
	_setClientDvar( self, what, value );
}

getStats( what, type )
{
	if( !isDefined( type ) )
		type = "int";
	
	stat = _getClientDvar( self, what, type );
	if(!isDefined(stat))
	{
		stat = 0;
	}
	return stat;
}

saveAllStats()
{
	logPrint( "\n===== BEGIN STATS =====\n" + "set dr_stats " + "\"" + getDvar("dr_stats") + "\"" + "\n" + "set dr_character " + "\"" + getDvar("dr_character") + "\"" + "\n" + "set dr_knife " + "\"" + getDvar("dr_knife") + "\"" + "\n" + "set dr_weapon " + "\"" + getDvar("dr_weapon") + "\"" + "\n" + "set warns " + "\"" + getDvar("warns") + "\"" + "\n" + "set saved_experience " + "\"" + getDvar("saved_experience") + "\"" + "\n===== END STATS =====\n" );
}