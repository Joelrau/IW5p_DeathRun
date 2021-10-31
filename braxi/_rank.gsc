#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include braxi\_common;

init()
{
    level.scoreInfo = [];
    level.xpScale = getDvarInt( "scr_xpscale" );
	
    level.rankTable = [];
    level.weaponRankTable = [];
    _precacheShader( "white" );
    _precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
    _precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
    _precacheString( &"RANK_WEAPON_WAS_PROMOTED" );
    _precacheString( &"RANK_PROMOTED" );
    _precacheString( &"RANK_PROMOTED_WEAPON" );
    _precacheString( &"MP_PLUS" );
    _precacheString( &"RANK_ROMANI" );
    _precacheString( &"RANK_ROMANII" );
    _precacheString( &"RANK_ROMANIII" );
    _precacheString( &"SPLASHES_LONGSHOT" );
    _precacheString( &"SPLASHES_PROXIMITYASSIST" );
    _precacheString( &"SPLASHES_PROXIMITYKILL" );
    _precacheString( &"SPLASHES_EXECUTION" );
    _precacheString( &"SPLASHES_AVENGER" );
    _precacheString( &"SPLASHES_ASSISTEDSUICIDE" );
    _precacheString( &"SPLASHES_DEFENDER" );
    _precacheString( &"SPLASHES_POSTHUMOUS" );
    _precacheString( &"SPLASHES_REVENGE" );
    _precacheString( &"SPLASHES_DOUBLEKILL" );
    _precacheString( &"SPLASHES_TRIPLEKILL" );
    _precacheString( &"SPLASHES_MULTIKILL" );
    _precacheString( &"SPLASHES_BUZZKILL" );
    _precacheString( &"SPLASHES_COMEBACK" );
    _precacheString( &"SPLASHES_KNIFETHROW" );
    _precacheString( &"SPLASHES_ONE_SHOT_KILL" );
	
	multiplier = 2;
	registerScoreInfo( "kill", 500 * multiplier );
	registerScoreInfo( "headshot", 600 * multiplier );
	registerScoreInfo( "melee", 550 * multiplier );
	registerScoreInfo( "activator", 300 * multiplier );
	registerScoreInfo( "trap_activation", 150 * multiplier );
	registerScoreInfo( "jumper_died", 200 * multiplier );

	registerScoreInfo( "win", 150 * multiplier );
	registerScoreInfo( "loss", 50 * multiplier );
	registerScoreInfo( "tie", 100 * multiplier );
	
    level.maxRank = int( tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ) );
    level.maxPrestige = int( tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ) );
    pId = 0;
    rId = 0;

    for ( pId = 0; pId <= level.maxPrestige; pId++ )
    {
        for ( rId = 0; rId <= level.maxRank; rId++ )
            _precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId + 1 ) );
    }

    var_2 = 0;

    for ( var_3 = tableLookup( "mp/ranktable.csv", 0, var_2, 1 ); isDefined( var_3 ) && var_3 != ""; var_3 = tableLookup( "mp/ranktable.csv", 0, var_2, 1 ) )
    {
        level.rankTable[var_2][1] = tableLookup( "mp/ranktable.csv", 0, var_2, 1 );
        level.rankTable[var_2][2] = tableLookup( "mp/ranktable.csv", 0, var_2, 2 );
        level.rankTable[var_2][3] = tableLookup( "mp/ranktable.csv", 0, var_2, 3 );
        level.rankTable[var_2][7] = tableLookup( "mp/ranktable.csv", 0, var_2, 7 );
        _precacheString( tableLookupistring( "mp/ranktable.csv", 0, var_2, 16 ) );
        var_2++;
    }

    var_4 = int( tableLookup( "mp/weaponRankTable.csv", 0, "maxrank", 1 ) );

    for ( var_5 = 0; var_5 < var_4 + 1; var_5++ )
    {
        level.weaponRankTable[var_5][1] = tableLookup( "mp/weaponRankTable.csv", 0, var_5, 1 );
        level.weaponRankTable[var_5][2] = tableLookup( "mp/weaponRankTable.csv", 0, var_5, 2 );
        level.weaponRankTable[var_5][3] = tableLookup( "mp/weaponRankTable.csv", 0, var_5, 3 );
    }
	
    level thread onPlayerConnect();
}

isRegisteredEvent( type )
{
    if ( isDefined( level.scoreInfo[type] ) )
        return 1;
    else
        return 0;
}

