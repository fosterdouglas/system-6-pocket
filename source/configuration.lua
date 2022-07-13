menuBar = MenuBar(
	{
		{ 
			label = "◊", 
			options = {
				{
					label = "About System 6 Pocket...",
					enabled = true,
					program = function() 
						factory:createFinder(
							{
							title = "Welcome to System 6® Pocket™", 
							content = {"System 6 Pocket is a classic Macintosh System 6 \"Simulator\" for the Playdate handheld game console, \n© Panic Inc."}, 
							footer = false,
							}
						) 
					end,
				},
				{
					label = "Playdate Controls",
					enabled = true,
					program = function() 
						factory:createFinder(
							{
							title = "Playdate Controls", 
							content = {"Use  ‹  and  ›  to naviate the top menu bar \nHighlight a menu item with  ∆  and  ∇ \nPress A to launch a program \nPress B to swap programs or exit the menu bar\nHold A until visible cursor, then move window with ‹ › ∆ ∇\nHold B until cursor is visible, release to close program"}, 
							footer = false,
							}
						) 
					end,
				},
				{
					label = "Clock",
					program = function()
						if programClock ~= nil then
							programClock:removeClock()
							programClock = nil
						else
							programClock = Clock()
							programClock:displayClock(262, 23)
						end
					end,
					enabled = true
				},
				{
					label = "Calculator",
					enabled = false
				},
				{
					label = "Note Pad",
					enabled = true,
					program = function()
						factory:createNotePad()
					end,
				},
				{
					label = "Puzzle",
					enabled = true,
					program = function()
						
					end,
				},
			}
		},
		
		
		{
			label = "File", 
			options = {
				{
					label = "Open",
					enabled = false
				},
				{
					label = "Close",
					program = function()
						factory:closeActiveProgram()
					end,
					enabled = true
				},
				{
					label = "New...",
					program = function()
						Finder("Hello World", nil, true)
					end,
					enabled = true
				},
				{
					label = "Save",
					enabled = false
				},
				{
					label = "Print",
					enabled = false
				},
				{
					label = "Quit",
					enabled = false
				},
			}
		},
		{
			label = "Edit", 
			options = {
				{
					label = "Undo",
					enabled = false
				},
				{
					label = "Copy",
					enabled = false
				},
				{
					label = "Paste",
					enabled = false
				},
				{
					label = "Select All",
					enabled = false
				},
				{
					label = "Clear",
					enabled = false
				},
			}
		},
		{
			label = "View",
			options = {
				{
					label = "by Icon",
					enabled = false
				},
				{
					label = "by Small Icon",
					enabled = false
				},
				{
					label = "by Name",
					enabled = false
				},
				{
					label = "by Date",
					enabled = false
				},
				{
					label = "by Size",
					enabled = false
				},
				{
					label = "by Kind",
					enabled = false
				},
			}
		},
	}
)