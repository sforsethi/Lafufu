//
//  ToyDB.swift
//
//
//  Created by Raghav Sethi on 21/06/25.
//

import Foundation

let fruitReleases: [ToyRelease] = [
    ToyRelease(name: "Lemon", chineseName: "柠檬", imageName: "lemon", color: "F9E79F", description: "Lemon-themed Toy with yellow bathtub and rubber duck"),
    ToyRelease(name: "Banana", chineseName: "香蕉", imageName: "banana", color: "F7DC6F", description: "Banana-themed Toy with striped hat and yellow scarf"),
    ToyRelease(name: "Pineapple", chineseName: "凤梨", imageName: "pineapple", color: "F4D03F", description: "Pineapple-themed Toy with tropical accessories"),
    ToyRelease(name: "Orange", chineseName: "甜橙", imageName: "orange", color: "F8C471", description: "Orange-themed Toy with cowboy hat and orange"),
    ToyRelease(name: "Coconut", chineseName: "椰子", imageName: "coconut", color: "85C1E9", description: "Coconut-themed Toy with palm tree and tropical vibes"),
    ToyRelease(name: "Grape", chineseName: "葡萄", imageName: "grape", color: "BB8FCE", description: "Grape-themed Toy with purple grapes and vintage style"),
    ToyRelease(name: "Pear", chineseName: "梨", imageName: "pear", color: "A9DFBF", description: "Pear-themed Toy with green accessories and playful pose"),
    ToyRelease(name: "Strawberry", chineseName: "草莓", imageName: "strawberry", color: "F1948A", description: "Strawberry-themed Toy with pink hat and strawberry"),
    ToyRelease(name: "Cherry", chineseName: "樱桃", imageName: "cherry", color: "EC7063", description: "Cherry-themed Toy with red cherries and cute styling"),
    ToyRelease(name: "Kiwi", chineseName: "奇异果", imageName: "kiwi", color: "A3E4D7", description: "Kiwi-themed Toy with striped outfit and bowl"),
    ToyRelease(name: "Watermelon", chineseName: "西瓜", imageName: "watermelon", color: "58D68D", description: "Watermelon-themed Toy with red headband and watermelon"),
    ToyRelease(name: "Peach", chineseName: "水蜜桃", imageName: "peach", color: "F8D7DA", description: "Peach-themed Toy with soft pink colors and peach")
]

let bigEnergyReleases: [ToyRelease] = [
    ToyRelease(name: "Love", chineseName: "爱情", imageName: "love", color: "FF69B4", description: "Pink fluffy Toy keychain representing love and affection"),
    ToyRelease(name: "Happiness", chineseName: "快乐", imageName: "happiness", color: "FFB347", description: "Orange fluffy Toy keychain symbolizing joy and happiness"),
    ToyRelease(name: "Loyalty", chineseName: "忠诚", imageName: "loyalty", color: "FFD700", description: "Yellow and pink fluffy Toy keychain representing loyalty"),
    ToyRelease(name: "Serenity", chineseName: "宁静", imageName: "serenity", color: "98FB98", description: "Green fluffy Toy keychain embodying peace and serenity"),
    ToyRelease(name: "Hope", chineseName: "希望", imageName: "hope", color: "87CEEB", description: "Blue fluffy Toy keychain inspiring hope and dreams"),
    ToyRelease(name: "Luck", chineseName: "幸运", imageName: "luck", color: "DDA0DD", description: "Purple fluffy Toy keychain bringing good luck and fortune")
]

let cocaColaReleases: [ToyRelease] = [
    ToyRelease(name: "Surprise Shake", chineseName: "惊喜摇摇", imageName: "surprise_shake", color: "DC143C", description: "White fluffy Toy with red Santa hat holding a classic Coca-Cola bottle"),
    ToyRelease(name: "Happy Factor", chineseName: "快乐因子", imageName: "happy_factor", color: "DC143C", description: "White fluffy Toy with winter accessories holding a red Coca-Cola cup")
]

