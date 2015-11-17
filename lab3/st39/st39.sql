-- phpMyAdmin SQL Dump
-- version 4.0.10.10
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 17 2015 г., 23:03
-- Версия сервера: 5.5.45
-- Версия PHP: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `data`
--

-- --------------------------------------------------------

--
-- Структура таблицы `st39`
--

CREATE TABLE IF NOT EXISTS `st39` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `performer` varchar(100) COLLATE cp1251_bin NOT NULL,
  `song` varchar(100) COLLATE cp1251_bin NOT NULL,
  `date` varchar(50) COLLATE cp1251_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `st39`
--

INSERT INTO `st39` (`id`, `performer`, `song`, `date`) VALUES
(1, 'Linkin Park', 'My December', '2000'),
(2, 'Eurythmics', 'Sweet Dreams', '1983'),
(3, 'The Beatles', 'Eleanor Rigby', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
