local Prop = {}
Prop.Name = "FBI Office"
Prop.Government = true
Prop.Doors = {
	Vector( -180, -2199, 522.28100585938 ),
	Vector( -316, -2207, 522.28100585938 ),
	Vector( -316, -1655, 522.28100585938 ),
	{ Pos = Vector( 59, -1752, 522 ), Locked = true },
	Vector( -61.5, -1220, 531.5 ),
	Vector( 71.5, -1220, 531.5 ),
}

GM.Property:Register( Prop )