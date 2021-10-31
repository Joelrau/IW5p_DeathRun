init( modVersion )
{
    setDvarIfUninitialized( "healthbar_enable", 1);				// Enabled?
    setDvarIfUninitialized( "healthbar_counter", 1 );			// Health: 100
    setDvarIfUninitialized( "healthbar_color", 1 );				// change color: full = green; low = red
	setDvarIfUninitialized( "healthbar_background", 0 );		// show background or not
	
	if( !getDvarInt("healthbar_enable") )
		return;

    precacheShader( "white" );

    while(1)
    {
        level waittill( "player_spawned", player );

        player thread CreateHealthBar();
        player thread RemoveHealthbarOn( "death" );
        player thread RemoveHealthbarOn( "disconnect" );
		player thread RemoveHealthbarOnLevel( "intermission" );
    }
}

CreateHealthBar()
{
    wait 0.05;
    self RemoveHealthBar();
	
	hb_xAlign = "center";
	hb_yAlign = "bottom";
	hb_horzAlign = "center_adjustable";
	hb_vertAlign = "bottom_adjustable";
	hb_xOffset = 0;
	hb_yOffset = -25;
	hb_shaderWidth = 100;
	hb_textXOffset = 0;
		
	
	if( getDvarInt("healthbar_background") )
	{
		self.hb_bg = NewClientHudElem( self );
		self.hb_bg.alignX = hb_xAlign;
		self.hb_bg.alignY = hb_yAlign;
		self.hb_bg.horzalign = hb_horzAlign;
		self.hb_bg.vertalign = hb_vertAlign;
		self.hb_bg.x = hb_xOffset;
		self.hb_bg.y = hb_yOffset;
		self.hb_bg.alpha = 1;
		self.hb_bg.color = (0,0,0);
		self.hb_bg.foreground = false;
		self.hb_bg.hideWhenInMenu = true;
		self.hb_bg setShader( "white", hb_shaderWidth, 16 );

		self.hb_fg = NewClientHudElem( self );
		self.hb_fg.alignX = hb_xAlign;
		self.hb_fg.alignY = hb_yAlign;
		self.hb_fg.horzalign = hb_horzAlign;
		self.hb_fg.vertalign = hb_vertAlign;
		self.hb_fg.x = hb_xOffset;
		self.hb_fg.y = hb_yOffset-1;
		self.hb_fg.alpha = 1;
		self.hb_fg.color = (0,1,0);
		self.hb_fg.foreground = true;
		self.hb_fg.hideWhenInMenu = true;
		self.hb_fg setShader( "white", hb_shaderWidth, 14 );
		
		hb_textXOffset = hb_xOffset + (hb_shaderWidth / 2) - 30;
	}

    if( getDvarInt("healthbar_counter") )
    {
        self.hb_value = NewClientHudElem( self );
        self.hb_value.alignX = hb_xAlign;
        self.hb_value.alignY = hb_yAlign;
        self.hb_value.horzalign = hb_horzAlign;
        self.hb_value.vertalign = hb_vertAlign;
        self.hb_value.x = hb_textXOffset;
        self.hb_value.y = hb_yOffset;
        self.hb_value.font = "default";
        self.hb_value.fontscale = 1.4;
        self.hb_value.alpha = 1;
        self.hb_value.foreground = true;
        self.hb_value.color = (1,1,1);
        self.hb_value.glowalpha = 1;
        self.hb_value.glowcolor = (0,1,0);
        self.hb_value.hideWhenInMenu = true;
        self.hb_value.label = &"Health: &&1";
        self.hb_value setValue( self.health );
    }

    while(1)
    {
        wait 0.1;
		
		if( isDefined(self.hb_fg) )
		{
			self.hb_fg ScaleOverTime( 0.2, int(self.health/self.maxhealth*hb_shaderWidth), 14 );
			if( getDvarInt("healthbar_color") )
				self.hb_fg.color = (1-(self.health/self.maxhealth),self.health/self.maxhealth,0);
		}
		
		if( isDefined( self.hb_value ) )
		{
            self.hb_value setValue( self.health );
			self.hb_value.glowcolor = (1-(self.health/self.maxhealth),self.health/self.maxhealth,0);
		}
    }
}

RemoveHealthbarOn( until )
{
    if( !isDefined( until ) || until == "" || until == " " || !isDefined( self ) || !isPlayer( self ) )
        return;

    self waittill( until );
    self thread RemoveHealthbar();
}

RemoveHealthbarOnLevel( until )
{
    if( !isDefined( until ) || until == "" || until == " " )
        return;

    level waittill( until );
    self thread RemoveHealthbar();
}

RemoveHealthBar()
{
    if( !isDefined( self ) || !isPlayer( self ) )
        return;

    if( isDefined( self.hb_bg ) )
        self.hb_bg destroy();

    if( isDefined( self.hb_fg ) )
        self.hb_fg destroy();

    if( isDefined( self.hb_value ) )
        self.hb_value destroy();
}