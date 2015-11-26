-- phpMyAdmin SQL Dump
-- version 4.0.10.10
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 26 2015 г., 20:46
-- Версия сервера: 5.5.45
-- Версия PHP: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `database03`
--

-- --------------------------------------------------------

--
-- Структура таблицы `st03`
--

CREATE TABLE IF NOT EXISTS `st03` (
  `key` int(15) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `diplom` varchar(200) NOT NULL,
  `dipRuk` varchar(200) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Дамп данных таблицы `st03`
--

INSERT INTO `st03` (`key`, `name`, `diplom`, `dipRuk`) VALUES
(4, 'sdg', 'sdsg', 'adfad1241234'),
(6, '123', '135d', 'tadg'),
(7, 'dsg', 'sfg', 'sfg'),
(8, '123', '123', '34');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
