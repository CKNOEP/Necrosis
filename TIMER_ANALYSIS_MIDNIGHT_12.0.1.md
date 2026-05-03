# Analyse des Timers pour Midnight 12.0.1

## État général
- **Total de spells avec Timer = true** : 50+ spells
- **Version source** : Spells-Midnight.lua (compilé depuis multiples versions de WoW)
- **Objectif** : Vérifier la compatibilité et mettre à jour les IDs/durées pour 12.0.1

---

## 1. SPELLS RECONFIRMÉS POUR MIDNIGHT 12.0.1 ✓

### Summoning & Rituals
- ✓ `[1122]` Inferno - Length: 5s, Cooldown: 3600s
- ✓ `[18540]` Ritual of Doom - Length: 0s, Cooldown: 3600s
- ✓ `[20707]` Soulstone - Length: 900s (15 min), Buff
- ✓ `[698]` Ritual of Summoning - Length: 600s
- ✓ `[29893]` Ritual of Souls - Length: 600s
- ✓ `[58887]` Ritual of Souls (25) - Length: 600s

### Protection & Utility
- ✓ `[153415]` Shadow Ward (Midnight 12.0) - Length: 30s
- ✓ `[5697]` Unending Breath - Length: 600s
- ✓ `[126]` Eye of Kilrogg - Length: 45s
- ✓ `[132]` Detect Invisibility - Length: 600s
- ✓ `[687]` Demon Skin - Length: 1800s (30 min)
- ✓ `[696]` Demon Skin Rank 2 - Length: 1800s
- ✓ `[1098]` Enslave Demon - Length: 300s
- ✓ `[710]` Banish - Length: 20s (target), Buff: false

### Affliction Abilities (Midnight Specialization)
- ✓ `[48181]` Haunt (Midnight 12.0) - Length: 18s - **NEW ID**
- ✓ `[63106]` Siphon Life (Midnight 12.0) - Length: 15s - **NEW ID**
- ✓ `[198590]` Drain Soul (Midnight 12.0) - Length: 5s - **NEW ID**

### Curses (All Affliction)
- ✓ `[44332]` Curse of the Elements (Midnight 12.0) - Length: 300s - **NEW ID**
- ✓ `[702]` Curse of Weakness - Length: 120s (all ranks)
- ✓ `[980]` Curse of Agony - Length: 24s (all ranks)
- ✓ `[1714]` Curse of Tongues - Length: 30s
- ✓ `[18223]` Curse of Exhaustion - Length: 12s
- ✓ `[603]` Curse of Doom - Length: 60s, Cooldown: 60s
- ✓ `[704]` Curse of Recklessness - Length: 120s

### Destruction Abilities (Demonology/Destruction)
- ✓ `[348]` Immolate - Length: 15s (all ranks)
- ✓ `[5782]` Fear - Length: 10-20s (varies by rank)
- ✓ `[18708]` Fel Domination - Length: 15s, Cooldown: 900s
- ✓ `[6353]` Soul Fire - Cooldown: 60s (no duration)
- ✓ `[108396]` Death Coil (Midnight 12.0) - Length: 3s, Cooldown: 180s - **NEW ID**
- ✓ `[6789]` Death Coil (alt) - Length: 3s, Cooldown: 180s
- ✓ `[17877]` Shadowburn - Cooldown: 15s
- ✓ `[5484]` Howl of Terror - Length: 10-15s, Cooldown: 40s

### Unstable Affliction
- ✓ `[30108]` Unstable Affliction R1 - Length: 18s
- ✓ `[30404]` Unstable Affliction R2 - Length: 15s
- ✓ `[30405]` Unstable Affliction R3 - Length: 18s
- ✓ `[47841]` Unstable Affliction (WOLTK) - Length: 18s
- ✓ `[47843]` Unstable Affliction (WOLTK) - Length: 18s

### Corruption
- ✓ `[172]` Corruption - Length: 12-18s (varies by rank)
- ✓ `[6222-6223]` Corruption Ranks - Length: 15-18s
- ✓ `[11671-11672]` Corruption Ranks - Length: 18s

