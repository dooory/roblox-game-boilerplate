---
name: roblox-purchases
description: Use when changing developer products, game passes, MarketplaceService prompts, ProcessReceipt, or purchase rewards.
---

# Purchases

`PurchaseService` owns `MarketplaceService.ProcessReceipt`. Nothing else may set it; Roblox allows only one handler.

- **Adding a developer product:** add `[productId] = function(player, services): boolean` to `src/server/Services/PurchaseService/Products.luau`. Return `true` once the reward is granted, `false` to have Roblox retry later.
- **Grants change only the player's profile data** (through `services.DataService`), such as `services.DataService:AdjustCash(player, 500)`. The receipt ID is recorded in the same profile (`Receipts`), and the purchase is confirmed only after one save contains both, so a crash cannot grant twice or lose a paid reward. Rewards outside the profile (server-wide effects) are not protected this way; ask the user before adding them.
- Grants must not yield, prompt or wait on the player: the receipt is recorded right after the grant returns, and a yield would let a save capture the reward without it. If the player has left or their data is not loaded, the purchase stays pending and Roblox retries it when they next join.
- Prompt purchases from the client with `MarketplaceService:PromptProductPurchase(player, productId)`; never grant from a client request.
- Game passes are not receipts: check ownership with `MarketplaceService:UserOwnsGamePassAsync` on the server (and on `PromptGamePassPurchaseFinished`), not in `Products`.
- The last 100 receipt IDs are kept per player.
