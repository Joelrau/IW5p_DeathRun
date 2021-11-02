#include braxi\_common;

init()
{
	_precacheShader( "black" );
	while( 1 )
	{
		level waittill( "player_killed", victim, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon );
		
		if( !isDefined( attacker ) || attacker == victim || !isPlayer( attacker ) )
			continue;
			
		if( level.dvar["playerCardsMW3"] == 1 )
		{
			// MW2 PLAYERCARD
			attacker SetCardDisplaySlot( victim, 8 );
			attacker openMenu( "youkilled_card_display" );

			victim SetCardDisplaySlot( attacker, 7 );
			victim openMenu( "killedby_card_display" );
			
			continue;
		}
		
		// BRAXI PLAYERCARD
		thread showPlayerCard( attacker, victim );
	}
}

showPlayerCard( attacker, victim )
{
	if( !level.dvar["playerCards"] || attacker == victim || !isPlayer( attacker ) )
		return;

	level notify( "new emblem" );	// one instance at a time
	level endon( "new emblem" );

	destroyPlayerCard();
	
	logo1 = ( "spray" + attacker braxi\_stats::getStats("dr_spray") + "_menu" );
	logo2 = ( "spray" + victim braxi\_stats::getStats("dr_spray") + "_menu" );
	
	width = 300;
	height = 64;
	
	logo_width = 64;
	logo_height = 64;
	
	x_pos = 0;
	y_pos = -65;
	
	level.playerCard[0] = newHudElem( level );
	level.playerCard[0].x = x_pos;
	level.playerCard[0].y = y_pos;
	level.playerCard[0].alpha = 0;
	level.playerCard[0] setShader( "black", width, height );
	level.playerCard[0].alignX = "center";
	level.playerCard[0].alignY = "bottom";
	level.playerCard[0].horzAlign = "center_adjustable";
	level.playerCard[0].vertAlign = "bottom_adjustable";
	level.playerCard[0].sort = 990;

	//logos
	level.playerCard[1] = braxi\_mod::addTextHud( level, x_pos-250, y_pos, 0, "center", "bottom", 1.8 ); 
	level.playerCard[1].horzAlign = "center_adjustable";
	level.playerCard[1].vertAlign = "bottom_adjustable";
	level.playerCard[1] setShader( logo1, logo_width, logo_height );
	level.playerCard[1].sort = 998;
	
	level.playerCard[2] = braxi\_mod::addTextHud( level, x_pos+250, y_pos, 0, "center", "bottom", 1.8 ); 
	level.playerCard[2].horzAlign = "center_adjustable";
	level.playerCard[2].vertAlign = "bottom_adjustable";
	level.playerCard[2] setShader( logo2, logo_width, logo_height );
	level.playerCard[2].sort = 998;
	
	level.playerCard[3] = braxi\_mod::addTextHud( level, x_pos, y_pos-(height/2)+10, 0, "center", "bottom", 1.8 ); 
	level.playerCard[3].horzAlign = "center_adjustable";
	level.playerCard[3].vertAlign = "bottom_adjustable";
	level.playerCard[3] setText( attacker.name + " killed " + victim.name );
	level.playerCard[3].sort = 999;
	level.playerCard[3].color = level.color_cool_green;
	level.playerCard[3].glowColor = level.color_cool_green_glow;
	level.playerCard[3] SetPulseFX( 30, 100000, 700 );
	level.playerCard[3].glowAlpha = 0.8;

	// === animation === //

	level.playerCard[1] moveOverTime( 0.44 );
	level.playerCard[1].x = ((width/2) * -1) + (logo_width/2);
	level.playerCard[2] moveOverTime( 0.44 );
	level.playerCard[2].x = (width/2) - (logo_width/2);

	for( i = 0; i < level.playerCard.size; i++ )
	{
		level.playerCard[i] fadeOverTime( 0.3 );

		if( i == 0 ) //hack
			level.playerCard[i].alpha = 0.5;
		else
			level.playerCard[i].alpha = 1.0;
	}

	wait 2.0;

	for( i = 0; i < level.playerCard.size; i++ )
	{
		level.playerCard[i] fadeOverTime( 0.8 );
		level.playerCard[i].alpha = 0;
	}
	wait 0.8;
	
	destroyPlayerCard();
}

destroyPlayerCard()
{
	if( !isDefined( level.playerCard ) || !level.playerCard.size )
		return;

	for( i = 0; i < level.playerCard.size; i++ )
		level.playerCard[i] destroy();
	level.playerCard = [];
}