--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--

Config = {}
Config.Locale = 'en'
Config.trigger_key = 46---------------------------(E)	default: 46
Config.greySquare = false-------------------------		default: false
Config.PedModel = 's_m_m_armoured_01'-------------		default: 's_m_m_armoured_01'
Config.MarkerType = 39----------------------------		default: 39
Config.maxAmountOfRoutes = 3----------------------		default: 3
Config.SalaryAccountType = 'bank'-----------------		default: 'bank'
Config.salary = 10000-----------------------------($) 	default: 10000
Config.vehicleBone = 'handle_pside_r'-------------		default: 'handle_pside_r'
Config.RequiredPolice = 3-------------------------		default: 3
Config.WaitTime = 35------------------------------(sec)	default: 35
Config.cooldown = 45------------------------------(min)	default: 45
Config.HeistMoneyAccountType = 'black_money'------		default: 'black_money'
Config.item = 'mo_thermitecharge'-----------------		default: 'mo_thermitecharge'

Config.startShift = {
	coords = vector3(-197.39, -831.45, 30.75),
}

Config.startDrive = {
	coords = vector3(-178.00, -832.90, 30.49),
}

Config.blips = {
	truck = {
		Sprite = 67,
		Display = 6,
		Colour = 2,
		Scale = 0.7,
	},
	building = {
		Sprite = 498,
		Display = 6,
		Colour = 26,
		Scale = 0.8,
	},
	currentTarget = {
		Sprite = 586,
		Display = 6,
		Colour = 81,
		Scale = 0.9,
	},
	moneyCourier = {
		Sprite = 351,
		Display = 8,
		Colour = 2,
		Scale = 0.6,
	},
	returnToDepository = {
		Sprite = 434,
		Display = 6,
		Colour = 81,
		Scale = 0.9,
		Coords = vector3(-34.757320404053, -669.96411132812, 31.943548202515),
		Heading = 184.0
	},
}

