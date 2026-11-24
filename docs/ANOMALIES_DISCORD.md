# Anomalies remontées sur Discord (Forever)

Statut au 20/11/2026 : A1, A2 et A3 corrigés dans le code (à valider en jeu). A4 à A16 documentés, non corrigés (A11 à A15 sont à reproduire, A16 est prête à corriger).

**Constat général** : le client Forever est un Classic Era (niveau 60, rangs Vanilla). Le port « Midnight » de `Spells-Forever.lua` avait commenté ou supprimé des sorts qui existent sur ce client. Les IDs ont été vérifiés avec `/necspells` (commande de diagnostic de `Debug-CheckSpells.lua`) et avec le tableau des sorts de Démoniste de Wowhead Forever.
Addon : Necrosis 8.8.5, TOC `Necrosis_Camelot.toc` (Interface 16001 / Forever 160001).

---

## A1 — Détection de l'invisibilité et Protection contre l'ombre grisées dans le menu des sorts

- **Source** : Rhythm [RXP], Discord, 19/11/2026.
- **Message** : « Detect Invisibility and Shadow Ward even you have learn them they're still grey out on the spell menu ».
- **Symptôme** : les deux sorts sont appris mais restent grisés dans le menu des sorts.
- **Pièce jointe** : capture d'écran non transmise, non analysée.

### Cause (confirmée par lecture du code et par `/necspells`)
Les entrées étaient commentées dans `Spells-Forever.lua` (« supprimées dans Midnight »), donc `IsSpellKnown` ne les reconnaissait jamais. `SpellIDMap` pointait sur des IDs inexistants (`11649`, `47891`) et le bouton de Protection contre l'ombre utilisait `dark_pact` (`108416`, inexistant).

### Correction appliquée
- Détection de l'invisibilité : `132`, `2970`, `11743` réactivés (vérifiés en jeu).
- Protection contre l'ombre : `6229`, `11739`, `11740`, `28610` réactivés. `6229` est vérifié en jeu (« Gardien de l'ombre » en français). Les rangs WotLK `47890` et `47891` restent commentés.
- `SpellIDMap` : `invisible = 132`, `ward = 6229`.
- Menu des buffs : le bouton de la protection contre l'ombre utilise `ward`.
- `Necrosis-Forever.lua` : infobulle `Invisible` réactivée.

**Reste à valider** avec un personnage de niveau suffisant (32 pour la protection, 26 pour la détection). Priorité : moyenne.

---

## A2 — Malédiction des éléments absente du menu des malédictions

- **Source** : Rhythm [RXP], Discord, 19/11/2026.
- **Message** : « Curse of the Elements is missing from the Curse Menu ».

### Causes
1. Les anciens IDs (`1490`, `11721`, `11722`, `27228`, `44332`, `47865`) n'existent pas sur Forever (vérifié avec `/necspells`).
2. La liste `curses` du menu n'avait aucune entrée `elements`.

### Correction appliquée
- Nouveaux IDs Forever, relevés sur Wowhead Forever : `440892` (niv. 20), `1311676` (niv. 30), `1311677` (niv. 40), `1311680` (niv. 50). Les niveaux sont déduits de l'ordre de la liste Wowhead, pas lus directement.
- Entrée `elements` ajoutée en position 6 du menu des malédictions.
- Malédiction de témérité (`704`, `7658`, `7659`, `11717`) remise en position 7 du menu, à la demande de l'utilisateur.

**Validé en jeu le 20/11/2026** (menu, état du bouton et lancement du sort OK, niveau 20, rang 1). Les rangs 2 à 4 restent à confirmer à leur niveau.

---

## A3 — Clic droit (invocation rapide) et Maj+clic droit (sacrifice) inopérants

- **Source** : message Discord sans auteur ni date dans le collage. Un fichier `Necrosis.lua` (11 Ko) et un extrait de `NecrosisConfig` (`MainSpell = "armor"`, `glow.enabled = true`) étaient joints. Seul l'extrait a été transmis.
- **Symptôme** : le clic droit sur un bouton de démon (invocation rapide) et Maj+clic droit (sacrifice) ne font plus rien. Contournement du joueur : une macro.

