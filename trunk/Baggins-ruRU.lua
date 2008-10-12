﻿local L = AceLibrary("AceLocale-2.2"):new("Baggins")


L:RegisterTranslations("ruRU", function()
	return {
		--itemtypes, these must match the Type and SubType returns from GetItemInfo for the ItemType rule to work
		["Armor"] = "Броня",
			["Cloth"] = "Тряпичная броня",
			["Idols"] = "Идол",
			["Leather"] = "Кожа",
			["Librams"] = "Либрам",
			["Mail"] = "Кольчуга",
			["Miscellaneous"] = "Разное",
			["Shields"] = "Щит",
			["Totems"] = "Тотем",
			["Plate"] = "Латы",
		["Consumable"] = "Расходуемое",
		["Container"] = "Контейнер",
			["Bag"] = "Сумка",
			["Enchanting Bag"] = "Сумка зачаровывателя",
			["Engineering Bag"] = "Сумка инженера",
			["Herb Bag"] = "Сумка травника",
			["Soul Bag"] = "Сумка Душ",
		["Key"] = "Ключ",
		["Miscellaneous"] = "Разное",
			["Junk"] = "Мусор",
		["Reagent"] = "Реагент",
		["Recipe"] = "Рецепт",
			["Alchemy"] = "Алхимия",
			["Blacksmithing"] = "Кузнечное дело",
			["Book"] = "Книга",
			["Cooking"] = "Кулинария",
			["Enchanting"] = "Чародейство",
			["Engineering"] = "Инженерное дело",
			["First Aid"] = "Первая помощь",
			["Leatherworking"] = "Кожевенное дело",
			["Tailoring"] = "Портняжное дело",
		["Projectile"] = "Боеприпасы",
			["Arrow"] = "Стрелы",
			["Bullet"] = "Пули",
		["Quest"] = "Задания",
		["Quiver"] = "Колчан",
			["Ammo Pouch"] = "Подсумок",
			["Quiver"] = "Колчан",
		["Trade Goods"] = "На продажу",
			["Devices"] = "Устройства",
			["Explosives"] = "Взрывчатка",
			["Parts"] = "Запчасти",
			["Gems"] = "Самоцветы",
		["Weapon"] = "Оружие",
			["Bows"] = "Лук",
			["Crossbows"] = "Арбалет",
			["Daggers"] = "Кинжал",
			["Guns"] = "Огнестрельное",
			["Fishing Pole"] = "Удочка",
			["Fist Weapons"] = "Кистевое",
			["Miscellaneous"] = "Разное",
			["One-Handed Axes"] = "Одноручный топор",
			["One-Handed Maces"] = "Одноручная дубина",
			["One-Handed Swords"] = "Одноручный меч",
			["Polearms"] = "Древко",
			["Staves"] = "Посох",
			["Thrown"] = "Метательное",
			["Two-Handed Axes"] = "Двуручный топор",
			["Two-Handed Maces"] = "Двуручная дубина",
			["Two-Handed Swords"] = "Двуручный меч",
			["Wands"] = "Жезл",
		--end of localizations needed for rules to work
		
	
	    ["Baggins"] = "Сумкин",
		["Toggle All Bags"] = "Показать Все сумки",
		["Columns"] = "Номера Колонок",
		["Number of Columns shown in the bag frames"] = "Номера колонок Позываются в области сумок",
		["Layout"] = "Расположение",
		["Layout of the bag frames."] = "Расположение области сумок",
		["Automatic"] = "Автоматически",
		["Automatically arrange the bag frames as the default ui does"] = "Автоматически формирует область сумок на ui по умолчанию",
		["Manual"] = "Вручную",
		["Each bag frame can be positioned manually."] = "Каждую область сумок можно сформировать вручную",
		["Show Section Title"] = "Показать названия Секций",
		["Show a title on each section of the bags"] = "Покажите название на каждой секции сумок",
		["Sort"] = "Сортировать",
		["How items are sorted"] = "Как сортировать Предметы",
		["Quality"] = "Качество",
		["Items are sorted by quality."] = "Сортировать предметы по качеству",
		["Name"] = "Название",
		["Items are sorted by name."] = "Сортировать предметы по названию",
		["Hide Empty Sections"] = "Скройте Пустые Секции",
		["Hide sections that have no items in them."] = "Скрывает Пустые Секции если вних нет предметов",
		["Hide Default Bank"] = "Скрывает банк по Умолчанию",
		["Hide the default bank window."] = "Скрывает окно банка по умолчанию",
		["FuBar Text"] = "Fubar Текст",
		["Options for the text shown on fubar"] = "Fubar  Опции для Показа текста",
		["Show empty bag slots"] = "Показать пустые слоты сумок",
		["Show used bag slots"] = "Показать заполненые слоты сумок",
		["Show Total bag slots"] = "Показать Всего слотов в сумках",
		["Combine Counts"] = "Рассчитать обьединение",
		["Show only one count with all the seclected types included"] = "Покажите только один тип сумок со всеми включенными выбранными типами",
		["Show Ammo Bags Count"] = "Показ сумку Патронов видимой",
		["Show Soul Bags Count"] = "Показ сумку Осколков видимой",
		["Show Specialty Bags Count"] = "Показ специальные сумки видимыми",
		["Show Specialty (profession etc) Bags Count"] = "Показ специальные ( только по проффесиям) сумки видимыми",
		["Set Layout Bounds"]= "Настройка автоматического Перемещения",
		["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] = "Показывает область, которую Вы можете тянуть и размер, чтобы установить его, куда сумки будут туда помещены, когда Расположение будет автоматическим",
		["Lock"] = "Закрепить",
		["Locks the bag frames making them unmovable"] = "Закрепляет область сумок чтобы не двигалась",
		["Shrink Width"] = "Сокращение Ширины",
		["Shrink the bag's width to fit the items contained in them"] = "Сократите ширину сумки, чтобы она соответствовала предметам, содержавшимся в ней",
		["Compress"] = "Сжатие",
		["Compress Multiple stacks into one item button"] = "Сожмите Многократные стеки в одну кнопку предмета",
		["Compress All"] = "Сжать все",
		["Show all items as a single button with a count on it"] = "Сожмите Многократные стеки в одну кнопку для  всех предметов",
		["Compress Empty Slots"] = "Сжать пустые слоты",
		["Show all empty slots as a single button with a count on it"] = "Сожмите Пустые слоты в одну кнопку предмета",
		["Compress Soul Shards"] = "Сжать осколки Души",
		["Show all soul shards as a single button with a count on it"] = "Сожмите Осколки души в одну кнопку предмета",
		["Compress Ammo"] = "Сожмите Пули",
		["Show all ammo as a single button with a count on it"] = "Сожмите Пули в одну кнопку предмета",
		["Quality Colors"]= "Цвет Качества",
		["Color item buttons based on the quality of the item"] = "Цвет Кнопки предметов сжатых из нескольких слотов",
		["Enable"] = "Включить",
		["Enable quality coloring"] = "Включает подкраску качества",
		["Color Threshold"] = "Порог  Цвета",
		["Only color items of this quality or above"] = "Окрашивает только порог  качества предмета или выше",
		["Color Intensity"] = "Интенсивность окраски",
		["Intensity of the quality coloring"] = "Интенсивность окраски качества",
		["Edit Bags"] = "Править Сумку",
		["Edit the Bag Definitions"] = "Править Определения Сумок",
		["Edit Categories"] = "Править Категории",
		["Edit the Category Definitions"] = "Править Определения Категорий",
		["Load Profile"] = "Загрузить Профиль",
		["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] = "Загрузите встроенный профиль: ОТМЕТЬТЕ: ВСЕ Текущие Сумки будут потеряны, и любой редактирование настроенное в категориях, будет потеряно.",
		["Default"] = "Умолчания",
		["A default set of bags sorting your inventory into categories"] = "Набор по умолчанию сумок, сортирующих Ваш инвентарь по категориям",
		["All in one"] = "Все в Одной",
		["A single bag containing your whole inventory, sorted by quality"] = "Единственная сумка, содержащая весь Вашинвентарь, сортированный по качеству",
		["Scale"] = "Масштаб",
		["Scale of the bag frames"] = "Масштаб Области сумок",
		--bagtypes
		["Backpack"] = "Рюкзак",
		["Bag1"] = "Сумка1",
		["Bag2"] = "Сумка2",
		["Bag3"] = "Сумка3",
		["Bag4"] = "Сумка4",
		["Bank Frame"] = "Область Банка",
		["Bank Bag1"] = "Сумка Банка1",
		["Bank Bag2"] = "Сумка Банка2",
		["Bank Bag3"] = "Сумка Банка3",
		["Bank Bag4"] = "Сумка Банка4",
		["Bank Bag5"] = "Сумка Банка5",
		["Bank Bag6"] = "Сумка Банка6",
		["Bank Bag7"] = "Сумка Банка7",
		["KeyRing"] = "Ключница",
		
		--qualoty names
		["Poor"] = "Простой",
		["Common"] = "Обычный",
		["Uncommon"] = "Необычный",
		["Rare"] = "Редкий",
		["Epic"] = "Эпический",
		["Legendary"] = "Легендарный",
		["Artifact"] = "Артефакт",
		
		["None"] = "Ни один",
		["All"] = "Все",
		
		["Item Type"] = "Тип Предмета",
		["Filter by Item type and sub-type as returned by GetItemInfo"] = "Фильтр по Типу предмета или подтипу как обратный Показ инфо Предмета",
		["ItemType - "] = "Предмет Тип - ",
		["Item Type Options"] = "Опции Типа Предмета",
		["Item Subtype"] = "Предмет Подтип",

		["Container Type"] = "Тип Контейнера",
		["Filter by the type of container the item is in."] = "Фильтр по типу контейнера  в котором находиться предмет",
		["Container : "] = "Контейнер:",
		["Container Type Options"] = "Опции Типа Контейнера",

		["Item ID"] = "Предмет ID",
		["Filter by ItemID, this can be a space delimited list or ids to match."] = "Фильтрация по ПредетID, можеть разграничен неораниченным списком для соответсвия.",
		["ItemIDs "] = "ПредметIDs",
		["ItemID Options"] = "ПредметIDs Опции",
		["Item IDs (space seperated list)"] = "ПредметIDs( (делают интервалы между смешанным списком )",
		["New"] = "Новый",
		["Current IDs, click to remove"] = "Текуший IDs, кликни для удаления",
		
		["Filter by the bag the item is in"] = "Фильтр по сумкам предмет в ",
		["Bag "] = "Сумка",
		["Bag Options"] = "Сумка  Опции",
		["Ignore Empty Slots"] = "Игнорировать пусты слоты",
		
		["Item Name"] = "Название  Предмета",
		["Filter by Name or partial name"] = "Фильтр по имени или частичному названию",
		["Name: "] = "Название:",
		["Item Name Options"] = "Опции названия Предметов",
		["String to Match"] = "Соотвующая последовательность",
		
		["PeriodicTable Set"] = "Набор Таблицы",
		["Filter by PeriodicTable Set"] = "Фильтр по наборам периодической таблицы",
		["Periodic Table Set Options"] = "Периодическая таблица Опции  Набора",
		["Set"] = "Набор",
		
		["Empty Slots"] = "Пустые Слоты",
		["Empty bag slots"] = "пустые слоты сумок",
		
		["Ammo Bag"] = "Сумка Патронов",
		["Items in an ammo pouch or quiver"] = "Предметы в сумке боеприпасов или порох",
		["Ammo Bag Slots"] = "Слоты Сумки Патронов",
		
		["Quality"] = "Качество",
		["Filter by Item Quality"] = "Фильтр качества Предметов",
		["Quality Options"] = "Опции Качества",
		["Comparison"] = "Сравнение",
		
		["Equip Location"] = "Расположение Экипировки",
		["Filter by Equip Location as returned by GetItemInfo"] = "Фильтр по Расположению Экипировки по ПредметПоказИнфо?",
		
		["Equip Location Options"] = "Опции Расположение Экипировки",
		["Location"] = "Расположение",
		
		["Unfiltered Items"] = "Нефильтрованные предметы",
		["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] = "Фильтрует все предметы, что были подобранны в любую другую сумку, ОТМЕТЬТЕ: это должно быть единственным правилом в категории, другие будут проигнорированы",
		["Unfiltered"] = "Нефильтрованные",
		
		["Bind"] = "Привязка",
		["Filter based on if the item binds, or if it is already bound"] = "Фильтр, основанный на привязке предмета, или если ое уже связан",
		["Bind *unset*"] = "Привязка *не набор*",
		["Unbound"] = "Непривязано",
		["Bind Options"] = "Опции привязки",
		["Bind Type"] = "Тип Привязки",
		["Binds on pickup"] = "Привязать загрузку",
		["Binds on equip"] = "Привязать экипировку",
		["Binds on use"] = "Привязать использование",
		["Soulbound"] = "Книга Душ",

		["Tooltip"] = "Окошки",
		["Filter based on text contained in its tooltip"] = "Фильтр, основанный на тексте, содержавшемся в окошке",
		["Tooltip Options"] = "Опции окошек",
		
		["ItemID: "] = "ПредметID:",
		["Item Type: "] = "Тип Предмета:",
		["Item Subtype: "] = "Подтип  Предмета:",
		
		["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] = "Клик по сумке чтобы посмотреть ее. Shift-clickчтобы двигать вверх. Alt-click чтобы двигать вниз",
		
		["Bags"] = "Сумка",
		["Options"] = "Опции",
		["Open With All"] = "Открывать со всеми",
		["Bank"] = "Банк",
		["Sections"] = "Секции",
		["Categories"] = "Категории",
		["Add Category"] = "Добавить Категорию?",
		["New Section"] = "Новая секция",
		["New Bag"] = "Новая сумка",
		["Close"] = "Закрыть",
		["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] = "Нажмите на ввод, чтобы открыть. Shift-Click, чтобы поднять. Alt-Click, чтобы опустить. Ctrl-Click, чтобы удалить.",
		["Rules"] = "Правило",
		["New Rule"] = "Новое Правило",
		["Add Rule"] = "Добавить правило",
		["New Category"] = "Новая категория",
		["Apply"] = "Обратиться",
		["Click on an entry to open. Ctrl-Click to delete."] = "Нажмите на ввод, чтобы открыть. Ctrl-Click, чтобы удалить.",
		
		["Editing Rule"] = "Редактировать Правило",
		["Type"] = "Тип",
		["Select a rule type to create the rule"] = "Выберите тип правила, чтобы создать правило",
		["Operation"] = "Операции",
		["AND"] = "И",
		["OR"] = "ИЛИ",
		["NOT"] = "НЕТ",
		
		["Baggins - New Bag"] = "Baggins - Новая сумка",
		["Baggins - New Section"] = "Baggins - Новая секция",
		["Baggins - New Category"] = "Baggins - Новая Категория",
		["Accept"] = "Принять",
		["Cancel"] = "Отменить",
		
		["Are you sure you want to delete this Bag? this cannot be undone"] = "Действительно ли Вы уверены, что Вы хотите удалить эту Сумку? она не может быть уничтожена",
		["Are you sure you want to delete this Section? this cannot be undone"] = "Действительно ли Вы уверены, что Вы хотите удалить эту Секцию? она не может быть уничтожена",
		["Are you sure you want to remove this Category? this cannot be undone"] = "Действительно ли Вы уверены, что Вы хотите удалить эту Категорию? она не может быть уничтожена",
		["Are you sure you want to remove this Rule? this cannot be undone"] = "Действительно ли Вы уверены, что Вы хотите удалить это Правило? она не может быть уничтожена",
		["Delete"] = "Удалить",
		["Cancel"] = "Отменить",
		
		["That category is in use by one or more bags, you cannot delete it."] = "Эта категория используется одной или более сумками, Вы не можете удалить ее.",
		["A category with that name already exists."] = "Категория с тем названием уже существует",
		
		["Drag to Move\nRight-Click to Close"] = "Двигать для Перемещения\nПравый Клик Закрыть",
		["Drag to Size"] = "Двигать Размер",
		
		["Previous "] = "Предыдущий",
		["Next "] = "Следующий",
		
		["All In One"] = "Все в Одной  сумке",
		["Bank All In One"] = "Банк все  в одном",
		["Bank Bags"] = "Сумка Банка",
		
		["Equipment"] = "Экипировка",
		["Weapons"] = "Оружие",
		["Quest Items"] = "Предметы квестов",
		["Consumables"] = "Предметы Потребления",
		["Water"] = "Вода",
		["Food"] = "Еда",
		["FirstAid"] = "Аптечка",
		["Potions"] = "Зелья",
		["Scrolls"] = "Свитки",
		["Misc"] = "Материалы",
		["Misc Consumables"] = "Потребляемые Материалы",

		["Mats"] = "Материалы",
		["Tradeskill Mats"] = "Уровень изготовления Материалов",
		["Gathered"] = "Собранные",
		["BankBags"] = "Сумки Банка",
		["Ammo"] = "Пули",
		["AmmoBag"] = "Сумка Патронов",
		["SoulShards"] = "Осколок Души",
		["SoulBag"] = "Сумка Душ",
		["Other"] = "Другие",
		["Trash"] = "Мусор",
		["TrashEquip"] = "Ненужная Экипировка",
		["Empty"] = "Пустой",
		["Bank Equipment"] = "Экипировка в банке",
		["Bank Quest"] = "Банк Квесты",
		["Bank Consumables"] = "Материалы в Банке",
		["Bank Trade Goods"] = "Банк Торговые товары",
		["Bank Other"] = "Банк Другие",
		
		["Add To Category"] = "Добавить к Категории",
		["Exclude From Category"] = "Удалить из Категории",
		["Item Info"] = "Предмет Инфо",
		["Use"] = "Использование",
			["Use/equip the item rather than bank/sell it"] = "Использовать/экипировать предмет, а не положить его в банк/продать",
		["Quality: "] = "Качество",
		["Level: "] = "Уровень:",
		["MinLevel: "] = "Мин. уровень:",
		["Stack Size: "] = "Размер Стека",
		["Equip Location: "] = "Расположение  Экипировки:",
		["Periodic Table Sets"] = "Расположение Таблицы",
		
		["Highlight New Items"] = "Первый План Новые Предметы",
		["Add *New* to new items, *+++* to items that you have gained more of."] = "Добавлять *Нов*, *+++* к предметам кторых вы получили больше.",
		["Reset New Items"] = "Обновить Новые Предметы",
		["Resets the new items highlights."] = "Обновить Новые Предметы первого плана",
		["*New*"] = "*Нов*",
		
		["Hide Duplicate Items"] = "Скрыть Дублируемые Предметы",
		["Prevents items from appearing in more than one section/bag."] = "Препятствует тому, чтобы предметы появились в больше чем одной секции/сумке",
		
		["Optimize Section Layout"] = "Оптимизируйте Расположение Секции",
		["Change order and layout of sections in order to save display space."] = "Настройки изменения и расположение секций, чтобы оставить свободное место на экране",
		
		["All In One Sorted"]= "Все в Одной Сортировка",
		["A single bag containing your whole inventory, sorted into categories"]= "Единственная сумка, содержащая весь Ваш инвентарь, сортированный по категориям",
		
		["Compress Stackable Items"]= "Сжать Стакающиеся Предметы",
		["Show stackable items as a single button with a count on it"]= "Покажите наращиваемые предметы как единственную кнопку со с этим предметом",

		["Appearance and layout"]= "Появление и расположение",
		["Bags"]= "Сумки",
		["Bag display and layout settings"]= "Показ сумки и параметры настройки расположения",
		["Layout Type"]= "Тип расположения",
		["Sets how all bags are laid out on screen."]= "настрйока как все сумки будут выглядет на экране",
		["Shrink bag title"]= "Сократить название сумки",
		["Mangle bag title to fit to content width"]= " Сокращает Название сумки , чтобы соответствовать названию сумки по ширине",
		["Sections"]= "Секции",
		["Bag sections display and layout settings."]= "??????????",
		["Items"]= "Предметы",
		["Item display settings"]= "Предметы опции Показа",
		["Bag Skin"]= "Шкурка сумок",
		["Select bag skin"]= "Выбрать сумку шкурок",
		
		["Compress bag contents"]= "Содержание Сжатой сумки",
		["Split %d"]= "Раскол %d",
		["Split_tooltip"] = "Раскол_окошко",
		
		["PT3 LoD Modules"] = "PT3 Загр Модуль",
		["Choose PT3 LoD Modules to load at startup, Will load immediately when checked"] = "Выберите PT3 LoD Модули, чтобы загрузить при запуске, он загрузит немедленно когда все проверено",
		["Load %s at Startup"] = "Загружать %s при Запуске",
		
		["Disable Compression Temporarily"] = "Отключить сжатие временно",
		["Disabled Item Compression until the bags are closed."] = "Отключает сжатие предметов когда сумки закрыты",
		
		["Always Resort"] = "Всегда Пересорт",
		["Keeps Items sorted always, this will cause items to jump around when selling etc."] = "Держит Предметы сортированными всегда, это заставит предметы подскакивать вокруг, продаваться и т.д.",
		
		["Force Full Refresh"] = "Полностью Обновить",
		["Forces a Full Refresh of item sorting"] = "Поностью обновляют и пересортировывают предметы",
		
		["Override Default Bags"] = "Отменяют сумки по умолчанию",
		["Baggins will open instead of the default bags"] = "Baggins откроется вместо сумок по умолчанию",
		["Sort New First"] = "Сортировать Новые",
		["Sorts New Items to the beginning of sections"] = "Сортирует новые Предметы в начальные секции",
		["New Items"] = "Новый предмет",
		
		["Items that match another category"] = "Предметы которые относятся к другой категории",
		["Category Options"] = "Опции  Категории",
		["Category"] = "Категории",

		["Layout Anchor"] = "Ресположение Якоря",
		["Sets which corner of the layout bounds the bags will be anchored to."] = "Настраивает в каком  углу будет расположен якорь сумок.",
		["Top Right"] = "Вверху Срава",
		["Top Left"] = "Вверху Слева",
		["Bottom Right"] = "Основание Справа",
		["Bottom Left"] = "Основание  Слева",

		["Show Money On Bag"] = "Показать деньги в сумке",
		["Which Bag to Show Money On"] = "Показывает деньги внутри сумки",

		["User Defined"] = "Определенный Пользователь",
		["Load a User Defined Profile"] = "Загрузить определенный профиль пользователя",
		["Save Profile"] = "Сохранить Профиль",
		["Save a User Defined Profile"] = "Сохранить определенный профиль пользователя",
		["New"] = "Новый",
		["Create a new Profile"] = "Создает новый Профиль",
		["Delete Profile"] = "Удалить Профиль",
		["Delete a User Defined Profile"] = "Удалить определенный профиль пользователя",
		["Save"] = "Сохранить",
		["Load"] = "Загрузить",
		["Delete"] = "Удалить",

		["Config Window"] = "Настройки Аддона",
		["Opens the Waterfall Config window"] = "Окрыть Ниспадающие настройки окна",
		["Bag/Category Config"] = "Сумки/Категории Настройка",
		["Opens the Waterfall Config window"] = "Открыть Waterfall меню настроек",
		["Rename / Reorder"] = "Переименовать/Пересортировать",
		["From Profile"] = "От Профиля",
		["User"] = "Пользователь",
		["Copy From"] = "Копия От",
		["Edit"] = "Править",
		["Automatically open at auction house"] = "Автоматически открывать на Аукционе",
		["Create"] = "Создать",
		["Bag Priority"] = "Приоритет сумок",
		["Section Priority"] = "Приоритет секций",
		
		["Allow Duplicates"] = "Рразрешить Дупликаты",
		["Import Sections From"] = "Импорт секция для",

	}
	
end)