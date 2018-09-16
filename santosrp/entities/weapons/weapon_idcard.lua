AddCSLuaFile()

SWEP.PrintName			= "ID Card"
SWEP.Author				= "Nomad"
SWEP.Purpose    		= "ID Card"
SWEP.Spawnable			= true
SWEP.UseHands			= true
SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"
SWEP.ViewModelFOV		= 54
SWEP.RenderGroup 		= RENDERGROUP_BOTH

if CLIENT then
	SWEP.PrintName = "ID Card"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	surface.CreateFont( "SRP_IDFont20", {size = 20, weight = 700, font = "Verdana"} )
	surface.CreateFont( "SRP_IDFont21", {size = 25, weight = 700, font = "Verdana"} )
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType( "camera" )
	if SERVER then return end
	
	self:InitializeSpawnIcon()
end

if CLIENT then
	function SWEP:InitializeSpawnIcon()
		self.SpawnIcon = vgui.Create( "SpawnIcon" ) 
		self.SpawnIcon:SetPos( 75, 268 )
		self.SpawnIcon:SetSize( 128, 128 )
		self.SpawnIcon:SetPaintedManually( true )
		self.SpawnIcon:SetMouseInputEnabled( false )
		self.SpawnIcon:SetModel( "models/error.mdl" )
	end
end

if SERVER then
	util.AddNetworkString( "displayID" )
else
	g_IDCardFrame = nil
	net.Receive( "displayID", function()
		local wep = LocalPlayer():GetActiveWeapon()
		local action = net.ReadBit() == 1

		if not action and ValidPanel( g_IDCardFrame ) and g_IDCardFrame:IsVisible() then
			if wep.SpawnIcon then
				wep.SpawnIcon:SetParent( nil )
			end

			g_IDCardFrame:Remove()
			return
		end

		if ValidPanel( g_IDCardFrame ) then
			g_IDCardFrame:Remove()
		end

		local person = net.ReadEntity()
		g_IDCardFrame = vgui.Create( "EditablePanel" )
		g_IDCardFrame:SetSize( 600, 420 )
		g_IDCardFrame:SetPos( 0, 0 )
		if wep.SpawnIcon then
			wep.SpawnIcon:SetParent( f )
		end
		
		function g_IDCardFrame:Paint( w, h )
			if wep and wep.drawIDInfo and IsValid( person ) then
				wep:drawIDInfo( person )
			else
				if not ValidPanel( g_IDCardFrame ) then return end
				if wep.SpawnIcon then
					wep.SpawnIcon:SetParent( nil )
				end
				g_IDCardFrame:Remove()
			end
		end
	end )
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity

	if not IsValid( ent ) or not ent:IsPlayer() or ent:GetPos():Distance( self.Owner:GetPos() ) > 200 then return end
	
	local wep = ent:GetActiveWeapon()
	if not IsValid( wep ) then return end
	
	if wep:GetClass() == self:GetClass() then
		net.Start( "displayID" )
			net.WriteBit( true )
			net.WriteEntity( ent )
		net.Send( self.Owner )
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if CLIENT then return end
	
	net.Start( "displayID" )
		net.WriteBit( false )
	net.Send( self.Owner )
end

function SWEP:OnRemove()
	if SERVER then return end
	if not IsValid( self.Owner ) then return end
	
	local vm = self.Owner:GetViewModel()
	if IsValid( vm ) then
		local BoneID = vm:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
		if BoneID then vm:ManipulateBonePosition( BoneID, Vector(0, 0, 0) ) end
	end
	
	self.SpawnIcon:Remove()
end

function SWEP:Holster()
	if CLIENT then
		local vm = self.Owner:GetViewModel()
		
		if IsValid( vm ) then
			local BoneID = vm:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
			if BoneID then vm:ManipulateBonePosition( BoneID, Vector(0, 0, 0) ) end
		end
	end
	
	return true
end

function SWEP:Deploy()
	if CLIENT then
		local vm = self.Owner:GetViewModel()
		
		if IsValid( vm ) then
			local BoneID = vm:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
			if BoneID then vm:ManipulateBonePosition( BoneID, Vector(0, 80, 0) ) end
		end
	end
	
	return true
end


local Card = Material( "materials/santosrp/hud/idcard3.png", "alphatest nocull" )
local OffPos = Vector( 27, -1, 0 )
local OffAng = Angle( 0, -90, 80 )

