-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 18, 2024 at 02:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restful_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `created_at`) VALUES
(1, 13, 'apa kek gitu', 'apakek dua kali kali', '2024-12-09 20:26:41'),
(2, 29, 'apa kek jilid2', 'apa kek dua kali jilid 2', '2024-12-09 20:27:33'),
(3, 30, 'akakaka', 'qhwudhjdoasbdn', '2024-12-09 20:28:48');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`) VALUES
(1, 'Test User', 'test@example.com', '$2y$10$vEKsTaehIdm9Dcw7Ag7Zb.7S4xH2cY17SpOta0KU1Ia1RVb.O66Ti'),
(2, 'axl', 'axlbeatrix@gmail.com', '$2y$10$rEGfZ0GLjif9nBDBAGFkdOE1Y8057rXsnZHMMZcZXTqxzVnFn98C6'),
(13, 'user1', 'user1@gmail.com', '$2y$10$iFIS2OpRZs4q6h160nnam.tBsIMcChC4ODXAB55q6SjVKBbeH0X32'),
(15, 'User2', 'user2@gmail.com', '$2y$10$qSEnKRN8As6PUrc/69v/DeZCrQNcrPQkyGKT4/y.srEECLpWHmWZ2'),
(17, 'User3', 'user3@gmail.com', '$2y$10$Cp0ixIlxp7.aFwp/TvNaueZRW1Rcph/u78JB0VD1fVMb.BQ/QOSjW'),
(18, 'user4', 'user4@gmail.com', '$2y$10$fLL7nVxqYKQ3mWaCaGRGvOAFgWD2u/qzwDJbUmb8p7fHeMz2QUnRC'),
(19, 'user5', 'user5@gmail.com', '$2y$10$MXE1FSSM0ZPYjxNGdsz9J.lSBNqTcpUx9lhxX3fV3L9R2siSg5Uiq'),
(21, 'user6', 'user6@gmail.com', '$2y$10$ahjDqr.zfatH9Ku8QRRfjO5X1XI7vz7mP5cLSR7lOKc1uJrexeAo2'),
(22, 'user10', 'user10@gmail.com', '$2y$10$gIE.JOUw6Qut40fYws0CWOJKgXryzLqHKIY7WTHwvctnmwHJnrZXy'),
(29, 'user11', 'user11@gmail.com', '$2y$10$1sVz8Yxo/Eeg/bAI5IbUwepj3k4EyHK3Eimb0VPphS6M.XFYMGHU.'),
(30, 'user12', 'user12@gmail.com', '$2y$10$IOWvIkdkG2ojgJioiHy76e/jBpBFGC4uXqC5RHNSd5lGXqfGzBFLW'),
(31, 'apakek', 'user13@gmail.com', '$2y$10$xQjtPGJ9QSjAUjniDSwXLugpvrSYv05fmJhy.YQteQQS4gT.fWv2y');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
