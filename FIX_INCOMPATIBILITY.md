# Correction d'Incompatibilité - Necrosis Midnight PTR

## ⚠️ Problème

L'addon est marqué comme "incompatible" par WoW. Cela signifie que la version interface du TOC ne correspond pas à la version réelle du PTR Midnight.

---

## 🔍 Étape 1 : Déterminer la version interface correcte

### Méthode 1 : Via la console WoW
1. Lancez WoW PTR
2. Appuyez sur **Esc** pour ouvrir le menu
3. Allez à **System → Console** (ou tapez **/console** en chat)
4. Entrez cette commande :
```
/run local m,n,p,b=GetBuildInfo() print("Interface: "..m..n..p)
```

Cela affichera quelque chose comme : `Interface: 110000` ou `Interface: 100007`

### Méthode 2 : Vérifier les logs
- Fichier: `C:\Program Files (x86)\World of Warcraft\_xptr_\Logs\ADDON_LIST.txt`
- Cherchez "Necrosis" pour voir le message d'erreur exact

---

## ✅ Étape 2 : Corriger le TOC

Une fois que vous avez la **vraie version interface** (ex: 110000), modifiez le TOC :

### Option A : Modifier Necrosis_Midnight.toc
Éditer le fichier et remplacer la première ligne :

```
## Interface: XXXXX
```

Remplacez `XXXXX` par la vraie version (ex: 110000, 110005, etc.)

### Option B : Utiliser Necrosis_XPTR.toc (créé automatiquement)
J'ai créé une version alternative nommée `Necrosis_XPTR.toc` avec la version 110000. Essayez cette version d'abord.

### Option C : Essayer plusieurs versions
J'ai préparé plusieurs versions de TOC avec les versions interface courantes pour Midnight :

```
110000  ← Midnight pré-expansion (The War Within)
110005  ← Midnight early patch
110007  ← Midnight typical version
110010  ← Midnight later patch
```

Essayez dans l'ordre jusqu'à ce que l'addon se charge.

---

## 🛠️ Versions Interface Courantes pour Midnight

| Version | Statut |
|---------|--------|
| 110000 | ✅ Par défaut Midnight (essayez d'abord) |
| 110005 | Midnight patch 11.0.5 |
| 110007 | Midnight 11.0.7 |
| 110010 | Midnight 11.0.10+ |
| 100007 | ❌ Dragonflight (trop ancien) |

---

## 📋 Démarche Complète

1. **Lancez WoW PTR Midnight**
2. **Entrez cette commande en chat** :
   ```
   /run local m,n,p,b=GetBuildInfo() print("Interface: "..m..n..p)
   ```
3. **Notez le numéro affiché** (ex: 110000)
4. **Modifiez la 1ère ligne de Necrosis_Midnight.toc** :
   ```
   ## Interface: [Votre Numéro Ici]
   ```
5. **Rechargez WoW ou tapez** :
   ```
   /reload
   ```
6. **Vérifiez si l'addon charge correctement**

---

## ✨ Fichiers TOC Disponibles

J'ai créé deux fichiers TOC pour plus de flexibilité :

### Necrosis_Midnight.toc
- Basé sur Midnight (actuellement 110000)
- À utiliser si c'est la bonne version

### Necrosis_XPTR.toc
- Version alternative plus simple
- À essayer si Necrosis_Midnight.toc ne fonctionne pas

**Pour changer de TOC** :
- Désactivez l'addon actuel dans les options WoW
- Activez l'autre TOC à la place
- Rechargez WoW

---

## 🐛 Vérification

Une fois l'addon chargé (plus de message incompatible) :

1. Vérifiez qu'il n'y a pas d'erreurs Lua :
   ```
   /console scriptErrors 1
   ```

2. Testez les fonctionnalités basiques :
   - Clic gauche sphère
   - Clic droit sphère (configuration)
   - Casting d'un sort

3. Consultez `MIDNIGHT_TESTING_GUIDE.md` pour les tests complets

---

## 💡 Dépannage

### Addon toujours incompatible après correction du TOC
- ❌ Version interface incorrecte
- ✅ Essayez la prochaine version de la liste
- ✅ Entrez la commande WoW pour vérifier la vraie version

### Addon charge mais erreurs Lua
- ✅ C'est normal au début
- ✅ Consultez `MIDNIGHT_TESTING_GUIDE.md`
- ✅ Certaines APIs peuvent nécessiter d'autres corrections

### Sphère n'apparaît pas
- ✅ Rechargez l'addon : `/reload`
- ✅ Vérifiez les erreurs Lua
- ✅ Vérifiez que Compat.lua se charge en premier

---

## 📞 Aide

Si l'addon reste incompatible :
1. **Donnez-moi la version interface** affichée par WoW (via /run GetBuildInfo())
2. **Je corrigerai le TOC** avec la bonne version
3. **On retestera ensemble**

---

## ⚡ Résumé Rapide

```
1. /run local m,n,p,b=GetBuildInfo() print("Interface: "..m..n..p)
2. Noter le numéro (ex: 110000)
3. Éditer Necrosis_Midnight.toc première ligne
4. Changer "## Interface: 110000" vers le numéro noté
5. /reload
6. Vérifier que l'addon charge
```

Voilà ! Cela devrait résoudre l'incompatibilité.