let findingMokokoReleases: [ToyRelease] = [
    ToyRelease(name: "Seen Her", chineseName: "花间迷藏", imageName: "seen_her", color: "FFB6C1", description: "Mokoko hiding among flowers with a playful pose"),
    ToyRelease(name: "Follow the Light", chineseName: "追光而遇", imageName: "follow_light", color: "FFEAA7", description: "Mokoko with glowing light accessories in a dreamy setting"),
    ToyRelease(name: "Painter's Help", chineseName: "画的倦么", imageName: "painters_help", color: "74B9FF", description: "Mokoko assisting with painting, covered in colorful paint"),
    ToyRelease(name: "Over There!", chineseName: "快看那里!", imageName: "over_there", color: "81ECEC", description: "Mokoko pointing excitedly with blue accessories"),
    ToyRelease(name: "See You", chineseName: "再见气球", imageName: "see_you", color: "A29BFE", description: "Mokoko with balloons in a farewell scene"),
    ToyRelease(name: "Great Discovery", chineseName: "重大发现", imageName: "great_discovery", color: "00B894", description: "Mokoko making an exciting discovery with green elements"),
    ToyRelease(name: "Move Bravely", chineseName: "勇敢向前", imageName: "move_bravely", color: "E17055", description: "Brave Mokoko in warrior outfit ready for adventure"),
    ToyRelease(name: "Careless Hunter", chineseName: "粗心猎手", imageName: "careless_hunter", color: "FDCB6E", description: "Mokoko as a hunter with camping gear and accessories"),
    ToyRelease(name: "Wind's Guidance", chineseName: "风的指引", imageName: "winds_guidance", color: "636E72", description: "Mokoko following the wind's direction with flowing elements"),
    ToyRelease(name: "Found It!", chineseName: "找到了!", imageName: "found_it", color: "00B894", description: "Mokoko celebrating a successful discovery with green theme"),
    ToyRelease(name: "Heart Maze", chineseName: "心的迷宫", imageName: "heart_maze", color: "FD79A8", description: "Mokoko navigating through a heart-shaped maze with pink theme")
]

let lazyYogaReleases: [ToyRelease] = [
    ToyRelease(name: "Little Bird", chineseName: "小鸟式", imageName: "little_bird", color: "9B59B6", description: "Toy in bird pose with purple hoodie and star crown"),
    ToyRelease(name: "Zone Out", chineseName: "放空式", imageName: "zone_out", color: "A8E6CF", description: "Toy in meditation pose with green hood and peaceful expression"),
    ToyRelease(name: "Ab Roller", chineseName: "杂技式", imageName: "ab_roller", color: "FFB3BA", description: "Toy doing ab exercises with pink coloring and determined look"),
    ToyRelease(name: "Sweating", chineseName: "暴汗式", imageName: "sweating", color: "DDA0DD", description: "Toy in intense workout pose with purple hood showing effort"),
    ToyRelease(name: "Confident", chineseName: "自信式", imageName: "confident", color: "F8BBD9", description: "Toy in confident pose with pink coloring and self-assured stance"),
    ToyRelease(name: "Stretch Out", chineseName: "拉伸式", imageName: "stretch_out", color: "BFEFFF", description: "Toy doing stretching exercises with light blue outfit and yellow accessory"),
    ToyRelease(name: "Cozy Time", chineseName: "慵懒式", imageName: "cozy_time", color: "98FB98", description: "Toy in relaxed pose with green and white outfit looking comfortable"),
    ToyRelease(name: "Sleepy Mode", chineseName: "困倦式", imageName: "sleepy_mode", color: "696969", description: "Toy in sleepy pose with dark gray coloring and coffee cup"),
    ToyRelease(name: "Happy Stretch", chineseName: "开心式", imageName: "happy_stretch", color: "87CEEB", description: "Toy in joyful stretching pose with light blue outfit and cheerful expression")
]

