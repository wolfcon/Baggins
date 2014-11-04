local L = LibStub("AceLocale-3.0"):NewLocale("Baggins", "koKR")
if not L then return end

--itemtypes, these must match the Type and SubType returns from GetItemInfo for the ItemType rule to work
L["Armor"] = "방어구"
	L["Cloth"] = "천"
	L["Idols"] = "우상"
	L["Leather"] = "가죽"
	L["Librams"] = "성서"
	L["Mail"] = "사슬"
	L["Miscellaneous"] = "기타"
	L["Shields"] = "방패"
	L["Totems"] = "토템"
	L["Plate"] = "판금"
L["Consumable"] = "소비 용품"
L["Container"] = "가방"
	L["Bag"] = "가방"
	L["Enchanting Bag"] = "마법부여 가방"
	L["Engineering Bag"] = "기계공학 가방"
	L["Herb Bag"] = "약초 가방"
	L["Soul Bag"] = "영혼의 가방"
L["Key"] = "열쇠"
L["Miscellaneous"] = "기타"
	L["Junk"] = "잡동사니"
L["Reagent"] = "재료"
L["Recipe"] = "제조법"
	L["Alchemy"] = "연금술"
	L["Blacksmithing"] = "대장기술"
	L["Book"] = "책"
	L["Cooking"] = "요리"
	L["Enchanting"] = "마법부여"
	L["Engineering"] = "기계공학"
	L["First Aid"] = "응급치료"
	L["Leatherworking"] = "가죽세공"
	L["Tailoring"] = "재봉술"
L["Projectile"] = "투사체"
	L["Arrow"] = "화살"
	L["Bullet"] = "탄환"
L["Quest"] = "퀘스트"
L["Quiver"] = "화살통"
	L["Ammo Pouch"] = "탄약 주머니"
	L["Quiver"] = "화살통"
L["Trade Goods"] = "직업 용품"
	L["Devices"] = "장치"
	L["Explosives"] = "폭발물"
	L["Parts"] = "부품"
	L["Gems"] = "보석"
L["Weapon"] = "무기"
	L["Bows"] = "활류"
	L["Crossbows"] = "석궁류"
	L["Daggers"] = "단검류"
	L["Guns"] = "총기류"
	L["Fishing Pole"] = "낚싯대"
	L["Fist Weapons"] = "장착 무기류"
	L["Miscellaneous"] = "기타"
	L["One-Handed Axes"] = "한손 도끼류"
	L["One-Handed Maces"] = "한손 둔기류"
	L["One-Handed Swords"] = "한손 도검류"
	L["Polearms"] = "장창류"
	L["Staves"] = "지팡이류"
	L["Thrown"] = "투척 무기류"
	L["Two-Handed Axes"] = "양손 도끼류"
	L["Two-Handed Maces"] = "양손 둔기류"
	L["Two-Handed Swords"] = "양손 도검류"
	L["Wands"] = "마법봉류"
		--end of localizations needed for rules to work


