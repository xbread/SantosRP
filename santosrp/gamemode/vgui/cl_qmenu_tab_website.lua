local Panel = {}

function Panel:Init()

end

function Panel:PerformLayout( intW, intH )

    gui.OpenURL("http://cosmicgaming.net")

end

vgui.Register( "srp_QMenu_Website", Panel, "EditablePanel" )
