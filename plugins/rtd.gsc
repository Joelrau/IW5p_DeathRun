//
// Plugin name: Roll The Dice
// Author: quaK
//

#include braxi\_common;
#include braxi\_dvar;
#include maps\mp\gametypes\_hud_util;

init( modVersion )
{
	addDvar( "pi_rtd_enable", "plugin_rtd_enable", 1, 0, 1, "int" ); 				// 1 == enable 0 == disable
	
	if( level.dvar["pi_rtd_enable"] == 0 )
		return;
	
	level.rtd_button = "+actionslot 5";
	level.fx["wtf"] = loadFX( "explosions/aerial_explosion_large" );
	
	precacheWeapons();
	
	thread onPlayerSpawn();
}

onPlayerSpawn()
{
	while(1)
	{
		level waittill("jumper", player);
		if(player.pers["team"] == "allies")
		{
			player thread rtd_init();
			player thread rtd();
		}
		else
		{
			player thread rtd_remove();
		}
	}
}

onFreeRun()
{
	self endon("rtd_off");
	level waittill("round_freerun");
	self thread rtd_remove();
}

rtd_init()
{
	self endon("disconnect");
	self endon("death");
	self endon("rtd_off");

	if( isDefined(self.rtd_initialized) && self.rtd_initialized == true /*|| self.pers["team"] != "allies"*/ )
		return;
	
	level waittill("game started");
	
    self notifyOnPlayerCommand( "rtd_on", level.rtd_button );
	
	self.rtd_initialized = true;
}

rtd_remove()
{
	self notify("rtd_off");
}

rtd()
{
	self endon("disconnect");
	self endon("death");
	self endon("rtd_off");
	
	if( isDefined( self.rtd_rolled ) && self.rtd_rolled == true )
	{
		return;
	}
	
	level waittill("game started");
	
	self thread help_hud();
	
	self thread onFreeRun();
	
	self waittill("rtd_on");
	
	if( self.sessionstate != "playing" )
		return;
	
	msg = "^2>>^6Roll The Dice Activated^2<<";
	self thread oben(msg,(0.0, 0, 1.0));
	
	//self playLocalSound("claymore_activated");
	
	wait 4;
	
	if( self.pers["team"] == "axis" )
	{
		return;
	}
	if( self.pers["team"] == "allies" )
	{
		if( isDefined( self.finishedMap ) && self.finishedMap == true )
		{
			return;
		}
		if( level.trapsDisabled )
		{
			msg = "^2>>^6No Roll The Dice on a free run!^2<<"; if( level.dvar["pi_rtd_hudmsgs"] ) self thread unten(msg,(0.0, 0, 1.0)); else iPrintLnBold(msg);
			return;
		}
		if( !isDefined( self.rtd_rolled ) || self.rtd_rolled == false )
		{
			self thread activated();
			self.rtd_rolled = true;
			return;
		}
		else if( isDefined( self.rtd_rolled ) && self.rtd_rolled == true )
		{
			msg = "^2>>^6You have already Rolled The Dice!^2<<";
			self thread unten(msg,(0.0, 0, 1.0));
			return;
		}
	}
}

activated()
{
	r = randomIntRange(0,100);
	
	if( r >= 0 && r < 60 )
		self randomWeapon();
	else if( r >= 60 && r < 100 )
		self randomStuff();
	else
		self iPrintLnBold("Rtd fuk'd");
}

randomWeapon()
{
	weapons = getWeapons();
	r = randomIntRange(0, weapons.size);
	weapon = weapons[r];
	
	weaponName = "";
	array_weaponName = strTok(weapon, "_");
	for(i = 0; i < array_weaponName.size; i++)
	{
		if(array_weaponName[i] == "iw5")
		{
			continue;
		}
		if(array_weaponName[i] == "mp")
		{
			break;
		}
		weaponName = weaponName + array_weaponName[i];
	}
	
	self giveWeapon( weapon );
	self giveMaxAmmo( weapon );
	self switchToWeapon( weapon );
	
	msg = "^2>>^6You got weapon: ^1 " + weaponName + "^6!^2<<";
	self thread unten2(msg,(0.0, 0, 1.0));
}