let almostHiddenReleases: [ToyRelease] = [
    ToyRelease(name: "Canned Pineapple", chineseName: "超罐菠萝云", imageName: "canned_pineapple", color: "FFA500", description: "Toy disguised as a canned pineapple with fruit topping"),
    ToyRelease(name: "Lamp", chineseName: "暗中观察", imageName: "lamp", color: "40E0D0", description: "Toy hiding inside a turquoise table lamp"),
    ToyRelease(name: "Sculpture", chineseName: "广场焦点", imageName: "sculpture", color: "A9A9A9", description: "Toy camouflaged as a stone sculpture statue"),
    ToyRelease(name: "Fire Hydrant", chineseName: "补水神器", imageName: "fire_hydrant", color: "DC143C", description: "Toy disguised as a red fire hydrant with winter accessories"),
    ToyRelease(name: "Tree House", chineseName: "怪诞树屋", imageName: "tree_house", color: "8B4513", description: "Toy hiding in a mysterious tree house structure"),
    ToyRelease(name: "Flask", chineseName: "奇妙实验", imageName: "flask", color: "00CED1", description: "Toy concealed inside a scientific laboratory flask"),
    ToyRelease(name: "Traffic Light", chineseName: "嘀嘀暗号", imageName: "traffic_light", color: "2F4F4F", description: "Toy disguised as a traffic light with red and green signals"),
    ToyRelease(name: "Flower Pot", chineseName: "隐身阳台", imageName: "flower_pot", color: "8FBC8F", description: "Toy camouflaged as a flower pot with cactus plants"),
    ToyRelease(name: "Spray Can", chineseName: "艺术猜想", imageName: "spray_can", color: "FF1493", description: "Toy hidden inside a pink graffiti spray can"),
    ToyRelease(name: "Bread Bag", chineseName: "怪味吐司", imageName: "bread_bag", color: "D2B48C", description: "Toy disguised as a loaf of bread in packaging"),
    ToyRelease(name: "Mailbox", chineseName: "神秘信件", imageName: "mailbox", color: "4169E1", description: "Toy hiding inside a blue mailbox with mail slot"),
    ToyRelease(name: "Cactus", chineseName: "无人区域", imageName: "cactus", color: "32CD32", description: "Toy camouflaged as a green cactus plant"),
    ToyRelease(name: "Kiddie Ride", chineseName: "偷偷开心", imageName: "kiddie_ride", color: "B22222", description: "Toy hiding in a coin-operated kiddie ride machine")
]

let excitingMacaronReleases: [ToyRelease] = [
    ToyRelease(name: "Soymilk", chineseName: "豆浆", imageName: "soymilk", color: "F5E6D3", description: "Creamy beige fluffy Toy keychain inspired by soymilk macaron flavor"),
    ToyRelease(name: "Lychee Berry", chineseName: "荔枝莓", imageName: "lychee_berry", color: "FFB6C1", description: "Sweet pink fluffy Toy keychain with lychee berry macaron theme"),
    ToyRelease(name: "Green Grape", chineseName: "青葡萄", imageName: "green_grape", color: "98FB98", description: "Fresh green fluffy Toy keychain inspired by green grape macaron"),
    ToyRelease(name: "Sea Salt Coconut", chineseName: "海盐椰子", imageName: "sea_salt_coconut", color: "87CEEB", description: "Ocean blue fluffy Toy keychain with sea salt coconut macaron flavor"),
    ToyRelease(name: "Toffee", chineseName: "太妃糖", imageName: "toffee", color: "DEB887", description: "Rich brown fluffy Toy keychain inspired by toffee macaron sweetness"),
    ToyRelease(name: "Sesame Bean", chineseName: "芝麻豆", imageName: "sesame_bean", color: "D3D3D3", description: "Elegant gray fluffy Toy keychain with sesame bean macaron theme")
]

let wackyMartReleases: [ToyRelease] = [
    ToyRelease(name: "Grilled Sausage", chineseName: "烤香肠", imageName: "grilled_sausage", color: "FF6347", description: "Toy with green hat holding a grilled sausage with cute carrot companion"),
    ToyRelease(name: "Cup Noodles", chineseName: "杯面", imageName: "cup_noodles", color: "FFE4B5", description: "Toy peeking out of an instant ramen cup with red and white packaging"),
    ToyRelease(name: "Milk", chineseName: "牛奶", imageName: "milk", color: "F5F5F5", description: "Toy in black and white cow pattern milk carton packaging"),
    ToyRelease(name: "Chips", chineseName: "薯片", imageName: "chips", color: "DEB887", description: "Toy emerging from a chip bag with orange and purple snack packaging"),
    ToyRelease(name: "Corn", chineseName: "玉米", imageName: "corn", color: "FFD700", description: "Toy transformed into golden corn with green husk wrapping"),
    ToyRelease(name: "Fried Shrimp", chineseName: "炸虾", imageName: "fried_shrimp", color: "FFA500", description: "Toy in crispy golden fried shrimp coating with fluffy texture"),
    ToyRelease(name: "Canned Sardines", chineseName: "沙丁鱼罐头", imageName: "canned_sardines", color: "C0C0C0", description: "Toy packed in silver sardine can with pull-tab lid"),
    ToyRelease(name: "Sandwich", chineseName: "三明治", imageName: "sandwich", color: "90EE90", description: "Toy as a layered sandwich with green wrapping and colorful fillings"),
    ToyRelease(name: "Salad", chineseName: "沙拉", imageName: "salad", color: "98FB98", description: "Toy in fresh salad container with healthy green vegetables"),
    ToyRelease(name: "Yakitori", chineseName: "烤鸡串", imageName: "yakitori", color: "D2691E", description: "Multiple Toy figures on yakitori skewers in traditional packaging"),
    ToyRelease(name: "Chow Mein", chineseName: "炒面", imageName: "chow_mein", color: "F4A460", description: "Toy with instant noodle packaging and chopstick accessories"),
    ToyRelease(name: "Onigiri", chineseName: "饭团", imageName: "onigiri", color: "F5F5DC", description: "Toy as rice ball with seaweed wrapper and traditional presentation")
]