registerScoreInfo( type, value )
{
    level.scoreInfo[type]["value"] = value;
}

getScoreInfoValue( type )
{
    overrideDvar = "scr_" + level.gameType + "_score_" + type;

    if ( getDvar( overrideDvar ) != "" )
        return getDvarInt( overrideDvar );
    else
        return level.scoreInfo[type]["value"];
}

getScoreInfoLabel( type )
{
    return level.scoreInfo[type]["label"];
}

getRankInfoMinXP( rankId )
{
    return int( level.rankTable[rankId][2] );
}

getWeaponRankInfoMinXP( rankId )
{
    return int( level.weaponRankTable[rankId][1] );
}

getRankInfoXPAmt( rankId )
{
    return int( level.rankTable[rankId][3] );
}

getWeaponRankInfoXPAmt( rankId )
{
    return int( level.weaponRankTable[rankId][2] );
}

getRankInfoMaxXp( rankId )
{
    return int( level.rankTable[rankId][7] );
}

getWeaponRankInfoMaxXp( rankId )
{
    return int( level.weaponRankTable[rankId][3] );
}

getRankInfoFull( rankId )
{
    return tableLookupistring( "mp/ranktable.csv", 0, rankId, 16 );
}

getRankInfoIcon( rankId, prestigeId )
{
    return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId + 1 );
}

getRankInfoLevel( rankId )
{
    return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill( "connected",  player  );
        player.pers["rankxp"] = player _getPlayerData( "experience" );

        if ( player.pers["rankxp"] < 0 )
            player.pers["rankxp"] = 0;

        var_1 = player getRankForXp( player getRankXP() );
        player.pers["rank"] = var_1;
        player.pers["participation"] = 0;
        player.xpUpdateTotal = 0;
        player.bonusUpdateTotal = 0;
        var_2 = player getPrestigeLevel();
        player setRank( var_1, var_2 );
        player.pers["prestige"] = var_2;

        //if ( player.clientid < level.MaxLogClients )
        //{
        //    setMatchData( "players", player.clientid, "rank", var_1 );
        //    setMatchData( "players", player.clientid, "Prestige", var_2 );
        //}

        player.postGamePromotion = 0;

        if ( !isDefined( player.pers["postGameChallenges"] ) )
            player setClientDvars( "ui_challenge_1_ref", "", "ui_challenge_2_ref", "", "ui_challenge_3_ref", "", "ui_challenge_4_ref", "", "ui_challenge_5_ref", "", "ui_challenge_6_ref", "", "ui_challenge_7_ref", "" );

        player setClientDvar( "ui_promotion", 0 );

        if ( !isDefined( player.pers["summary"] ) )
        {
            player.pers["summary"] = [];
            player.pers["summary"]["xp"] = 0;
            player.pers["summary"]["score"] = 0;
            player.pers["summary"]["challenge"] = 0;
            player.pers["summary"]["match"] = 0;
            player.pers["summary"]["misc"] = 0;
            player setClientDvar( "player_summary_xp", "0" );
            player setClientDvar( "player_summary_score", "0" );
            player setClientDvar( "player_summary_challenge", "0" );
            player setClientDvar( "player_summary_match", "0" );
            player setClientDvar( "player_summary_misc", "0" );
        }

        player setClientDvar( "ui_opensummary", 0 );
        //player thread maps\mp\gametypes\_missions::updateChallenges();
        player.explosiveKills[0] = 0;
        player.xpGains = [];
        player.hud_xpPointsPopup = player createXpPointsPopup();
        player.hud_xpEventPopup = player createXpEventPopup();
        player thread onPlayerSpawned();
        player thread onJoinedTeam();
        player thread onJoinedSpectators();
        //player thread setGamesPlayed();

        if ( player getplayerdata( "prestigeDoubleXp" ) )
            player.prestigeDoubleXp = 1;
        else
            player.prestigeDoubleXp = 0;

        if ( player getplayerdata( "prestigeDoubleWeaponXp" ) )
        {
            player.prestigeDoubleWeaponXp = 1;
            continue;
        }

        player.prestigeDoubleWeaponXp = 0;
    }
}

setGamesPlayed()
{
    self endon( "disconnect" );

    for (;;)
    {
        wait 30;

        if ( !self.hasDoneCombat )
            continue;

        _addPlayerData( "gamesPlayed", 1 );
        break;
    }
}

