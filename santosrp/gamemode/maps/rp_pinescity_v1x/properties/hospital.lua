local Prop = {}
Prop.Name = "Hospital"
Prop.Government = true
Prop.Doors = {
	Vector( -6317, 6953, 347 ),
	Vector( -6476.75, 6481, 347.20999145508 ),
	{ Pos = Vector( -6556, 6165, 348 ), Locked = true },
    { Pos = Vector( -6492, 6165, 348 ), Locked = true },
}

GM.Property:Register( Prop )