getWeapons()
{
	if(!isDefined(level.rtd_weapons))
	{
raw_weapons = "iw5_44magnum_mp,iw5_usp45_mp,iw5_deserteagle_mp,iw5_mp412_mp,iw5_p99_mp,iw5_fnfiveseven_mp,iw5_fmg9_mp,iw5_skorpion_mp,iw5_mp9_mp,iw5_g18_mp,iw5_mp5_mp,iw5_m9_mp,iw5_p90_mp,iw5_pp90m1_mp,iw5_ump45_mp,iw5_mp7_mp,iw5_ak47_mp,iw5_m16_mp,iw5_m4_mp,iw5_fad_mp,iw5_acr_mp,iw5_type95_mp,iw5_mk14_mp,iw5_scar_mp,iw5_g36c_mp,iw5_cm901_mp,m320_mp,rpg_mp,iw5_smaw_mp,iw5_dragunov_mp_dragunovscope,iw5_msr_mp_msrscope,iw5_barrett_mp_barrettscope,iw5_rsass_mp_rsassscope,iw5_as50_mp_as50scope,iw5_l96a1_mp_l96a1scope,iw5_ksg_mp,iw5_1887_mp,iw5_striker_mp,iw5_aa12_mp,iw5_usas12_mp,iw5_spas12_mp,iw5_m60_mp,iw5_mk46_mp,iw5_pecheneg_mp,iw5_sa80_mp,iw5_mg36_mp,iw5_xm25_mp,iw5_ak74u_mp,iw5_cheytac_mp_cheytacscope";
		weapons = strTok(raw_weapons, ",");
		level.rtd_weapons = weapons;
	}
	return level.rtd_weapons;
}

precacheWeapons()
{
	weapons = getWeapons();
	for(i = 0; i < weapons.size; i++)
	{
		precacheItem(weapons[i]);
	}
}

randomStuff()
{
	r = randomIntRange(0,5);
	
	switch( r )
	{
		case 0:
			// WTF
			self thread wtf();
			msg = "^2>>^6You got ^1WTF?!^2<<"; self thread unten2(msg,(0.0, 0, 1.0));
		break;
		case 1:
			// Clone
			self thread Clone();
			msg = "^2>>^6You got ^3Clones^6!^2<<"; self thread unten2(msg,(0.0, 0, 1.0));
		break;
		case 2:
			// Double Health
			self thread doubleHealth();
			msg = "^2>>^6You got ^3Double ^2Health^6!^2<<"; self thread unten2(msg,(0.0, 0, 1.0));
		break;
		case 3:
			// Freeze player
			self thread freeze();
			msg = "^2>>^6You got ^4Frozen^6!^2<"; self thread unten2(msg,(0.0, 0, 1.0));
		break;
		default:
			// Nothing
			msg = "^2>>^6You got... Nothing!^2<<"; self thread unten2(msg,(0.0, 0, 1.0));
		break;
	}
}

// STUFF

wtf()
{
	self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;

	if( !isAlive(self) )
		return;
	
	playFx( level.fx["wtf"], self.origin );
	self suicide();
}

Clone()
{	
	self endon("death");
	self endon("stopclone");
	level endon( "endround" );
	
	self thread _clone_watcher();
	while(isDefined(self) && self.sessionstate == "playing")
	{
		if(self getStance() == "stand" && isDefined( self.clon ))
		{
			for(j=0;j<8;j++)
			{
				if(isDefined( self.clon[j] ))
					self.clon[j] hide();
			}
				
			self notify("newclone");
		}
		else
		{
			self notify("newclone");
			self thread hideClone();

			while(isDefined(self) && isAlive(self) && self getStance() != "stand")
				wait .05;
		}
		wait .05;
	}
}

freeze()
{
	self endon("death");
	self endon("disconnect");
	self iPrintLnBold("^1You are frozen for 10sec!");
	self freezeControls(true);
	wait(10);
	self iPrintLnBold("^1You can move now!");
	self freezeControls(false); 
}

