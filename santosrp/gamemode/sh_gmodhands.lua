--Thank you facepunch for this fix!

local meta = FindMetaTable("Player")

if (SERVER) then
	function meta:InitializeHands(name)
		local oldhands = self:GetHands()
		
		if (IsValid( oldhands )) then oldhands:Remove() end

		local hands = ents.Create( "gmod_hands" )
		
		if (IsValid(hands)) then
			self:SetHands( hands )
			hands:SetOwner( self )
			
			local info = player_manager.TranslatePlayerHands( name )
			
			if ( info ) then
				hands:SetModel( info.model )
				hands:SetSkin( info.skin )
				hands:SetBodyGroups( info.body )
			end

			local vm = self:GetViewModel( 0 )
			hands:AttachToViewmodel( vm )

			vm:DeleteOnRemove( hands )
			self:DeleteOnRemove( hands )

			hands:Spawn()
		end
	end
else
	function GM:PostDrawViewModel( vm, self, weapon )
		if (weapon.UseHands or !weapon:IsScripted()) then
			local hands = LocalPlayer():GetHands()
			if (IsValid(hands)) then hands:DrawModel() end
		end
	end
end