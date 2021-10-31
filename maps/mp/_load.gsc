main()
{
    if ( isdefined( level._loadStarted ) )
        return;

    level._loadStarted = 1;
    level.createFX_enabled = getdvar( "createfx" ) != "";
    common_scripts\utility::struct_class_init();
    maps\mp\_utility::initGameFlags();
    maps\mp\_utility::initLevelFlags();
    level.generic_index = 0;
    level.flag_struct = spawnstruct();
    level.flag_struct common_scripts\utility::assign_unique_id();

    if ( !isdefined( level.flag ) )
    {
        level.flag = [];
        level.flags_lock = [];
    }

    level.requiredMapAspectRatio = getdvarfloat( "scr_RequiredMapAspectratio", 1 );
    level.createClientFontString_func = maps\mp\gametypes\_hud_util::createFontString;
    level.HUDsetPoint_func = maps\mp\gametypes\_hud_util::setPoint;
    level.leaderDialogOnPlayer_func = maps\mp\_utility::leaderDialogOnPlayer;
    //thread maps\mp\gametypes\_tweakables::init();

    if ( !isdefined( level.func ) )
        level.func = [];

    level.func["precacheMpAnim"] = ::precachempanim;
    level.func["scriptModelPlayAnim"] = ::scriptmodelplayanim;
    level.func["scriptModelClearAnim"] = ::scriptmodelclearanim;

    if ( !level.createFX_enabled )
    {
        thread maps\mp\_minefields::minefields();
        thread maps\mp\_radiation::radiation();
        thread maps\mp\_shutter::main();
        thread maps\mp\_destructables::init();
        thread common_scripts\_elevator::init();
        thread common_scripts\_dynamic_world::init();
        thread common_scripts\_destructible::init();
        thread common_scripts\_pipes::main();
    }

    if ( getmapcustom( "thermal" ) == "invert" )
    {
        game["thermal_vision"] = "thermal_snowlevel_mp";
        setthermalbodymaterial( "thermalbody_snowlevel" );
    }
    else
        game["thermal_vision"] = "thermal_mp";

    visionsetnaked( "", 0 );
    visionsetnight( "default_night_mp" );
    visionsetmissilecam( "missilecam" );
    visionsetthermal( game["thermal_vision"] );
    visionsetpain( "near_death_mp", 0 );
    var_0 = getentarray( "lantern_glowFX_origin", "targetname" );

    for ( var_1 = 0; var_1 < var_0.size; var_1++ )
        var_0[var_1] thread lanterns();

    maps\mp\_audio::init_audio();
    maps\mp\_art::main();
    setupExploders();
    thread common_scripts\_fx::initFX();

    if ( level.createFX_enabled )
        maps\mp\_createfx::createFX();

    if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
    {
        maps\mp\gametypes\_spawnlogic::setMapCenterForReflections();
        maps\mp\_global_fx::main();
        level waittill( "eternity" );
    }

    thread maps\mp\_global_fx::main();

    for ( var_2 = 0; var_2 < 6; var_2++ )
    {
        switch ( var_2 )
        {
            case 0:
                var_3 = "trigger_multiple";
                break;
            case 1:
                var_3 = "trigger_once";
                break;
            case 2:
                var_3 = "trigger_use";
                break;
            case 3:
                var_3 = "trigger_radius";
                break;
            case 4:
                var_3 = "trigger_lookat";
                break;
            default:
                var_3 = "trigger_damage";
                break;
        }

        var_4 = getentarray( var_3, "classname" );

        for ( var_1 = 0; var_1 < var_4.size; var_1++ )
        {
            if ( isdefined( var_4[var_1].script_prefab_exploder ) )
                var_4[var_1].script_exploder = var_4[var_1].script_prefab_exploder;

            if ( isdefined( var_4[var_1].script_exploder ) )
                level thread exploder_load( var_4[var_1] );
        }
    }

    var_5 = getentarray( "trigger_hurt", "classname" );

    //foreach ( var_7 in var_5 )
    //    var_7 thread hurtPlayersThink();

    thread maps\mp\_animatedmodels::main();
    level.func["damagefeedback"] = maps\mp\gametypes\_damagefeedback::updateDamageFeedback;
    level.func["setTeamHeadIcon"] = maps\mp\_entityheadicons::setTeamHeadIcon;
    level.laserOn_func = ::laseron;
    level.laserOff_func = ::laseroff;
    setdvar( "sm_sunShadowScale", 1 );
    setdvar( "sm_spotLightScoreModelScale", 0 );
    setdvar( "r_specularcolorscale", 2.5 );
    setdvar( "r_diffusecolorscale", 1 );
    setdvar( "r_lightGridEnableTweaks", 0 );
    setdvar( "r_lightGridIntensity", 1 );
    setdvar( "r_lightGridContrast", 0 );
    setupDestructibleKillCamEnts();
    precacheitem( "bomb_site_mp" );
    level.fauxVehicleCount = 0;
}