let onePieceReleases: [ToyRelease] = [
    ToyRelease(name: "Monkey D. Luffy", chineseName: "蒙奇·D·路飞", imageName: "monkey_d_luffy", color: "DC143C", description: "Toy as the Straw Hat Pirates captain with signature red vest and straw hat"),
    ToyRelease(name: "Roronoa Zoro", chineseName: "罗罗诺亚·索隆", imageName: "roronoa_zoro", color: "228B22", description: "Toy as the three-sword style swordsman with green hair and katanas"),
    ToyRelease(name: "Nami", chineseName: "娜美", imageName: "nami", color: "FF8C00", description: "Toy as the navigator with orange hair and weather manipulation staff"),
    ToyRelease(name: "Usopp", chineseName: "乌索普", imageName: "usopp", color: "8B4513", description: "Toy as the sniper with long nose and slingshot equipment"),
    ToyRelease(name: "Sanji", chineseName: "山治", imageName: "sanji", color: "FFD700", description: "Toy as the cook with blonde hair and black suit"),
    ToyRelease(name: "Tony Tony Chopper", chineseName: "托尼托尼·乔巴", imageName: "tony_tony_chopper", color: "FF69B4", description: "Toy as the reindeer doctor with blue nose and pink hat"),
    ToyRelease(name: "Nico Robin", chineseName: "妮可·罗宾", imageName: "nico_robin", color: "800080", description: "Toy as the archaeologist with black hair and sunglasses"),
    ToyRelease(name: "Franky", chineseName: "弗兰奇", imageName: "franky", color: "00CED1", description: "Toy as the cyborg shipwright with blue hair and mechanical arms"),
    ToyRelease(name: "Brook", chineseName: "布鲁克", imageName: "brook", color: "FFD700", description: "Toy as the skeleton musician with afro and golden crown"),
    ToyRelease(name: "Jinbe", chineseName: "甚平", imageName: "jinbe", color: "4169E1", description: "Toy as the fish-man helmsman with blue skin and traditional outfit"),
    ToyRelease(name: "Sabo", chineseName: "萨博", imageName: "sabo", color: "000080", description: "Toy as the Revolutionary Army chief with top hat and goggles"),
    ToyRelease(name: "Trafalgar Law", chineseName: "特拉法尔加·罗", imageName: "trafalgar_law", color: "C0C0C0", description: "Toy as the surgeon of death with spotted hat and nodachi sword")
]

let takeASeatReleases: [ToyRelease] = [
    ToyRelease(name: "Sisi", chineseName: "思思", imageName: "sisi", color: "F5DEB3", description: "Beige fluffy Toy in sitting pose with gentle closed-eye expression and warm keychain"),
    ToyRelease(name: "Hehe", chineseName: "呵呵", imageName: "hehe", color: "808080", description: "Gray fluffy Toy in sitting pose with playful winking expression and silver keychain"),
    ToyRelease(name: "Baba", chineseName: "爸爸", imageName: "baba", color: "DEB887", description: "Light brown fluffy Toy in sitting pose with sweet wide-eyed expression and golden keychain"),
    ToyRelease(name: "Zizi", chineseName: "紫紫", imageName: "zizi", color: "9370DB", description: "Purple fluffy Toy in sitting pose with sleepy peaceful expression and lavender keychain"),
    ToyRelease(name: "Ququ", chineseName: "曲曲", imageName: "ququ", color: "98FB98", description: "Mint green fluffy Toy in sitting pose with bright curious expression and pastel keychain"),
    ToyRelease(name: "Dada", chineseName: "哒哒", imageName: "dada", color: "FFB6C1", description: "Pink fluffy Toy in sitting pose with cheerful blushing expression and rose keychain")
]

