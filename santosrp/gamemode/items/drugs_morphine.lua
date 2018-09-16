--[[
	Name: drugs_morphine.lua
	For: TalosLife
	By: TalosLife
]]--

--[[ Morphine Effect ]]--
local drugEffect = {}
drugEffect.Name = "morphine"
drugEffect.NiceName = "Morphine"
drugEffect.MaxPower = 7

function drugEffect:OnStart( pPlayer )
	if SERVER then
		--[[if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) > self.MaxPower *0.5 then
			if math.random( 1, 2 ) == 1 then
				self:MakePlayerVomit( pPlayer )
			end
		end]]--

		if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) >= self.MaxPower then
			if not pPlayer:IsUncon() then
				pPlayer:GoUncon()
			end
		end
	end
end

function drugEffect:Think( pPlayer )
	if CLIENT then return end

--[[	if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) > self.MaxPower *0.25 then
		if not pPlayer.m_intLastRandomVomit then
			pPlayer.m_intLastRandomVomit = CurTime() +math.random( 5, 10 )
		end

		if CurTime() > pPlayer.m_intLastRandomVomit then
			local offset = self.MaxPower *0.25
			local scalar = Lerp( (GAMEMODE.Drugs:GetPlayerEffectPower(pPlayer, self.Name) -offset) /(self.MaxPower -offset), 1, 0.33 )
			pPlayer.m_intLastRandomVomit = CurTime() +math.random( 60 *scalar, 120 *scalar )
			self:MakePlayerVomit( pPlayer )
		end
	end]]--
end

function drugEffect:OnStop( pPlayer )
	if CLIENT then return end
	
	--[[if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) <= self.MaxPower *0.25 then
		pPlayer.m_intLastRandomVomit = nil
	end]]--
end

--[[local randomSounds = {
	Sound( "npc/zombie/zombie_pain1.wav" ),
	Sound( "npc/zombie/zombie_pain3.wav" ),
	Sound( "npc/barnacle/barnacle_die1.wav" ),
}
function drugEffect:MakePlayerVomit( pPlayer )
	if not pPlayer:Alive() or pPlayer:IsRagdolled() then return end
	
	local snd = table.Random( randomSounds )
	pPlayer:EmitSound( snd )

	timer.Create( ("effect_vomit_%p"):format(pPlayer), 0.1, 10, function()
		if not IsValid( pPlayer ) or not pPlayer:Alive() then return end
		
		local effectData = EffectData()
		effectData:SetOrigin( pPlayer:GetShootPos() +(pPlayer:EyeAngles():Forward() *8) )
		effectData:SetNormal( pPlayer:GetAimVector() )
		util.Effect( "vomitSpray", effectData )
		pPlayer:ViewPunch( Angle(10, 0, 0) )
	end )
end]]--

if CLIENT then
	local drugColor = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}

	function drugEffect:RenderScreenspaceEffects()
		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )

		drugColor["$pp_colour_colour"] = Lerp( pow /self.MaxPower *2, 1, 1.2 )
		DrawColorModify( drugColor )
		DrawToyTown( Lerp(pow /self.MaxPower, 1, 5), ScrH() *Lerp(pow /self.MaxPower, 0.5, 1) )
	end

	function drugEffect:GetMotionBlurValues( intW, intH, intForward, intRot )
		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )
		local speed = Lerp( pow /self.MaxPower, 0.5, 1.5 )
		local strength = Lerp( pow /self.MaxPower, 0.01, 0.05 )
		intRot = intRot +math.sin( CurTime() *speed ) *strength

		return intW, intH, intForward, intRot
	end
end
GM.Drugs:RegisterEffect( drugEffect )