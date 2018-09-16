local Prop = {}
Prop.Name = "City Hall"
Prop.Government = true
Prop.Doors = {
	Vector( -772.36999511719, -1452, 138 ),
	Vector( -675.63000488281, -1452, 138 ),
	Vector( -492.36999511719, -1452, 138 ),
	Vector( -395.63000488281, -1452, 138 ),
	{ Pos = Vector( 59, -1752, 130 ), Locked = true },
}

GM.Property:Register( Prop )