### Causes
1. `XML/Attributes-Forever.lua`, `SetPetSpellAttribute` : le clic droit et le sacrifice étaient imbriqués dans `if IsSpellKnown("domination")`. Domination utilisait l'ID retail `333889`, inexistant sur Forever.
2. L'entrée du sacrifice (`18788`) était commentée dans `Spells-Forever.lua`.
3. Fel Domination (`18708`, usage `fel_domination_legacy`) était commentée.

### Correction appliquée
- Clic droit : macro Domination + invocation si Domination (ou `fel_domination_legacy`) est connue, sinon invocation simple.
- Maj+clic droit : sacrifice posé indépendamment de Domination, sur le démon choisi dans les options.
- `Spells-Forever.lua` : `18788` et `18708` réactivés, vérifiés avec `/necspells vanilla`.

**Limites** : `IsSpellKnown("domination")` utilise toujours l'ID `333889`. Le repli sur `fel_domination_legacy` couvre le cas. Le personnage de test (niveau 20) n'a pas ces sorts. **À valider en jeu.** Priorité : haute.

---

## A4 — Sous-menus impossibles à ouvrir en combat

- **Symptôme** : tous les sous-menus doivent être ouverts avant le combat. Une fois en combat, ils ne s'ouvrent plus et on ne peut utiliser que ce qui était déjà ouvert.

### Analyse du code (première lecture)
- `Necrosis-Forever.lua` compte 11 `InCombatLockdown` et le menu est construit par `CreateMenu` (~l. 3466). L'ouverture passe sans doute par du code non sécurisé qui fait `Show`/`Hide` sur des frames protégées, interdit en combat.
- Le même type de blocage a déjà été corrigé pour le bouton Bannir (voir la mémoire du projet : « Banish combat target change »).

### Piste de correction
Gérer l'ouverture et la fermeture du menu avec un gestionnaire sécurisé (`SecureHandlerClickTemplate` / `SecureHandlerStateTemplate`) ou des attributs `_onclick` en snippet restreint. Étudier le chemin exact de l'ouverture avant de choisir.

- **Priorité** : haute (bloquant en combat).

---

## A5 — Menus qui restent ouverts après usage malgré « fermer après un clic »

- **Symptôme** : après l'usage d'un sort du menu, celui-ci reste affiché, alors que l'option de fermeture après clic est activée.

### Analyse du code (première lecture)
- La clé de configuration est `Menus["Fermer le menu apres un clic sur un de ses elements"]` (case à cocher dans `XML/Options-Menus_retail.lua`, ~l. 960). Je n'ai trouvé dans `Necrosis-Forever.lua` aucune lecture évidente de cette option pour fermer le menu. **À confirmer** par une recherche plus précise de la clé.

### Cause probable
L'option n'est plus branchée sur la fermeture dans la version Forever, ou la fermeture est bloquée en combat (voir A4).

- **Priorité** : moyenne. Probablement liée à A4.

---

## A6 — Bouton Pierre de soins : plusieurs clics nécessaires

