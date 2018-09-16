local Prop = {}
Prop.Name = "Court House"
Prop.Government = true
Prop.Doors = {
	Vector( -32, -1452, 1802 ),
	Vector( -316, -1461, 1802.2800292969 ),
	Vector( -316, -1555, 1802.2800292969 ),
	Vector( -180, -2279, 1802.2800292969 ),
	Vector( -180, -2185, 1802.2800292969 ),
	{ Pos = Vector( 59, -1752, 1802 ), Locked = true },
}

GM.Property:Register( Prop )