--L["Baggins"] = true
L["Toggle All Bags"] = "모든 가방 열기/닫기"
L["Columns"] = "칸"
L["Number of Columns shown in the bag frames"] = "가방창의 칸수를 조절합니다"
L["Layout"] = "레이아웃"
L["Layout of the bag frames."] = "가방창의 레이아웃을 설정합니다"
L["Automatic"] = "자동"
L["Automatically arrange the bag frames as the default ui does"] = "가방창을 기본 UI로 자동으로 배열합니다"
L["Manual"] = "수동"
L["Each bag frame can be positioned manually."] = "각각의 가방창을 수동으로 배열합니다."
L["Show Section Title"] = "분류명 표시"
L["Show a title on each section of the bags"] = "각각의 가방의 분류명칭을 표시합니다."
L["Sort"] = "정렬"
L["How items are sorted"] = "아이템을 어떻게 정렬할지를 선택합니다"
L["Quality"] = "품질"
L["Items are sorted by quality."] = "아이템을 품질에 따라서 분류합니다."
L["Name"] = "이름"
L["Items are sorted by name."] = "아이템을 이름에 따라서 분류합니다."
L["Hide Empty Sections"] = "빈 분류 숨기기"
L["Hide sections that have no items in them."] = "해당 분류의 아이템이 없는 경우 해당 분류를 숨깁니다."
L["Hide Default Bank"] = "기본 은행 숨김"
L["Hide the default bank window."] = "기본 은행창을 숨깁니다"
L["FuBar Text"] = "텍스트 표시"
L["Options for the text shown on fubar"] = "페널에 플러그인 텍스트를 표시합니다."
L["Show empty bag slots"] = "빈 가방 슬롯 표시"
L["Show used bag slots"] = "사용중인 가방 슬롯 표시"
L["Show Total bag slots"] = "총 가방 슬롯 표시"
L["Combine Counts"] = "갯수 통합"
L["Show only one count with all the seclected types included"] = "선택된 형식에 포함되어 있는 아이템의 갯수를 합쳐서 표시합니다"
L["Show Ammo Bags Count"] = "투사체 가방 갯수 표시"
L["Show Soul Bags Count"] = "영혼의 가방 갯수 표시"
L["Show Specialty Bags Count"] = "특수 가방 갯수 표시"
L["Show Specialty (profession etc) Bags Count"] = "특수(전문기술 등) 가방 갯수 표시"
L["Set Layout Bounds"]= "레이아웃 기반 설정"
L["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] = "레이아웃을 자동으로 정렬하는 드래그하고 크기를 조절이 가능한 창을 설정합니다"
L["Lock"] = "잠금"
L["Locks the bag frames making them unmovable"] = "가방창의 위치를 고정합니다"
L["Shrink Width"] = "너비 자동 조절"
L["Shrink the bag's width to fit the items contained in them"] = "창의 크기를 아이템의 갯수에 따라서 자동으로 조절합니다"
L["Compress"] = "합침"
L["Compress Multiple stacks into one item button"] = "아이템을 합쳐서 하나의 버튼에 표시합니다"
L["Compress All"] = "모두 합침"
L["Show all items as a single button with a count on it"] = "합칠 수 있는 모든 아이템을 합쳐서 하나의 버튼에 갯수만을 표시하도록 합니다"
L["Compress Empty Slots"] = "빈 슬롯 합침"
L["Show all empty slots as a single button with a count on it"] = "가방 안의 빈 슬롯을 합쳐서 하나의 버튼에 갯수만을 표시합니다"
L["Compress Soul Shards"] = "영혼의 조각 합침"
L["Show all soul shards as a single button with a count on it"] = "가방 안의 영혼의 조각을 합쳐서 하나의 버튼에 갯수만을 표시합니다"
L["Compress Ammo"] = "투사체 합침"
L["Show all ammo as a single button with a count on it"] = "가방 안의 투사체를 합쳐서 하나의 버튼에 갯수만을 표시합니다"
L["Quality Colors"]= "품질 색상"
L["Color item buttons based on the quality of the item"] = "아이템의 품질에 따라서 아이템의 버튼 색상을 변경합니다"
L["Enable"] = "사용"
L["Enable quality coloring"] = "품질 색상 기능 사용"
L["Color Threshold"] = "색상 한계선"
L["Only color items of this quality or above"] = "해당 품질 이상의 아이템에만 품질 색상 기능을 사용합니다"
L["Color Intensity"] = "색상 농도"
L["Intensity of the quality coloring"] = "품질 색상의 농도를 설정합니다"
L["Edit Bags"] = "가방 편집"
L["Edit the Bag Definitions"] = "가방별 정의를 편집합니다."
L["Edit Categories"] = "분류 편집"
L["Edit the Category Definitions"] = "분류별 정의를 편집합니다."
L["Load Profile"] = "프로파일 불러오기"
L["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] = "기본 설정된 프로파일을 불러옵니다. 주의: 모든 사용사 설정이 사라집니다."
L["Default"] = "기본값"
L["A default set of bags sorting your inventory into categories"] = "분류별로 인벤토리를 정렬하는 설정입니다"
L["All in one"] = "통합 가방"
L["A single bag containing your whole inventory, sorted by quality"] = "모든 아이템을 하나의 통합가방에 품질별로 정렬하는설정입니다"
L["Scale"] = "크기"
L["Scale of the bag frames"] = "가방창의 크기를 조절합니다"
		--bagtypes
L["Backpack"] = "소지품"
L["Bag1"] = "1번 가방"
L["Bag2"] = "2번 가방"
L["Bag3"] = "3번 가방"
L["Bag4"] = "4번 가방"
L["Bank Frame"] = "은행창"
L["Bank Bag1"] = "1번 은행 가방"
L["Bank Bag2"] = "2번 은행 가방"
L["Bank Bag3"] = "3번 은행 가방"
L["Bank Bag4"] = "4번 은행 가방"
L["Bank Bag5"] = "5번 은행 가방"
L["Bank Bag6"] = "6번 은행 가방"
L["Bank Bag7"] = "7번 은행 가방"
L["Reagent Bank"] = true
L["KeyRing"] = "열쇠 고리"

		--qualoty names
L["Poor"] = "하급"
L["Common"] = "일반"
L["Uncommon"] = "고급"
L["Rare"] = "희귀"
L["Epic"] = "영웅"
L["Legendary"] = "전설"
L["Artifact"] = "유물"

L["None"] = "없음"
L["All"] = "통합 가방"

L["Item Type"] = "아이템 종류"
L["Filter by Item type and sub-type as returned by GetItemInfo"] = "GetItemInfo 함수값인 아이템 종류와 세부 종류에 따라서 분류합니다"
L["ItemType - "] = "아이템 종류 - "
L["Item Type Options"] = "아이템 종류 설정"
L["Item Subtype"] = "아이템 세부 종류"

L["Container Type"] = "가방 종류"
L["Filter by the type of container the item is in."] = "아이템이 들어 있는 가방의 종류에 따라서 분류합니다"
L["Container : "] = "가방 : "
L["Container Type Options"] = "가방 종류 설정"

L["Item ID"] = "아이템ID"
L["Filter by ItemID, this can be a space delimited list or ids to match."] = "아이템ID별로 아이템을 분류합니다."
L["ItemIDs "] = "아이템ID"
L["ItemID Options"] = "아이템ID 설정"
L["Item IDs (space seperated list)"] = "아이템ID(공백으로 복구 입력)"
L["New"] = "신규"
L["Current IDs, click to remove"] = "현재 ID, 클릭시 제거"

L["Filter by the bag the item is in"] = "아이템이 들어 있는 가방에 따라서 분류합니다"
L["Bag "] = "가방 "
L["Bag Options"] = "가방 설정"
L["Ignore Empty Slots"] = "공란 무시"

L["Item Name"] = "아이템 이름"
L["Filter by Name or partial name"] = "아이템의 이름 또는 이름의 일부분으로 분류합니다"
L["Name: "] = "이름: "
L["Item Name Options"] = "아이템 이름 설정"
L["String to Match"] = "일치할 문자열"

L["PeriodicTable Set"] = "PeriodicTable 세트"
L["Filter by PeriodicTable Set"] = "PeriodicTable 세트별로 분류합니다"
L["Periodic Table Set Options"] = "Periodic Table 세트 설정"
L["Set"] = "세트"

L["Empty Slots"] = "공란"
L["Empty bag slots"] = "가방 공란"

L["Ammo Bag"] = "투사체 가방"
L["Items in an ammo pouch or quiver"] = "화살통 또는 탄약 주머니 안의 아이템"
L["Ammo Bag Slots"] = "투사체 가방 슬롯"

L["Quality"] = "품질"
L["Filter by Item Quality"] = "아이템 품질별로 분류합니다"
L["Quality Options"] = "품질 설정"
L["Comparison"] = "비교"

L["Equip Location"] = "착용 부위"
L["Filter by Equip Location as returned by GetItemInfo"] = "GetItemInfo 함수값인 착용부위별로 분류합니다"
L["Equip Location Options"] = "착용 부위 설정"
L["Location"] = "위치"

L["Unfiltered Items"] = "미분류 아이템"
L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] = "다른 가방에 속하지 않는 모든 아이템, 주의: 이것은 분류 규칙만 적용됩니다. 기타의 사항은 무시합니다"
L["Unfiltered"] = "미분류"

L["Bind"] = "귀속"
L["Filter based on if the item binds, or if it is already bound"] = "아이템의 귀속 시기별로 분류합니다"
L["Bind *unset*"] = "귀속 설정 없음"
L["Unbound"] = "귀속안됨"
L["Bind Options"] = "귀속 설정"
L["Bind Type"] = "귀속 방식"
L["Binds on pickup"] = "획득 시 귀속"
L["Binds on equip"] = "착용 시 귀속"
L["Binds on use"] = "사용 시 귀속"
L["Soulbound"] = "귀속 아이템"

L["Tooltip"] = "툴팁"
L["Filter based on text contained in its tooltip"] = "툴팁의 문구를 기본으로 필터링합니다"
L["Tooltip Options"] = "툴팁 설정"

L["ItemID: "] = "아이템ID: "
L["Item Type: "] = "아이템 종류: "
L["Item Subtype: "] = "아이템 세부 종류: "

L["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] = "클릭시 가방을 토글, Shift-클릭시 위로, Alt-클릭시 아래로"

L["Bags"] = "가방"
L["Options"] = "설정"
L["Open With All"] = "모두 열기 시에 열기"
L["Bank"] = "은행"
L["Sections"] = "구분"
L["Categories"] = "분류"
L["Add Category"] = "분류 추가"
L["New Section"] = "신규 구분 추가"
L["New Bag"] = "신규 가방 추가"
L["Close"] = "닫기"
L["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] = "클릭시 전체 열기, Shift-클릭시 위로, Alt-클릭시 아래로, Ctrl 클릭시 삭제"
L["Rules"] = "규칙"
L["New Rule"] = "신규 규칙"
L["Add Rule"] = "규칙 추가"
L["New Category"] = "신규 분류 추가"
L["Apply"] = "적용"
L["Click on an entry to open. Ctrl-Click to delete."] = "클릭시 전체 열기, Ctrl-클릭시 삭제"

L["Editing Rule"] = "규칙 편집"
L["Type"] = "형식"
L["Select a rule type to create the rule"] = "규칙 작성의 형식을 선택합니다"
L["Operation"] = "인식자"
L["AND"] = "그리고"
L["OR"] = "또는"
L["NOT"] = "반면"

L["Baggins - New Bag"] = "Baggins - 신규 가방"
L["Baggins - New Section"] = "Baggins - 신규 구분"
L["Baggins - New Category"] = "Baggins - 신규 분류"
L["Accept"] = "수락"
L["Cancel"] = "취소"

L["Are you sure you want to delete this Bag? this cannot be undone"] = "정말로 이 가방을 삭제하시겠습니까? 복구가 불가능합니다"
L["Are you sure you want to delete this Section? this cannot be undone"] = "정말로 이 구분을 삭제하시겠습니까? 복구가 불가능합니다"
L["Are you sure you want to remove this Category? this cannot be undone"] = "정말로 이 분류를 제거하시겠습니까? 복구가 불가능합니다"
L["Are you sure you want to remove this Rule? this cannot be undone"] = "정말로 이 규칙을 제거하시겠습니까? 복구가 불가능합니다"
L["Delete"] = "삭제"
L["Cancel"] = "취소"

L["That category is in use by one or more bags, you cannot delete it."] = "이 분류는 한 개 이상의 가방에서 사용중입니다. 제거가 불가능 합니다"
L["A category with that name already exists."] = "해당 분류명은 이미 사용중입니다."

L["Drag to Move\nRight-Click to Close"] = "드래그로 이동 우클릭으로 닫기"
L["Drag to Size"] = "드래그로 크기 조절"

L["Previous "] = "이전"
L["Next "] = "다음"

L["All In One"] = "통합 가방"
L["Bank All In One"] = "은행 통합 가방"
L["Bank Bags"] = "은행 가방"

L["Equipment"] = "착용 아이템"
L["Weapons"] = "무기"
L["Quest Items"] = "퀘스트 아이템"
L["Consumables"] = "소비 용품"
L["Water"] = "음료"
L["Food"] = "음식"
L["FirstAid"] = "응급치료"
L["Potions"] = "물약"
L["Scrolls"] = "두루마리"
L["Misc"] = "기타"
L["Misc Consumables"] = "기타 소비 용품"

L["Mats"] = "재료"
L["Tradeskill Mats"] = "전문기술 재료"
L["Gathered"] = "채집물"
L["BankBags"] = "은행가방"
L["Ammo"] = "투사체"
L["AmmoBag"] = "화살통"
L["SoulShards"] = "영혼의 조각"
L["SoulBag"] = "영혼의 가방"
L["Other"] = "기타"
L["Trash"] = "쓰레기"
L["TrashEquip"] = "쓰레기 아이템"
L["Empty"] = "공란"
L["Bank Equipment"] = "은행 착용장비"
L["Bank Quest"] = "은행 퀘스트아이템"
L["Bank Consumables"] = "은행 소비용품"
L["Bank Trade Goods"] = "은행 전문기술용품"
L["Bank Other"] = "은행 기타품목"

L["Add To Category"] = "분류 추가"
L["Exclude From Category"] = "분류에서 제거"
L["Item Info"] = "아이템 정보"
L["Quality: "] = "품질: "
L["Level: "] = "레벨: "
L["MinLevel: "] = "최저 레벨: "
L["Stack Size: "] = "묶음 크기: "
L["Equip Location: "] = "착용 부위: "
--L["Periodic Table Sets"] = true

L["Highlight New Items"] = "신규 아이템 강조"
L["Add *New* to new items, *+++* to items that you have gained more of."] = "신규 아이템에 *New*를, 추가 획득 아이템에 *+++*를 표시합니다."
L["Reset New Items"] = "신규 아이템 초기화"
L["Resets the new items highlights."] = "신규 아이템 강조 기능을 초기화 합니다"
--L["*New*"] = true

L["Hide Duplicate Items"] = "중복 아이템 숨김"
L["Prevents items from appearing in more than one section/bag."] = "아이템이 한 개 이상 표시되지 않습니다"

L["Optimize Section Layout"] = "구분 배열 최적화"
L["Change order and layout of sections in order to save display space."] = "저장된 표시 공간의 순서에 따라서 구분의 배열 순서를 변경합니다."

L["All In One Sorted"]= "통합 가방 정렬"
L["A single bag containing your whole inventory, sorted into categories"]= "통합 가방 형태에서 분류별로 정렬합니다"

L["Compress Stackable Items"]= "묶음 아이템 합침"
L["Show stackable items as a single button with a count on it"]= "겹치는 아이템은 하나의 버튼으로 수량만을 표시합니다"

L["Appearance and layout"]= "외양과 배치"
L["Bags"]= "가방"
L["Bag display and layout settings"]= "가방 표시와 배치 설정"
L["Layout Type"]= "배치 형식"
L["Sets how all bags are laid out on screen."]= "화면상에 모든 가방의 배열을 설정합니다"
L["Shrink bag title"]= "가방 이름 너비"
L["Mangle bag title to fit to content width"]= "가방의 너비를 가방의 이름에 따라 조절합니다"
L["Sections"]= "구분"
L["Bag sections display and layout settings."]= "가방 안의 구분 간의 배열을 설정합니다"
L["Items"]= "아이템"
L["Item display settings"]= "아이템 표시 설정"
L["Bag Skin"]= "가방 스킨"
L["Select bag skin"]= "가방의 스킨을 선택합니다"

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