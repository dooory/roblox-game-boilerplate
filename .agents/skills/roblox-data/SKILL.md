---
name: roblox-data
description: Use when changing player data, ProfileStore persistence, schema validation or migrations, DataService, DataController, or Replica data replication.
---

# Player data

- Only `DataService` touches ProfileStore. Other services call `GetData`, `Set`, `AdjustCash`, `GetReplica`, `RequestSave` and `WaitForSave`.
- Each loaded player's profile data is wrapped in a `PlayerData` replica that replicates to that player only. The replica's `Data` is the profile's data table, so a change made through the replica is saved as well as replicated.
- Change data that clients show only through the replica: `DataService:Set(player, { "Cash" }, 10)`, `DataService:AdjustCash(player, 10)`, or `DataService:GetReplica(player)` for `SetValues`, `TableInsert` and `TableRemove`. Assigning to the data table directly saves but never reaches the client. Only server bookkeeping (`SchemaVersion`, `LastSeenAt`, `Receipts`) and final writes in `PlayerReleasing` are written directly; clients must not read those fields.
- Replicated data cannot contain arrays with gaps or keys that are not strings or numbers.
- The whole data table is sent once when the player loads; after that each change sends only its path and value to the owner. `DataService:Set` skips unchanged non-table values. Keep traffic small: change the deepest path that changed rather than setting a whole table, group related changes with `SetValues`, and never change player data every frame (per-frame values belong in Packet events or client-side state).
- On the client, read data through `DataController`: `Get(path?)` returns the current value (nil until loaded), `Observe(path, callback)` calls `callback(value)` once the data loads and after every change at, above or below `path`, and returns a connection to add to a Trove. `Loaded` fires once with the data table and `IsLoaded()` checks it. Treat values from `Get` as read-only.
- Data that other players should see (leaderboards, public stats) needs its own replica with `:Replicate()`, or an attribute; never replicate another player's `PlayerData`.
- For per-player setup, connect to `DataService.PlayerLoaded(player, data)` in `Start`, not `Players.PlayerAdded` (which fires before data exists). Loading always yields, so every service that connects in `Start` sees every player, including those already in the server.
- For per-player cleanup, connect to `DataService.PlayerReleasing(player, data)`. It fires just before the session is saved and released, on leave and on shutdown. Write final state into `data` there, without yielding. `DataService` is registered first, so it is destroyed last; do not disconnect `PlayerLoaded`/`PlayerReleasing` connections in your own `Destroy`, or the shutdown release will miss you.
- Check `GetData` for nil in every handler, and never keep the data table across a yield. On the client, show data through `DataController:Observe` so nothing is shown before it loads.
- When adding a field, update `Data`, `Template` and `Validate` in `src/server/Data/PlayerData.luau` together. Add an explicit migration before changing `SchemaVersion`. Never reset progress for invalid data.
