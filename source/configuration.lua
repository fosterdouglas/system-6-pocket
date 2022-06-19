menuBar = MenuBar(
	{
		{ 
			label = "◊", 
			options = {
				{
					label = "About System 6 Pocket...",
					program = function() 
						Finder("Welcome to System 6® Pocket™")
					end 
				},
				{
					label = "Clock"
				},
				{
					label = "Calculator"
				},
				{
					label = "Note Pad"
				},
			}
		},
		{
			label = "File", 
			options = {
				{
					label = "Open"
				},
				{
					label = "Close",
					program = function()
						closeActiveWindow()
					end
				},
				{
					label = "New...",
					program = function()
						Finder("Hello World")
					end
				},
				{
					label = "Save"
				},
				{
					label = "Print"
				},
				{
					label = "Quit"
				},
			}
		},
		{
			label = "Edit", 
			options = {
				{
					label = "Undo"
				},
				{
					label = "Copy"
				},
				{
					label = "Paste"
				},
				{
					label = "Select All"
				},
				{
					label = "Clear"
				},
			}
		},
		{
			label = "View",
			options = {
				{
					label = "by Icon"
				},
				{
					label = "by Small Icon"
				},
				{
					label = "by Name"
				},
				{
					label = "by Date"
				},
				{
					label = "by Size"
				},
				{
					label = "by Kind"
				},
			}
		},
	}
)