function SWEP:drawIDInfo( pl )
	surface.SetMaterial( Card )
	surface.SetDrawColor( color_white )
	surface.DrawTexturedRect( 0, 0, 612, 512 )

	if ValidPanel( self.SpawnIcon ) then
		self.SpawnIcon:SetPaintedManually( false )
		self.SpawnIcon:PaintManual()
		self.SpawnIcon:SetPaintedManually( true )
	end
		
	local job = GAMEMODE.Jobs:GetPlayerJob( pl )

	local license_id = GAMEMODE.Player:GetSharedGameVar( pl, "driver_license", "None" )
	local nameFirst = GAMEMODE.Player:GetSharedGameVar( pl, "name_first", pl:RealNick() )
	local nameLast = GAMEMODE.Player:GetSharedGameVar( pl, "name_last", "" )
	local gender = GAMEMODE.Player:GetSharedGameVar( pl, "char_sex", 0 )
	gender = gender == 0 and "Male" or "Female"
	job = job and job.Name or "Unknown"
	license_id = license_id ~= "" and license_id or "None"

	--Info
	draw.SimpleText(
		nameFirst,
		"SRP_IDFont21",
		180,
		188.5,
		color_white
	)
	draw.SimpleText(
		nameLast,
		"SRP_IDFont21",
		180,
		215.5,
		color_white
	)
	draw.SimpleText(
		gender,
		"SRP_IDFont20",
		302,
		265,
		color_white
	)

	draw.SimpleText(
		job,
		"SRP_IDFont20",
		345,
		284.5,
		color_white
	)
	draw.SimpleText(
		"Los Santos City",
		"SRP_IDFont20",
		278,
		305,
		color_white
	)
	draw.SimpleText(
		license_id,
		"SRP_IDFont20",
		304,
		326,
		color_white
	)
end

function SWEP:PostDrawViewModel( vm, pl, wep )
	vm:SetMaterial( nil )
	
	local Ang = vm:GetAngles()
	local Pos = vm:GetPos()
	
	local Rop = OffPos *1
	local Roa = Ang *1
	
	Roa:RotateAroundAxis( Ang:Right(), OffAng.p )
	Roa:RotateAroundAxis( Ang:Forward(), OffAng.r )
	Roa:RotateAroundAxis( Ang:Up(), OffAng.y )
	
	Rop:Rotate( Ang )
	
	if not IsValid( self.SpawnIcon ) then self:InitializeSpawnIcon() end
	self.SpawnIcon:SetModel( pl:GetModel() )

	local old = render.GetToneMappingScaleLinear()
	render.SetToneMappingScaleLinear( Vector(1, 1, 1) )
		render.SuppressEngineLighting( true )
		render.PushFilterMag( 3 )
		render.PushFilterMin( 3 )

		cam.Start3D2D( Pos +Rop, Roa, 0.0125 )
			self:drawIDInfo( pl )
		cam.End3D2D()

		render.PopFilterMag()
		render.PopFilterMin()
		render.SuppressEngineLighting( false )
	render.SetToneMappingScaleLinear( old )
end


local WOffPos = Vector( 4, 0, -4.7 )
local WOffAng = Angle( 0, -60, -90 )
function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
	local pl = self.Owner
	
	if not IsValid( pl ) then return end
	
	local ID = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
	if not ID then return end
	
	local Pos, Ang = pl:GetBonePosition( ID )
	local Rop = WOffPos *1
	local Roa = Ang *1
	
	Roa:RotateAroundAxis( Ang:Right(), WOffAng.p )
	Roa:RotateAroundAxis( Ang:Forward(), WOffAng.r )
	Roa:RotateAroundAxis( Ang:Up(), WOffAng.y )
	
	Rop:Rotate( Ang )
	
	if not IsValid( self.SpawnIcon ) then self:InitializeSpawnIcon() end
	self.SpawnIcon:SetModel( pl:GetModel() )

	local old = render.GetToneMappingScaleLinear()
	render.SetToneMappingScaleLinear( Vector(1, 1, 1) )
		render.SuppressEngineLighting( true )
		render.PushFilterMag( 3 )
		render.PushFilterMin( 3 )

		cam.Start3D2D( Pos +Rop, Roa, 0.0125 )
			self:drawIDInfo( pl )
		cam.End3D2D()

		render.PopFilterMag()
		render.PopFilterMin()
		render.SuppressEngineLighting( false )
	render.SetToneMappingScaleLinear( old )
end

function SWEP:PreDrawViewModel( vm, pl, wep )
	vm:SetMaterial( "engine/occlusionproxy" )
end