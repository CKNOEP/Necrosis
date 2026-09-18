# ⚡ Comment Recharger les Options Timers

## 🔄 PROBLEM: Les changements du layout ne s'affichent pas

**Cause**: Les anciennes frames restent en cache après un premier chargement

**Solution**: Recharger l'addon ou utiliser une commande de rechargement

---

## ✅ OPTION 1: Rechargement complet du jeu (Recommandé)

```
1. Quit World of Warcraft
2. Restart WoW
3. Reload l'addon
```

**Avantage**: Nettoie complètement le cache
**Temps**: ~2-3 minutes

---

## ✅ OPTION 2: Rechargement de l'interface en jeu

### Commande console:
```
/reload
```

**Cela relance tous les addons sans redémarrer WoW**

**Étapes**:
1. Ouvrir chat (Entrée)
2. Taper: `/reload`
3. Appuyer sur Entrée
4. L'interface va scintiller pendant 1-2 secondes
5. Rouvrir Necrosis Options → Timers

**Avantage**: Rapide, pas besoin de redémarrer
**Temps**: ~10 secondes

---

## ✅ OPTION 3: Recharger juste les options Timers (Plus rapide)

Si vous avez LUA Console d'erreur active:

```lua
Necrosis:SetTimersConfig()
```

Puis rouvrir le panneau Options.

---

## 🎯 APRÈS RECHARGEMENT

**Vérifier que vous voyez:**

```
PAGE 1 (1/3): Timer Settings
├─ Timer Type dropdown
├─ Checkboxes pour affichage
└─ Slider Transparence

PAGE 2 (2/3): Timers 1-20
├─ LEFT column (10 items)
└─ RIGHT column (10 items)

PAGE 3 (3/3): Timers 21-40+
├─ LEFT column (10 items)
└─ RIGHT column (10 items)
```

---

## 🔍 TROUBLESHOOTING

### Je vois toujours "2 / 3" au lieu de "3 / 3"
```
→ Votre cache n'a pas été nettoyé
→ Essayez: /reload
→ Ou redémarrez WoW complètement
```

### Je vois seulement 7 timers
```
→ Les anciennes frames sont toujours chargées
→ Utilisez /reload
→ Vérifiez que XML/Options-Timers_retail.lua est à jour
```

### Les colonnes se chevauchent
```
→ Problème de UI Scale
→ Essayez /reload
→ Ou vérifiez votre résolution d'écran
```

---

## 📋 CHECKLIST APRÈS RECHARGEMENT

- [ ] Ouvrir Necrosis Options
- [ ] Aller à "Timers"
- [ ] Vérifier Page 1 (1/3) s'affiche
- [ ] Cliquer [>>>] → Page 2 (2/3) avec 20 timers
- [ ] Cliquer [>>>] → Page 3 (3/3) avec 20 timers
- [ ] Cliquer [>>>] → Revenir à Page 1
- [ ] Toggle un timer ON/OFF
- [ ] Recharger l'interface
- [ ] Vérifier que le toggle a persisté
- [ ] ✅ DONE !

---

## 💡 NOTES IMPORTANTES

1. **Cache de WoW** : Les interfaces utilisateur sont mises en cache lors du chargement
2. **Nouveau layout** : Nécessite une recreation complète des frames
3. **Auto-clean** : Le nouveau code détecte l'ancien layout et le nettoie automatiquement
4. **Pas de danger** : Le rechargement ne supprime aucune configuration

---

## 📞 SI CELA NE FONCTIONNE PAS

1. Assurez-vous que vous avez la dernière version du code
   ```bash
   git status
   ```

2. Vérifiez que XML/Options-Timers_retail.lua contient "3 / 3"
   ```bash
   grep "3 / 3" XML/Options-Timers_retail.lua
   ```

3. Vérifiez que le .toc charge le bon fichier
   ```
   Necrosis_Retail.toc doit avoir:
   XML\Options-Timers_retail.lua
   ```

4. Si tout est bon, essayez une suppression du cache WoW:
   ```
   Delete: WoW/Cache folder (si applicable)
   Restart WoW
   ```

---

**TL;DR** : Faites `/reload` en jeu ! 🎮