onJoinedTeam()
{
    self endon( "disconnect" );

    for (;;)
    {
        self waittill( "joined_team" );
        thread removeRankHUD();
    }
}

onJoinedSpectators()
{
    self endon( "disconnect" );

    for (;;)
    {
        self waittill( "joined_spectators" );
        thread removeRankHUD();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );

    for (;;)
        self waittill( "spawned_player" );
}

giveRankXP( type, value )
{
    self endon("disconnect");
	
	if ( !isDefined( value ) )
		value = getScoreInfoValue( type );

	if( level.freeRun )
		value = int( value * 0.5 ); // play deathrun or gtfo and play cj
	
	value *= level.xpScale;
	
	oldxp = self getRankXP();
	
	if ( !isdefined( self.xpGains[type] ) )
        self.xpGains[type] = 0;
	self.xpGains[type] += value;
	
	self incRankXP( value );
	
	thread xpPointsPopup(value, 0, (1,1,0), 0 );
	
	self.score += value;
	self.pers["score"] = self.score;
	
	self _addPlayerData( "score", value );

	if ( updateRank( oldxp ) )
		self thread updateRankAnnounceHUD();

	// Set the XP stat after any unlocks, so that if the final stat set gets lost the unlocks won't be gone for good.
	self syncXPStat();
}

weaponShouldGetXP( var_0, var_1 )
{
    if ( self isitemunlocked( "cac" ) && !maps\mp\_utility::isJuggernaut() && isDefined( var_0 ) && isDefined( var_1 ) && !maps\mp\_utility::isKillstreakWeapon( var_0 ) )
    {
        if ( maps\mp\_utility::isBulletDamage( var_1 ) )
            return 1;

        if ( isexplosivedamagemod( var_1 ) || var_1 == "MOD_IMPACT" )
        {
            if ( maps\mp\_utility::getWeaponClass( var_0 ) == "weapon_projectile" || maps\mp\_utility::getWeaponClass( var_0 ) == "weapon_assault" )
                return 1;
        }

        if ( var_1 == "MOD_MELEE" )
        {
            if ( maps\mp\_utility::getWeaponClass( var_0 ) == "weapon_riot" )
                return 1;
        }
    }

    return 0;
}

updateRank( oldxp )
{
    newRankId = getRank();

    if ( newRankId == self.pers["rank"] )
        return 0;

    oldRank = self.pers["rank"];
    self.pers["rank"] = newRankId;
    self setRank( newRankId );
	
	print( "promoted " + self.name + " from rank " + oldRank + " to " + newRankId + ". Experience went from " + oldxp + " to " + self getRankXP() + "." );
	self updateUnlocks(); //DR
	
    return 1;
}

updateWeaponRank( var_0, var_1 )
{
    var_2 = getWeaponRank( var_1 );

    if ( var_2 == self.pers["weaponRank"] )
        return 0;

    var_3 = self.pers["weaponRank"];
    self.pers["weaponRank"] = var_2;
    self setplayerdata( "weaponRank", var_1, var_2 );
    thread maps\mp\gametypes\_missions::masteryChallengeProcess( var_1 );
    return 1;
}

updateRankAnnounceHUD()
{
    self endon( "disconnect" );
    self notify( "update_rank" );
    self endon( "update_rank" );
    team = self.pers["team"];

    if ( !isDefined( team ) )
        return;

    //if ( !maps\mp\_utility::levelFlag( "game_over" ) )
     //   level common_scripts\utility::waittill_notify_or_timeout( "game_over", 0.25 );

    newRankName = getRankInfoFull( self.pers["rank"] );
    rank_char = level.rankTable[self.pers["rank"]][1];
    subRank = int( rank_char[rank_char.size - 1] );
    thread maps\mp\gametypes\_hud_message::promotionSplashNotify();

    if ( subRank > 1 )
        return;

    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];
        playerteam = player.pers["team"];

        if ( isDefined( playerteam ) && player != self )
        {
            if ( playerteam == team )
                player iPrintLn( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );
        }
    }
}

updateWeaponRankAnnounceHUD()
{
    self endon( "disconnect" );
    self notify( "update_weapon_rank" );
    self endon( "update_weapon_rank" );
    team = self.pers["team"];

    if ( !isDefined( team ) )
        return;

    if ( !maps\mp\_utility::levelFlag( "game_over" ) )
        level common_scripts\utility::waittill_notify_or_timeout( "game_over", 0.25 );

    thread maps\mp\gametypes\_hud_message::weaponPromotionSplashNotify();
}

