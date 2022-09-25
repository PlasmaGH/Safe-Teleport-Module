# Safe-Teleport-Module
A safe module for teleporting players from place to place in Roblox.

---

## Examples:

### Loading on Client:
> To load on the client, simply load the module.
(everything will be pre-setup)
```lua
require(...)
```

`safeTeleport` is for server use only.

### Using on Server:
> Teleport the player by calling the "`safeTeleport`" command.
> Returns boolean : Teleport Success

```lua
local module = require(...);
module.safeTeleport(player, placeID, teleportData)
```
