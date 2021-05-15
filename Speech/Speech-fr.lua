--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

function Necrosis:Localization_Speech_Fr()

	self.Speech.TP = {
		[0] = {
			"<after>Invocation en cours, cliquez sur le portail svp",
		},
		[1] = {
			"<after>Taxi des Arcanes ! Cliquez sur le portail svp !",
		},
		[2] = {
			"<after>Bienvenue, sur le vol de ~Succube Air Lines~ \195\160 destination de <player>...",
			"<after>Les h\195\180tesses et leur fouet sont \195\160 votre disposition durant le trajet",
		},
		[3] = {
			"<after>Si vous ne voulez pas qu'une cr\195\169ature tentaculaire, glaireuse et asthmatique sorte de ce portail, cliquez dessus au plus vite !",
		},
		[4] = {
			"<after>Si vous cliquez sur le portail, on commencera \195\160 jouer plus vite...",
		},
		[5] = {
			"Tel un lapin dans un chapeau de mage, nous allons faire appara\195\174tre devant vos yeux \195\169bahis...",
			"<after>Et hop.",
		},
		[6] = {
			"PAR ASTAROTH ET DASMODES, JE T'INVOQUE, O TOUT PUISSANT DEMON DES SEPTS ENFERS, PARANGON VELU DES INFRA MONDES DEMONIAQUES, PAR LA PUISSANCE DU SCEAU ANCESTR... euh ?!? Je crois qu'il y a un probl\195\168me l\195\160...",
			"<after>Ah ben non...",
		},
	}

	self.Speech.Rez = {
		[0] = {
			"<after>--> <target> est prot\195\169g\195\169 par une pierre d'\195\162me <--",
		},
		[1] = {
			"<after>Si ca vous tente un suicide collectif, <target> s'en fout, la pierre d'\195\162me lui permettra de se relever",
		},
		[2] = {
			"<after><target> peut partir siroter un caf\195\169, et pourra se relever du wipe qui s'en suivra gr\195\162ce \195\160 sa pierre d'\195\162me",
		},
		[3] = {
			"<after>Pierre pos\195\169e sur <target>, vous pouvez recommencer \195\160 faire n'importe quoi sans risque",
		},
		[4] = {
			"<after>Gr\195\162ce \195\160 sa pierre d'\195\162me, <target> est pass\195\169 en mode Easy wipe",
		},
		[5] = {
			"<after><target> peut d\195\169sormais revenir d'entre les morts, histoire d'organiser le prochain wipe",
		},
		[6] = {
			"<after>Les hindous croient \195\160 l'immortalit\195\169, <target> aussi depuis que je lui ai pos\195\169 une pierre d'\195\162me",
		},
		[7] = {
			"Ne bougeons plus !",
			"<after><target> est d\195\169sormais \195\169quip\195\169 de son kit de survie temporaire.",
		},
		[8] = {
			"<after>Tel le ph\195\169nix, <target> pourra revenir d'entre les flammes de l'enfer (Faut dire aussi qu'il a beaucoup de rf...)",
		},
		[9] = {
			"<after>Gr\195\162ce \195\160 sa pierre d'\195\162me, <target> peut de nouveau faire n'importe quoi.",
		},
		[10] = {
			"<after>Sur <target> poser une belle pierre d'\195\162me,",
			"<after>Voil\195\160 qui peut ma foi \195\169viter bien des drames !",
		},
	}
	
	self.Speech.RoS = {
		[1] = {
			"Utilisons donc les \195\162mes de nos ennemis, pour nous redonner la vie !",
		},
		[2] = {
			"Votre \195\162me, mon \195\162me, leur \195\162me... Quelle importance ? Allez, piochez-en juste une !",
		},
	}

	self.Speech.ShortMessage = {
		{{"<after>--> <target> est prot\195\169g\195\169 par une pierre d'\195\162me <--"}},
		{{"<after><TP> Invocation en cours, cliquez sur le portail svp <TP>"}},
		{{"Rassembler un rituel des \195\162mes"}}
	}

	self.Speech.Demon = {
		-- Diablotin
		[1] = {
			[1] = {
				"Bon, s\195\162le petite peste de Diablotin, tu arr\195\170tes de bouder et tu viens m'aider ! ET C'EST UN ORDRE !",
			},
			[2] = {
				"<pet> ! AU PIED ! TOUT DE SUITE !",
			},
			[3] = {
				"Attendez, je sors mon briquet !",
			},
		},
		-- Marcheur �th�r�
		[2] = {
			[1] = {
				"Oups, je vais sans doute avoir besoin d'un idiot pour prendre les coups \195\160 ma place...",
				"<pet>, viens m'aider !",
			},
			[2] = {
				"GRAOUbouhhhhh GROUAHOUhououhhaahpfffROUAH !",
				"GRAOUbouhhhhh GROUAHOUhououhhaahpfffROUAH !",
				"(Non je ne suis pas dingue, j'imite le bruit du marcheur en rut !)",
			},
		},
		-- Succube
		[3] = {
			[1] = {
				"<pet> ma grande, viens m'aider ch\195\169rie !",
			},
			[2] = {
				"Ch\195\169rie, l\195\162che ton rimmel et am\195\168ne ton fouet, y a du taf l\195\160 !",
			},
			[3] = {
				"<pet> ? Viens ici ma louloutte !",
			},
		},
		-- Chasseur corrompu
		[4] = {
			[1] = {
				"<pet> ! <pet> ! Aller viens mon brave, viens ! <pet> !",
			},
			[2] = {
				"Rhoo, et qui c'est qui va se bouffer le mage hein ? C'est <pet> !",
				"<after>Regardez, il bave d\195\169j\195\160 :)",
			},
			[3] = {
				"Une minute, je sors le caniche et j'arrive !",
			},
		},
		-- Gangregarde
		[5] = {
			[1] = {
				"<player> concentre toute sa puissance dans ses connaissances d\195\169monologiques...",
				"En \195\169change de cette \195\162me, viens \195\160 moi, Gangregarde !",
				"<after>Ob\195\169is moi maintenant, <pet> !",
				"<after><player> fouille dans son sac, puis lance un cristal \195\160 <pet>",
				"<sacrifice>Retourne dans les limbes et donne moi de ta puissance, D\195\169mon !"
			},
		},
		-- Phrase pour la premi�re invocation de pet (quand Necrosis ne connait pas encore leur nom)
		[6] = {
			[1] = {
				"La p\195\170che au d\195\169mon ? Rien de plus facile !",
				"Bon, je ferme les yeux, j'agite les doigts comme \195\167a...",
				"<after>Et hop ! Oh, les jolies couleurs !",
			},
			[2] = {
				"Toute fa\195\167on je vous d\195\169teste tous ! J'ai pas besoin de vous, j'ai des amis.... Puissants !",
				"VENEZ A MOI, CREATURES DE L'ENFER !",
			},
			[3] = {
				"Eh, le d\195\169mon, viens voir, il y a un truc \195\160 cogner l\195\160 !",
			},
			[4] = {
				"En farfouillant dans le monde abyssal, on trouve de ces trucs...",
				"<after>Regardez, ceci par exemple !",
			},

		},
		-- Phrase pour la monture
		[7] = {
			[1] = {
				"Mmmphhhh, je suis en retard ! Invoquons vite un cheval qui rox !",
			},
			[2] = {
				"J'invoque une monture de l'enfer !",
			},
			[3] = {
				"<player> ricane comme un damn\195\169 !",
				"<after><yell>TREMBLEZ, MORTELS, J'ARRIVE A LA VITESSE DU CAUCHEMAR !!!!",
			},
			[4] = {
				"Et hop, un cheval tout feu tout flamme !",
			},
			[5] = {
				"Vous savez, depuis que j'ai mis une selle ignifug\195\169e, je n'ai plus de probl\195\168me de culotte !"
			},
		},

	}

end


-- Pour les caract�res sp�ciaux :
-- � = \195\169 ---- � = \195\168
-- � = \195\160 ---- � = \195\162
-- � = \195\180 ---- � = \195\170
-- � = \195\187 ---- � = \195\164
-- - = \195\132 ---- � = \195\182
-- � = \195\150 ---- � = \195\188
-- _ = \195\156 ---- � = \195\159
-- � = \195\167 ---- � = \195\174