exploder_load( var_0 )
{
    level endon( "killexplodertridgers" + var_0.script_exploder );
    var_0 waittill( "trigger" );

    if ( isdefined( var_0.script_chance ) && randomfloat( 1 ) > var_0.script_chance )
    {
        if ( isdefined( var_0.script_delay ) )
            wait(var_0.script_delay);
        else
            wait 4;

        level thread exploder_load( var_0 );
        return;
    }

    common_scripts\utility::exploder( var_0.script_exploder );
    level notify( "killexplodertridgers" + var_0.script_exploder );
}

setupExploders()
{
    var_0 = getentarray( "script_brushmodel", "classname" );
    var_1 = getentarray( "script_model", "classname" );

    for ( var_2 = 0; var_2 < var_1.size; var_2++ )
        var_0[var_0.size] = var_1[var_2];

    for ( var_2 = 0; var_2 < var_0.size; var_2++ )
    {
        if ( isdefined( var_0[var_2].script_prefab_exploder ) )
            var_0[var_2].script_exploder = var_0[var_2].script_prefab_exploder;

        if ( isdefined( var_0[var_2].script_exploder ) )
        {
            if ( var_0[var_2].model == "fx" && ( !isdefined( var_0[var_2].targetname ) || var_0[var_2].targetname != "exploderchunk" ) )
            {
                var_0[var_2] hide();
                continue;
            }

            if ( isdefined( var_0[var_2].targetname ) && var_0[var_2].targetname == "exploder" )
            {
                var_0[var_2] hide();
                var_0[var_2] notsolid();
                continue;
            }

            if ( isdefined( var_0[var_2].targetname ) && var_0[var_2].targetname == "exploderchunk" )
            {
                var_0[var_2] hide();
                var_0[var_2] notsolid();
            }
        }
    }

    var_3 = [];
    var_4 = getentarray( "script_brushmodel", "classname" );

    for ( var_2 = 0; var_2 < var_4.size; var_2++ )
    {
        if ( isdefined( var_4[var_2].script_prefab_exploder ) )
            var_4[var_2].script_exploder = var_4[var_2].script_prefab_exploder;

        if ( isdefined( var_4[var_2].script_exploder ) )
            var_3[var_3.size] = var_4[var_2];
    }

    var_4 = getentarray( "script_model", "classname" );

    for ( var_2 = 0; var_2 < var_4.size; var_2++ )
    {
        if ( isdefined( var_4[var_2].script_prefab_exploder ) )
            var_4[var_2].script_exploder = var_4[var_2].script_prefab_exploder;

        if ( isdefined( var_4[var_2].script_exploder ) )
            var_3[var_3.size] = var_4[var_2];
    }

    var_4 = getentarray( "item_health", "classname" );

    for ( var_2 = 0; var_2 < var_4.size; var_2++ )
    {
        if ( isdefined( var_4[var_2].script_prefab_exploder ) )
            var_4[var_2].script_exploder = var_4[var_2].script_prefab_exploder;

        if ( isdefined( var_4[var_2].script_exploder ) )
            var_3[var_3.size] = var_4[var_2];
    }

    if ( !isdefined( level.createFXent ) )
        level.createFXent = [];

    var_5 = [];
    var_5["exploderchunk visible"] = 1;
    var_5["exploderchunk"] = 1;
    var_5["exploder"] = 1;

    for ( var_2 = 0; var_2 < var_3.size; var_2++ )
    {
        var_6 = var_3[var_2];
        var_7 = common_scripts\utility::createExploder( var_6.script_fxid );
        var_7.v = [];
        var_7.v["origin"] = var_6.origin;
        var_7.v["angles"] = var_6.angles;
        var_7.v["delay"] = var_6.script_delay;
        var_7.v["firefx"] = var_6.script_firefx;
        var_7.v["firefxdelay"] = var_6.script_firefxdelay;
        var_7.v["firefxsound"] = var_6.script_firefxsound;
        var_7.v["firefxtimeout"] = var_6.script_firefxtimeout;
        var_7.v["earthquake"] = var_6.script_earthquake;
        var_7.v["damage"] = var_6.script_damage;
        var_7.v["damage_radius"] = var_6.script_radius;
        var_7.v["soundalias"] = var_6.script_soundalias;
        var_7.v["repeat"] = var_6.script_repeat;
        var_7.v["delay_min"] = var_6.script_delay_min;
        var_7.v["delay_max"] = var_6.script_delay_max;
        var_7.v["target"] = var_6.target;
        var_7.v["ender"] = var_6.script_ender;
        var_7.v["type"] = "exploder";

        if ( !isdefined( var_6.script_fxid ) )
            var_7.v["fxid"] = "No FX";
        else
            var_7.v["fxid"] = var_6.script_fxid;

        var_7.v["exploder"] = var_6.script_exploder;

        if ( !isdefined( var_7.v["delay"] ) )
            var_7.v["delay"] = 0;

        if ( isdefined( var_6.target ) )
        {
            var_8 = getent( var_7.v["target"], "targetname" ).origin;
            var_7.v["angles"] = vectortoangles( var_8 - var_7.v["origin"] );
        }

        if ( var_6.classname == "script_brushmodel" || isdefined( var_6.model ) )
        {
            var_7.model = var_6;
            var_7.model.disconnect_paths = var_6.script_disconnectpaths;
        }

        if ( isdefined( var_6.targetname ) && isdefined( var_5[var_6.targetname] ) )
            var_7.v["exploder_type"] = var_6.targetname;
        else
            var_7.v["exploder_type"] = "normal";

        var_7 common_scripts\_createfx::post_entity_creation_function();
    }
}