endGameUpdate()
{
    player = self;
}

createXpPointsPopup()
{
    var_0 = newclienthudelem( self );
    var_0.horzalign = "center";
    var_0.vertalign = "middle";
    var_0.alignx = "center";
    var_0.aligny = "middle";
    var_0.x = 30;

    if ( level.splitscreen )
        var_0.y = -30;
    else
        var_0.y = -50;

    var_0.font = "hudbig";
    var_0.fontScale = 0.65;
    var_0.archived = 0;
    var_0.color = ( 0.5, 0.5, 0.5 );
    var_0.sort = 10000;
    var_0 maps\mp\gametypes\_hud::fontPulseInit( 3.0 );
    return var_0;
}

xpPointsPopup( amount, bonus, hudColor, glowAlpha )
{
    self endon( "disconnect" );
    self endon( "joined_team" );
    self endon( "joined_spectators" );

    if ( amount == 0 )
        return;

    self notify( "xpPointsPopup" );
    self endon( "xpPointsPopup" );
    self.xpUpdateTotal = self.xpUpdateTotal + amount;
    self.bonusUpdateTotal = self.bonusUpdateTotal + bonus;
    wait 0.05;

    if ( self.xpUpdateTotal < 0 )
        self.hud_xpPointsPopup.label = &"";
    else
        self.hud_xpPointsPopup.label = &"MP_PLUS";

    self.hud_xpPointsPopup.color = hudColor;
    self.hud_xpPointsPopup.glowcolor = hudColor;
    self.hud_xpPointsPopup.glowalpha = glowAlpha;
    self.hud_xpPointsPopup setvalue( self.xpUpdateTotal );
    self.hud_xpPointsPopup.alpha = 0.85;
    self.hud_xpPointsPopup thread maps\mp\gametypes\_hud::fontPulse( self );
    var_4 = max( int( self.bonusUpdateTotal / 20 ), 1 );

    if ( self.bonusUpdateTotal )
    {
        while ( self.bonusUpdateTotal > 0 )
        {
            self.xpUpdateTotal = self.xpUpdateTotal + min( self.bonusUpdateTotal, var_4 );
            self.bonusUpdateTotal = self.bonusUpdateTotal - min( self.bonusUpdateTotal, var_4 );
            self.hud_xpPointsPopup setvalue( self.xpUpdateTotal );
            wait 0.05;
        }
    }
    else
        wait 1.0;

    self.hud_xpPointsPopup fadeovertime( 0.75 );
    self.hud_xpPointsPopup.alpha = 0;
    self.xpUpdateTotal = 0;
}

createXpEventPopup()
{
    var_0 = newclienthudelem( self );
    var_0.children = [];
    var_0.horzalign = "center";
    var_0.vertalign = "middle";
    var_0.alignx = "center";
    var_0.aligny = "middle";
    var_0.x = 55;

    if ( level.splitscreen )
        var_0.y = -20;
    else
        var_0.y = -35;

    var_0.font = "hudbig";
    var_0.fontScale = 0.65;
    var_0.archived = 0;
    var_0.color = ( 0.5, 0.5, 0.5 );
    var_0.sort = 10000;
    var_0.elemType = "msgText";
    var_0 maps\mp\gametypes\_hud::fontPulseInit( 3.0 );
    return var_0;
}

xpeventpopupfinalize( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    self endon( "joined_team" );
    self endon( "joined_spectators" );
    self notify( "xpEventPopup" );
    self endon( "xpEventPopup" );

    if ( level.hardcoreMode )
        return;

    wait 0.05;

    if ( !isDefined( var_1 ) )
        var_1 = ( 1, 1, 0.5 );

    if ( !isDefined( var_2 ) )
        var_2 = 0;

    if ( !isDefined( self ) )
        return;

    self.hud_xpEventPopup.color = var_1;
    self.hud_xpEventPopup.glowcolor = var_1;
    self.hud_xpEventPopup.glowalpha = var_2;
    self.hud_xpEventPopup settext( var_0 );
    self.hud_xpEventPopup.alpha = 0.85;
    wait 1.0;

    if ( !isDefined( self ) )
        return;

    self.hud_xpEventPopup fadeovertime( 0.75 );
    self.hud_xpEventPopup.alpha = 0;
    self notify( "PopComplete" );
}

