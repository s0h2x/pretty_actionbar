local addon = select(2,...);
addon._dir = [[Interface\AddOns\pretty_actionbar\assets\]];
addon.config = {
	-- @desc: mainbar settings
	-- @param: number of scale
	mainbars = {
		scale_actionbar = 0.9,			--; mainbar scale.
		scale_rightbar = 0.9,			--; multibar right scale (under minimap).
		scale_leftbar = 0.9,			--; multibar left scale (under minimap).
		scale_vehicle = 1,				--; vehicle artbar scale.
	},
	
	micromenu = {
	-- @desc: micromenu & bags bar
	-- @param: number, boolean
		scale_menu = 1.4,				--; scale for micromenu.
		scale_bags = 0.9,				--; scale for bags bar.
		x_position = 0,					--; x offset (negative moves menu to left side).
		y_position = -48,				--; y offset.
		hide_on_vehicle = false,		--; hide micromenu and bags if you sit on vehicle.
	},
	
	xprepbar = {
	-- @desc: offset by y-axis for XP and reputation bar, this pushes mainbar to up
	-- @param: offset number
		bothbar_offset = 39,		--; XP & reputation bar is shown.
		singlebar_offset = 24,		--; XP or reputation bar is shown.
		nobar_offset = 18,			--; XP or reputation bar not is shown.
		repbar_abovexp_offset = 16,	--; XP bar is shown, move reputation bar.
		repbar_offset = 2,			--; XP bar not is shown.
	},
	
	style = {
	-- @desc: customize art style based on blizzard texture versions
	-- @param: old, new, [flying - only for gryphons], [none - for hide]
		gryphons = 'new',	--; display style for gryphons.
		xpbar = 'new', 		--; display style for XP and reputation bar.
		bags = 'new',		--; display style for bags bar.
	},
	
	buttons = {
	-- @desc: customize button style
	-- @param: boolean and value [font flag - NONE, OUTLINE, THICKOUTLINE, MONOCHROME]
		only_actionbackground = true,								--; display empty slot background only for bottom buttons.
		petbar_grid = false,										--; display empty slots on pet bar.
		count = {
			show = true,
			position = {'BOTTOMRIGHT', 2, -1 },						--; x, y position.
			font = {addon._dir..'expressway.ttf', 14, 'OUTLINE'},	--; count font, size, flag.
		},
		hotkey = {
			show = true,
			range = true,											--; show small range indicator point on buttons.
			font = {addon._dir..'expressway.ttf', 14, ''},			--; hotkey font, size, flag.
			shadow = {0, 0, 0, 1},									--; text shadow color.
		},
		macros = {
			show = true,
			font = {addon._dir..'expressway.ttf', 14, ''},			--; macro font, size, flag.
			color = {.67, .80, .93, 1},								--; macro text color.
		},
		pages = {
			show = true,
			font = {addon._dir..'expressway.ttf', 14, ''},			--; pages font, size, flag.
		},
		cooldown = {
			show = false,											--; display cooldown text.
			position = {'BOTTOM'},									--; y position.
			font = {addon._dir..'expressway.ttf', 14, 'OUTLINE'},	--; cooldown font style.
			color = {.67, .80, .93, 1},								--; cooldown text color.
			min_duration = 3,										--; min duration for text triggering.
		},
		border_color = {1, 1, 1, 1},								--; need to reset color after showing grid.
	},
	
	additional = {
	-- @desc: settings pet, stance, totems, vehicle
	-- @param: number, boolean
		size = 27,											--; button size.
		spacing = 6,										--; space between buttons.
		y_position = 52,									--; multibar not is shown, default position.
		leftbar_offset = 90,								--; multibar left is shown, this pushes bar to up.
		rightbar_offset = 40,								--; multibar right is shown, this pushes bar to up.
		stance = {
			x_position = 0,									--; stancebar x-axis position.
		},
		pet = {
			x_position = 190,								--; petbar x-axis position.
			grid = false,									--; display empty slots on pet bar.
		},
		vehicle = {
			-- @param: artstyle: [true - like blizzard original bar arts], [false - like other bars]
			artstyle = true,								--; vehicle bar style.
			position = {'BOTTOMLEFT', -52, 0},				--; vehicle leave button position.
		},
	},

	assets = {
	-- @desc: media folder
	-- @param: path
		normal = addon._dir..'uiactionbariconframe.tga',
		highlight = addon._dir..'uiactionbariconframehighlight.tga',
	},
};