Config.places = {
	{
		Type = 'bank',
		Coords = vector3(147.43591308594, -1044.9503173828, 29.368036270142),
		Parking = vector3(158.10456848145, -1036.1547851562, 29.201391220093),
		Money = {
			Min = 500000,
			Max = 1250000,
		},
	},
	{
		Type = 'bank',
		Coords = vector3(-1211.2990722656, -335.48358154297, 37.780990600586),
		Parking = vector3(-1211.384765625, -320.09683227539, 37.759761810303),
		Money = {
			Min = 500000,
			Max = 1250000,
		},
	},
	{
		Type = 'bank',
		Coords = vector3(-2957.5541992188, 481.97552490234, 15.69704246521),
		Parking = vector3(-2959.5512695312, 461.46328735352, 15.231229782104),
		Money = {
			Min = 500000,
			Max = 1250000,
		},
	},
	{
		Type = 'bank',
		Coords = vector3(-105.01634216309, 6476.6225585938, 31.626728057861),
		Parking = vector3(-128.45294189453, 6456.3642578125, 31.459310531616),
		Money = {
			Min = 500000,
			Max = 1250000,
		},
	},
	{
		Type = 'bank',
		Coords = vector3(311.81057739258, -283.380859375, 54.164791107178),
		Parking = vector3(306.74835205078, -269.54040527344, 53.95902633667),
		Money = {
			Min = 500000,
			Max = 1250000,
		},
	},
	{
		Type = 'bank',
		Coords = vector3(-353.29690551758, -54.187553405762, 49.036548614502),
		Parking = vector3(-333.68594360352, -38.433826446533, 47.861324310303),
		Money = {
			Min = 500000,
			Max = 1250000,
		},
	},
	{
		Type = 'centralbank',
		Coords = vector3(241.36320495605, 225.39007568359, 106.28678894043),
		Parking = vector3(226.4637298584, 221.47895812988, 105.54941558838),
		Money = {
			Min = 2500000,
			Max = 5500000,
		},
	},
	{ --jeweler
		Type = 'shop',
		Coords = vector3(-630.94342041016, -229.66528320312, 38.057060241699),
		Parking = vector3(-665.77062988281, -230.23370361328, 37.155170440674),
		Money = {
			Min = 200000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-43.336479187012, -1748.5170898438, 29.421018600464),
		Parking = vector3(-59.087940216064, -1745.9376220703, 29.347442626953),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(28.239925384521, -1339.2298583984, 29.497022628784),
		Parking = vector3(50.125034332275, -1353.1638183594, 29.291536331177),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-709.68225097656, -904.17645263672, 19.215612411499),
		Parking = vector3(-707.85980224609, -920.00946044922, 19.013917922974),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-3047.7807617188, 585.55682373047, 7.9089274406433),
		Parking = vector3(-3051.1906738281, 597.15704345703, 7.4504880905151),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-3250.0891113281, 1004.3641357422, 12.830704689026),
		Parking = vector3(-3240.0537109375, 993.0205078125, 12.409936904907),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(1959.2062988281, 3748.83203125, 32.343742370605),
		Parking = vector3(1972.4460449219, 3746.5754394531, 32.289749145508),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-2959.505859375, 387.14901733398, 14.043295860291),
		Parking = vector3(-2976.3225097656, 398.39410400391, 15.062900543213),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-1829.1394042969, 798.77862548828, 138.19041442871),
		Parking = vector3(-1816.7702636719, 787.81549072266, 137.88485717773),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-1479.0086669922, -375.32769775391, 39.1633644104),
		Parking = vector3(-1489.1442871094, -391.53366088867, 39.145614624023),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(-1220.8430175781, -915.91687011719, 11.326335906982),
		Parking = vector3(-1221.6776123047, -895.15740966797, 12.548451423645),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(378.08752441406, 333.35998535156, 103.56637573242),
		Parking = vector3(370.09216308594, 321.12591552734, 103.54775238037),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(1159.5604248047, -314.04565429688, 69.205146789551),
		Parking = vector3(1163.0892333984, -329.84124755859, 69.001564025879),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(2549.3190917969, 385.06185913086, 108.62294006348),
		Parking = vector3(2566.087890625, 391.03729248047, 108.4627532959),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(1126.8332519531, -980.15515136719, 45.415836334229),
		Parking = vector3(1145.9936523438, -985.38702392578, 45.961654663086),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(546.51696777344, 2662.9099121094, 42.156494140625),
		Parking = vector3(556.04669189453, 2680.6030273438, 42.115619659424),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(1169.2320556641, 2717.79296875, 37.157695770264),
		Parking = vector3(1164.7232666016, 2696.2895507812, 37.826023101807),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(2672.7749023438, 3286.5859375, 55.24112701416),
		Parking = vector3(2682.00390625, 3293.5541992188, 55.23685836792),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(1707.7548828125, 4920.46875, 42.063674926758),
		Parking = vector3(1698.5540771484, 4936.9970703125, 42.082656860352),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'shop',
		Coords = vector3(1734.8129882812, 6420.7954101562, 35.037220001221),
		Parking = vector3(1727.6918945312, 6406.3012695312, 34.363872528076),
		Money = {
			Min = 100000,
			Max = 400000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(-334.60751342773, 6081.857421875, 31.454763412476),
		Parking = vector3(-317.22427368164, 6076.9052734375, 31.330879211426),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(-1122.2174072266, 2696.8742675781, 18.554151535034),
		Parking = vector3(-1117.1577148438, 2681.96875, 18.56770324707),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(-666.48284912109, -933.74566650391, 21.829233169556),
		Parking = vector3(-667.63244628906, -949.0302734375, 21.47713470459),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(12.445470809937, -1105.810546875, 29.797021865845),
		Parking = vector3(-8.2186260223389, -1111.5886230469, 28.170919418335),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(1689.5836181641, 3757.8781738281, 34.705360412598), 
		Parking = vector3(1701.6107177734, 3746.6782226562, 33.997360229492),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(2572.1096191406, 292.69262695312, 108.73487854004), 
		Parking = vector3(2574.9484863281, 312.10913085938, 108.45813751221),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(254.9328918457, -46.605953216553, 69.941055297852), 
		Parking = vector3(238.62484741211, -34.021144866943, 69.723289489746),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{
		Type = 'ammunation',
		Coords = vector3(846.55297851562, -1035.0732421875, 28.296655654907), 
		Parking = vector3(839.38818359375, -1019.1136474609, 27.469644546509),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
	{ --36
		Type = 'ammunation',
		Coords = vector3(819.6787109375, -2155.2687988281, 29.619007110596), 
		Parking = vector3(822.23706054688, -2143.7973632812, 28.795024871826),
		Money = {
			Min = 250000,
			Max = 550000,
		},
	},
}

--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--
