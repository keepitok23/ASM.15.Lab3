SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `st42` (
  `item` int(15) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE cp1251_bin NOT NULL,
  `surname` varchar(200) COLLATE cp1251_bin NOT NULL,
  `hometown` varchar(200) COLLATE cp1251_bin NOT NULL,
  `status` varchar(200) COLLATE cp1251_bin DEFAULT NULL,
  PRIMARY KEY (`item`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=1;