lanterns()
{
    if ( !isdefined( level._effect["lantern_light"] ) )
        level._effect["lantern_light"] = loadfx( "props/glow_latern" );

    common_scripts\_fx::loopfx( "lantern_light", self.origin, 0.3, self.origin + ( 0, 0, 1 ) );
}

hurtPlayersThink()
{
    level endon( "game_ended" );
    wait(randomfloat( 1.0 ));

    for (;;)
    {
        foreach ( var_1 in level.players )
        {
            if ( var_1 istouching( self ) && maps\mp\_utility::isReallyAlive( var_1 ) )
                var_1 maps\mp\_utility::_suicide();
        }

        wait 0.5;
    }
}

setupDestructibleKillCamEnts()
{
    var_0 = getentarray( "destructible_vehicle", "targetname" );

    foreach ( var_2 in var_0 )
    {
        switch ( getdvar( "mapname" ) )
        {
            case "mp_interchange":
                if ( var_2.origin[2] > 150.0 )
                    continue;

                break;
        }

        var_3 = var_2.origin + ( 0, 0, 5 );
        var_4 = var_2.origin + ( 0, 0, 128 );
        var_5 = bullettrace( var_3, var_4, 0, var_2 );
        var_2.killCamEnt = spawn( "script_model", var_5["position"] );
        var_2.killCamEnt.targetname = "killCamEnt_destructible_vehicle";
        var_2.killCamEnt setscriptmoverkillcam( "explosive" );
        var_2 thread deleteDestructibleKillCamEnt();
    }

    var_7 = getentarray( "destructible_toy", "targetname" );

    foreach ( var_2 in var_7 )
    {
        var_3 = var_2.origin + ( 0, 0, 5 );
        var_4 = var_2.origin + ( 0, 0, 128 );
        var_5 = bullettrace( var_3, var_4, 0, var_2 );
        var_2.killCamEnt = spawn( "script_model", var_5["position"] );
        var_2.killCamEnt.targetname = "killCamEnt_destructible_toy";
        var_2.killCamEnt setscriptmoverkillcam( "explosive" );
        var_2 thread deleteDestructibleKillCamEnt();
    }

    var_10 = getentarray( "explodable_barrel", "targetname" );

    foreach ( var_2 in var_10 )
    {
        var_3 = var_2.origin + ( 0, 0, 5 );
        var_4 = var_2.origin + ( 0, 0, 128 );
        var_5 = bullettrace( var_3, var_4, 0, var_2 );
        var_2.killCamEnt = spawn( "script_model", var_5["position"] );
        var_2.killCamEnt.targetname = "killCamEnt_explodable_barrel";
        var_2.killCamEnt setscriptmoverkillcam( "explosive" );
        var_2 thread deleteDestructibleKillCamEnt();
    }
}

deleteDestructibleKillCamEnt()
{
    level endon( "game_ended" );
    var_0 = self.killCamEnt;
    var_0 endon( "death" );
    self waittill( "death" );
    wait 10;

    if ( isdefined( var_0 ) )
        var_0 delete();
}