xpeventpopupterminate()
{
    self endon( "PopComplete" );
    common_scripts\utility::waittill_any( "joined_team", "joined_spectators" );
    self.hud_xpEventPopup fadeovertime( 0.05 );
    self.hud_xpEventPopup.alpha = 0;
}

xpEventPopup( var_0, var_1, var_2 )
{
    thread xpeventpopupfinalize( var_0, var_1, var_2 );
    thread xpeventpopupterminate();
}

removeRankHUD()
{
    self.hud_xpPointsPopup.alpha = 0;
}

getRank()
{
    rankXp = self.pers["rankxp"];
    rankId = self.pers["rank"];

    if ( rankXp < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
        return rankId;
    else
        return getRankForXp( rankXp );
}

getWeaponRank( var_0 )
{
    var_1 = self getplayerdata( "weaponXP", var_0 );
    return getWeaponRankForXp( var_1, var_0 );
}

levelForExperience( experience )
{
    return getRankForXp( experience );
}

weaponLevelForExperience( var_0 )
{
    return getWeaponRankForXp( var_0 );
}

getCurrentWeaponXP()
{
    var_0 = self getcurrentweapon();

    if ( isDefined( var_0 ) )
        return self getplayerdata( "weaponXP", var_0 );

    return 0;
}

getRankForXp( xpVal )
{
    rankId = 0;
    rankName = level.rankTable[rankId][1];

    while ( isDefined( rankName ) && rankName != "" )
    {
        if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
            return rankId;

        rankId++;

        if ( isDefined( level.rankTable[rankId] ) )
        {
            rankName = level.rankTable[rankId][1];
            continue;
        }

        rankName = undefined;
    }

    rankId--;
    return rankId;
}

getWeaponRankForXp( var_0, var_1 )
{
    if ( !isDefined( var_0 ) )
        var_0 = 0;

    var_2 = tableLookup( "mp/statstable.csv", 4, var_1, 2 );
    var_3 = int( tableLookup( "mp/weaponRankTable.csv", 0, var_2, 1 ) );

    for ( var_4 = 0; var_4 < var_3 + 1; var_4++ )
    {
        if ( var_0 < getWeaponRankInfoMinXP( var_4 ) + getWeaponRankInfoXPAmt( var_4 ) )
            return var_4;
    }

    return var_4 - 1;
}

getSPM()
{
    rankLevel = getRank() + 1;
    return ( 3 + rankLevel * 0.5 ) * 10;
}

getPrestigeLevel()
{
    return _getPlayerData( "prestige" );
}

getRankXP()
{
    return self.pers["rankxp"];
}

getWeaponRankXP( var_0 )
{
    return self getplayerdata( "weaponXP", var_0 );
}

getWeaponMaxRankXP( var_0 )
{
    var_1 = tableLookup( "mp/statstable.csv", 4, var_0, 2 );
    var_2 = int( tableLookup( "mp/weaponRankTable.csv", 0, var_1, 1 ) );
    var_3 = getWeaponRankInfoMaxXp( var_2 );
    return var_3;
}

isWeaponMaxRank( var_0 )
{
    var_1 = self _getPlayerData( "weaponXP", var_0 );
    var_2 = getWeaponMaxRankXP( var_0 );
    return var_1 >= var_2;
}

incRankXP( amount )
{
    //if ( !maps\mp\_utility::rankingEnabled() )
    //    return;

    //if ( isDefined( self.isCheater ) )
    //    return;

    xp = getRankXP();
    newXp = int( min( xp, getRankInfoMaxXp( level.maxRank ) ) ) + amount;

    if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXp( level.maxRank ) )
        newXp = getRankInfoMaxXp( level.maxRank );

    self.pers["rankxp"] = newXp;
}

getRestXPAward( baseXP )
{
    if ( !getDvarInt( "scr_restxp_enable" ) )
        return 0;

    restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
    wantGiveRestXP = int( baseXP * restXPAwardRate );
    mayGiveRestXP = self _getPlayerData( "restXPGoal" ) - getRankXP();

    if ( mayGiveRestXP <= 0 )
        return 0;

    return wantGiveRestXP;
}

