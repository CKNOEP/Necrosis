--[[
    Necrosis - Threat Meter
    Copyright (C) - copyright file included in this release
--]]

------------------------------------------------------------------------------------------------------
-- THREAT METER - Circular threat indicator around the main sphere
------------------------------------------------------------------------------------------------------

local _G = getfenv(0)

-- Référence au frame de l'anneau de menace (créé dans Initialize.lua)
local threatRing = nil

------------------------------------------------------------------------------------------------------
-- Fonction pour calculer la couleur du dégradé selon le pourcentage de menace
------------------------------------------------------------------------------------------------------
function Necrosis:GetThreatColor(percent)
	local r, g, b

	if percent < 33 then
		-- Vert (0%) → Orange (33%)
		-- De RGB(0,1,0) vers RGB(1,1,0)
		local ratio = percent / 33
		r = ratio
		g = 1
		b = 0
	elseif percent < 75 then
		-- Orange (33%) → Rouge (75%)
		-- De RGB(1,1,0) vers RGB(1,0,0)
		local ratio = (percent - 33) / 42
		r = 1
		g = 1 - ratio
		b = 0
	else
		-- Rouge pur (75-100%)
		r = 1
		g = 0
		b = 0
	end

	return r, g, b
end

------------------------------------------------------------------------------------------------------
-- Fonction pour mettre à jour l'anneau de menace
------------------------------------------------------------------------------------------------------
function Necrosis:UpdateThreatMeter()
	if not threatRing then
		threatRing = _G["NecrosisThreatRing"]
		if not threatRing then return end
	end

	-- Vérifier si l'option est activée
	if not NecrosisConfig.ThreatMeterEnabled then
		threatRing:Hide()
		return
	end

	-- Vérifier si en combat et avec une cible
	if not UnitAffectingCombat("player") or not UnitExists("target") then
		threatRing:Hide()
		return
	end

	-- Récupérer le pourcentage de menace détaillé
	local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")

	if not threatpct then
		threatRing:Hide()
		return
	end

	-- Calculer la couleur avec dégradé
	local r, g, b = self:GetThreatColor(threatpct)

	-- Calculer l'alpha (transparence) selon la menace
	-- 0% menace = presque invisible (0.2)
	-- 100% menace = opaque (1.0)
	local alpha = 0.2 + (threatpct / 100) * 0.8

	-- Appliquer la couleur sur tous les segments de l'anneau
	if threatRing.segments then
		for _, segment in ipairs(threatRing.segments) do
			segment:SetVertexColor(r, g, b, alpha)
		end
	end
	threatRing:Show()  -- Make the ring visible during combat

	-- Alerte à 90% (future implémentation)
	if threatpct >= 90 and not threatRing.alertShown then
		-- TODO: Ajouter message d'alerte
		threatRing.alertShown = true
	elseif threatpct < 85 then
		threatRing.alertShown = false
	end

	threatRing:Show()
end

