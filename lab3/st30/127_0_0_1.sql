-- phpMyAdmin SQL Dump
-- version 4.0.10.6
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1:3306
-- Время создания: Окт 16 2015 г., 00:55
-- Версия сервера: 5.5.41-log
-- Версия PHP: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `lab3`
--

-- --------------------------------------------------------

--
-- Структура таблицы `st30`
--

CREATE TABLE IF NOT EXISTS `st30` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) COLLATE cp1251_bin NOT NULL,
  `phone` varchar(40) COLLATE cp1251_bin NOT NULL,
  `business_phone` varchar(40) COLLATE cp1251_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=31 ;

--
-- Дамп данных таблицы `st30`
--

INSERT INTO `st30` (`id`, `name`, `phone`, `business_phone`) VALUES
(27, 'fghbjkm', 'кепнролджэ', 'йцукепролд'),
(28, 'Fsdf', 'sdfsd', NULL),
(29, 'sdfsdf', 'sdf6789', ''),
(30, 'fgvhbnjkm69', 'dfghj', '123456');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
