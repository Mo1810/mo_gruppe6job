INSERT INTO `items` (name, label, weight, rare, can_remove, price) VALUES 
	('mo_thermitecharge', 'thermit charge', 1500, 0, 1, 15000)
;

CREATE TABLE `gruppe6vehicles` (
  `plate` varchar(11) NOT NULL,
  `currentMoneyInside` int(11) NOT NULL DEFAULT 0,
  `inGarage` tinyint(1) NOT NULL DEFAULT 1,
  
  PRIMARY KEY (`plate`)
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `gruppe6vehicles` (`plate`, `currentMoneyInside`, `inGarage`) VALUES
('ZIEMANN1', 0, 1),
('ZIEMANN2', 0, 1),
('ZIEMANN3', 0, 1),
('ZIEMANN4', 0, 1),
('ZIEMANN5', 0, 1),
('ZIEMANN6', 0, 1),
('ZIEMANN7', 0, 1),
('ZIEMANN8', 0, 1),
('ZIEMANN9', 0, 1)
;