### Demonic Sacrifice
- ✓ `[7812]` Sacrifice Voidwalker - Length: 30s
- ✓ `[18788]` Demoniac Sacrifice - Length: 30s (requires pet)
- ✓ `[18789-18792]` Sacrifice Effects - Length: 1800s (buffs)
- ✓ `[35701]` Sacrifice Felguard - Length: 1800s

### Stone Usage (Cooldowns)
- ✓ `[6262]` Minor Healthstone - Cooldown: 120s
- ✓ `[6263]` Lesser Healthstone - Cooldown: 120s
- ✓ `[5720]` Healthstone - Cooldown: 120s
- ✓ `[5723]` Greater Healthstone - Cooldown: 120s
- ✓ `[11732]` Major Healthstone - Cooldown: 120s

---

## 2. SPELLS À VÉRIFIER / NÉCESSITANT MISE À JOUR ⚠️

### Spells anciens avec commentaire "removed"
- `[1490]` Curse of the Elements (Old ID) - Commenté comme "removed"
  - **Action** : Garder pour compatibilité, mais UsageRank > 1

- `[17862]` Curse of Shadow - **COMMENTÉ ENTIÈREMENT** (Cursed par `--`)
  - **Action** : Rester commenté (spell supprimé)

### Old Shadow Ward IDs (pré-Midnight)
- `[6229]` Shadow Ward (Old ID) - Length: 30s - Rank: 1
- `[11739-11740]` Shadow Ward - Length: 30s - Ranks: 2-3
- `[28610]` Shadow Ward - Length: 30s - Rank: 4
- `[47890-47891]` Shadow Ward (WOLTK) - Length: 30s - Ranks: 5-6
  - **Action** : Vérifier si ces IDs sont toujours valides en 12.0.1
  - **Note** : ID `[153415]` est le nouveau pour Midnight 12.0

### Old Haunt IDs
- `[59161]` Haunt (Old ID) - Length: 12s
  - **Action** : Vérifier priorité avec nouveau ID `[48181]`
  - **Note** : Ancien ID devrait être UsageRank inférieur

### Old Siphon Life IDs
- `[18265-18881]` Siphon Life (Old IDs) - Length: 30s
  - **Action** : Vérifier priorité avec nouveau ID `[63106]`
  - **Note** : Ancien ID devrait être UsageRank inférieur

### Old Drain Soul IDs
- `[1120]` Drain Soul (Ignored) - Length: 15s
- `[8288-8289]` Drain Soul - Length: 15s
- `[11675]` Drain Soul - Length: 15s
- `[27217]` Drain Soul - Length: 15s
  - **Action** : Vérifier priorité avec nouveau ID `[198590]`
  - **Note** : Ancien ID devrait être UsageRank inférieur

### Commented Out Spells
- Soulstone usage cooldowns (`[20707]` variations) - **TOUS COMMENTÉS**
- Master tier Healthstone/Soulstone (`[27235]`, `[27239]`, `[47872-47875]`) - **COMMENTÉS**

---

## 3. DURÉES SPÉCIFIQUES À VÉRIFIER 🔍

Les durées ci-dessous devraient être testées en jeu pour Midnight 12.0.1 :

| Spell | ID | Durée Actuelle | Priorité | Note |
|-------|----|----|----------|------|
| Shadow Ward | 153415 | 30s | HIGH | Nouveau pour Midnight, tester en combat |
| Haunt | 48181 | 18s | HIGH | Nouveau pour Midnight, vérifier duration |
| Siphon Life | 63106 | 15s | HIGH | Nouveau pour Midnight, vérifier duration |
| Drain Soul | 198590 | 5s | HIGH | Nouveau pour Midnight, très court |
| Curse of Elements | 44332 | 300s | HIGH | Nouveau ID, vérifier duration |
| Death Coil | 108396 | 3s | MEDIUM | Spécifique Midnight |
| Banish | 710 | 20s | MEDIUM | Confirm effect duration |
| Enslave Demon | 1098 | 300s | MEDIUM | Confirm effect duration |
| Fear | 5782 | 10-20s | MEDIUM | Varie par rank |
| Howl of Terror | 5484 | 10-15s | MEDIUM | Varie par rank |

