local Prop = {}
Prop.Name = "Secret Service Office"
Prop.Government = true
Prop.Doors = {
	Vector( 14, -1452, 3849.25 ),
	Vector( -126, -1452, 3849.25 ),
	{ Pos = Vector( 59, -1752, 3849 ), Locked = true },
}

GM.Property:Register( Prop )