------------------------------------------------------------------------------------------------------
-- Fonction pour créer l'anneau de menace
------------------------------------------------------------------------------------------------------
function Necrosis:CreateThreatRing()
	local mainButton = _G["NecrosisButton"]
	if not mainButton then
		print("Necrosis: Error - NecrosisButton not found for threat ring")
		return
	end

	-- Créer le frame de l'anneau (parent = mainButton pour suivre automatiquement la sphère)
	local ring = CreateFrame("Frame", "NecrosisThreatRing", mainButton)
	ring:SetFrameStrata("MEDIUM")
	ring:SetFrameLevel(mainButton:GetFrameLevel() + 2)

	-- Récupérer la taille de la sphère (sans scale car hérité du parent)
	local buttonWidth = mainButton:GetWidth() or 58
	local buttonHeight = mainButton:GetHeight() or 58
	local buttonSize = math.max(buttonWidth, buttonHeight)

	-- L'anneau doit être légèrement plus grand que la sphère
	local thickness = NecrosisConfig.ThreatRingThickness or 7
	local ringSize = buttonSize + (thickness * 2)

	ring:SetSize(ringSize, ringSize)

	-- Ancrer au centre du parent (mainButton)
	ring:ClearAllPoints()
	ring:SetPoint("CENTER", mainButton, "CENTER", 0, 0)

	-- Approche simple : créer plusieurs barres disposées en cercle pour former un anneau
	local numSegments = 120  -- Nombre de segments pour former le cercle (plus = plus lisse)
	local segmentWidth = thickness
	local segmentHeight = 8  -- Hauteur augmentée pour un cercle plus continu
	local radius = buttonSize / 2 + thickness / 2  -- Rayon du cercle

	ring.segments = {}
	for i = 1, numSegments do
		local angle = (i / numSegments) * 360
		local segment = ring:CreateTexture(nil, "OVERLAY")
		segment:SetTexture("Interface\\Buttons\\WHITE8X8")
		segment:SetSize(segmentWidth, segmentHeight)
		segment:SetVertexColor(0, 1, 0, 0)  -- Vert, invisible au départ

		-- Calculer la position en coordonnées polaires
		local rad = math.rad(angle)
		local x = radius * math.cos(rad)
		local y = radius * math.sin(rad)

		segment:SetPoint("CENTER", ring, "CENTER", x, y)
		segment:SetRotation(math.rad(angle + 90))  -- Rotation pour suivre le cercle

		table.insert(ring.segments, segment)
	end

	ring.outerTexture = ring.segments[1]  -- Pour compatibilité avec le code existant

	ring:Hide()  -- Masqué par défaut (hors combat)
	ring.alertShown = false

	threatRing = ring

	return ring
end

------------------------------------------------------------------------------------------------------
-- Fonction pour mettre à jour l'épaisseur de l'anneau
------------------------------------------------------------------------------------------------------
function Necrosis:UpdateThreatRingThickness()
	if not threatRing then return end

	local mainButton = _G["NecrosisButton"]
	if not mainButton then return end

	-- Récupérer la taille de la sphère (sans scale car hérité du parent)
	local buttonWidth = mainButton:GetWidth() or 58
	local buttonHeight = mainButton:GetHeight() or 58
	local buttonSize = math.max(buttonWidth, buttonHeight)

	-- Calculer la nouvelle taille de l'anneau
	local thickness = NecrosisConfig.ThreatRingThickness or 7
	local ringSize = buttonSize + (thickness * 2)
	local radius = buttonSize / 2 + thickness / 2

	-- Redimensionner le frame principal
	threatRing:SetSize(ringSize, ringSize)

	-- Mettre à jour la taille et position de chaque segment
	if threatRing.segments then
		local numSegments = #threatRing.segments
		for i, segment in ipairs(threatRing.segments) do
			segment:SetSize(thickness, 8)

			-- Recalculer la position
			local angle = (i / numSegments) * 360
			local rad = math.rad(angle)
			local x = radius * math.cos(rad)
			local y = radius * math.sin(rad)

			segment:ClearAllPoints()
			segment:SetPoint("CENTER", threatRing, "CENTER", x, y)
		end
	end

	-- Forcer une mise à jour visuelle
	self:UpdateThreatMeter()
end

------------------------------------------------------------------------------------------------------
-- Event handler pour la mise à jour de la menace
------------------------------------------------------------------------------------------------------
local threatFrame = CreateFrame("Frame")
threatFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
threatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")  -- Enter combat
threatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")   -- Leave combat
threatFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

threatFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		-- Sortie de combat : masquer l'anneau
		if threatRing then
			threatRing:Hide()
		end
	else
		-- Mise à jour de la menace
		Necrosis:UpdateThreatMeter()
	end
end)

-- Mise à jour périodique (toutes les 0.2 secondes en combat)
threatFrame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.2 then
		self.elapsed = 0
		if UnitAffectingCombat("player") and NecrosisConfig.ThreatMeterEnabled then
			Necrosis:UpdateThreatMeter()
		end
	end
end)