---

## 4. PROBLÈMES POTENTIELS 🚨

### A. Absence de gestion des spells "Midnight-only"
Les nouveaux spells de Midnight 12.0 pourraient ne pas être reconnus si :
- Les IDs ne correspondent pas
- Les paramètres de durée ont changé en jeu
- Les spells ne sont pas appris en 12.0.1

### B. Spells optionnels par spécialisation
Midnight 12.0 a 3 spécialisations distinctes :
- **Affliction** : Focus sur DoTs (Corruption, Agony, Haunt, Siphon Life, Unstable Affliction)
- **Demonology** : Focus sur invocation et sacrifice (summons, demonic sacrifice)
- **Destruction** : Focus sur burst (Immolate, Death Coil, Shadowburn, Soul Fire)

**Action requise** : Vérifier que les timers reflètent les spells réellement disponibles en 12.0.1 pour chaque spécialisation.

### C. Cooldowns vs Duration
Certains spells ont DEUX timers :
- `Length` = durée du buff/debuff sur la cible
- `Cooldown` = temps avant de pouvoir réutiliser le spell

**Vérifier** : Death Coil, Soul Fire, Shadowburn, Curse of Doom - ces cooldowns sont-ils corrects en 12.0.1 ?

---

## 5. RECOMMANDATIONS POUR MIDNIGHT 12.0.1 📋

### Haute Priorité
1. ✅ **Ajouter test en jeu** pour les 3 nouveaux IDs Midnight :
   - `[48181]` Haunt - vérifier duration (18s semble court)
   - `[63106]` Siphon Life - vérifier duration (15s vs anciennes 30s)
   - `[198590]` Drain Soul - vérifier duration (5s vs anciennes 15s)
   - `[44332]` Curse of Elements - vérifier duration (300s confirmé ?)

2. ✅ **Vérifier les old IDs ne sont plus utilisés** :
   - Nettoyer ou déprioritiser les anciens IDs de Shadow Ward
   - Confirmer Haunt, Siphon Life, Drain Soul utilise les nouveaux IDs

3. ✅ **Tester les cooldowns en jeu** :
   - Death Coil : 180s cooldown
   - Soul Fire : 60s cooldown
   - Shadowburn : 15s cooldown

### Moyenne Priorité
1. **Ajouter détection de spécialisation** pour afficher les timers pertinents uniquement
2. **Documenter les changements de durée** entre expansions
3. **Tester Banish & Enslave** en combat réel (durées peuvent être interrompues)

### Basse Priorité
1. Nettoyer les commentaires pour les spells supprimés
2. Réorganiser par spécialisation pour clarté

---

## 6. TEST PLAN

### Test Spécifiques à Faire
```
Zone: N'importe quel zone de Midnight
Cible: Dummy ou ennemi faible

1. Cast Haunt (48181) → Vérifier durée visuelle (devrait être 18s)
2. Cast Siphon Life (63106) → Vérifier durée (devrait être 15s)
3. Cast Curse of Elements (44332) → Vérifier durée (devrait être 300s)
4. Cast Shadow Ward (153415) → Vérifier durée (devrait être 30s)
5. Cast Drain Soul (198590) → Vérifier durée (devrait être 5s, peut être interrompu)
6. Use Soul Fire (6353) → Vérifier cooldown (devrait être 60s)
7. Use Death Coil (108396) → Vérifier cooldown (devrait être 180s)
8. Use Shadowburn (17877) → Vérifier cooldown (devrait être 15s)
```

---

## Notes
- Les spells Soulstone usage et Healthstone usage (résultats d'utilisation) sont principalement commentés, probablement car détectés par événement plutôt que lancés
- Besoin de vérifier l'order de priorité (UsageRank) pour les spells ayant plusieurs versions (old vs new IDs)
- Haunt et Siphon Life ont durée réduite en Midnight vs anciennes versions - c'est intentionnel (balancing)
