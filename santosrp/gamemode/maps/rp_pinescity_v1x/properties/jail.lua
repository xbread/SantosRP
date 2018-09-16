local Prop = {}
Prop.Name = "Jail"
Prop.Government = true
Prop.Doors = {
    { Pos = Vector( -8463, 10425, -720 ), Locked = true },
    { Pos = Vector( -8463, 10519, -720 ), Locked = true },
    { Pos = Vector( -8135, 10425, -720 ), Locked = true },
    { Pos = Vector( -8135, 10519, -720 ), Locked = true },
    { Pos = Vector( -8189, 10404.59375, -720 ), Locked = true },
}

GM.Property:Register( Prop )