--[INSTALLATION]--

[EN]
- Copy the script onto your server

- Register the script in the `server.cfg` OR `resource.cfg` file: [start mo_gruppe6job]

- Execute the `mo_transportOfValuables_en.sql` file or copy the content into the MySQL console

- Insert the item `mo_thermitecharge` in your pawnshop script or other buy options
		[-Default SQL-]
				
				>>>> INSERT INTO `shops` (store, item, price) VALUES ('TwentyFourSeven', 'mo_thermitecharge', 15000); <<<<
				
		!!!OR!!!
		
		[-Pawnshop script / Item in the config-]
		
				>>>>
				['mo_thermitecharge'] = {
					['name'] = "thermite charge",
					['price_to_customer'] = 15000,
					['price_to_owner'] = 5000,
					['amount_to_owner'] = 5,
					['amount_to_delivery'] = 10,
					['page'] = 2
				},
				<<<<

- (If the amount of transporters isn't enough you can add more in your database)



[GER]
- Füge das Script auf deinen Server hinzu

- Registiere das Script in der `server.cfg` oder `resource.cfg`: [start mo_gruppe6job]

- Führe die `mo_transportOfValuables.sql` Datei aus

- Füge das Item `mo_thermitecharge` in dein Pfandhausscript oder andere Einkaufsmöglichkeiten ein
		[-Standard SQL-]
				
				>>>> INSERT INTO `shops` (store, item, price) VALUES ('TwentyFourSeven', 'mo_thermitecharge', 15000); <<<<
		
		!!!OR!!!
		
		[-Pfandhausscript / Items in der Config-]
				
				>>>>
				['mo_thermitecharge'] = {
					['name'] = "thermite charge",
					['price_to_customer'] = 15000,
					['price_to_owner'] = 5000,
					['amount_to_owner'] = 5,
					['amount_to_delivery'] = 10,
					['page'] = 2
				},
				<<<<

- (Falls die Anzahl an Transportern nicht reichen, können in der Datenbank neue hinzugefügt werden)