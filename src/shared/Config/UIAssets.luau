--!strict

export type Asset = {
	Id: string,
	Aspect: number,
}

local Icons: { [string]: Asset } = {}
local Art: { [string]: Asset } = {}

return table.freeze({
	Icons = table.freeze(Icons),
	Art = table.freeze(Art),
})
