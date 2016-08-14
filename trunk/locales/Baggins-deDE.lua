local L = LibStub("AceLocale-3.0"):NewLocale("Baggins", "deDE")
if not L then return end

L["Armor"] = "Rüstung"
	L["Cloth"] = "Stoff"
	L["Idols"] = "Götze"
	L["Leather"] = "Leder"
	L["Librams"] = "Buchband"
	L["Mail"] = "Schwere Rüstung"
	L["Miscellaneous"] = "Verschiedenes"
	L["Shields"] = "Schilde"
	L["Totems"] = "Totem"
	L["Plate"] = "Platte"
L["Consumable"] = "Verbrauchbar"
L["Container"] = "Behälter"
	L["Bag"] = "Tasche"
	L["Enchanting Bag"] = "Verzauberertasche"
	L["Engineering Bag"] = "Ingenieurstasche"
	L["Herb Bag"] = "Kräutertasche"
	L["Soul Bag"] = "Seelentasche"
L["Key"] = "Schlüssel"
L["Miscellaneous"] = "Verschiedenes"
	L["Junk"] = "Plunder"
L["Reagent"] = "Reagenz"
L["Recipe"] = "Rezept"
	L["Alchemy"] = "Alchemie"
	L["Blacksmithing"] = "Schmiedekunst"
	L["Book"] = "Buch"
	L["Cooking"] = "Kochkunst"
	L["Enchanting"] = "Verzauberungskunst"
	L["Engineering"] = "Ingenierskunst"
	L["First Aid"] = "Erste Hilfe"
	L["Leatherworking"] = "Lederverarbeitung"
	L["Tailoring"] = "Schneiderrei"
L["Projectile"] = "Projektil"
	L["Arrow"] = "Pfeil"
	L["Bullet"] = "Kugel"
L["Quest"] = "Quest"
L["Quiver"] = "Köcher"
	L["Ammo Pouch"] = "Munitionsbeutel"
	L["Quiver"] = "Köcher"
L["Trade Goods"] = "Handwerkswaren"
	L["Devices"] = "Geräte"
	L["Explosives"] = "Sprengstoff"
	L["Parts"] = "Teile"
	L["Gems"] = "Edelsteine"
L["Weapon"] = "Waffe"
	L["Bows"] = "Bögen"
	L["Crossbows"] = "Armbrüste"
	L["Daggers"] = "Dolche"
	L["Guns"] = "Schusswaffen"
	L["Fishing Pole"] = "Angel"
	L["Fist Weapons"] = "Faustkampfwaffen"
	L["Miscellaneous"] = "Verschiedenes"
	L["One-Handed Axes"] = "Einhandäxte"
	L["One-Handed Maces"] = "Einhandstreitkolben"
	L["One-Handed Swords"] = "Einhandschwerter"
	L["Polearms"] = "Stangenwaffen"
	L["Staves"] = "Stäbe"
	L["Thrown"] = "Wurfwaffe"
	L["Two-Handed Axes"] = "Zweihandäxte"
	L["Two-Handed Maces"] = "Zweihandstreitkolben"
	L["Two-Handed Swords"] = "Zweihandschwerter"
	L["Wands"] = "Zauberstäbe"
		--end of localizations needed for rules to work