hideClone()
{
	self endon("disconenct");
	self endon("stopclone");
	self endon("newclone");
	level endon( "endround" );
	self.clon = [];
	
	for(k=0;k<8;k++)
		self.clon[k] = self clonePlayer(10);
				
	while( isDefined(self) && self.sessionstate == "playing" )
	{
		if(isDefined(self.clon[0]))
		{
			self.clon[0].origin = self.origin + (0, 60, 0);
			self.clon[1].origin = self.origin + (-41.5, 41.5, 0);
			self.clon[2].origin = self.origin + (-60, 0, 0);
			self.clon[3].origin = self.origin + (-41.5, -41.5, 0);
			self.clon[4].origin = self.origin + (0, -60, 0);
			self.clon[5].origin = self.origin + (41.5, -41.5, 0);
			self.clon[6].origin = self.origin + (60, 0, 0);
			self.clon[7].origin = self.origin + (41.5, 41.5, 0);
			
			for(j=0;j<8;j++)
				self.clon[j].angles = self.angles;
		}
		wait .05;
	}
	
	for(i=0;i<8;i++)
	{
		if(isDefined(self.clon[i]))
			self.clon[i] delete();
	}
}
_removeClone()
{
	self notify("stopclone");
	for(i=0;i<8;i++)
	{
		if(isDefined(self.clon[i]))
			self.clon[i] delete();
	}
}
_clone_watcher()
{
	self endon("disconnect");
	self common_scripts\utility::waittill_any("death", "rtd_off");
	self _removeClone();
}

doubleHealth()
{
	self.maxhealth = self.maxhealth * 2;
	self.health = self.maxhealth;
}

//HUD

help_hud()
{
	self notify("rtdhelphud");
	self endon("rtdhelphud");
	if(isDefined(self.rtd_help_hud))
		self.rtd_help_hud destroy();
	self.rtd_help_hud = createText("default",1.5,"TOPLEFT","TOPLEFT",5,105,1,10,"Press ^2[{" + level.rtd_button + "}]^7 to Roll the Dice!");
	self.rtd_help_hud.glowAlpha = 1;
	self.rtd_help_hud.glowColor = (0,1,1);
	self.rtd_help_hud.hidewheninmenu = true;
	self thread _help_hud_watcher();
	level thread _help_hud_watcher_level(self);
}
_help_hud_watcher()
{
	self common_scripts\utility::waittill_any("death", "rtd_on", "rtd_off");
	if(isDefined(self.rtd_help_hud))
		self.rtd_help_hud destroy();
}
_help_hud_watcher_level(you)
{
	level common_scripts\utility::waittill_any("intermission", "endround");
	you rtd_remove();
}

oben(text1,glowColor)
{
	self notify("newoben");
	self endon("newoben");
	self endon("disconnect");
	
	if(isDefined(self.oben))
		self.oben destroy();
	
	self.oben = createText("default",2,"","",-200,-70,1,10,text1);
	self.oben.glowAlpha = 1;
	self.oben.glowColor = glowColor;
	//self.oben setPulseFX(20,4900,1500);
	self.oben hudmove(7,1600,0);
	wait 8;
	self.oben destroy();
}

unten(text2,glowColor)
{
	self notify("newunten");
	self endon("newunten");
	self endon("disconnect");
	
	if(isDefined(self.unten))
		self.unten destroy();
	
	self.unten = createText("default",2,"","",1200,-50,1,10,text2);
	self.unten.alignX = "right";
	self.unten.glowAlpha = 1;
	self.unten.glowColor = glowColor;
	//self.unten setPulseFX(140,4900,1500);
	self.unten hudmove(6,-1700,0);
	wait 7;
	self.unten destroy();
}

unten2(text2,glowColor)
{
	self notify("newunten2");
	self endon("newunten2");
	self endon("disconnect");
	
	if(isDefined(self.unten2))
		self.unten2 destroy();
	
	self.unten2 = self createText("default",2,"","",1000,-50,1,10,text2);
	self.unten2.alignX = "center";
	self.unten2.glowAlpha = 1;
	self.unten2.glowColor = glowColor;
	self.unten2 setPulseFX(50,4900,600);
	self.unten2 hudmove(4,-1600,0);
	wait 5;
	self.unten2 destroy();
}

hudmove(time,x,y)
{
	self moveOverTime(time);
	
	self.x += x;
	self.y += y;
}

createText(font,fontscale,align,relative,x,y,alpha  ,sort,text)
{
	self.hudText = self createFontString(font,fontscale);
	self.hudText setPoint(align,relative,x,y);
	self.hudText.alpha = alpha;
	self.hudText.sort = sort;
	self.hudText setText(text);
	return self.hudText;
}