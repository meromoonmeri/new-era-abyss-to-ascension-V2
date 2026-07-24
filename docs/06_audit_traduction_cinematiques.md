# Audit traduction — cinématiques et textes visibles

Date : 2026-07-24

## Résultat principal

Le chapitre 5 n'est **pas encore entièrement en français**.

Les dialogues principaux référencés par `STRINGS.MapStrings` sont bien localisés :

- 18 scripts de scènes du chapitre 5 examinés ;
- 739 clés `MapStrings` référencées ;
- 739 versions françaises présentes.

Cependant, plusieurs dialogues secondaires, voix off et conversations d'interaction sont encore écrits directement dans les fichiers Lua.

## Chapitre 5 — textes encore en dur en anglais

Après retrait des commentaires Lua, il reste **93 appels actifs** de dialogue/voix/menu sans `STRINGS:Format` dans les scènes du chapitre 5.

Fichiers principaux concernés :

- `searing_tunnel_entrance/searing_tunnel_entrance_ch_5.lua` : 24 ;
- `vast_steppe_entrance/vast_steppe_entrance_ch_5.lua` : 18 ;
- `metano_town/metano_town_ch_5.lua` : 14 ;
- `searing_tunnel_midpoint/searing_tunnel_midpoint_ch_5.lua` : 10 ;
- `guild_guildmasters_room/guild_guildmasters_room_ch_5.lua` : 4 ;
- `guild_second_floor/guild_second_floor_ch_5.lua` : 4 ;
- `guild_third_floor_lobby/guild_third_floor_lobby_ch_5.lua` : 4 ;
- `metano_cafe/metano_cafe_ch_5.lua` : 4 ;
- `metano_inn/metano_inn_ch_5.lua` : 4 ;
- autres maisons/lieux : 7.

Exemples visibles :

- voix off du départ de l'expédition dans `guild_third_floor_lobby_ch_5.lua` ;
- dialogues de ravitaillement et de défaite à l'entrée de la Grande Steppe ;
- conversations du Tunnel Incandescent et du point de contrôle ;
- discussions annexes de la ville, du café, de l'auberge et des maisons ;
- textes provisoires `"Placeholder."`, `"alo"` et `"Inneeways!"`.

## Correctif déjà appliqué dans cette passe

Les textes directement codés identifiés dans les premières scènes ont été déplacés vers les `.resx` et traduits :

- 1 texte de l'étang Altere ;
- 6 textes de la scène de la guilde ;
- 2 textes de Metano ;
- 2 pensées du héros au Crucible ;
- 4 textes du Tunnel Incandescent.

Les scripts Lua concernés utilisent maintenant `STRINGS:Format(STRINGS.MapStrings[...])`.

Validation :

- 178 fichiers Lua analysés ; 0 erreur de syntaxe ;
- 0 fichier `.resx` invalide ;
- 0 doublon de clé dans les `.resx` modifiés.

## Reste du mod

Le problème ne concerne pas uniquement le chapitre 5 :

- de nombreux appels de dialogue restent en dur dans les scènes des chapitres 1 à 4 ;
- `PartnerEssentials.lua`, les scripts de la guilde et certains événements génériques contiennent encore beaucoup d'anglais ;
- 80 clés `Strings/stringsEx.fr.resx` restent manquantes, notamment les répliques de commentaires en donjon `TALK_FULL_3100` à `TALK_FULL_3164` et les clés d'erreur `TALK_*_9999` ;
- plusieurs noms de zones, rangs, objets et statuts dans `Data/*.json` n'ont pas encore de `LocalTexts.fr`.

## Conclusion

La traduction française des **739 clés principales du chapitre 5** est présente, mais cela ne signifie pas que toutes les cinématiques et interactions du chapitre sont traduites. Les 93 dialogues Lua encore en dur doivent être migrés vers les `.resx` puis traduits pour obtenir un chapitre 5 réellement entièrement en français.

Ce contrôle est statique ; les scènes n'ont pas été testées dans PMDO en jeu.