L["Baggins"] = "Baggins"
L["Toggle All Bags"] = "Aktiviere alle Taschen."
L["Columns"] = "Spalten"
L["Number of Columns shown in the bag frames"] = "Anzahl der Spalten in den Taschenfenstern."
L["Layout"] = "Layout"
L["Layout of the bag frames."] = "Layout des Taschenfensters."
L["Automatic"] = "Automatisch"
L["Automatically arrange the bag frames as the default ui does"] = "Automatisch die Taschenfenster anordnen wie es die Blizzard Taschen auch tun."
L["Manual"] = "Manuell"
L["Each bag frame can be positioned manually."] = "Jede Tasche kann manuell positioniert werden."
L["Show Section Title"] = "Zeige Kategorie Titel"
L["Show a title on each section of the bags"] = "Zeige den Titel von jeder Kategorie auf den Taschen."
L["Sort"] = "Sortiere"
L["How items are sorted"] = "Wie die Items sortiert werden."
L["Quality"] = "Qualität"
L["Items are sorted by quality."] = "Items werden nach Qualität sortiert."
L["Name"] = "Namen"
L["Items are sorted by name."] = "Items werden nach Namen sortiert."
L["Hide Empty Sections"] = "Verstecke Leere Kategorien"
L["Hide sections that have no items in them."] = "Verstecke Kategorien die keinen Inhalt haben."
L["Hide Default Bank"] = "Verstecke normale Bank"
L["Hide the default bank window."] = "Verstecke das normale Bankfenster."
L["FuBar Text"] = "FuBar Text"
L["Options for the text shown on fubar"] = "Optionen für den Text der in Fubar angezeigt wird."
L["Show empty bag slots"] = "Zeige leere Taschenplätze"
L["Show used bag slots"] = "Zeige benutzte Taschenplätze"
L["Show Total bag slots"] = "Zeige gesammte Taschenplätze"
L["Combine Counts"] = "Kombiniere Anzahl"
L["Show only one count with all the seclected types included"] = "Zeige nur eine Anzahl mit allen ausgewählten Typen darin."
L["Show Ammo Bags Count"] = "Zeige Munitionstaschenplätze Anzahl"
L["Show Soul Bags Count"] = "Zeige Seelentaschenplätze Anzahl"
L["Show Specialty Bags Count"] = "Zeige Spezielle Taschen Anzahl"
L["Show Specialty (profession etc) Bags Count"] = "Zeige Spezielle (Berufe ect.) Taschen Anzahl."
L["Set Layout Bounds"]= "Justiere Layoutbestimmungen"
L["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] = "Zeig ein Fenster das du verschieben und in der Größe ändern kannst um zu bestimmen wo die Taschen angezeigt werden wenn das Layout auf 'Automatisch' steht."
L["Lock"] = "Sperren"
L["Locks the bag frames making them unmovable"] = "Sperrt die Taschenfenster gegen verschieben."
L["Shrink Width"] = "Verkleinere Breite"
L["Shrink the bag's width to fit the items contained in them"] = "Verkleinere die Breite der Taschen damit die Items in ihnen optimal reinpassen."
L["Compress"] = "Komprimiere"
L["Compress Multiple stacks into one item button"] = "Komprimiere mehrere Stapel eines Items in ein Item Symbol"
L["Compress All"] = "Komprimiere Alles"
L["Show all items as a single button with a count on it"] = "Zeige alle Gegenstände in einer einzigen Taste mit der Anzahl darin"
L["Compress Empty Slots"] = "Komprimiere leere Felder"
L["Show all empty slots as a single button with a count on it"] = "Zeige alle leeren Felder in einer einzigen Taste mit der Anzahl darin"
L["Compress Soul Shards"] = "Komprimiere Seelensteine"
L["Show all soul shards as a single button with a count on it"] = "Zeige alle Seelensplitter in einer einzigen Taste mit der Anzahl darin"
L["Compress Ammo"] = "Komprimiere Munition"
L["Show all ammo as a single button with a count on it"] = "Zeige alle Munition in einer einzigen Taste mit der Anzahl darin"
L["Quality Colors"]= "Qualitäts Farben"
L["Color item buttons based on the quality of the item"] = "Färbe die Itemtasten nach der Qualität der Items."
L["Enable"] = "Aktiviere"
L["Enable quality coloring"] = "Aktiviere das einfärben nach Qualität."
L["Color Threshold"] = "Farben Begrenzung"
L["Only color items of this quality or above"] = "Färbe nur Items ab dieser Qualität und höher."
L["Color Intensity"] = "Farben Intensität"
L["Intensity of the quality coloring"] = "Intensität des einfärben nach Qualität."
L["Edit Bags"] = "Editiere Taschen"
L["Edit the Bag Definitions"] = "Editiere die Taschen Definitionen."
L["Edit Categories"] = "Editiere Kategorieren"
L["Edit the Category Definitions"] = "Editiere die Kategorie Definitionen."
L["Load Profile"] = "Lade Profil"
L["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] = "Lade ein eingebautes Profil: BEACHTE: ALLE selbst erstellten Taschen gehn verlohren und alle editierten Kategorien in den selbst erstellten Taschen auch."
L["Default"] = "Grundeinstellung"
L["A default set of bags sorting your inventory into categories"] = "Vorgegebenes Profil an Taschen die nach Kategorien sortiert sind."
L["All in one"] = "Alle in Einer"
L["A single bag containing your whole inventory, sorted by quality"] = "Eine einzige Tasche die dein gesmmtes Inventar enthält, sortiert nach Qualität."
L["Scale"] = "Skalierung"
L["Scale of the bag frames"] = "Skalierung des Taschen Fensters."
		--bagtypes
L["Backpack"] = "Rucksack"
L["Bag1"] = "Tasche 1"
L["Bag2"] = "Tasche 2"
L["Bag3"] = "Tasche 3"
L["Bag4"] = "Tasche 4"
L["Bank Frame"] = "Bank Fenster"
L["Bank Bag1"] = "Banktasche 1"
L["Bank Bag2"] = "Banktasche 2"
L["Bank Bag3"] = "Banktasche 3"
L["Bank Bag4"] = "Banktasche 4"
L["Bank Bag5"] = "Banktasche 5"
L["Bank Bag6"] = "Banktasche 6"
L["Bank Bag7"] = "Banktasche 7"
L["Reagent Bank"] = true
L["KeyRing"] = "Schlüsselbund"

		--qualoty names
L["Poor"] = "Schlecht"
L["Common"] = "Verbreitet"
L["Uncommon"] = "Selten"
L["Rare"] = "Rar"
L["Epic"] = "Episch"
L["Legendary"] = "Legendär"
L["Artifact"] = "Artefakt"

L["None"] = "Keins"
L["All"] = "Alle"

L["Item Type"] = "Item Typ"
L["Filter by Item type and sub-type as returned by GetItemInfo"] = "Filtere nach Gegenstandstyp und Untertyp wie es GetItemInfo ausgibt."
L["ItemType - "] = "Gegenstandstyp"
L["Item Type Options"] = "Gegenstandstyp Optionen"
L["Item Subtype"] = "Gegenstands-Untertyp"

L["Container Type"] = "Behälter Typ"
L["Filter by the type of container the item is in."] = "Filtere nach dem Typ des Behälters in dem der Gegenstand ist."
L["Container : "] = "Behälter : "
L["Container Type Options"] = "Behälter Typ Optionen."

L["Item ID"] = "Gegenstand ID"
L["Filter by ItemID, this can be a space delimited list or ids to match."] = "Filtere nach Gegenstands-ID, dies kann eine Leerstellen unlimitierte Liste oder ID's sein."
L["ItemIDs "] = "Gegenstand-IDs"
L["ItemID Options"] = "Gegenstand-IDs Optionen."
L["Item IDs (space seperated list)"] = "Gegenstand-IDs (Leerstellen getrennte Liste)"
L["New"] = "Neu"
L["Current IDs, click to remove"] = "Gegenwärtige IDs, klicken um zu entfernen"

L["Filter by the bag the item is in"] = "Filtere nach der Tasche in der der Gegenstand ist."
L["Bag "] = "Tasche "
L["Bag Options"] = "Taschen Optionen."
L["Ignore Empty Slots"] = "Ignoriere Leere Felder"

L["Item Name"] = "Gegenstandsname"
L["Filter by Name or partial name"] = "Filtere nach Namen oder Teilnamen."
L["Name: "] = "Name: "
L["Item Name Options"] = "Gegenstandsnamen Optionen"
L["String to Match"] = "Zeichenkette zum Übereinstimmen"

L["PeriodicTable Set"] = "PeriodischerTabellen Satz"
L["Filter by PeriodicTable Set"] = "Filtere nach PeriodischerTabellen Satz"
L["Periodic Table Set Options"] = "PeriodischerTabellen Satz Optionen"
L["Set"] = "Satz"

L["Empty Slots"] = "Leere Felder"
L["Empty bag slots"] = "Leere Taschen Felder"

L["Ammo Bag"] = "Munitionstasche"
L["Items in an ammo pouch or quiver"] = "Gegenstände in einem Munitionsbeutel oder Köcher"
L["Ammo Bag Slots"] = "Munitionstaschen Felder"

L["Quality"] = "Qualität"
L["Filter by Item Quality"] = "Filtere nach Gegenstands-Qualität."
L["Quality Options"] = "Qualitäts Optionen"
L["Comparison"] = "Vergleichen"

L["Equip Location"] = "Ausrüstungsposition"
L["Filter by Equip Location as returned by GetItemInfo"] = "Filtere nach der Ausrüstungsposition wie sie von GetItemInfo ausgegeben wird."

L["Equip Location Options"] = "Ausrüstungsposition Optionen"
L["Location"] = "Position"

L["Unfiltered Items"] = "Ungefilterte Gegenstände"
L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] = "Trifft für alle Gegenstände zu bei dehnen nicht der Filter einer anderen Tasche zutrifft. HINWEIS: Dies sollte die einzige Kategorie sein, andere werden ignorierd."
L["Unfiltered"] = "Ungefiltert"

L["Bind"] = "Seelengebunden"
L["Filter based on if the item binds, or if it is already bound"] = "Filter basierend auf Gegestands-Seelen-Verbindungen, oder wenn es bereits gebunden ist."
L["Bind *unset*"] = "Binden *ungesezt*"
L["Unbound"] = "Ungebunden"
L["Bind Options"] = "Seelengebunden Optionen"
L["Bind Type"] = "Binden Typ"
L["Binds on pickup"] = "Gebunden beim Aufheben"
L["Binds on equip"] = "Gebunden beim Anziehen"
L["Binds on use"] = "Gebunden bei Benutzung"
L["Soulbound"] = "Seelengebunden"

L["Tooltip"] = "Tooltip"
L["Filter based on text contained in its tooltip"] = "Filtere basierend auf dem Text der in dem Tooltip ist."
L["Tooltip Options"] = "Tooltip Optionen"

L["ItemID: "] = "Gegenstands-ID: "
L["Item Type: "] = "Gegenstandstyp: "
L["Item Subtype: "] = "Gegenstands-Untertyp: "

L["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] = "Klick auf einen Tasche um sie zu öffnen. Shift-Klick um hoch zu bewegen. Alt-Klick um runter zubewegen."

L["Bags"] = "Taschen"
L["Options"] = "Optionen"
L["Open With All"] = "Öffnen mit Allem"
L["Bank"] = "Bank"
L["Sections"] = "Sektionen"
L["Categories"] = "Kategorie"
L["Add Category"] = "Kategorie hinzufügen"
L["New Section"] = "Neue Sektion"
L["New Bag"] = "Neue Tasche"
L["Close"] = "Schliessen"
L["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] = "Klick auf Eintrag zum öffnen. Shift-Klick um hoch zu bewegen. Alt-Klick um runter zubewegen. Strg-Klick um zu löschen."
L["Rules"] = "Regeln"
L["New Rule"] = "Neue Regel"
L["Add Rule"] = "Regel hinzufügen"
L["New Category"] = "Neue Kategorie"
L["Apply"] = "Anwenden"
L["Click on an entry to open. Ctrl-Click to delete."] = "Klick auf einen Eintrag zum öffnen. Strg-klick zum löschen."

L["Editing Rule"] = "Editiere Regel"
L["Type"] = "Typ"
L["Select a rule type to create the rule"] = "Wähle einen Regltyp um die Regel zu erstellen."
L["Operation"] = "Vorgang"
L["AND"] = "UND"
L["OR"] = "ODER"
L["NOT"] = "NICHT"

L["Baggins - New Bag"] = "Baggins - Neue Tasche"
L["Baggins - New Section"] = "Baggins - Neue Sektion"
L["Baggins - New Category"] = "Baggins - Neue Kategorie"
L["Accept"] = "Akzeptieren"
L["Cancel"] = "Abbrechen"

L["Are you sure you want to delete this Bag? this cannot be undone"] = "Bist du sicher das du diese Tasche löschen willst? Dies kann nicht rückgängig gemacht werden."
L["Are you sure you want to delete this Section? this cannot be undone"] = "Bist du sicher das du diese Sektion löschen willst? Dies kann nicht rückgängig gemacht werden."
L["Are you sure you want to remove this Category? this cannot be undone"] = "Bist du sicher das du diese Kategorie löschen willst? Dies kann nicht rückgängig gemacht werden."
L["Are you sure you want to remove this Rule? this cannot be undone"] = "Bist du sicher das du diese Regel löschen willst? Dies kann nicht rückgängig gemacht werden."
L["Delete"] = "Löschen"
L["Cancel"] = "Abbrechen"

L["That category is in use by one or more bags, you cannot delete it."] = "Diese Kategorie wird von einer oder mehreren Taschen verwendet, du kannst sie nicht löschen."
L["A category with that name already exists."] = "Ein Kategorie mit diesem Namen existiert bereits."

L["Drag to Move\nRight-Click to Close"] = "Ziehen zum bewegen\nRechts-Klick zum schliessen"
L["Drag to Size"] = "Ziehen um Größe einzustellen"

L["Previous "] = "Vorherige"
L["Next "] = "Nächste"

L["All In One"] = "Alles in Einer"
L["Bank All In One"] = "Bank Alles in Einer"
L["Bank Bags"] = "Bank Taschen"

L["Equipment"] = "Ausrüstung"
L["Weapons"] = "Waffen"
L["Quest Items"] = "Quest Gegenstände"
L["Consumables"] = "Verbrauchbares"
L["Water"] = "Wasser"
L["Food"] = "Essen"
L["FirstAid"] = "Erste Hilfe"
L["Potions"] = "Tränke"
L["Scrolls"] = "Schriftrollen"
L["Misc"] = "Verschiedenes"
L["Misc Consumables"] = "Verschiedenes zum verbrauchen"

L["Mats"] = "Materialien"
L["Tradeskill Mats"] = "Handwerks Materialien"
L["Gathered"] = "Gesammelt"
L["BankBags"] = "BankTaschen"
L["Ammo"] = "Munition"
L["AmmoBag"] = "MunitionsTasche"
L["SoulShards"] = "SeelenSplitter"
L["SoulBag"] = "SeelenTasche"
L["Other"] = "Anderes"
L["Trash"] = "Plunder"
L["TrashEquip"] = "PlunderAusrüstung"
L["Empty"] = "Leer"
L["Bank Equipment"] = "Bank Ausrüstung"
L["Bank Quest"] = "Bank Quest"
L["Bank Consumables"] = "Bank Verbrauchbares"
L["Bank Trade Goods"] = "Bank Handwerkswaren"
L["Bank Other"] = "Bank Anderes"

L["Add To Category"] = "Hinzufügen zur Kategorie"
L["Exclude From Category"] = "Entfernen von der Kategorie"
L["Item Info"] = "Gegenstands-Info"
L["Quality: "] = "Qualität: "
L["Level: "] = "Level: "
L["MinLevel: "] = "MinLevel: "
L["Stack Size: "] = "Stapel Größe: "
L["Equip Location: "] = "Trage Position: "
L["Periodic Table Sets"] = "Periodische Tabelle Sätze"

L["Highlight New Items"] = "Neue Items hervorheben"
L["Add *New* to new items, *+++* to items that you have gained more of."] = "Füge *NEU* zu neuen Gegenständen, *+++* zu Gegenständen von dehnen du noch mehr hast."
L["Reset New Items"] = "Neue Items resetten"
L["Resets the new items highlights."] = "Resettet die gegenwärtig als neu hervorgehoben Gegenstände."
L["*New*"] = "*Neu*"

L["Hide Duplicate Items"] = "Verstecke doppelte Gegenstände"
L["Prevents items from appearing in more than one section/bag."] = "Verhindert das Gegenstände mehr als einmal in einer Sektion/Tasche angezeigt werden."

L["Optimize Section Layout"] = "Optimiere Sektionsanordnung"
L["Change order and layout of sections in order to save display space."] = "Ändere Reihenfolge und die Anordnung der Sektionen um optisch alles platzsparender anzuzeigen."

L["All In One Sorted"]= "Alles in Einer-Sortiert"
L["A single bag containing your whole inventory, sorted into categories"]= "Eine einzige Tasche welche dein gesammtes Inventar enthält, sortiert nach Kategorien."

L["Compress Stackable Items"]= "Komprimiere stapelbare Gegenstände"
L["Show stackable items as a single button with a count on it"]= "Zeige stapelbare Gegenstände als eine einzige Taste mit einem Zähler darin."

L["Appearance and layout"]= "Aussehn und Layout"
L["Bags"]= "Taschen"
L["Bag display and layout settings"]= "Taschen Aussehn und Layout Einstellungen."
L["Layout Type"]= "Layout Typ"
L["Sets how all bags are laid out on screen."]= "Stellt ein wie alle Taschen auf dem Bildschrim angeordnet werden."
L["Shrink bag title"]= "Verkleinere Taschen Titel"
L["Mangle bag title to fit to content width"]= "Passt den Titeltext der Breite der Tasche an wenn nötig."
L["Sections"]= "Sektionen"
L["Bag sections display and layout settings."]= "Taschen Sektions Anzeige und Layout Einstellungen."
L["Items"]= "Gegenstände"
L["Item display settings"]= "Gegennstandsanzeige Einstellungen."
L["Bag Skin"]= "Taschen Ausssehn"
L["Select bag skin"]= "Wähle das Taschen Aussehn."

L["Show Bank Controls On Bag"] = true
L["Which Bag to Show Bank Controls On"] = true

L["Buy Bank Bag Slot"] = true
L["Buy Reagent Bank"] = true
L["Deposit All Reagents"] = true
L["Crafting Reagent"] = true
L["Reagent Deposit"] = true
L["Automatically deposits crafting reagents into the reagent bank if available."] = true

L["Disable Bag Menu"] = true
L["Disables the menu that pops up when right clicking on bags."] = true

L["Override Backpack Button"] = true
L["Baggins will open when clicking the backpack. Holding alt will open the default backpack."] = true
L["General"] = true
L["Display and Overrides"] = true
L["Display"] = true
L["Overrides"] = true

L["New Item Duration"] = true
L["Controls how long (in minutes) an item will be considered new. 0 disables the time limit."] = true
