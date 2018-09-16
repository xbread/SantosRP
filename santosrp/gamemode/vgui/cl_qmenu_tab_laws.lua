local Panel = {}

function Panel:Init()

end



function Panel:PerformLayout( intW, intH )

    gui.OpenURL("http://www.adaptgamers.com/")

end

vgui.Register( "srp_QMenu_Laws", Panel, "EditablePanel" )