isLastRestXPAward( baseXP )
{
    if ( !getDvarInt( "scr_restxp_enable" ) )
        return 0;

    restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
    wantGiveRestXP = int( baseXP * restXPAwardRate );
    mayGiveRestXP = self _getPlayerData( "restXPGoal" ) - getRankXP();

    if ( mayGiveRestXP <= 0 )
        return 0;

    if ( wantGiveRestXP >= mayGiveRestXP )
        return 1;

    return 0;
}

syncXPStat()
{
    if ( level.xpScale > 4 || level.xpScale <= 0 )
        exitlevel( 0 );

    xp = getRankXP();
    _setPlayerData( "experience", xp );
}

//DR

updateUnlocks()
{
	self thread unlockCharacter();
	self thread unlockItem();
	self thread unlockKnife();
	self thread unlockSpray();
}

processXpReward( sMeansOfDeath, attacker, victim )
{
	if( attacker.pers["team"] == victim.pers["team"] )
		return;

	kills = attacker _getPlayerData( "kills" );
	attacker _setPlayerData( "kills", kills+1 );

	switch( sMeansOfDeath )
	{
		case "MOD_HEAD_SHOT":
			attacker.pers["headshots"]++;
			attacker braxi\_rank::giveRankXP( "headshot" );
			hs = attacker _getPlayerData( "headshots" );
			attacker _setPlayerData( "headshots", hs+1 );
			break;
		case "MOD_MELEE":
			attacker.pers["knifes"]++;
			attacker braxi\_rank::giveRankXP( "melee" );
			break;
		default:
			attacker braxi\_rank::giveRankXP( "kill" );
			break;
	}
}

unlockCharacter()
{
	if(!isDefined(level.characterInfo))
	{
		return;
	}

	for( i = 0; i < level.characterInfo.size; i++ )
	{
		if( self getRank() == level.characterInfo[i]["rank"]  )
		{
			notifyData = spawnStruct();
			notifyData.title = "New Character!";
			notifyData.description = level.characterInfo[i]["name"];
			notifyData.icon = level.characterInfo[i]["shader"];
			notifyData.duration = 2.9;
			self thread unlockMessage( notifyData );
			break;
		}
	}
}

isCharacterUnlocked( num )
{
	if(!isDefined(level.characterInfo))
	{
		return false;
	}
	
	if( num >= level.numCharacters || num <= -1)
		return false;
	if( self getRank() >= level.characterInfo[num]["rank"] )
		return true;
	return false;
}

unlockItem()
{
	if(!isDefined(level.itemInfo))
	{
		return false;
	}
	
	for( i = 0; i < level.itemInfo.size; i++ )
	{
		if( self getRank() == level.itemInfo[i]["rank"] )
		{
		notifyData = spawnStruct();
		notifyData.title = "New Weapon!";
		notifyData.description = level.itemInfo[i]["name"];
		notifyData.icon = level.itemInfo[i]["shader"];
		notifyData.duration = 2.9;
		self thread unlockMessage( notifyData );
			break;
		}
	}
}

isItemUnlocked1( num )
{
	if(!isDefined(level.itemInfo))
	{
		return false;
	}
	
	if( num > level.numItems || num <= -1)
		return false;
	if( self getRank() >= level.itemInfo[num]["rank"] )
		return true;
	return false;
}

unlockKnife()
{
	if(!isDefined(level.knifeInfo))
	{
		return false;
	}
	
	for( i = 0; i < level.knifeInfo.size; i++ )
	{
		if( self getRank() == level.knifeInfo[i]["rank"] )
		{
		notifyData = spawnStruct();
		notifyData.title = "New Knife!";
		notifyData.description = level.knifeInfo[i]["name"];
		notifyData.icon = level.knifeInfo[i]["shader"];
		notifyData.duration = 2.9;
		self thread unlockMessage( notifyData );
			break;
		}
	}
}

isKnifeUnlocked( num )
{
	if(!isDefined(level.knifeInfo))
	{
		return false;
	}
	
	if( num > level.numKnifes || num <= -1)
		return false;
	if( self getRank() >= level.knifeInfo[num]["rank"] )
		return true;
	return false;
}

unlockSpray()
{
	if(!isDefined(level.sprayInfo))
	{
		return;
	}
	
	for( i = 0; i < level.sprayInfo.size; i++ )
	{
		if( self getRank() == level.sprayInfo[i]["rank"] )
		{
			notifyData = spawnStruct();
			notifyData.title = "New Spray!";
			notifyData.description = level.sprayInfo[i]["name"];
			notifyData.icon = level.sprayInfo[i]["shader"];
			notifyData.duration = 2.9;
			self thread unlockMessage( notifyData );
			break;
		}
	}
}