// MARK: - Toy Series Data
let toySeries: [ToySeries] = [
    ToySeries(
        name: "Fruit Series",
        chineseName: "水果系列",
        releases: fruitReleases,
        color: "4CAF50",
        description: "A delightful collection of fruit-themed Toy figures, each representing a different fruit with unique accessories and vibrant colors."
    ),
    ToySeries(
        name: "Big Energy Series",
        chineseName: "前方高能系列",
        releases: bigEnergyReleases,
        color: "FF6B9D",
        description: "Vibrant fluffy keychain Toy collection representing different emotions and energies. One random item per blind box with colorful ring attachments."
    ),
    ToySeries(
        name: "Coca-Cola Series",
        chineseName: "可口可乐系列",
        releases: cocaColaReleases,
        color: "DC143C",
        description: "Limited winter collaboration with Coca-Cola featuring fluffy white Toy figures with festive accessories and classic Coke products. One random item per blind box."
    ),
    ToySeries(
        name: "Finding Mokoko Series",
        chineseName: "全款展示",
        releases: findingMokokoReleases,
        color: "FFB6C1",
        description: "Adventure-themed collection featuring Mokoko in various discovery scenarios. Each figure tells a story of exploration and wonder with unique accessories and poses."
    ),
    ToySeries(
        name: "Lazy Yoga Series",
        chineseName: "慵懒瑜伽系列",
        releases: lazyYogaReleases,
        color: "DDA0DD",
        description: "Relaxing yoga-themed collection featuring Toy in various exercise and meditation poses. Each figure represents different yoga positions and wellness activities."
    ),
    ToySeries(
        name: "Almost Hidden Series",
        chineseName: "几乎隐藏系列",
        releases: almostHiddenReleases,
        color: "708090",
        description: "Creative camouflage collection featuring Toy cleverly disguised as everyday objects. Each figure showcases masterful hide-and-seek skills in plain sight."
    ),
    ToySeries(
        name: "Exciting Macaron Series",
        chineseName: "美味马卡龙系列",
        releases: excitingMacaronReleases,
        color: "FFB6C1",
        description: "Sweet fluffy keychain collection inspired by delicious macaron flavors. Each vinyl face blind box figure features soft textures and dessert-themed colors with golden keychains."
    ),
    ToySeries(
        name: "Toy x Kow Yokoyama Ma.K. Series",
        chineseName: "横山宏Ma.K系列",
        releases: [],
        color: "2F4F4F",
        description: "Innovative collaboration blending Toy's playful charm with retro-futuristic mechanical designs inspired by the legendary Maschinen Krieger series. Each figure features detailed armor and tactical gear."
    ),
    ToySeries(
        name: "Wacky Mart Series",
        chineseName: "疯狂市场系列",
        releases: wackyMartReleases,
        color: "FF8C00",
        description: "Quirky convenience store themed collection featuring Toy disguised as popular snacks and food items. A pop-up exclusive series with unique packaging designs inspired by everyday grocery products."
    ),
    ToySeries(
        name: "The Monsters x One Piece Series",
        chineseName: "怪物×海贼王系列",
        releases: onePieceReleases,
        color: "FF6347",
        description: "Epic anime collaboration featuring Toy characters reimagined as beloved One Piece crew members. Each 13-figurine blind box captures iconic pirate adventures with golden display bases."
    ),
    ToySeries(
        name: "Take a Seat Series",
        chineseName: "坐一坐系列",
        releases: takeASeatReleases,
        color: "D2B48C",
        description: "Adorable sitting pose collection featuring Toy in relaxed positions with various expressions. Each fluffy keychain figure showcases different moods and personalities in comfortable seated poses."
    )
]

func getReleaseByImageName(_ imageName: String) -> ToyRelease? {
    return toySeries.flatMap { $0.releases }.first { $0.imageName == imageName }
}
