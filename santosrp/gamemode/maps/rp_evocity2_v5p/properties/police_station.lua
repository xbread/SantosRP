local Prop = {}
Prop.Name = "Police Station"
Prop.Government = true
Prop.Doors = {
	{ Pos = Vector( -593, -1460, -373.75 ), Locked = true },
	{ Pos = Vector( -499, -1460, -373.75 ), Locked = true },
	{ Pos = Vector( -600, -1507, -373.75 ), Locked = true },
	{ Pos = Vector( -687, -1817, -373.75 ), Locked = true },
	{ Pos = Vector( -213, -2081, -373.75 ), Locked = true },
}

GM.Property:Register( Prop )