isSprayUnlocked( num )
{
	if(!isDefined(level.sprayInfo))
	{
		return false;
	}
	
	if( num > level.numSprays || num <= -1)
		return false;
	if( self getRank() >= level.sprayInfo[num]["rank"] )
		return true;
	return false;
}

destroyUnlockMessage()
{
	if( !isDefined( self.unlockMessage ) )
		return;

	for( i = 0; i < self.unlockMessage.size; i++ )
		self.unlockMessage[i] destroy();

	self.unlockMessage = undefined;
	self.doingUnlockMessage = false;
}

initUnlockMessage()
{
	self.doingUnlockMessage = false;
	self.unlockMessageQueue = [];
}

unlockMessage( notifyData )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	if( !isDefined( self.doingUnlockMessage ))
	{
		self initUnlockMessage();
	}
	
	if ( !self.doingUnlockMessage )
	{
		self thread showUnlockMessage( notifyData );
		return;
	}
	
	self.unlockMessageQueue[ self.unlockMessageQueue.size ] = notifyData;
}

showUnlockMessage( notifyData )
{
	self endon("disconnect");

	self playLocalSound( "mp_ingame_summary" );

	self.doingUnlockMessage = true;
	self.unlockMessage = [];

	self.unlockMessage[0] = newClientHudElem( self );
	self.unlockMessage[0].x = -180;
	self.unlockMessage[0].y = 20;
	self.unlockMessage[0].alpha = 0.76;
	self.unlockMessage[0] setShader( "black", 195, 48 );
	self.unlockMessage[0].sort = 990;

	self.unlockMessage[1] = braxi\_mod::addTextHud( self, -190, 20, 1, "left", "top", 1.5 ); 
	self.unlockMessage[1] setShader( notifyData.icon, 55, 48 );
	self.unlockMessage[1].sort = 992;

	self.unlockMessage[2] = braxi\_mod::addTextHud( self, -130, 23, 1, "left", "top", 1.4 ); 
	self.unlockMessage[2].font = "objective";
	self.unlockMessage[2] setText( notifyData.title );
	self.unlockMessage[2].sort = 993;

	self.unlockMessage[3] = braxi\_mod::addTextHud( self, -130, 40, 1, "left", "top", 1.4 ); 
	self.unlockMessage[3] setText( notifyData.description );
	self.unlockMessage[3].sort = 993;

	for( i = 0; i < self.unlockMessage.size; i++ )
	{
		self.unlockMessage[i].horzAlign = "fullscreen";
		self.unlockMessage[i].vertAlign = "fullscreen";
		self.unlockMessage[i].hideWhenInMenu = true;

		self.unlockMessage[i] moveOverTime( notifyData.duration/4 );

		if( i == 1 )
			self.unlockMessage[i].x = 11.5;
		else if( i >= 2 )
			self.unlockMessage[i].x = 71;
		else
			self.unlockMessage[i].x = 10;
	}

	wait notifyData.duration *0.8;

	for( i = 0; i < self.unlockMessage.size; i++ )
	{
		self.unlockMessage[i] fadeOverTime( notifyData.duration*0.2 );
		self.unlockMessage[i].alpha = 0;
	}

	wait notifyData.duration*0.2;

	self destroyUnlockMessage();
	self notify( "unlockMessageDone" );

	if( self.unlockMessageQueue.size > 0 )
	{
		nextUnlockMessageData = self.unlockMessageQueue[0];
		
		newQueue = [];
		for( i = 1; i < self.unlockMessageQueue.size; i++ )
			self.unlockMessageQueue[i-1] = self.unlockMessageQueue[i];
		self.unlockMessageQueue[i-1] = undefined;
		
		self thread showUnlockMessage( nextUnlockMessageData );
	}
}

// x-x

_setPlayerData( what, amount )
{
	if( what == "experience" )
		self braxi\_stats::setStats( "saved_experience", amount );
	else if( what == "prestige" )
		self braxi\_stats::setStats( "saved_prestige", amount );
	
	self setPlayerData( what, amount );
}

_addPlayerData( what, amount )
{
	return self _setPlayerData( what, _getPlayerData( what ) + amount );
}

_getPlayerData( what )
{
	return self getPlayerData( what );
}