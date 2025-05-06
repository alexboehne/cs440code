CREATE TABLE `snack` (
  `itemID` int NOT NULL,
  `itemName` varchar(255) DEFAULT NULL,
  `itemPrice` double DEFAULT NULL,
  PRIMARY KEY (`itemID`)
);

CREATE TABLE `movie` (
  `movieID` int NOT NULL AUTO_INCREMENT,
  `movieName` varchar(255) DEFAULT NULL,
  `movieLength` varchar(255) DEFAULT NULL,
  `movieGenre` varchar(255) DEFAULT NULL,
  `movieRating` varchar(5) DEFAULT NULL,
  `moviePrice` double DEFAULT NULL,
  PRIMARY KEY (`movieID`)
);

CREATE TABLE `theatre` (
  `thID` int NOT NULL,
  `seats` int DEFAULT NULL,
  `seatsAvailable` int DEFAULT NULL,
  PRIMARY KEY (`thID`)
);

CREATE TABLE `member` (
  `memberID` int NOT NULL AUTO_INCREMENT,
  `memberName` varchar(255) DEFAULT NULL,
  `creditCard` char(16) DEFAULT NULL,
  `memberDiscount` double DEFAULT NULL,
  PRIMARY KEY (`memberID`)
);

CREATE TABLE `showing` (
  `showID` int NOT NULL,
  `movieID` int DEFAULT NULL,
  `thID` int DEFAULT NULL,
  `startTime` time DEFAULT NULL,
  PRIMARY KEY (`showID`),
  KEY `thID` (`thID`),
  KEY `showing_ibfk_1_idx` (`movieID`),
  CONSTRAINT `showing_ibfk_1` FOREIGN KEY (`movieID`) REFERENCES `movie` (`movieID`),
  CONSTRAINT `showing_ibfk_2` FOREIGN KEY (`thID`) REFERENCES `theatre` (`thID`)
);

CREATE TABLE `sale` (
  `saleID` int NOT NULL AUTO_INCREMENT,
  `saleDate` datetime NOT NULL DEFAULT (curdate()),
  `showID` int DEFAULT NULL,
  `itemID` int DEFAULT NULL,
  `saleTax` double DEFAULT NULL,
  `memberID` int DEFAULT NULL,
  `finalPrice` double DEFAULT NULL,
  PRIMARY KEY (`saleID`),
  KEY `showID` (`showID`),
  KEY `itemID` (`itemID`),
  KEY `sale_ibfk_3_idx` (`memberID`),
  CONSTRAINT `sale_ibfk_1` FOREIGN KEY (`showID`) REFERENCES `showing` (`showID`),
  CONSTRAINT `sale_ibfk_2` FOREIGN KEY (`itemID`) REFERENCES `snack` (`itemID`),
  CONSTRAINT `sale_ibfk_3` FOREIGN KEY (`memberID`) REFERENCES `member` (`memberID`)
);
