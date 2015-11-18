-- phpMyAdmin SQL Dump
-- version 4.0.10.10
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 17 2015 г., 14:43
-- Версия сервера: 5.5.45
-- Версия PHP: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES cp1251 */;

--
-- База данных: `data`
--

-- --------------------------------------------------------

--
-- Структура таблицы `st01`
--

CREATE TABLE IF NOT EXISTS `st01` (
  `number` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE cp1251_bin NOT NULL,
  `author` varchar(150) COLLATE cp1251_bin NOT NULL,
  `year` varchar(150) COLLATE cp1251_bin NOT NULL,
  `edition` varchar(150) COLLATE cp1251_bin DEFAULT NULL,
  PRIMARY KEY (`number`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `st01`
--

INSERT INTO `st01` (`number`, `name`, `author`, `year`, `edition`) VALUES
(1, 'Двенадцатая ночь', 'Шекспир', '1600', NULL),
(2, 'Освой самостоятельно SQL. 10 минут на урок', 'Форта', '2014', '3-е');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
