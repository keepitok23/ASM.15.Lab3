SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `lab3`
--

--
-- Структура таблицы `st47`
--

CREATE TABLE IF NOT EXISTS `st47` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cname` varchar(200) COLLATE cp1251_bin NOT NULL,
  `ctown` varchar(200) COLLATE cp1251_bin NOT NULL,
  `clocation` varchar(200) COLLATE cp1251_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `st47`
--

INSERT INTO `st47` (`id`, `cname`, `ctown`, `clocation`) VALUES
(1, 'ГАЗПРОМ', 'Москва', ' ул. Наметкина, 16'),
(2, 'ЛУКОЙЛ', 'Москва', 'Сретенский бульвар, 11'),
(3, 'Шлюмберже', 'Мсоква', 'Ленинградское шоссе, 16');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
