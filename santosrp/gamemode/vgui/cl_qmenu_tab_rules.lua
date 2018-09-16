local Panel = {}

function Panel:Init()

end



function Panel:PerformLayout( intW, intH )

    gui.OpenURL("http://www.adaptgamers.com/")

end

vgui.Register( "SRPQMenu_Rules", Panel, "EditablePanel" )
