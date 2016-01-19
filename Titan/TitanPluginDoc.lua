--[[ File
NAME: DocTitanPlugin.lua
DESC: This file contains documentation of Titan to assist a developer.
:DESC
--]]
--[[ API
NAME: Titan API overview for developers
DESC: Updated Dec 2011

This documentation is intended for addon developers that wish to create a Titan plugin.

Terms:
Throughout the documentation and naming of routines and variables there are some terms that are used interchangably.
- Plugin / button / frame 
- Character / player / toon
- Plugin ID / plugin name
Over time we desire to consolidate terms but it may take time.

Plugin Types:
Titan allows two types of plugins:
- Titan native
- LDB enabled addons
See http://code.google.com/p/titanpanel/downloads/list to download examples.

Titan Plugin Recognition:
Titan native plugins must use one of the Titan templates found in TitanPanelTemplates.xml. 

LDB Plugin Recognition:
LDB enabled addons only need to adhere to the LDB (Lib Data Broker) 1.1 spec.
Titan uses the callback feature ("LibDataBroker_DataObjectCreated") to recognize LDB addons. 
At player_login Titan registers the call back. 
It then loops through the the LDB objects using :DataObjectIterator().
When any LDB object is found Titan will attempt to create a Titan native plugin for display.

Registration Steps:
Titan attempts to register each plugin it recognizes. Registration for Titan is a two step process. 
Step one: On the creation of a Titan plugin frame place the plugin in a holding table until the "Player Entering World" (PEW) event is fired.
Step two: Once Titan is initialized it will take each plugin from this table and attempt to register it for display. The attempt uses a protected call (pcall) to protect the Titan core and (hopefully) prevents Titan from crashing.

Registration Attempts:
Each plugin attempt is placed in an 'attempted' table along with the results of the registration. This attempted table is accessible to the user in the Titan "Attempted" options. The developer can see what happened and users can report issues using that data.

Registry Table of Each Plugin:
Each plugin must contain a table called "registry".
   self.registry = {}

The registry table must have a unique id across all Titan plugins that are loaded.
   self.registry = {id = "MyPlugin"}
This is all that is required for successful registration. It will register but will be a rather dull plugin.
It is strongly recommended that you download the TitanStarter plugin example(see the link above). The example explains all the elements of the registry that Titan uses. The example is based on TitanBags so you can play with the code and compare it to a supported plugin.

Titan API:
The functions that Titan offers to the plugin developer are in a separate document. Within the Titan files you can recognize an API routine by the comment just before the function declaration. The comment block will have "API" as part of the starting block.
:DESC
--]]