- **Symptôme** : parfois, le clic gauche sur le bouton Pierre de soins doit être répété plusieurs fois avant de fonctionner.
- **Statut** : cause non identifiée. À reproduire avec le debug des boutons (`Necrosis.Debug.buttons`). Pistes à vérifier : reconfiguration des attributs sécurisés pendant un `BAG_UPDATE`, ou attributs non posés en combat (`SetPetSpellAttribute` et d'autres sortent dès `InCombatLockdown()`).
- **Priorité** : moyenne.

---

## A7 — Changement d'échelle de la barre de boutons : une barre en trop derrière

- **Symptôme** : en modifiant l'échelle de la barre de boutons, une seconde barre apparaît derrière.
- **Pièce jointe** : capture d'écran non transmise, donc non analysée.
- **Pistes** : `SetScale` appliqué à un seul des deux ensembles de frames (~l. 1792 et ~l. 3316 de `Necrosis-Forever.lua`), ou des frames dupliquées après recréation du menu. Le `SetScale` de la sphère est reporté après le combat (`XML/Options-Sphere-Forever.lua`, ~l. 149-153).
- **Priorité** : basse (visuel).

---

## A8 — Changement d'échelle du bouton Bannir : recouvert par d'autres boutons

- **Symptôme** : en agrandissant le bouton Bannir, d'autres boutons le recouvrent.
- **Pièce jointe** : capture d'écran non transmise, donc non analysée.
- **Pistes** : ordre des couches (`SetFrameLevel`/`FrameStrata`) et zones invisibles Asservir/Bannir (voir l'issue #46, `Necrosis-Forever.lua` ~l. 4060).
- **Priorité** : basse (visuel). Proche de A7.

---

## A9 — Menu des démons : se ferme en combat, ne se rouvre pas, et cases de l'onglet Démons qui changent seules

- **Source** : message Discord sans auteur ni date dans le collage. Fichier joint `Necrosis.lua.bak` (9,97 Ko), non transmis.
- **Symptôme** :
  1. Le menu des démons se ferme en combat et ne peut plus être rouvert.
  2. Dans l'onglet Démons des options, les cases cochées changent seules au bout d'un moment.
  3. Demande du joueur : que le menu des démons s'affiche toujours correctement.
- **Suggestion** : pouvoir détacher les démons un par un et les laisser affichés par une option, comme le bouton de la pierre d'âme ou de soins.

### Analyse du code (première lecture)
- Le point 1 est du même type que A4 (menus et `InCombatLockdown`). À traiter ensemble.
- Les cases de l'onglet sont créées dans `XML/Options-Menus_retail.lua` (`NecrosisDemonShow<i>`, ~l. 544-561). La dérive des cases suggère une réinitialisation de `NecrosisConfig` par des valeurs par défaut ou une migration qui s'exécute plus tard (voir l'ajout tardif de `ShadowTranceAlert` / `CreatureAlert`, `Necrosis-Forever.lua` ~l. 1366-1370). **Hypothèse non vérifiée** : relire où ces cases sont écrites et lues.

### Piste de correction
- Mettre le menu des démons sous gestionnaire sécurisé (voir A4).
- Chercher ce qui réécrit les cases `NecrosisDemonShow<i>` hors d'un clic du joueur.
- La suggestion est une fonctionnalité nouvelle, à traiter à part.

- **Priorité** : haute pour la fermeture en combat, moyenne pour la dérive des cases.

---

## A10 — Son et alertes de Transe de l'ombre absents en combat

- **Source** : message Discord sans auteur ni date dans le collage (même fichier joint `Necrosis.lua.bak`, non transmis).
- **Symptôme** : le son de Transe de l'ombre et les alertes associées ne se produisent pas en combat. Ils reviennent dès la sortie de combat.

### Analyse du code (première lecture)
- Sur ce client, `COMBAT_LOG_EVENT_UNFILTERED` n'est pas accessible aux addons. Les procs sont donc lus via `UNIT_AURA` (`Necrosis-Forever.lua` ~l. 1402-1404).
- Le son se joue dans le traitement du nom de l'aura (~l. 872-874, comparaison `nom == Necrosis.Translation.Proc.ShadowTrance`). En combat, les noms d'aura peuvent être des valeurs secrètes (le fichier gère déjà `issecretvalue`, ~l. 1110, 1150). Une comparaison avec un nom illisible échoue sans erreur.

### Cause probable
En combat, le nom de l'aura est illisible : la comparaison échoue, ni son ni alerte. Hors combat, les valeurs sont lisibles. **Hypothèse non vérifiée en jeu.**

### Piste de correction
Détecter le proc par son identifiant de sort (`spellId` de la Transe de l'ombre) ou par `C_UnitAuras.GetPlayerAuraBySpellID`, plutôt que par le nom. Contrôler la même chose pour Contrecoup (Backlash). Voir aussi l'audit des valeurs secrètes (point connu : clés `arg2`).

- **Priorité** : moyenne à haute (alerte de jeu).

---

## A11 — Montures inopérantes (bouton de monture)

- **Source** : commentaire CurseForge, joueur `user_q5gvaeo3m5mvrpgk`, « il y a 13 jours » (autour du 10/11/2026, après `fix5`).
- **Message** : « the mounts, demon button, and a few other things are not working in forever yet ».
- **Symptôme** : les montures ne marchent pas. Pas d'autre détail (bouton grisé, absent, clic sans effet ?).

### Analyse du code (première lecture)
- `Spells-Forever.lua` (~l. 222-223) : usage `mounts` avec `5784` (Palefroi corrompu, niv. 40) et `23161` (Destrier de l'effroi, niv. 60).
- Ces deux IDs ne figurent pas dans la liste de sorts de Démoniste de Wowhead Forever (ce sont des sorts de quête). À vérifier avec `/necspells` sur un personnage qui les a.
- Le bouton `NecrosisMountButton` dépend de `NecrosisConfig.LeftMount` / `RightMount` (`Necrosis-Forever.lua` ~l. 804-815 et ~992). La configuration de ces valeurs n'a pas été relue.
- Le personnage de test (niveau 20) ne peut pas tester les montures.

### Piste
Vérifier les IDs avec un joueur niveau 40+, puis l'association des montures au bouton (`LeftMount`, `RightMount`). Demander au joueur ce qu'il constate exactement.

- **Priorité** : moyenne. Statut : à reproduire.

---

## A12 — Afficher les ennemis insensibles à la peur

- **Source** : même commentaire CurseForge. Le joueur demande un addon qui signale les ennemis insensibles à la peur et propose un bouton de suppression des fragments d'âme.
- **Symptôme / demande** : l'alerte des ennemis non « fearables » ne semble pas fonctionner pour lui. Le rapport de l'issue #46 mentionnait déjà Peur/Bannir comme point restant.

### Analyse du code (première lecture)
- Les boutons d'alerte de créature (`NecrosisCreatureAlertButton_elemental`, `_demon`) et `CreatureAlert` sont dans `Necrosis-Forever.lua` (~l. 82, 166-167, 1366-1389). `CreatureAlert` était absent des valeurs par défaut utilisées (corrigé dans l'issue #46).
- La détection du type de créature passe par `IsCreatureType()`. En combat, le type peut être illisible (valeurs secrètes).
- Le bouton de suppression des fragments (« Destroy Shards ») a été ajouté dans `fix5`. Le joueur ne l'avait peut-être pas encore.

### Piste
Reproduire avec une cible insensible à la peur (mort-vivant, élémentaire) et vérifier l'alerte avec `/dump UnitCreatureType("target")`. À préciser avec le joueur.

- **Priorité** : basse à moyenne. Statut : à reproduire.

---

## A13 — Annonce de pierre d'âme : « inconnu » à la création, rien à l'utilisation

- **Source** : commentaire CurseForge, joueur `GAARAtheRED`, « il y a 9 jours » (autour du 14/11/2026).
- **Message** : en groupe, à la *création* d'une pierre d'âme, l'addon annonce qu'« unknown » (ou le membre ciblé) est ressuscité en pierre d'âme, puis n'annonce rien quand la pierre est réellement utilisée.
- **Symptôme** : l'annonce part au mauvais moment (création) avec une cible erronée (« unknown », ou la cible courante), et pas à l'utilisation.

### Analyse du code (première lecture)
- `Spells-Forever.lua` (~l. 246-255) : les sorts de **création** (`693`, `20752`, `20755`, `20756`, `20757`, `47884`) portent l'usage `soulstone`. Les annonces de `Speech\Speech-*.lua` (« <target> is soulstoned ») sont donc déclenchées par la création.
- `Necrosis-Forever.lua` (~l. 1640-1690, `UNIT_SPELLCAST_SENT`) prend la cible de `target` ou, à défaut, `UnitName("target")`. Sans cible : nom vide, d'où « unknown ».
- Le sort d'**utilisation** de la pierre (« Résurrection de Pierre d'âme », `20762`–`20765`) n'était pas suivi : ces entrées étaient commentées avant le correctif `fix6`. Elles sont maintenant actives (usage `ss_used`, etc.). Aucun lien n'a été vérifié avec l'annonce.

### Cause probable
L'annonce est branchée sur la création au lieu de l'utilisation (ou sur les deux). **Non confirmé en jeu.**

### Piste de correction
Annoncer seulement quand la pierre est utilisée sur une cible (sorts `20762`–`20765`), et pas à la création. Contrôler `Message.lua` (`Speech_It`) et le message `SoulstoneEn`.

- **Priorité** : moyenne. À reproduire en groupe.

---

## A14 — Bouton de pierre d'âme en recharge après création, clic inopérant

- **Source** : même commentaire que A13.
- **Message** : après création d'une pierre d'âme en groupe, le bouton de l'interface passe en temps de recharge et ne peut plus être cliqué pour lancer la pierre. Le joueur doit faire un clic droit sur la pierre depuis ses sacs.
- **Symptôme** : bouton en recharge et clic sans effet.

### Analyse du code (première lecture)
- Le bouton de pierre d'âme est configuré dans `XML/Attributes-Forever.lua` (`soulstoneID`, ~l. 23) et dépend du contenu des sacs (`BAG_UPDATE`). Un correctif de pierre d'âme existait déjà dans l'issue #46.
- Hypothèse : le bouton garde le sort de **création** (en recharge) au lieu de basculer sur l'**objet** (utilisation) une fois la pierre créée. `SetAttribute` est interdit en combat ou en groupe sous verrou, d'où un attribut resté figé.
- **Non vérifié** : je n'ai pas relu le code d'attribution.

### Piste de correction
Après `BAG_UPDATE`, repasser le bouton en mode « objet » (`type1 = item`) quand la pierre est dans les sacs. Tester avec et sans groupe.

- **Priorité** : moyenne à haute (fonction centrale du bouton). À reproduire.

---

## A15 — Rafale d'erreurs Lua en instance à 5 joueurs

- **Source** : commentaire CurseForge, joueur `zeta_420`, « il y a 8 jours » (autour du 15/11/2026).
- **Message** : dans une instance à 5 joueurs, « out of nowhere » une rafale d'erreurs Lua, sans arrêt, jusqu'à la désactivation de Necrosis.
- **Symptôme** : erreurs Lua en boucle, immédiatement et en nombre, en donjon.
- **Information manquante** : le texte des erreurs n'est pas fourni. Sans lui, on ne peut pas localiser le fichier ni la ligne.

### Analyse (hypothèses, rien de vérifié)
- Contexte typique : en instance, les valeurs « secrètes » (noms d'aura, GUID, cibles de groupe) deviennent illisibles. Le fichier gère déjà `issecretvalue` à plusieurs endroits, mais un cas oublié peut lever une erreur à chaque événement. Un audit en donjon (04/10/2026) notait déjà un point connu : les clés `arg2`.
- Une erreur dans un gestionnaire d'événement fréquent (`UNIT_AURA`, `UNIT_SPELLCAST_*`, `GROUP_ROSTER_UPDATE`) se répète à chaque événement, d'où la « rafale ».

### Piste
1. Demander au joueur le texte exact des erreurs (BugSack, BugGrabber ou `/console scriptErrors 1`).
2. Reproduire en groupe à 5 avec les erreurs affichées.
3. Protéger la ligne fautive avec `issecretvalue` ou `pcall`.

- **Priorité** : haute (rend l'addon inutilisable en donjon). Statut : informations insuffisantes.

---

## A16 — Durées de sorts : regrouper par monstre (timers qui sautent)

- **Source** : commentaire CurseForge, auteur non indiqué dans le collage.
- **Message** : dans « Spell Durations », peut-on regrouper les timers par monstre (monstre A avec ses malédictions 1 et 2, puis monstre B avec les siennes) ? Actuellement, quand des debuffs sont actifs sur 2 monstres ou plus, les durées « sautent » selon le temps restant. Exemple : malédictions 1 et 2 sur A et B donnent A-1, A-1, B-2, B-2, et les malédictions ne sont pas bien rattachées à leur monstre.
- **Symptôme** : liste de timers mélangée, étiquettes de monstre mal placées, écran encombré.

### Analyse du code (première lecture)
- `Timers/GraphicalTimers.lua` (~l. 243), dans `NecrosisUpdateTimer` : `table.sort(tableau, function(a,b) return a.Time < b.Time end)`. Le tri se fait **uniquement sur le temps restant**, à chaque mise à jour. L'ordre change donc en continu et ignore le monstre.
- `Timers/Functions_retail.lua` (~l. 250-255) trie aussi par `Time`, puis `Parsing` crée les groupes par nom de monstre. Le tri graphique défait ce regroupement.
- Les titres de groupe (nom du monstre) sont posés à partir de `SpellGroup`. Deux monstres de même nom (ou un monstre sans nom lisible en combat) peuvent être fusionnés.

### Cause probable
Le tri final par `Time` écrase le regroupement par monstre.

### Piste de correction
Trier d'abord par groupe (GUID du monstre, sinon nom), puis par temps restant. Garder l'ordre des groupes stable (ordre d'apparition du premier timer) pour que la liste ne saute pas. Vérifier que l'étiquette suit bien le monstre cible de chaque sort.

- **Priorité** : moyenne. Amélioration visible, correction localisée. Statut : prête à corriger.

---

## Audit des IDs de sorts (20/11/2026)

- **Outil** : `/necspells` liste les IDs de `Spells-Forever.lua` inexistants sur le client. `/necspells vanilla` teste les IDs de `Spells-Vanilla.lua` absents du fichier Forever.
- **Résultat** : sur 181 IDs testés, 64 sont inexistants. Ce sont des rangs TBC/WotLK ou des sorts retail. Ils sont inoffensifs et laissés en place (le fichier est partagé avec d'autres versions).
- **Réactivés** (existent sur Forever, vérifiés en jeu) : Pierre de sort, Pierre de feu, Lien spirituel, Fel Domination, Siphon de vie, Sacrifice du Marcheur du Vide, Siphon d'âme, marqueurs de Pierre de soins et de Pierre d'âme, Bannir rang 2 (`18647`), Voile mortel rangs 2 et 3 (`17925`, `17926`).
- **Comparaison avec Wowhead Forever** : 191 sorts de la liste, 121 présents dans le fichier, 70 absents. Les absents sont des rangs de Drain de vie, Captation de vie, Douleur brûlante, Pluie de feu, Flammes infernales, Drain de mana et des runes Season of Discovery. Non ajoutés : Necrosis ne les utilise pas.
- **Calvaire** (`1316697`, « Wrack ») : sort canalisé d'Ombre, 6 s, 200 mana. Ajouté comme timer (usage `wrack`, 6 s), sans bouton. À valider en jeu.
- **Wither** (`445468`) : inexistant sur ce client mais présent dans le menu. Non traité.
- **Ruine** : talent passif, rien à ajouter.
- **Sauvegarde** de l'état avant audit : `%TEMP%\Spells-Forever.before-audit.lua`.

---

## A17 — Le menu Démon ne se ferme pas (surtout en combat)

- **Source** : Discord, deux joueurs (Skript, Rhythm) le 24/11/2026. « Le menu démon ne devrait-il pas se fermer en combat plutôt que rester ouvert ? » — « il reste ouvert comme avant ».
- **Cause** : `MenuAttribute` (`XML/Attributes-Forever.lua`) avait été simplifié pour la bêta 160001 : un `SetScript("OnClick")` non sécurisé faisait `Show()`/`Hide()` sur des boutons protégés (interdit en combat), et les `WrapScript` de fermeture (`ClosingMenu`) étaient désactivés. Le menu ne se refermait donc jamais après un clic, et `AutomaticMenu` n'avait plus d'effet.
- **Correction** (sauvegarde : `XML/Attributes-Forever.lua.bak_A17`) : ouverture/fermeture par snippet sécurisé (`_onclick`), fermeture après clic sur un enfant via `SecureHandlerWrapScript` quand `ClosingMenu` est actif, `BlockedMenu` laisse le menu ouvert, `AutomaticMenu` ouvre en combat et ferme à la sortie (`RegisterStateDriver`).
- **Complément** : la reconstruction du menu (`SPELLS_CHANGED` après une invocation) cachait les enfants ; `MenuAttribute` ne cache plus qu'à la première création. Le snippet de fermeture utilise `self:GetParent()` et `SecureHandlerWrapScript` exige un `preBody` non nul sur ce client.
- **Pièges rencontrés** : `ClosingMenu` lu `nil` au premier `MenuAttribute` (config pas encore chargée) donnait `closeAfter=0` ; le post-script de `SecureHandlerWrapScript` ne s'exécute pas sur ce client, la fermeture est donc dans le pré-script. Commande de diagnostic `/necmenu` ajoutée.
- **Statut** : corrigé, **confirmé en jeu le 24/11/2026** (menus démons, buffs et malédictions). Combat et menu bloqué non testés.

---

## Remarque
A1 et A2 montrent le même défaut : des sorts retirés « pour Midnight » alors que le client Forever les a encore. Il faudrait auditer les autres entrées commentées de `Spells-Forever.lua` (par exemple Soul Link, ligne ~322) avant de corriger.
