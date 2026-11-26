-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 26, 2026 at 09:48 AM
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
-- Database: `hms`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `updationDate` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`, `updationDate`) VALUES
(1, 'admin', '$2y$10$Mf1nyZSTpNqfpf6.SkUwlukUlqshzTqfRnP0pX4XWR2pyjoL.sbSe', '04-03-2024 11:42:05 AM');

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `id` int(11) NOT NULL,
  `doctorSpecialization` varchar(255) DEFAULT NULL,
  `doctorId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `consultancyFees` int(11) DEFAULT NULL,
  `appointmentDate` varchar(255) DEFAULT NULL,
  `appointmentTime` varchar(255) DEFAULT NULL,
  `postingDate` timestamp NULL DEFAULT current_timestamp(),
  `userStatus` int(11) DEFAULT NULL,
  `doctorStatus` int(11) DEFAULT NULL,
  `updationDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `status` enum('Pending','Approved','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
  `status_updated_at` datetime DEFAULT NULL,
  `status_updated_by` varchar(80) DEFAULT NULL,
  `reschedule_reason` varchar(255) DEFAULT NULL,
  `cancel_reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`id`, `doctorSpecialization`, `doctorId`, `userId`, `consultancyFees`, `appointmentDate`, `appointmentTime`, `postingDate`, `userStatus`, `doctorStatus`, `updationDate`, `status`, `status_updated_at`, `status_updated_by`, `reschedule_reason`, `cancel_reason`) VALUES
(7, 'Poli Umum Tes Kesehatan P3K', 33, 19, 1000000, '2026-11-18', '10:16:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(8, 'Poli Bedah (Eksekutif)', 35, 20, 1000000, '2026-11-18', '12:58:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(9, 'Poli Bedah', 35, 21, 1000000, '2026-11-11', '11:25:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(10, 'Poli Anak Sub. Kardiologi', 47, 22, 1000000, '2026-11-23', '12:07:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(11, 'Poli Penyakit Jiwa', 49, 23, 1000000, '2026-11-28', '08:43:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(12, 'Poli Kulit & Kelamin (Eksekutif)', 49, 24, 1000000, '2026-11-28', '14:01:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(13, 'Poli Kulit & Kelamin', 49, 25, 1000000, '2026-11-16', '08:30:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(14, 'Poli Kandungan', 18, 26, 1000000, '2026-11-16', '11:03:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(15, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 57, 27, 1000000, '2026-11-18', '11:09:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(16, 'Poli Jantung', 44, 28, 1000000, '2026-11-24', '10:05:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(17, 'Poli Saraf', 15, 29, 1000000, '2026-11-26', '10:01:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(18, 'RADIOLOGI', 46, 30, 1000000, '2026-11-23', '18:07:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(19, 'Poli Saraf', 30, 31, 1000000, '2026-11-02', '11:34:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(20, 'Poli THT', 43, 32, 1000000, '2026-11-23', '09:11:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(21, 'Uji Kesehatan PNS (Paket)', 41, 33, 1000000, '2026-11-09', '08:46:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(22, 'Uji Kesehatan PNS (Paket)', 34, 34, 1000000, '2026-11-13', '09:14:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(23, 'Poli Periodonti', 63, 35, 1000000, '2026-11-09', '09:29:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(24, 'Poli Bedah', 35, 36, 1000000, '2026-11-16', '10:10:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(25, 'Poli Anak (Eksekutif)', 53, 37, 1000000, '2026-11-21', '10:16:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(26, 'Poli Bedah', 44, 38, 1000000, '2026-11-05', '09:30:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(27, 'Poli Urologi', 51, 39, 1000000, '2026-11-12', '09:04:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(28, 'Poli Bedah (Eksekutif)', 48, 40, 1000000, '2026-11-23', '10:04:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(29, 'Poli Kulit & Kelamin', 51, 41, 1000000, '2026-11-20', '11:06:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(30, 'Poli Kandungan (Eksekutif)', 53, 42, 1000000, '2026-11-27', '11:18:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(31, 'P. VK (Rajal)', 53, 43, 1000000, '2026-11-27', '08:28:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(32, 'GCU : Surat Sehat Jasmani + Rohani', 45, 44, 1000000, '2026-11-04', '10:52:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(33, 'Poli Fisioterapi', 61, 45, 1000000, '2026-11-05', '10:59:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(34, 'Poli Anak', 32, 46, 1000000, '2026-11-23', '10:14:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(35, 'Poli Penyakit Dalam (Eksekutif)', 35, 47, 1000000, '2026-11-16', '13:52:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(36, 'Poli Penyakit Dalam (Eksekutif)', 48, 48, 1000000, '2026-11-11', '13:08:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(37, 'Uji Kesehatan PNS (Paket)', 41, 49, 1000000, '2026-11-23', '11:08:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(38, 'Poli Umum', 58, 50, 1000000, '2026-11-23', '12:57:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(39, 'Poli Penyakit Dalam (Eksekutif)', 24, 51, 1000000, '2026-11-20', '11:50:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(40, 'Poli Anak', 18, 52, 1000000, '2026-11-05', '10:49:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(41, 'Poli Penyakit Dalam (Eksekutif)', 35, 53, 1000000, '2026-11-06', '13:35:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(42, 'Poli VCT', 33, 54, 1000000, '2026-11-21', '08:22:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(43, 'Poli Bedah', 48, 55, 1000000, '2026-11-17', '13:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(44, 'Poli Kandungan (Eksekutif)', 12, 56, 1000000, '2026-11-23', '10:42:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(45, 'Poli Anak', 12, 57, 1000000, '2026-11-05', '13:29:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(46, 'Uji Kesehatan PNS (Paket)', 60, 58, 1000000, '2026-11-16', '09:48:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(47, 'Poli THT', 38, 59, 1000000, '2026-11-06', '10:20:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(48, 'Poli Penyakit Dalam', 22, 60, 1000000, '2026-11-13', '11:13:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(49, 'Poli Saraf (Eksekutif)', 25, 61, 1000000, '2026-11-20', '11:48:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(50, 'Uji Kesehatan PNS (Paket)', 42, 62, 1000000, '2026-11-09', '10:49:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(51, 'Tes Dewan', 33, 63, 1000000, '2026-11-24', '10:08:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(52, 'Poli THT', 43, 64, 1000000, '2026-11-04', '13:01:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(53, 'TUMBUH KEMBANG ANAK', 12, 65, 1000000, '2026-11-23', '08:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(54, 'Poli Penyakit Dalam (Eksekutif)', 10, 66, 1000000, '2026-11-23', '09:53:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(55, 'Poli Fisioterapi', 61, 67, 1000000, '2026-11-24', '13:09:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(56, 'Poli Penyakit Dalam (Sore)', 22, 68, 1000000, '2026-11-26', '16:35:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(57, 'Poli Penyakit Dalam (Sore)', 22, 69, 1000000, '2026-11-19', '19:00:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(58, 'Uji Kesehatan PNS (Paket)', 54, 70, 1000000, '2026-11-06', '11:10:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(59, 'Poli Umum', 17, 71, 1000000, '2026-11-27', '11:55:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(60, 'Poli Anak (Sore)', 20, 72, 1000000, '2026-11-19', '16:20:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(61, 'Poli Bedah', 49, 73, 1000000, '2026-11-18', '12:51:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(62, 'Poli Bedah', 48, 74, 1000000, '2026-11-07', '13:05:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(63, 'Poli Orthopaedi & Traumatologi', 19, 75, 1000000, '2026-11-30', '11:40:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(64, 'Poli Anak Sub. Kardiologi', 31, 76, 1000000, '2026-11-13', '10:39:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(65, 'Tes Dewan', 17, 77, 1000000, '2026-11-23', '11:09:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(66, 'Poli THT', 38, 78, 1000000, '2026-11-20', '09:08:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(67, 'Poli Kandungan', 53, 79, 1000000, '2026-11-16', '09:44:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(68, 'Poli Anak (Eksekutif)', 12, 80, 1000000, '2026-11-27', '15:23:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(69, 'Poli Paru', 62, 81, 1000000, '2026-11-30', '09:16:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(70, 'Poli Penyakit Dalam (Eksekutif)', 10, 82, 1000000, '2026-11-11', '10:23:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(71, 'Poli Kandungan (Eksekutif)', 53, 83, 1000000, '2026-11-18', '10:32:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(72, 'Poli Kandungan (Eksekutif)', 18, 84, 1000000, '2026-11-07', '09:19:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(73, 'Uji Kesehatan PNS (Paket)', 45, 85, 1000000, '2026-11-09', '10:32:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(74, 'Poli Anak (Eksekutif)', 26, 86, 1000000, '2026-11-17', '15:12:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(75, 'Uji Kesehatan PNS (Paket)', 29, 87, 1000000, '2026-11-24', '12:45:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(76, 'P. VK (Rajal)', 53, 88, 1000000, '2026-11-06', '09:38:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(77, 'Tes Dewan', 60, 89, 1000000, '2026-11-11', '09:25:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(78, 'Poli Kandungan (Eksekutif)', 39, 90, 1000000, '2026-11-18', '13:11:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(79, 'Poli Rehabilitasi Medik', 24, 91, 1000000, '2026-11-27', '09:37:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(80, 'Poli Anak Sub. Kardiologi', 20, 92, 1000000, '2026-11-04', '09:09:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(81, 'Poli Umum Tes Kesehatan P3K', 17, 93, 1000000, '2026-11-05', '10:02:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(82, 'Uji Kesehatan PNS (Paket)', 60, 94, 1000000, '2026-11-23', '13:23:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(83, 'Poli Orthopaedi & Traumatologi', 57, 95, 1000000, '2026-11-10', '08:13:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(84, 'Poli Kulit & Kelamin', 55, 96, 1000000, '2026-11-12', '09:08:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(85, 'Poli Penyakit Dalam', 13, 97, 1000000, '2026-11-19', '08:56:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(86, 'Poli Penyakit Dalam (Eksekutif)', 10, 98, 1000000, '2026-11-25', '11:18:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(87, 'RADIOLOGI', 46, 99, 1000000, '2026-11-11', '15:47:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(88, 'Poli Umum Tes Kesehatan P3K', 45, 100, 1000000, '2026-12-01', '11:17:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(89, 'Poli Dalam Sub. Gastroenterohepatologi', 47, 101, 1000000, '2026-11-09', '11:44:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(90, 'Poli Umum', 15, 102, 1000000, '2026-11-18', '11:04:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(91, 'Poli Kulit & Kelamin (Eksekutif)', 49, 103, 1000000, '2026-11-24', '14:49:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(92, 'Poli Kandungan', 39, 104, 1000000, '2026-11-05', '13:13:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(93, 'Poli Penyakit Jiwa', 11, 105, 1000000, '2026-11-24', '10:52:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(94, 'Poli Jantung', 35, 106, 1000000, '2026-11-14', '10:05:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(95, 'TUMBUH KEMBANG ANAK', 12, 107, 1000000, '2026-11-09', '08:29:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(96, 'Poli Gigi & Mulut', 63, 108, 1000000, '2026-11-11', '12:43:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(97, 'LABORATORIUM PATOLOGI KLINIK (SENTRAL)', 59, 109, 1000000, '2026-11-05', '18:38:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(98, 'Poli Bedah', 35, 110, 1000000, '2026-11-27', '11:05:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(99, 'Poli Mata', 36, 111, 1000000, '2026-11-20', '12:08:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(100, 'Poli Rehabilitasi Medik', 24, 112, 1000000, '2026-11-18', '10:45:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(101, 'Poli Gigi Anak', 64, 113, 1000000, '2026-11-06', '12:19:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(102, 'P. VK (Rajal)', 18, 114, 1000000, '2026-11-07', '10:05:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(103, 'Poli Anak (Sore)', 20, 115, 1000000, '2026-11-07', '18:40:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(104, 'GCU : Surat Sehat Jasmani + Rohani', 60, 116, 1000000, '2026-11-12', '12:05:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(105, 'Poli Urologi (Eksekutif)', 51, 117, 1000000, '2026-11-23', '09:07:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(106, 'Poli Saraf', 15, 118, 1000000, '2026-11-12', '10:56:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(107, 'Uji Kesehatan PNS (Paket)', 42, 119, 1000000, '2026-11-13', '10:21:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(108, 'Poli THT', 55, 120, 1000000, '2026-11-13', '10:33:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(109, 'Poli Jantung', 52, 121, 1000000, '2026-11-14', '11:37:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(110, 'Poli Anak', 26, 122, 1000000, '2026-11-18', '10:29:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(111, 'Poli Penyakit Dalam', 30, 123, 1000000, '2026-11-10', '10:59:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(112, 'Tes Dewan', 60, 124, 1000000, '2026-12-02', '07:57:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(113, 'Poli Bedah (Eksekutif)', 44, 125, 1000000, '2026-11-05', '10:25:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(114, 'Poli Fisioterapi', 24, 126, 1000000, '2026-11-28', '10:39:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(115, 'Poli Umum', 15, 127, 1000000, '2026-11-14', '11:43:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(116, 'Poli Jantung (Eksekutif)', 16, 128, 1000000, '2026-11-27', '14:02:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(117, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 19, 129, 1000000, '2026-11-20', '12:52:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(118, 'Poli Penyakit Dalam', 24, 130, 1000000, '2026-11-16', '12:28:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(119, 'Hemodialisa', 24, 131, 1000000, '2026-11-18', '09:27:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(120, 'Poli THT', 45, 132, 1000000, '2026-11-11', '07:34:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(121, 'Poli Anak (Eksekutif)', 32, 133, 1000000, '2026-12-01', '13:15:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(122, 'Poli Saraf', 25, 134, 1000000, '2026-11-07', '12:25:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(123, 'Poli Paru', 15, 135, 1000000, '2026-11-12', '08:27:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(124, 'Poli Saraf', 11, 136, 1000000, '2026-11-12', '08:31:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(125, 'P. VK (Rajal)', 39, 137, 1000000, '2026-11-24', '08:50:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(126, 'Poli Bedah (Eksekutif)', 44, 138, 1000000, '2026-11-09', '08:27:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(127, 'Poli Umum Tes Kesehatan P3K', 33, 139, 1000000, '2026-11-12', '10:33:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(128, 'Poli THT', 55, 140, 1000000, '2026-11-18', '10:12:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(129, 'Poli Penyakit Jiwa', 11, 141, 1000000, '2026-11-28', '09:45:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(130, 'Uji Kesehatan PNS (Paket)', 27, 142, 1000000, '2026-11-13', '09:12:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(131, 'Poli Bedah (Eksekutif)', 35, 143, 1000000, '2026-11-13', '11:23:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(132, 'Poli Umum Tes Kesehatan P3K', 60, 144, 1000000, '2026-11-23', '11:13:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(133, 'Poli Orthopaedi & Traumatologi', 57, 145, 1000000, '2026-11-10', '08:41:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(134, 'Poli Orthopaedi & Traumatologi', 19, 146, 1000000, '2026-11-12', '10:17:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(135, 'Poli Umum', 15, 147, 1000000, '2026-11-14', '11:25:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(136, 'Poli Penyakit Dalam (Eksekutif)', 24, 148, 1000000, '2026-11-06', '13:52:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(137, 'Matahari', 56, 149, 1000000, '2026-11-28', '09:33:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(138, 'Poli Penyakit Dalam (Eksekutif)', 48, 150, 1000000, '2026-11-04', '15:20:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(139, 'Poli Jantung', 48, 151, 1000000, '2026-11-25', '10:59:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(140, 'Poli Jantung', 44, 152, 1000000, '2026-11-20', '08:14:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(141, 'Poli Gigi & Mulut', 36, 153, 1000000, '2026-11-04', '09:11:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(142, 'Poli Anak', 32, 154, 1000000, '2026-11-11', '10:14:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(143, 'Poli Penyakit Mulut', 65, 155, 1000000, '2026-11-09', '13:04:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(144, 'Poli Anak (Eksekutif)', 32, 156, 1000000, '2026-11-12', '14:58:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(145, 'Uji Kesehatan PNS (Paket)', 27, 157, 1000000, '2026-11-06', '09:10:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(146, 'Poli Umum', 45, 158, 1000000, '2026-11-05', '08:47:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(147, 'Poli Kandungan (Eksekutif)', 53, 159, 1000000, '2026-11-19', '09:55:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(148, 'Poli Saraf (Eksekutif)', 15, 160, 1000000, '2026-11-23', '14:26:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(149, 'Poli Penyakit Dalam (Eksekutif)', 44, 161, 1000000, '2026-11-20', '11:06:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(150, 'Poli Anak Sub. Kardiologi', 47, 162, 1000000, '2026-11-26', '12:05:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(151, 'Poli Umum', 60, 163, 1000000, '2026-11-19', '12:31:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(152, 'Poli Jantung (Eksekutif)', 16, 164, 1000000, '2026-11-16', '13:09:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(153, 'GCU : Surat Sehat Jasmani + Rohani', 45, 165, 1000000, '2026-11-27', '12:30:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(154, 'Poli Paru', 55, 166, 1000000, '2026-11-10', '11:09:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(155, 'Poli Orthopaedi & Traumatologi', 24, 167, 1000000, '2026-11-16', '10:46:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(156, 'Poli Paru', 55, 168, 1000000, '2026-11-27', '09:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(157, 'Poli Urologi (Eksekutif)', 51, 169, 1000000, '2026-11-20', '11:28:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(158, 'Uji Kesehatan PNS (Paket)', 54, 170, 1000000, '2026-12-01', '10:35:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(159, 'Poli Urologi', 50, 171, 1000000, '2026-11-17', '09:26:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(160, 'Poli Saraf (Eksekutif)', 15, 172, 1000000, '2026-11-19', '10:17:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(161, 'Poli THT', 45, 173, 1000000, '2026-11-18', '09:05:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(162, 'Uji Kesehatan PNS (Paket)', 33, 174, 1000000, '2026-11-03', '08:08:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(163, 'Poli Jantung', 19, 175, 1000000, '2026-11-05', '10:44:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(164, 'Poli Anak', 26, 176, 1000000, '2026-11-18', '10:54:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(165, 'Poli THT', 55, 177, 1000000, '2026-11-18', '08:58:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(166, 'LABORATORIUM PATOLOGI KLINIK (SENTRAL)', 59, 178, 1000000, '2026-11-30', '08:37:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(167, 'Poli Anak', 20, 179, 1000000, '2026-11-09', '10:41:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(168, 'Poli Penyakit Dalam', 10, 180, 1000000, '2026-11-28', '10:39:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(169, 'Poli Jantung', 51, 181, 1000000, '2026-11-19', '11:10:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(170, 'Uji Kesehatan PNS (Paket)', 29, 182, 1000000, '2026-11-24', '11:19:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(171, 'Poli Anak (Sore)', 22, 183, 1000000, '2026-11-04', '19:17:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(172, 'PCR (LAB)', 59, 184, 1000000, '2026-11-25', '13:38:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(173, 'Poli Paru', 14, 185, 1000000, '2026-11-07', '08:14:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(174, 'Poli Kulit & Kelamin', 51, 186, 1000000, '2026-11-24', '13:06:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(175, 'Poli Kandungan (Eksekutif)', 12, 187, 1000000, '2026-11-23', '10:13:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(176, 'Poli Anak (Eksekutif)', 53, 188, 1000000, '2026-11-18', '10:10:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(177, 'Poli Penyakit Dalam', 22, 189, 1000000, '2026-11-23', '10:07:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(178, 'Matahari', 56, 190, 1000000, '2026-11-28', '12:10:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(179, 'Poli Paru (Eksekutif)', 14, 191, 1000000, '2026-11-14', '10:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(180, 'Poli Paru', 14, 192, 1000000, '2026-11-05', '12:18:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(181, 'Poli Bedah', 49, 193, 1000000, '2026-11-28', '11:59:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(182, 'Poli Penyakit Dalam (Sore)', 65, 194, 1000000, '2026-11-27', '17:36:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(183, 'Poli Penyakit Dalam', 10, 195, 1000000, '2026-11-24', '12:27:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(184, 'Poli Gigi Anak', 64, 196, 1000000, '2026-11-09', '11:45:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(185, 'Poli Penyakit Dalam (Eksekutif)', 48, 197, 1000000, '2026-11-11', '13:56:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(186, 'Poli Bedah (Eksekutif)', 48, 198, 1000000, '2026-11-26', '11:08:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(187, 'Poli Bedah (Eksekutif)', 44, 199, 1000000, '2026-11-16', '09:19:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(188, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 57, 200, 1000000, '2026-11-14', '10:34:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(189, 'Uji Kesehatan PNS (Paket)', 28, 201, 1000000, '2026-11-19', '09:29:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(190, 'Poli Fisioterapi', 24, 202, 1000000, '2026-11-23', '10:48:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(191, 'Uji Kesehatan PNS (Paket)', 40, 203, 1000000, '2026-11-02', '10:19:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(192, 'Tes P3K Tanpa Surat Sehat', 11, 204, 1000000, '2026-11-16', '08:58:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(193, 'Poli Gigi & Mulut', 21, 205, 1000000, '2026-11-23', '09:58:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(194, 'Poli Anak', 12, 206, 1000000, '2026-11-05', '09:32:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(195, 'P. VK (Rajal)', 39, 207, 1000000, '2026-11-14', '10:18:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(196, 'GCU : Surat Sehat Jasmani + Rohani', 33, 208, 1000000, '2026-11-12', '11:05:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(197, 'Poli Mata', 36, 209, 1000000, '2026-11-19', '13:18:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(198, 'Poli Penyakit Jiwa', 49, 210, 1000000, '2026-11-21', '08:37:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(199, 'Poli Paru (Eksekutif)', 62, 211, 1000000, '2026-11-25', '11:17:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(200, 'Poli Anak (Eksekutif)', 53, 212, 1000000, '2026-11-21', '09:10:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(201, 'Poli Periodonti', 65, 213, 1000000, '2026-11-10', '08:59:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(202, 'Poli Penyakit Dalam (Sore)', 65, 214, 1000000, '2026-11-09', '18:37:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(203, 'GCU : Surat Sehat Jasmani + Rohani', 17, 215, 1000000, '2026-11-13', '13:30:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(204, 'Poli Jantung', 19, 216, 1000000, '2026-11-30', '11:17:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(205, 'Poli THT', 45, 217, 1000000, '2026-11-25', '08:38:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(206, 'Poli Mata', 56, 218, 1000000, '2026-11-24', '11:08:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(207, 'Poli Umum', 33, 219, 1000000, '2026-12-01', '09:32:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(208, 'Poli Umum Tes Kesehatan P3K', 17, 220, 1000000, '2026-11-19', '12:55:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(209, 'Poli Anak (Sore)', 13, 221, 1000000, '2026-11-17', '17:56:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(210, 'Poli Kandungan (Eksekutif)', 39, 222, 1000000, '2026-11-11', '10:42:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(211, 'Poli Anak', 20, 223, 1000000, '2026-11-09', '12:04:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(212, 'Poli Anak Sub. Kardiologi', 20, 224, 1000000, '2026-11-25', '10:07:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(213, 'Poli Saraf', 11, 225, 1000000, '2026-11-12', '08:35:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(214, 'Poli Kandungan (Eksekutif)', 18, 226, 1000000, '2026-11-17', '10:29:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(215, 'Poli Umum Tes Kesehatan P3K', 60, 227, 1000000, '2026-11-06', '08:35:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(216, 'Poli Urologi', 51, 228, 1000000, '2026-11-09', '11:25:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(217, 'Poli Anak', 32, 229, 1000000, '2026-11-23', '08:43:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(218, 'Poli Penyakit Dalam', 56, 230, 1000000, '2026-11-12', '09:07:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(219, 'Poli Rehabilitasi Medik', 61, 231, 1000000, '2026-11-04', '11:30:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(220, 'Poli VCT', 33, 232, 1000000, '2026-11-26', '11:32:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(221, 'Poli Penyakit Dalam (Sore)', 13, 233, 1000000, '2026-11-04', '18:10:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(222, 'Poli Periodonti', 63, 234, 1000000, '2026-11-25', '10:02:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(223, 'P. VK (Rajal)', 39, 235, 1000000, '2026-11-05', '08:33:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(224, 'Poli Umum Tes Kesehatan P3K', 17, 236, 1000000, '2026-11-09', '11:10:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(225, 'Poli Anak (Sore)', 13, 237, 1000000, '2026-11-10', '19:02:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(226, 'Tes Dewan', 17, 238, 1000000, '2026-11-16', '09:40:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(227, 'Poli Penyakit Dalam (Sore)', 65, 239, 1000000, '2026-11-04', '18:00:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(228, 'RADIOLOGI', 46, 240, 1000000, '2026-11-16', '19:17:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(229, 'Poli Umum', 60, 241, 1000000, '2026-11-03', '12:25:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(230, 'GCU : Surat Sehat Jasmani + Rohani', 17, 242, 1000000, '2026-11-13', '12:18:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(231, 'Poli Mata', 36, 243, 1000000, '2026-11-06', '09:03:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(232, 'Poli Penyakit Dalam (Sore)', 13, 244, 1000000, '2026-12-02', '19:08:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(233, 'Poli Umum', 21, 245, 1000000, '2026-11-06', '09:53:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(234, 'PCR (LAB)', 59, 246, 1000000, '2026-11-06', '17:52:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(235, 'Poli Rehabilitasi Medik', 61, 247, 1000000, '2026-12-02', '10:20:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(236, 'Poli Urologi', 51, 248, 1000000, '2026-11-26', '09:55:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(237, 'Poli Penyakit Dalam', 24, 249, 1000000, '2026-11-16', '10:07:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(238, 'Poli Penyakit Dalam (Eksekutif)', 44, 250, 1000000, '2026-11-04', '09:55:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(239, 'Tes Dewan', 33, 251, 1000000, '2026-12-01', '08:59:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(240, 'Poli Bedah (Eksekutif)', 48, 252, 1000000, '2026-11-02', '09:15:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(241, 'Tes Dewan', 33, 253, 1000000, '2026-12-01', '08:08:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(242, 'Poli Rehabilitasi Medik', 24, 254, 1000000, '2026-11-03', '09:43:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(243, 'Poli Orthopaedi & Traumatologi', 24, 255, 1000000, '2026-11-09', '09:40:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(244, 'Tes Dewan', 45, 256, 1000000, '2026-11-04', '08:14:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(245, 'Poli Anak Sub. Kardiologi', 31, 257, 1000000, '2026-11-17', '10:49:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(246, 'Poli Jantung', 16, 258, 1000000, '2026-11-10', '08:37:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(247, 'Poli Penyakit Jiwa', 49, 259, 1000000, '2026-11-11', '10:46:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(248, 'Poli Anak', 20, 260, 1000000, '2026-11-09', '13:03:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(249, 'Poli Mata', 56, 261, 1000000, '2026-11-19', '10:38:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(250, 'Poli Periodonti', 65, 262, 1000000, '2026-11-03', '08:54:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(251, 'PCR (LAB)', 59, 263, 1000000, '2026-11-27', '08:53:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(252, 'Poli Paru', 15, 264, 1000000, '2026-11-09', '10:37:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(253, 'Poli Penyakit Dalam (Sore)', 65, 265, 1000000, '2026-11-30', '16:44:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(254, 'Poli Gigi & Mulut', 36, 266, 1000000, '2026-12-02', '11:25:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(255, 'Poli Penyakit Dalam (Eksekutif)', 13, 267, 1000000, '2026-11-10', '10:28:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(256, 'Poli Dalam Sub. Gastroenterohepatologi', 47, 268, 1000000, '2026-11-24', '08:04:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(257, 'Poli Kulit & Kelamin', 49, 269, 1000000, '2026-11-16', '10:29:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(258, 'Poli Umum', 45, 270, 1000000, '2026-11-27', '08:47:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(259, 'Poli Saraf', 10, 271, 1000000, '2026-11-25', '08:49:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(260, 'GCU : Surat Sehat Jasmani + Rohani', 60, 272, 1000000, '2026-11-03', '08:55:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(261, 'Poli Kulit & Kelamin', 51, 273, 1000000, '2026-11-20', '12:41:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(262, 'Tes Dewan', 60, 274, 1000000, '2026-11-18', '08:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(263, 'Poli Penyakit Dalam (Eksekutif)', 13, 275, 1000000, '2026-11-17', '10:07:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(264, 'Uji Kesehatan PNS (Paket)', 42, 276, 1000000, '2026-11-16', '10:59:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(265, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 19, 277, 1000000, '2026-11-27', '14:37:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(266, 'Poli Kulit & Kelamin', 55, 278, 1000000, '2026-11-19', '13:03:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(267, 'Uji Kesehatan PNS (Paket)', 23, 279, 1000000, '2026-11-27', '10:56:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(268, 'Poli Bedah', 44, 280, 1000000, '2026-11-27', '09:19:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(269, 'Poli Orthopaedi & Traumatologi', 24, 281, 1000000, '2026-11-13', '08:47:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(270, 'Poli Urologi', 50, 282, 1000000, '2026-11-19', '11:34:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(271, 'Tes P3K Tanpa Surat Sehat', 11, 283, 1000000, '2026-11-16', '11:30:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(272, 'Uji Kesehatan PNS (Paket)', 23, 284, 1000000, '2026-11-23', '11:27:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(273, 'Poli Saraf', 10, 285, 1000000, '2026-11-10', '12:19:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(274, 'Poli Jantung (Eksekutif)', 52, 286, 1000000, '2026-11-30', '09:58:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(275, 'Poli Paru (Eksekutif)', 62, 287, 1000000, '2026-11-09', '09:53:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(276, 'Uji Kesehatan PNS (Paket)', 33, 288, 1000000, '2026-11-17', '09:09:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(277, 'Poli VCT', 33, 289, 1000000, '2026-11-03', '11:04:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(278, 'Poli Jantung', 35, 290, 1000000, '2026-11-24', '08:37:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(279, 'Poli Kandungan', 53, 291, 1000000, '2026-11-25', '11:02:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(280, 'Poli Gigi & Mulut', 65, 292, 1000000, '2026-11-30', '09:53:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(281, 'Poli Kandungan', 18, 293, 1000000, '2026-11-19', '11:23:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(282, 'Poli Anak (Sore)', 22, 294, 1000000, '2026-11-18', '17:36:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(283, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 57, 295, 1000000, '2026-11-18', '13:11:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(284, 'Poli Umum', 17, 296, 1000000, '2026-11-30', '10:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(285, 'Poli Gigi & Mulut', 63, 297, 1000000, '2026-11-25', '07:43:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(286, 'Poli Umum', 15, 298, 1000000, '2026-11-21', '11:31:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(287, 'Poli Anak Sub. Kardiologi', 47, 299, 1000000, '2026-11-11', '08:19:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(288, 'Poli Bedah (Eksekutif)', 48, 300, 1000000, '2026-11-09', '10:30:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(289, 'Poli Jantung', 48, 301, 1000000, '2026-11-04', '11:12:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(290, 'Poli Penyakit Mulut', 65, 302, 1000000, '2026-11-19', '10:02:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(291, 'Poli Paru (Eksekutif)', 62, 303, 1000000, '2026-11-06', '09:20:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(292, 'P. VK (Rajal)', 18, 304, 1000000, '2026-11-04', '11:21:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(293, 'Poli Urologi', 51, 305, 1000000, '2026-11-23', '12:39:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(294, 'Poli Paru', 62, 306, 1000000, '2026-11-02', '10:44:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(295, 'Poli Urologi', 51, 307, 1000000, '2026-11-16', '13:17:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(296, 'Hemodialisa', 24, 308, 1000000, '2026-11-18', '10:52:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(297, 'Poli Gigi & Mulut', 21, 309, 1000000, '2026-11-27', '11:56:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(298, 'Poli Kandungan', 18, 310, 1000000, '2026-11-05', '09:03:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(299, 'Poli THT', 55, 311, 1000000, '2026-11-23', '08:54:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(300, 'Poli Dalam Sub. Gastroenterohepatologi', 47, 312, 1000000, '2026-11-05', '12:10:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(301, 'Poli VCT', 24, 313, 1000000, '2026-11-11', '09:10:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(302, 'Poli Anak (Sore)', 20, 314, 1000000, '2026-11-17', '16:50:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(303, 'Poli Fisioterapi', 61, 315, 1000000, '2026-11-19', '13:14:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(304, 'Poli Orthopaedi & Traumatologi', 19, 316, 1000000, '2026-11-23', '11:06:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(305, 'Poli Jantung', 35, 317, 1000000, '2026-11-17', '08:42:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(306, 'Poli Saraf (Eksekutif)', 25, 318, 1000000, '2026-12-01', '11:10:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(307, 'Poli Penyakit Dalam', 10, 319, 1000000, '2026-11-13', '12:28:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(308, 'Poli VCT', 33, 320, 1000000, '2026-11-24', '09:25:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(309, 'Poli Paru (Eksekutif)', 14, 321, 1000000, '2026-11-28', '11:25:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(310, 'Poli Penyakit Dalam (Eksekutif)', 24, 322, 1000000, '2026-11-17', '14:09:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(311, 'Poli Paru Sub. Onkologi Toraks', 37, 323, 1000000, '2026-11-26', '13:25:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(312, 'Poli Saraf', 10, 324, 1000000, '2026-11-17', '09:58:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(313, 'Poli Anak (Eksekutif)', 26, 325, 1000000, '2026-11-19', '14:00:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(314, 'Poli Jantung', 16, 326, 1000000, '2026-11-10', '08:42:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(315, 'Uji Kesehatan PNS (Paket)', 45, 327, 1000000, '2026-11-27', '12:49:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(316, 'Matahari', 56, 328, 1000000, '2026-11-04', '10:52:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(317, 'Poli Anak', 18, 329, 1000000, '2026-11-12', '09:33:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(318, 'Poli Urologi', 51, 330, 1000000, '2026-11-02', '11:54:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(319, 'Tes P3K Tanpa Surat Sehat', 11, 331, 1000000, '2026-11-05', '10:10:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(320, 'Poli Penyakit Dalam', 56, 332, 1000000, '2026-11-26', '11:32:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(321, 'Poli Umum Tes Kesehatan P3K', 45, 333, 1000000, '2026-11-27', '08:42:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(322, 'Poli Umum', 21, 334, 1000000, '2026-11-23', '10:14:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(323, 'Poli VCT', 24, 335, 1000000, '2026-11-06', '11:31:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(324, 'Poli Kandungan (Eksekutif)', 12, 336, 1000000, '2026-11-23', '09:28:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(325, 'Poli Umum', 58, 337, 1000000, '2026-11-19', '11:35:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(326, 'Tes Dewan', 45, 338, 1000000, '2026-11-14', '08:44:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(327, 'Poli Saraf', 30, 339, 1000000, '2026-11-09', '11:42:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(328, 'Poli Kulit & Kelamin (Eksekutif)', 49, 340, 1000000, '2026-11-14', '14:00:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(329, 'Uji Kesehatan PNS (Paket)', 41, 341, 1000000, '2026-11-19', '08:27:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(330, 'Poli Anak (Eksekutif)', 12, 342, 1000000, '2026-11-27', '11:39:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(331, 'Uji Kesehatan PNS (Paket)', 28, 343, 1000000, '2026-11-12', '12:44:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(332, 'Poli Kandungan', 39, 344, 1000000, '2026-11-09', '10:15:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(333, 'Poli Umum', 33, 345, 1000000, '2026-11-20', '10:52:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(334, 'Poli VCT', 24, 346, 1000000, '2026-11-09', '10:49:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(335, 'Poli Penyakit Dalam', 37, 347, 1000000, '2026-11-16', '11:03:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(336, 'Uji Kesehatan PNS (Paket)', 40, 348, 1000000, '2026-11-10', '13:06:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(337, 'Poli Penyakit Jiwa', 49, 349, 1000000, '2026-11-18', '08:41:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(338, 'Poli Jantung', 51, 350, 1000000, '2026-11-23', '10:41:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(339, 'Poli Gigi & Mulut', 65, 351, 1000000, '2026-11-05', '08:44:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(340, 'GCU : Surat Sehat Jasmani + Rohani', 33, 352, 1000000, '2026-11-14', '09:25:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(341, 'Poli Jantung', 44, 353, 1000000, '2026-11-03', '10:44:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(342, 'Poli Penyakit Dalam', 30, 354, 1000000, '2026-11-12', '11:25:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(343, 'Poli Saraf', 25, 355, 1000000, '2026-11-09', '09:39:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(344, 'Poli Penyakit Dalam', 13, 356, 1000000, '2026-11-07', '08:01:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(345, 'Poli Saraf (Eksekutif)', 25, 357, 1000000, '2026-11-10', '13:31:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(346, 'Uji Kesehatan PNS (Paket)', 34, 358, 1000000, '2026-11-06', '09:46:00', '2026-11-20 08:00:00', 0, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(347, 'Poli Penyakit Dalam', 13, 359, 1000000, '2026-11-10', '07:55:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(348, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 19, 360, 1000000, '2026-11-09', '12:42:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(349, 'Poli Urologi', 50, 361, 1000000, '2026-11-21', '12:50:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(350, 'Poli Jantung (Eksekutif)', 52, 362, 1000000, '2026-11-11', '10:32:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(351, 'Poli Penyakit Dalam', 56, 363, 1000000, '2026-11-09', '08:41:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(352, 'Poli Penyakit Dalam', 37, 364, 1000000, '2026-11-23', '09:15:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL),
(353, 'Poli Jantung', 52, 365, 1000000, '2026-11-24', '12:18:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(354, 'P. VK (Rajal)', 39, 366, 1000000, '2026-11-03', '11:19:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(355, 'Poli Umum', 45, 367, 1000000, '2026-11-25', '12:37:00', '2026-11-20 08:00:00', 1, 1, NULL, 'Pending', NULL, NULL, NULL, NULL),
(356, 'Poli Paru Sub. Onkologi Toraks', 37, 368, 1000000, '2026-11-18', '11:34:00', '2026-11-20 08:00:00', 1, 0, NULL, 'Pending', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `actor_type` varchar(30) NOT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(80) NOT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `entity_type`, `entity_id`, `details`, `ip_address`, `created_at`) VALUES
(1, 'doctor', 1, 'appointment_status_changed', 'appointment', 1, 'Status changed to Completed', '::1', '2026-06-15 22:06:25'),
(2, 'doctor', 1, 'prescription_saved', 'appointment', 1, 'Prescription saved for John Doe', '::1', '2026-06-15 22:06:25'),
(3, 'doctor', 1, 'appointment_status_changed', 'appointment', 1, 'Status changed to Completed', '::1', '2026-06-15 22:06:51'),
(4, 'doctor', 1, 'appointment_status_changed', 'appointment', 1, 'Status changed to Completed', '::1', '2026-06-15 22:07:28'),
(5, 'doctor', 1, 'prescription_saved', 'appointment', 1, 'Prescription saved for John Doe', '::1', '2026-06-15 22:07:28'),
(6, 'doctor', 1, 'availability_created', 'doctor_availability', 1, 'Created availability slot.', '::1', '2026-06-15 22:09:38'),
(7, 'admin', 1, 'appointment_status_changed', 'appointment', 3, 'Status changed to Approved', '', '2026-06-15 22:14:59'),
(8, 'doctor', 1, 'appointment_status_changed', 'appointment', 3, 'Status changed to Completed', '', '2026-06-15 22:14:59'),
(9, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-15 22:20:47'),
(10, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-15 22:26:23'),
(11, 'admin', 1, 'appointment_status_changed', 'appointment', 2, 'Status changed to Cancelled', '::1', '2026-06-15 22:30:32'),
(12, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-16 07:34:07'),
(13, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-16 21:04:12'),
(14, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-18 12:38:02'),
(15, 'admin', 1, 'doctor_created', 'doctors', 8, 'Doctor created: Pankaj Sharma', '::1', '2026-06-18 12:40:41'),
(16, 'admin', 1, 'availability_created', 'doctor_availability', 3, 'Created doctor availability slot.', '::1', '2026-06-18 12:42:32'),
(17, 'patient', 3, 'appointment_created', 'appointment', 4, 'Booked with Dr. Pankaj Sharma', '::1', '2026-06-18 12:43:11'),
(18, 'doctor', 8, 'appointment_status_changed', 'appointment', 4, 'Status changed to Approved', '::1', '2026-06-18 12:51:27'),
(19, 'doctor', 8, 'appointment_status_changed', 'appointment', 4, 'Status changed to Completed', '::1', '2026-06-18 13:02:15'),
(20, 'doctor', 8, 'prescription_saved', 'appointment', 4, 'Prescription saved for John Karie', '::1', '2026-06-18 13:02:15'),
(21, 'doctor', 8, 'patient_created', 'tblpatient', 3, 'Patient created: Seema Nair', '::1', '2026-06-18 13:04:16'),
(22, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-18 13:15:44'),
(23, 'admin', 1, 'medical_history_added', 'tblpatient', 3, 'Admin added medical history.', '::1', '2026-06-18 13:31:20'),
(24, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-21 21:41:12'),
(25, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '::1', '2026-06-21 21:42:42'),
(26, 'admin', 1, 'doctor_created', 'doctors', 9, 'Doctor created: Garima Singh', '::1', '2026-06-21 21:44:46'),
(27, 'doctor', 9, 'availability_created', 'doctor_availability', 4, 'Created availability slot.', '::1', '2026-06-21 21:45:41'),
(28, 'patient', 4, 'appointment_created', 'appointment', 5, 'Booked with Dr. Garima Singh', '::1', '2026-06-21 21:47:00'),
(29, 'doctor', 9, 'appointment_status_changed', 'appointment', 5, 'Status changed to Completed', '::1', '2026-06-21 21:47:19'),
(30, 'doctor', 9, 'appointment_status_changed', 'appointment', 5, 'Status changed to Completed', '::1', '2026-06-21 21:47:50'),
(31, 'doctor', 9, 'prescription_saved', 'appointment', 5, 'Prescription saved for Amit', '::1', '2026-06-21 21:47:50'),
(32, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-26 15:54:03'),
(33, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-26 16:28:36'),
(34, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-26 16:33:29'),
(35, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 06:48:02'),
(36, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 06:48:12'),
(37, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 06:48:42'),
(38, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 07:10:01'),
(39, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 07:50:05'),
(40, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 08:09:07'),
(41, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 08:20:38'),
(42, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 09:58:36'),
(43, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 10:02:00'),
(44, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 10:12:05'),
(45, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 10:14:03'),
(46, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 10:23:06'),
(47, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 10:42:58'),
(48, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 11:24:25'),
(49, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 11:31:26'),
(50, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 11:48:49'),
(51, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 12:06:12'),
(52, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 12:09:16'),
(53, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 12:13:13'),
(54, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 12:26:53'),
(55, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 12:27:58'),
(56, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 12:35:29'),
(57, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 13:00:10'),
(58, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 13:04:13'),
(59, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 19:54:50'),
(60, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 20:05:09'),
(61, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-09-27 20:50:30'),
(62, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-10-21 22:12:31'),
(63, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-10-21 22:40:09'),
(64, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-10-22 05:15:38'),
(65, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-10-22 13:36:52'),
(66, 'admin', 1, 'availability_created', 'doctor_availability', 5, 'Created doctor availability slot.', '127.0.0.1', '2026-10-22 14:27:14'),
(67, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-10-22 19:32:40'),
(68, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-10-22 20:31:11'),
(69, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-10 10:12:31'),
(70, 'doctor', 1, 'patient_updated', 'tblpatient', 2, 'Patient updated: Amit', '127.0.0.1', '2026-11-12 14:59:46'),
(71, 'doctor', 1, 'appointment_status_changed', 'appointment', 3, 'Status changed to Completed', '127.0.0.1', '2026-11-12 15:00:02'),
(72, 'doctor', 1, 'appointment_status_changed', 'appointment', 1, 'Status changed to Completed', '127.0.0.1', '2026-11-12 15:00:05'),
(73, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-13 08:55:45'),
(74, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-13 09:47:15'),
(75, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-13 11:37:44'),
(76, 'admin', 1, 'doctor_created', 'doctors', 10, 'Doctor created: dr. A. Dedi Rusmanto, Sp.PD.', '127.0.0.1', '2026-11-13 13:42:15'),
(77, 'admin', 1, 'doctor_created', 'doctors', 11, 'Doctor created: dr. Yekti Nurhaeni, Sp.KJ', '127.0.0.1', '2026-11-13 13:44:01'),
(78, 'admin', 1, 'doctor_created', 'doctors', 12, 'Doctor created: dr. Riza Maulina, Sp.A', '127.0.0.1', '2026-11-13 13:47:11'),
(79, 'admin', 1, 'doctor_created', 'doctors', 13, 'Doctor created: dr. Dwi Retno Puji Rahayu, Sp.PD', '127.0.0.1', '2026-11-13 13:48:42'),
(80, 'admin', 1, 'doctor_created', 'doctors', 14, 'Doctor created: dr. Joko Susilo, Sp.P', '127.0.0.1', '2026-11-13 13:50:51'),
(81, 'admin', 1, 'doctor_created', 'doctors', 15, 'Doctor created: dr. Rosari Listiana, Sp.S', '127.0.0.1', '2026-11-13 13:52:18'),
(82, 'admin', 1, 'doctor_created', 'doctors', 16, 'Doctor created: dr. Anna Budiarti, Sp.JP(K)', '127.0.0.1', '2026-11-13 14:08:44'),
(83, 'admin', 1, 'doctor_created', 'doctors', 17, 'Doctor created: dr. Suryawan Widodo', '127.0.0.1', '2026-11-13 14:10:13'),
(84, 'admin', 1, 'doctor_created', 'doctors', 18, 'Doctor created: dr. Meirosa Sibuea, Sp.OG.', '127.0.0.1', '2026-11-13 14:18:32'),
(85, 'admin', 1, 'doctor_created', 'doctors', 19, 'Doctor created: dr. Rachmat Saleh Raharjo, Sp.OT', '127.0.0.1', '2026-11-13 14:20:25'),
(86, 'admin', 1, 'doctor_created', 'doctors', 20, 'Doctor created: dr. Indana Lazulfa, Sp. A,M.Ked.Klin', '127.0.0.1', '2026-11-13 14:22:13'),
(87, 'admin', 1, 'doctor_created', 'doctors', 21, 'Doctor created: drg. Mohammad Qirom', '127.0.0.1', '2026-11-13 14:28:24'),
(88, 'admin', 1, 'doctor_updated', 'doctors', 8, 'Doctor updated: Pankaj Sharma', '127.0.0.1', '2026-11-13 14:28:52'),
(89, 'admin', 1, 'doctor_updated', 'doctors', 7, 'Doctor updated: Bhavya rathore', '127.0.0.1', '2026-11-13 14:29:10'),
(90, 'admin', 1, 'doctor_updated', 'doctors', 8, 'Doctor updated: dr.Pankaj Sharma', '127.0.0.1', '2026-11-13 14:29:54'),
(91, 'admin', 1, 'doctor_updated', 'doctors', 9, 'Doctor updated: dr. Garima', '127.0.0.1', '2026-11-13 14:30:10'),
(92, 'admin', 1, 'doctor_updated', 'doctors', 7, 'Doctor updated: dr.Bhavya rathore', '127.0.0.1', '2026-11-13 14:30:24'),
(93, 'admin', 1, 'doctor_updated', 'doctors', 6, 'Doctor updated: dr Romil', '127.0.0.1', '2026-11-13 14:30:41'),
(94, 'admin', 1, 'doctor_updated', 'doctors', 5, 'Doctor updated: dr Vipin Tayagi', '127.0.0.1', '2026-11-13 14:30:56'),
(95, 'admin', 1, 'doctor_updated', 'doctors', 4, 'Doctor updated: dr.Patrisia', '127.0.0.1', '2026-11-13 14:31:11'),
(96, 'admin', 1, 'doctor_updated', 'doctors', 2, 'Doctor updated: dr.Charu Dua', '127.0.0.1', '2026-11-13 14:31:24'),
(97, 'admin', 1, 'doctor_updated', 'doctors', 1, 'Doctor updated: rr.Selonan Sp.PD', '127.0.0.1', '2026-11-13 14:31:58'),
(98, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-13 15:58:17'),
(99, 'admin', 1, 'doctor_updated', 'doctors', 1, 'Doctor updated: dr.Selonan Sp.PD', '127.0.0.1', '2026-11-13 15:58:44'),
(100, 'doctor', 1, 'availability_created', 'doctor_availability', 1, 'Created availability slot.', '127.0.0.1', '2026-11-13 16:02:52'),
(101, 'doctor', 1, 'availability_created', 'doctor_availability', 2, 'Created availability slot.', '127.0.0.1', '2026-11-13 16:03:44'),
(102, 'doctor', 1, 'availability_created', 'doctor_availability', 3, 'Created availability slot.', '127.0.0.1', '2026-11-13 16:05:01'),
(103, 'admin', 1, 'doctor_updated', 'doctors', 1, 'Doctor updated: dr.Selonan Sp.PD', '127.0.0.1', '2026-11-13 17:27:48'),
(104, 'admin', 1, 'doctor_updated', 'doctors', 1, 'Doctor updated: dr.Selonan Sp.PD', '127.0.0.1', '2026-11-13 19:48:48'),
(105, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-14 09:12:12'),
(106, 'admin', 1, 'doctor_updated', 'doctors', 15, 'Doctor updated: dr. Rosari Listiana, Sp.S', '127.0.0.1', '2026-11-14 09:29:20'),
(107, 'admin', 1, 'doctor_updated', 'doctors', 14, 'Doctor updated: dr. Joko Susilo, Sp.P', '127.0.0.1', '2026-11-14 09:30:12'),
(108, 'doctor', 21, 'availability_created', 'doctor_availability', 22, 'Created availability slot.', '127.0.0.1', '2026-11-14 09:33:36'),
(109, 'doctor', 13, 'availability_created', 'doctor_availability', 23, 'Created availability slot.', '127.0.0.1', '2026-11-14 09:35:43'),
(110, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-14 11:36:31'),
(111, 'admin', 1, 'doctor_updated', 'doctors', 1, 'Doctor updated: dr.Selonan Sp.PD', '127.0.0.1', '2026-11-14 12:19:50'),
(112, 'patient', 5, 'appointment_created', 'appointment', 6, 'Booked with Dr. drg. Mohammad Qirom', '127.0.0.1', '2026-11-14 16:32:46'),
(113, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-15 07:44:40'),
(114, 'doctor', 21, 'appointment_status_changed', 'appointment', 6, 'Status changed to Approved', '127.0.0.1', '2026-11-15 07:47:25'),
(115, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-15 09:52:56'),
(116, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-15 10:26:22'),
(117, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-17 06:37:13'),
(118, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-17 07:33:16'),
(119, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-17 07:41:13'),
(120, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-18 08:30:24'),
(121, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-18 09:02:51'),
(122, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-18 10:07:06'),
(123, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-18 10:49:19'),
(124, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-18 11:12:06'),
(125, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-20 10:06:22'),
(126, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-26 11:40:40'),
(127, 'admin', 1, 'admin_login', 'admin', 1, 'Admin logged in.', '127.0.0.1', '2026-11-26 15:26:19');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `specilization` varchar(255) DEFAULT NULL,
  `doctorName` varchar(255) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `docFees` varchar(255) DEFAULT NULL,
  `contactno` bigint(11) DEFAULT NULL,
  `docEmail` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `creationDate` timestamp NULL DEFAULT current_timestamp(),
  `updationDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `specilization`, `doctorName`, `address`, `docFees`, `contactno`, `docEmail`, `password`, `creationDate`, `updationDate`) VALUES
(1, 'Poli Bedah', 'dr.Selonan Sp.PD', 'Jl. Raya Kopo No.161, Situsaeur, Kec. Bojongloa Kidul, Kota Bandung, Jawa Barat 40233.', '3000000', 142536250, 'anujk123@test.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2024-04-10 18:16:52', '2026-11-26 04:38:34'),
(2, 'Endocrinologists', 'dr.Charu Dua', 'ABC Apartment Laxmi Nagar Baru Delhi', '800', 1231231230, 'charudua12@test.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2024-04-11 01:06:41', '2026-11-26 04:38:44'),
(4, 'Pediatrics', 'dr.Patrisia', 'Jl. Perjuangan No.Kav. 8, Kebon Jeruk, Kec. Kb. Jeruk, Kota Jakarta Barat.', '700', 74561235, 'p12@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2024-05-16 09:12:23', '2026-11-26 04:38:56'),
(5, 'Orthopedics', 'dr Vipin Tayagi', 'Yasho Hospital Baru Delhi', '1200', 95214563210, 'vpint123@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2024-05-16 09:13:11', '2026-11-26 04:39:13'),
(6, 'Internal Medicine', 'dr Romil', 'Max Hospital Vaishali  GZB', '1500', 8563214751, 'drromil12@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2024-05-16 09:14:11', '2026-11-26 04:39:47'),
(7, 'Obstetrics and Gynecology', 'dr.Bhavya rathore', 'Shop 12 Indira Puram Ghaziabad', '800', 745621330, 'bhawya12@tt.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2024-05-16 09:15:18', '2026-11-26 04:39:47'),
(8, 'Dental Care', 'dr.Pankaj Sharma', 'P-907, Navi Market\r\nKanpur Uttar Pradeah', '800', 2255647899, 'pankaj@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-06-18 07:10:41', '2026-11-26 04:39:47'),
(9, 'Dental Care', 'dr. Garima', 'Berlin German', '500', 5264123032, 'ga12@test.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-06-21 16:14:46', '2026-11-26 04:39:47'),
(10, 'Poli Penyakit Dalam (Eksekutif)', 'dr. A. Dedi Rusmanto, Sp.PD.', 'Klinik Imanuel Serua Depok', '1000000', 628562177324, 'adedi@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 06:42:15', '2026-11-26 04:39:47'),
(11, 'Poli Saraf', 'dr. Yekti Nurhaeni, Sp.KJ', 'Imanuek Depok', '1000000', 6285677455, 'YektiNurhaeni@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 06:44:01', '2026-11-26 04:39:47'),
(12, 'Poli Anak', 'dr. Riza Maulina, Sp.A', 'RS Bromeus Dago Bandung', '1000000', 62085677456, 'RizaMaulina@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 06:47:11', '2026-11-26 04:39:47'),
(13, 'Poli Penyakit Dalam (Eksekutif)', 'dr. Dwi Retno Puji Rahayu, Sp.PD', 'RS AL-IHSAN Bale Endah Bandung', '1000000', 62867877888, 'DwiRetno@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 06:48:42', '2026-11-26 04:39:47'),
(14, 'Poli Jantung (Eksekutif)', 'dr. Joko Susilo, Sp.P', 'RS Imanuel Bandung', '1000.000', 62882787656, 'JokoSusilo@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 06:50:51', '2026-11-26 04:39:47'),
(15, 'Poli Saraf', 'dr. Rosari Listiana, Sp.S', 'RS Siloan Jakarta', '2000000', 628857876777, 'RosariListiana@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 06:52:18', '2026-11-26 04:39:47'),
(16, 'Poli Jantung (Eksekutif)', 'dr. Anna Budiarti, Sp.JP(K)', 'RS SILOAN JAKARTA', '2000000', 62885657767, 'AnnaBudiarti@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 07:08:44', '2026-11-26 04:39:47'),
(17, 'Poli Medical Check Up (MCU) / Umum', 'dr. Suryawan Widodo', 'RS SILOAN JAKARTA', '0', 63885787999, 'SuryawanWidodo@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 07:10:13', '2026-11-26 04:39:47'),
(18, 'Poli Kebidanan / Kamar Bersalin (VK Rajal)', 'dr. Meirosa Sibuea, Sp.OG.', 'RS SILOAN JAKARTA', '1000000', 62888598764, 'MeirosaSibuea@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 07:18:32', '2026-11-26 04:39:47'),
(19, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 'dr. Rachmat Saleh Raharjo, Sp.OT', 'RS SILOAN JAKARTA', '2000000', 88587877667, 'RachmatSaleh@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 07:20:25', '2026-11-26 04:39:47'),
(20, 'Poli Anak Sub. Kardiologi', 'dr. Indana Lazulfa, Sp. A,M.Ked.Klin', 'RS SILOAN JAKARTA', '100000', 88543447777, 'IndanaLazulfa@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 07:22:13', '2026-11-26 04:39:47'),
(21, 'Poli Umum', 'drg. Mohammad Qirom', '-', '1000000', 62885788999, 'MohammadQirom@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-13 07:28:24', '2026-11-26 04:39:47'),
(22, 'Poli Penyakit Dalam (Sore)', 'Dr. Ayyesha Yuanita, Sp.PD', 'RS Siloan Jakarta', '1000000', 628120000022, 'drayyeshayuanitasppd@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(23, 'Uji Kesehatan PNS (Paket)', 'dr. ANGGI KUMALAROSITA', 'RS Siloan Jakarta', '1000000', 628120000023, 'dranggikumalarosita@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(24, 'Poli Penyakit Dalam (Eksekutif)', 'dr. Agus Dahana, Sp.PD., FINASIM', 'RS Siloan Jakarta', '1000000', 628120000024, 'dragusdahanasppdfina@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(25, 'Poli Saraf', 'dr. Antonius Gatot Subroto, Sp.S', 'RS Siloan Jakarta', '1000000', 628120000025, 'drantoniusgatotsubro@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(26, 'Poli Anak', 'dr. Dana Sumanti, Sp.A', 'RS Siloan Jakarta', '1000000', 628120000026, 'drdanasumantispa@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(27, 'Uji Kesehatan PNS (Paket)', 'dr. Deta Anggrea Awan Rengga', 'RS Siloan Jakarta', '1000000', 628120000027, 'drdetaanggreaawanren@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(28, 'Uji Kesehatan PNS (Paket)', 'dr. Dian Junianto Ramadhani Wakiran', 'RS Siloan Jakarta', '1000000', 628120000028, 'drdianjuniantoramadh@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(29, 'Uji Kesehatan PNS (Paket)', 'dr. Dimas Rendhyka Dewandaru', 'RS Siloan Jakarta', '1000000', 628120000029, 'drdimasrendhykadewan@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(30, 'Poli Penyakit Dalam', 'dr. Dwita Sukmala Ratih, Sp. N', 'RS Siloan Jakarta', '1000000', 628120000030, 'drdwitasukmalaratihs@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(31, 'Poli Anak Sub. Kardiologi', 'dr. Emi Yulianti, Sp.A, Subsp. Kardio (K)', 'RS Siloan Jakarta', '1000000', 628120000031, 'dremiyuliantispasubs@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(32, 'Poli Anak (Eksekutif)', 'dr. Endah Setyarini, Sp. A., M.Biomed', 'RS Siloan Jakarta', '1000000', 628120000032, 'drendahsetyarinispam@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(33, 'Poli Umum Tes Kesehatan P3K', 'dr. Endri Sulistyani', 'RS Siloan Jakarta', '1000000', 628120000033, 'drendrisulistyani@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(34, 'Uji Kesehatan PNS (Paket)', 'dr. Fahri Sulistyo W', 'RS Siloan Jakarta', '1000000', 628120000034, 'drfahrisulistyow@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(35, 'Poli Bedah (Eksekutif)', 'dr. Fajar Triwibawa, Sp.B.', 'RS Siloan Jakarta', '1000000', 628120000035, 'drfajartriwibawaspb@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(36, 'Poli Gigi & Mulut', 'dr. Ferriya Sri Agustin, Sp.M', 'RS Siloan Jakarta', '1000000', 628120000036, 'drferriyasriagustins@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(37, 'Poli Penyakit Dalam', 'dr. Fitri Emizola. Sp.P, Subsp. Onk.T', 'RS Siloan Jakarta', '1000000', 628120000037, 'drfitriemizolasppsub@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(38, 'Poli THT', 'dr. Indra Setiawan, Sp. THT-KL', 'RS Siloan Jakarta', '1000000', 628120000038, 'drindrasetiawansptht@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(39, 'P. VK (Rajal)', 'dr. Indri Hapsari Raganingtyas, Sp.oG', 'RS Siloan Jakarta', '1000000', 628120000039, 'drindrihapsariragani@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(40, 'Uji Kesehatan PNS (Paket)', 'dr. Kun Imam Suharto', 'RS Siloan Jakarta', '1000000', 628120000040, 'drkunimamsuharto@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(41, 'Uji Kesehatan PNS (Paket)', 'dr. Lina Tuwuh Yuwanti', 'RS Siloan Jakarta', '1000000', 628120000041, 'drlinatuwuhyuwanti@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(42, 'Uji Kesehatan PNS (Paket)', 'dr. Maretha Laksmi Mahanani', 'RS Siloan Jakarta', '1000000', 628120000042, 'drmarethalaksmimahan@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(43, 'Poli THT', 'dr. Matheos lucky haurissa Sp. THT-KL', 'RS Siloan Jakarta', '1000000', 628120000043, 'drmatheosluckyhauris@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(44, 'Poli Bedah', 'dr. Mia Rachmi Widyaningrum, Sp.B. FINACS', 'RS Siloan Jakarta', '1000000', 628120000044, 'drmiarachmiwidyaning@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(45, 'Poli THT', 'dr. Muhammad Kartikanuddin', 'RS Siloan Jakarta', '1000000', 628120000045, 'drmuhammadkartikanud@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(46, 'RADIOLOGI', 'dr. Naely Rahma, Sp.Rad', 'RS Siloan Jakarta', '1000000', 628120000046, 'drnaelyrahmasprad@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(47, 'Poli Dalam Sub. Gastroenterohepatologi', 'dr. Nuraida Wisudani, Sp. PD-KGEH', 'RS Siloan Jakarta', '1000000', 628120000047, 'drnuraidawisudanispp@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(48, 'Poli Penyakit Dalam (Eksekutif)', 'dr. Rakhmad Fajaruddin, Sp.B.', 'RS Siloan Jakarta', '1000000', 628120000048, 'drrakhmadfajaruddins@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(49, 'Poli Kulit & Kelamin', 'dr. Ratna Ika Susanti, Sp.KK', 'RS Siloan Jakarta', '1000000', 628120000049, 'drratnaikasusantispk@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(50, 'Poli Urologi', 'dr. Reza amorga. Sp U', 'RS Siloan Jakarta', '1000000', 628120000050, 'drrezaamorgaspu@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(51, 'Poli Urologi', 'dr. Rifky Aulia, Sp.U', 'RS Siloan Jakarta', '1000000', 628120000051, 'drrifkyauliaspu@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(52, 'Poli Jantung', 'dr. Rina Mawarti, Sp.JP., FIHA', 'RS Siloan Jakarta', '1000000', 628120000052, 'drrinamawartispjpfih@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(53, 'Poli Kandungan', 'dr. Riza Firman Satria,Sp.OG', 'RS Siloan Jakarta', '1000000', 628120000053, 'drrizafirmansatriasp@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(54, 'Uji Kesehatan PNS (Paket)', 'dr. Rizki Ronita Sari', 'RS Siloan Jakarta', '1000000', 628120000054, 'drrizkironitasari@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(55, 'Poli Kulit & Kelamin', 'dr. Sabilarrusydi, Sp.THT-KL', 'RS Siloan Jakarta', '1000000', 628120000055, 'drsabilarrusydisptht@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(56, 'Poli Penyakit Dalam', 'dr. Sri Mariati, Sp.M', 'RS Siloan Jakarta', '1000000', 628120000056, 'drsrimariatispm@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(57, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 'dr. Sulung Breilyan, Sp.OT', 'RS Siloan Jakarta', '1000000', 628120000057, 'drsulungbreilyanspot@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(58, 'Poli Umum', 'dr. TITA RISKANA', 'RS Siloan Jakarta', '1000000', 628120000058, 'drtitariskana@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(59, 'PCR (LAB)', 'dr. Timotheus Elfin Widijatmoko, Sp.PK', 'RS Siloan Jakarta', '1000000', 628120000059, 'drtimotheuselfinwidi@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(60, 'Tes Dewan', 'dr. Wiji Kusbiyah', 'RS Siloan Jakarta', '1000000', 628120000060, 'drwijikusbiyah@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(61, 'Poli Rehabilitasi Medik', 'dr.. Dilia Ratna Dewi, Sp.K.F.R', 'RS Siloan Jakarta', '1000000', 628120000061, 'drdiliaratnadewispkf@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(62, 'Poli Paru (Eksekutif)', 'dr.Sari Apriliana Rahmawati, Sp.P', 'RS Siloan Jakarta', '1000000', 628120000062, 'drsariaprilianarahma@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(63, 'Poli Gigi & Mulut', 'drg. Alifiani Eprilina, Sp. Perio', 'RS Siloan Jakarta', '1000000', 628120000063, 'drgalifianieprilinas@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(64, 'Poli Gigi Anak', 'drg. Citra Saka Gama Diarum, Sp.KGA', 'RS Siloan Jakarta', '1000000', 628120000064, 'drgcitrasakagamadiar@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47'),
(65, 'Poli Periodonti', 'drg. Novitasari, Sp.PM', 'RS Siloan Jakarta', '1000000', 628120000065, 'drgnovitasarisppm@hms.local', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-20 08:00:00', '2026-11-26 04:39:47');

-- --------------------------------------------------------

--
-- Table structure for table `doctorslog`
--

CREATE TABLE `doctorslog` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `userip` binary(16) DEFAULT NULL,
  `loginTime` timestamp NULL DEFAULT current_timestamp(),
  `logout` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `doctorslog`
--

INSERT INTO `doctorslog` (`id`, `uid`, `username`, `userip`, `loginTime`, `logout`, `status`) VALUES
(1, 1, 'anujk123@test.com', 0x3a3a3100000000000000000000000000, '2024-05-16 05:19:33', NULL, 1),
(2, 1, 'anujk123@test.com', 0x3a3a3100000000000000000000000000, '2024-05-16 09:01:03', '16-05-2024 02:37:32 PM', 1),
(3, 1, 'anujk123@test.com', 0x3a3a3100000000000000000000000000, '2026-06-15 16:25:28', NULL, 1),
(4, 1, 'anujk123@test.com', 0x3a3a3100000000000000000000000000, '2026-06-15 16:31:47', NULL, 1),
(5, NULL, 'anuj@gmail.com', 0x3a3a3100000000000000000000000000, '2026-06-18 07:04:53', NULL, 0),
(6, 8, 'pankaj@gmail.com', 0x3a3a3100000000000000000000000000, '2026-06-18 07:16:50', '18-06-2026 01:09:38 PM', 1),
(7, 9, 'ga12@test.com', 0x3a3a3100000000000000000000000000, '2026-06-21 16:14:57', '21-06-2026 09:49:45 PM', 1),
(8, NULL, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-09-27 13:51:36', NULL, 0),
(9, 1, 'selonan123@test.com', 0x3132372e302e302e3100000000000000, '2026-09-27 13:54:24', NULL, 1),
(10, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:17:57', NULL, 0),
(11, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:21:14', NULL, 0),
(12, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:39:04', NULL, 0),
(13, 1, 'selonan123@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:46:40', NULL, 1),
(14, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-12 07:09:38', NULL, 0),
(15, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-12 07:57:41', NULL, 0),
(16, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-12 07:58:56', NULL, 1),
(17, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 08:59:11', NULL, 1),
(18, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 12:50:08', NULL, 1),
(19, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 02:32:30', NULL, 1),
(20, 13, 'DwiRetno@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 02:34:55', NULL, 1),
(21, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 02:54:26', NULL, 1),
(22, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 02:57:11', NULL, 1),
(23, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 02:59:13', NULL, 1),
(24, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-14 04:22:12', NULL, 1),
(25, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-14 04:23:58', NULL, 1),
(26, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-14 04:38:13', NULL, 1),
(27, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 05:22:23', NULL, 1),
(28, NULL, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 07:18:39', NULL, 0),
(29, NULL, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 07:19:02', NULL, 0),
(30, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 07:19:43', NULL, 1),
(31, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 07:25:44', NULL, 1),
(32, NULL, 'MohammadQirom@gmail.co', 0x3132372e302e302e3100000000000000, '2026-11-15 00:46:36', NULL, 0),
(33, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-15 00:47:03', NULL, 1),
(34, 21, 'MohammadQirom@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-15 01:27:53', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `doctorspecilization`
--

CREATE TABLE `doctorspecilization` (
  `id` int(11) NOT NULL,
  `specilization` varchar(255) DEFAULT NULL,
  `creationDate` timestamp NULL DEFAULT current_timestamp(),
  `updationDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `doctorspecilization`
--

INSERT INTO `doctorspecilization` (`id`, `specilization`, `creationDate`, `updationDate`) VALUES
(1, 'Orthopedics', '2024-04-09 18:09:46', '2024-05-14 09:26:47'),
(2, 'Internal Medicine', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(3, 'Obstetrics and Gynecology', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(4, 'Dermatology', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(5, 'Pediatrics', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(6, 'Radiology', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(7, 'General Surgery', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(8, 'Ophthalmology', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(9, 'Anesthesia', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(10, 'Pathology', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(11, 'ENT', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(12, 'Dental Care', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(13, 'Dermatologists', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(14, 'Endocrinologists', '2024-04-09 18:09:46', '2024-05-14 09:26:56'),
(15, 'Neurologists', '2024-04-09 18:09:46', '2024-05-14 09:26:56');

-- --------------------------------------------------------

--
-- Stand-in structure for view `doctor_availability`
-- (See below for the actual view)
--
CREATE TABLE `doctor_availability` (
`id` bigint(20) unsigned
,`doctor_id` int(11)
,`day_of_week` tinyint(3) unsigned
,`available_date` datetime
,`start_time` time
,`end_time` time
,`slot_duration_minutes` int(11)
,`max_appointments` int(10) unsigned
,`is_active` tinyint(1)
,`created_at` datetime
,`updated_at` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `doctor_availability_backup`
--

CREATE TABLE `doctor_availability_backup` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `day_of_week` tinyint(4) NOT NULL,
  `available_date` date DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `slot_duration_minutes` int(11) NOT NULL DEFAULT 30,
  `max_appointments` int(11) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_availability_backup`
--

INSERT INTO `doctor_availability_backup` (`id`, `doctor_id`, `day_of_week`, `available_date`, `start_time`, `end_time`, `slot_duration_minutes`, `max_appointments`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2026-06-20', '11:10:00', '14:30:00', 10, 50, 1, '2026-06-15 22:09:38', NULL),
(2, 1, 2, '2026-06-16', '09:00:00', '12:00:00', 30, 3, 1, '2026-06-15 22:14:59', NULL),
(3, 8, 0, '2026-06-20', '09:30:00', '18:30:00', 30, 10, 1, '2026-06-18 12:42:32', NULL),
(4, 9, 1, '2026-06-22', '10:30:00', '12:50:00', 25, 10, 1, '2026-06-21 21:45:41', NULL),
(5, 5, 0, '2026-10-23', '09:00:00', '12:30:00', 30, 1, 1, '2026-10-22 14:27:14', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hms_admissions`
--

CREATE TABLE `hms_admissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `visit_id` int(10) UNSIGNED DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `admission_no` varchar(40) NOT NULL,
  `bed_id` int(11) DEFAULT NULL,
  `admission_date` datetime NOT NULL DEFAULT current_timestamp(),
  `discharge_date` datetime DEFAULT NULL,
  `class_name` varchar(60) DEFAULT NULL,
  `attending_doctor_id` int(11) DEFAULT NULL,
  `status` enum('DIRAWAT','PINDAH','PULANG') NOT NULL DEFAULT 'DIRAWAT',
  `discharge_note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_audit_events`
--

CREATE TABLE `hms_audit_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `actor_role` varchar(40) DEFAULT NULL,
  `actor_name` varchar(150) DEFAULT NULL,
  `action_name` varchar(80) NOT NULL,
  `module_name` varchar(80) NOT NULL,
  `table_name` varchar(80) DEFAULT NULL,
  `record_id` bigint(20) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `old_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_data`)),
  `new_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_data`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_audit_events`
--

INSERT INTO `hms_audit_events` (`id`, `actor_id`, `actor_role`, `actor_name`, `action_name`, `module_name`, `table_name`, `record_id`, `description`, `old_data`, `new_data`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI', 'tblpatient', 4, 'Pasien baru dibuat', NULL, '{\"medical_record_no\":\"RM2026000004\",\"name\":\"Roberta Suares\",\"nik\":\"312677877660009\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-22 05:18:47'),
(2, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI', 'hms_patient_visits', 1, 'Kunjungan terdaftar', NULL, '{\"medical_record_no\":\"RM2026000004\",\"registration_no\":\"REG202610220001\",\"mr_type\":\"LAMA\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Penyakit Dalem\",\"doctor_id\":1,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"counter\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-22 05:19:31'),
(3, 0, '', '', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 5, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000005\",\"name\":\"Kapargam\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-22 13:29:28'),
(4, 0, '', '', 'CREATE', 'ANTREAN_PUBLIK', 'hms_patient_visits', 2, 'Nomor antrean rawat jalan dibuat melalui portal publik', NULL, '{\"registration_no\":\"REG202610220002\",\"queue_no\":\"P001\",\"poli\":\"Poli Penyakit Dalam\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-22 13:30:06'),
(5, 1, 'admin', 'admin', 'CREATE', 'RAWAT_JALAN', 'hms_outpatient_encounters', 1, 'Pelayanan rawat jalan dibuat', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-22 14:29:39'),
(6, 1, 'admin', 'admin', 'UPDATE', 'RAWAT_JALAN', 'hms_outpatient_encounters', 1, 'Pelayanan klinis rawat jalan diperbarui', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-22 20:32:54'),
(7, 0, '', '', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 6, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000006\",\"name\":\"Bobby JacksOn\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0', '2026-11-10 09:47:56'),
(8, 0, '', '', 'CREATE', 'ANTREAN_PUBLIK', 'hms_patient_visits', 3, 'Nomor antrean rawat jalan dibuat melalui portal publik', NULL, '{\"registration_no\":\"REG202611100001\",\"queue_no\":\"P001\",\"poli\":\"Poli Penyakit Dalam\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0', '2026-11-10 09:48:42'),
(9, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 3, 'Status antrean diubah', '{\"id\":3,\"patient_id\":6,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611100001\",\"visit_date\":\"2026-11-10\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Penyakit Dalam\",\"doctor_id\":null,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Portal Publik\",\"status\":\"MENUNGGU\",\"called_at\":null,\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-10 09:48:42\",\"arrived_at\":null,\"updated_at\":null}', '{\"status\":\"DIPANGGIL\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0', '2026-11-10 10:45:05'),
(10, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 3, 'Status antrean diubah', '{\"id\":3,\"patient_id\":6,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611100001\",\"visit_date\":\"2026-11-10\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Penyakit Dalam\",\"doctor_id\":null,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Portal Publik\",\"status\":\"DIPANGGIL\",\"called_at\":\"2026-11-10 10:45:05\",\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-10 09:48:42\",\"arrived_at\":null,\"updated_at\":\"2026-11-10 10:45:05\"}', '{\"status\":\"DILAYANI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0', '2026-11-10 10:45:33'),
(11, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 11, 'Master poli ditambahkan', NULL, '{\"code\":\"POLI-SARAF\",\"name\":\"Poli Saraf\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:33:05'),
(12, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 14, 'Master poli ditambahkan', NULL, '{\"code\":\"POLI ANAK\",\"name\":\"Poli Anak\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:34:05'),
(13, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 21, 'Master poli ditambahkan', NULL, '{\"code\":\"POPA\",\"name\":\"Poli Paru\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:38:24'),
(14, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 24, 'Master poli ditambahkan', NULL, '{\"code\":\"POJAN\",\"name\":\"Poli Jantung (Eksekutif)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:44:33'),
(15, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 27, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-MCU\",\"name\":\"Poli Medical Check Up (MCU) / Umum\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:49:32'),
(16, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 30, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-ORTH\",\"name\":\"Poli Orthopaedi & Traumatologi (Eksekutif)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:50:21'),
(17, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 33, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-KANDIO\",\"name\":\"Poli Anak Sub. Kardiologi\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 10:51:38'),
(18, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 36, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-KUKEL\",\"name\":\"Poli Kulit & Kelamin\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:01:57'),
(19, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 41, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-ANSO\",\"name\":\"Poli Anak (Sore)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:04:19'),
(20, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 44, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-KEKABER\",\"name\":\"Poli Kebidanan / Kamar Bersalin (VK Rajal)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:05:07'),
(21, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 47, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-REHME\",\"name\":\"Poli Rehabilitasi Medik\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:05:49'),
(22, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 50, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-HEDIA\",\"name\":\"Unit Hemodialisa\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:06:32'),
(23, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 53, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-UROGI\",\"name\":\"Poli Urologi\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:07:10'),
(24, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 56, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-THTKL\",\"name\":\"Poli THT-KL\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:07:30'),
(25, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 59, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-GASTOGI\",\"name\":\"Poli Gastroenterohepatologi\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:08:21'),
(26, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 65, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-TUMKEM\",\"name\":\"Poli Tumbuh Kembang Anak\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:09:23'),
(27, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 68, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-GIMU\",\"name\":\"Poli Gigi & Mulut\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:09:57'),
(28, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 71, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-PSIKIATRI\",\"name\":\"Poli Jiwa (Psikiatri)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:11:12'),
(29, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 74, 'Master poli ditambahkan', NULL, '{\"code\":\"INS_LAB\",\"name\":\"Instalasi Laboratorium\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:12:44'),
(30, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 77, 'Master poli ditambahkan', NULL, '{\"code\":\"PO_VCT\",\"name\":\"Poli VCT\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:13:04'),
(31, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 80, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-GIGIANAK\",\"name\":\"Poli Gigi Anak\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:13:37'),
(32, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 83, 'Master poli ditambahkan', NULL, '{\"code\":\"INS-PATKLI\",\"name\":\"Instalasi Laboratorium Patologi Klinik\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:15:09'),
(33, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 112, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-PENDA\",\"name\":\"Poli Penyakit Dalam\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 11:40:14'),
(34, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 124, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-PENDAEKS\",\"name\":\"Poli Penyakit Dalam (Eksekutif)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 13:39:38'),
(35, 1, 'admin', 'admin', 'CREATE', 'MASTER_POLI', 'hms_master_poli', 163, 'Master poli ditambahkan', NULL, '{\"code\":\"PO-KANKEBID\",\"name\":\"Poli Kandungan & Kebidanan (Obgyn)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 14:14:20'),
(36, 0, '', '', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 7, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000007\",\"name\":\"Ratna Anggraini\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 15:47:21'),
(37, 1, 'doctor', 'anujk123@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 8, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000008\",\"name\":\"Rizky Anggraini\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 16:07:25'),
(38, 1, 'doctor', 'anujk123@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 9, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000009\",\"name\":\"Ratna Anggraini\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 16:15:38'),
(39, 1, 'doctor', 'anujk123@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 10, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000010\",\"name\":\"Ratna Anggraini\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 16:29:52'),
(40, 1, 'doctor', 'anujk123@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 11, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000011\",\"name\":\"Ratna Anggraini\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 16:31:23'),
(41, 1, 'doctor', 'anujk123@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 12, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000012\",\"name\":\"Ratna Anggraini\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 16:47:24'),
(42, 1, 'doctor', 'anujk123@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 13, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000013\",\"name\":\"Amir\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 16:58:47'),
(43, 1, 'patient', 'johndoe12@test.com', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 14, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000014\",\"name\":\"Ratna\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 17:11:24'),
(44, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI_TERINTEGRASI', 'hms_patient_visits', 4, 'Kunjungan terdaftar melalui master poli-dokter-jadwal-kuota', NULL, '{\"registration_no\":\"REG202611130001\",\"queue_no\":\"P001\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"schedule_id\":4,\"service_date\":\"2026-11-15\",\"quota_remaining\":19}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 19:37:03'),
(45, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 4, 'Status antrean diubah', '{\"id\":4,\"patient_id\":7,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611130001\",\"visit_date\":\"2026-11-15\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"OFFLINE\",\"online_booking_token\":null,\"registration_counter\":\"\",\"status\":\"MENUNGGU\",\"called_at\":null,\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-13 19:37:03\",\"arrived_at\":null,\"updated_at\":null,\"appointment_status\":null}', '{\"status\":\"DIPANGGIL\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 19:52:07'),
(46, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 3, 'Status antrean diubah', '{\"id\":3,\"patient_id\":6,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611100001\",\"visit_date\":\"2026-11-10\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Penyakit Dalam\",\"doctor_id\":null,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Portal Publik\",\"status\":\"DILAYANI\",\"called_at\":\"2026-11-10 10:45:05\",\"served_at\":\"2026-11-10 10:45:33\",\"completed_at\":null,\"created_at\":\"2026-11-10 09:48:42\",\"arrived_at\":null,\"updated_at\":\"2026-11-10 10:45:33\",\"appointment_status\":null}', '{\"status\":\"SELESAI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 19:52:30'),
(47, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 4, 'Status antrean diubah', '{\"id\":4,\"patient_id\":7,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611130001\",\"visit_date\":\"2026-11-15\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"OFFLINE\",\"online_booking_token\":null,\"registration_counter\":\"\",\"status\":\"DIPANGGIL\",\"called_at\":\"2026-11-13 19:52:07\",\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-13 19:37:03\",\"arrived_at\":null,\"updated_at\":\"2026-11-13 19:52:07\",\"appointment_status\":null}', '{\"status\":\"DILAYANI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 19:52:49'),
(48, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 15, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000015\",\"name\":\"Eko Hidayat\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:37:50'),
(49, 1, 'admin', 'admin', 'CREATE', 'ANTREAN_PUBLIK', 'hms_patient_visits', 5, 'Antrean publik dibuat dari jadwal dokter.', NULL, '{\"registration_no\":\"REG202611140001\",\"queue_no\":\"P001\",\"poli\":\"Poli Umum\",\"doctor_id\":21,\"schedule_id\":22,\"service_date\":\"2026-11-18\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:38:12'),
(50, 1, 'admin', 'admin', 'CHECK_IN', 'ANTRIAN', 'hms_patient_visits', 5, 'Pasien check-in di lokasi.', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:39:34'),
(51, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 5, 'Status antrean diubah', '{\"id\":5,\"patient_id\":15,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611140001\",\"visit_date\":\"2026-11-18\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Umum\",\"doctor_id\":21,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Portal Publik\",\"status\":\"MENUNGGU\",\"called_at\":null,\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-14 09:38:12\",\"arrived_at\":\"2026-11-14 09:39:34\",\"updated_at\":\"2026-11-14 09:39:34\",\"appointment_status\":null}', '{\"status\":\"DIPANGGIL\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:39:54'),
(52, 1, 'admin', 'admin', 'CREATE', 'RAWAT_JALAN', 'hms_outpatient_encounters', 2, 'Pelayanan rawat jalan dibuat', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:42:06'),
(53, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 5, 'Status antrean diubah', '{\"id\":5,\"patient_id\":15,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611140001\",\"visit_date\":\"2026-11-18\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Umum\",\"doctor_id\":21,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Portal Publik\",\"status\":\"DIPANGGIL\",\"called_at\":\"2026-11-14 09:39:54\",\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-14 09:38:12\",\"arrived_at\":\"2026-11-14 09:39:34\",\"updated_at\":\"2026-11-14 09:39:54\",\"appointment_status\":null}', '{\"status\":\"DILAYANI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:55:39'),
(54, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 5, 'Status antrean diubah', '{\"id\":5,\"patient_id\":15,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611140001\",\"visit_date\":\"2026-11-18\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Umum\",\"doctor_id\":21,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Portal Publik\",\"status\":\"DILAYANI\",\"called_at\":\"2026-11-14 09:39:54\",\"served_at\":\"2026-11-14 09:55:39\",\"completed_at\":null,\"created_at\":\"2026-11-14 09:38:12\",\"arrived_at\":\"2026-11-14 09:39:34\",\"updated_at\":\"2026-11-14 09:55:39\",\"appointment_status\":null}', '{\"status\":\"SELESAI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 09:58:36'),
(55, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 16, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000016\",\"name\":\"Surya Nugroho\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:11:18'),
(56, 1, 'admin', 'admin', 'CREATE', 'ANTREAN_PUBLIK', 'hms_patient_visits', 6, 'Antrean langsung tanpa jadwal dibuat.', NULL, '{\"registration_no\":\"REG202611140002\",\"queue_no\":\"P001\",\"poli\":\"Poli Penyakit Dalam\",\"doctor_id\":1,\"service_date\":\"2026-11-14\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:12:46'),
(57, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI_PUBLIK', 'tblpatient', 17, 'Pasien baru mendaftar melalui portal publik', NULL, '{\"medical_record_no\":\"RM2026000017\",\"name\":\"Mega Pratama\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:13:18'),
(58, 1, 'admin', 'admin', 'CREATE', 'REGISTRASI_TERINTEGRASI', 'hms_patient_visits', 7, 'Kunjungan terdaftar melalui master poli-dokter-jadwal-kuota', NULL, '{\"registration_no\":\"REG202611140003\",\"queue_no\":\"P001\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"schedule_id\":6,\"service_date\":\"2026-11-16\",\"quota_remaining\":14}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:16:23'),
(59, 1, 'admin', 'admin', 'CREATE', 'RAWAT_JALAN', 'hms_outpatient_encounters', 3, 'Encounter dibuat otomatis dari antrean dokter.', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:18:57'),
(60, 1, 'admin', 'admin', 'CHECK_IN', 'ANTRIAN', 'hms_patient_visits', 1, 'Pasien check-in di lokasi.', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:23:14'),
(61, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 7, 'Status antrean diubah', '{\"id\":7,\"patient_id\":16,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611140003\",\"visit_date\":\"2026-11-16\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"OFFLINE\",\"online_booking_token\":null,\"registration_counter\":\"\",\"status\":\"MENUNGGU\",\"called_at\":null,\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-14 11:16:23\",\"arrived_at\":null,\"updated_at\":null,\"appointment_status\":null}', '{\"status\":\"DIPANGGIL\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:27:07'),
(62, 1, 'admin', 'admin', 'CREATE', 'RAWAT_JALAN', 'hms_outpatient_encounters', 4, 'Encounter dibuat otomatis dari antrean dokter.', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:38:29'),
(63, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 7, 'Status antrean diubah', '{\"id\":7,\"patient_id\":16,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611140003\",\"visit_date\":\"2026-11-16\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"OFFLINE\",\"online_booking_token\":null,\"registration_counter\":\"\",\"status\":\"DIPANGGIL\",\"called_at\":\"2026-11-14 11:27:07\",\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-14 11:16:23\",\"arrived_at\":null,\"updated_at\":\"2026-11-14 11:27:07\",\"appointment_status\":null}', '{\"status\":\"DILAYANI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 11:38:29'),
(64, 1, 'admin', 'admin', 'CREATE', 'MASTER_JADWAL', 'hms_doctor_schedules', 24, 'Jadwal dokter ditambahkan', NULL, '{\"poli_id\":390,\"doctor_id\":21,\"day\":3,\"quota\":30}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 13:42:55'),
(65, 21, 'doctor', 'MohammadQirom@gmail.com', 'CREATE', 'JADWAL_DOKTER', 'hms_doctor_schedules', 25, 'Dokter menambahkan jadwal pada Master Poli.', NULL, '{\"poli_id\":1,\"doctor_id\":21,\"day_of_week\":1,\"available_date\":\"2026-11-19\",\"start_time\":\"09:00:00\",\"end_time\":\"11:30:00\",\"quota\":20,\"slot_duration_minutes\":30}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 14:27:01'),
(66, 5, 'patient', 'SuryaNugroho@gmail.com', 'CREATE', 'APPOINTMENT_BRIDGE', 'hms_patient_visits', 8, 'Appointment terhubung ke kunjungan dan antrean.', NULL, '{\"appointment_id\":6,\"patient_id\":18,\"doctor_id\":21,\"queue_no\":\"P001\",\"visit_date\":\"2026-11-19\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-14 16:32:46'),
(67, 1, 'admin', 'admin', 'CHECK_IN', 'ANTRIAN', 'hms_patient_visits', 8, 'Pasien check-in di lokasi.', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-15 07:48:54'),
(68, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 8, 'Status antrean diubah', '{\"id\":8,\"patient_id\":18,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611140004\",\"visit_date\":\"2026-11-19\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Umum\",\"doctor_id\":21,\"appointment_id\":6,\"queue_no\":\"P001\",\"source\":\"ONLINE\",\"online_booking_token\":null,\"registration_counter\":\"Appointment Online\",\"status\":\"MENUNGGU\",\"called_at\":null,\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-14 16:32:46\",\"arrived_at\":\"2026-11-15 07:48:54\",\"updated_at\":\"2026-11-15 07:48:54\",\"appointment_status\":\"Approved\"}', '{\"status\":\"DIPANGGIL\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-15 07:48:59');

-- --------------------------------------------------------

--
-- Table structure for table `hms_beds`
--

CREATE TABLE `hms_beds` (
  `id` int(10) UNSIGNED NOT NULL,
  `room_no` varchar(30) NOT NULL,
  `bed_no` varchar(30) NOT NULL,
  `class_name` varchar(60) NOT NULL,
  `ward` varchar(100) NOT NULL,
  `daily_rate` decimal(14,2) NOT NULL DEFAULT 0.00,
  `status` enum('TERSEDIA','TERISI','DIBERSIHKAN','NONAKTIF') NOT NULL DEFAULT 'TERSEDIA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_bed_movements`
--

CREATE TABLE `hms_bed_movements` (
  `id` int(10) UNSIGNED NOT NULL,
  `admission_id` int(11) NOT NULL,
  `from_bed_id` int(11) DEFAULT NULL,
  `to_bed_id` int(11) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `moved_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_bills`
--

CREATE TABLE `hms_bills` (
  `id` int(10) UNSIGNED NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `visit_id` int(10) UNSIGNED DEFAULT NULL,
  `admission_id` int(10) UNSIGNED DEFAULT NULL,
  `invoice_no` varchar(50) NOT NULL,
  `bill_date` datetime NOT NULL DEFAULT current_timestamp(),
  `payer_type` enum('TUNAI','BPJS','ASURANSI','PERUSAHAAN') NOT NULL DEFAULT 'TUNAI',
  `payer_name` varchar(150) DEFAULT NULL,
  `subtotal` decimal(14,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total` decimal(14,2) NOT NULL DEFAULT 0.00,
  `status` enum('BELUM_LUNAS','SEBAGIAN','LUNAS','BATAL') NOT NULL DEFAULT 'BELUM_LUNAS'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_bill_items`
--

CREATE TABLE `hms_bill_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `bill_id` int(10) UNSIGNED NOT NULL,
  `service_type` varchar(80) NOT NULL,
  `description` varchar(255) NOT NULL,
  `qty` decimal(10,2) NOT NULL DEFAULT 1.00,
  `unit_price` decimal(14,2) NOT NULL DEFAULT 0.00,
  `amount` decimal(14,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_clinical_charges`
--

CREATE TABLE `hms_clinical_charges` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `visit_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `cppt_id` int(11) DEFAULT NULL,
  `igd_id` int(11) DEFAULT NULL,
  `service_id` int(10) UNSIGNED DEFAULT NULL,
  `service_type` varchar(80) NOT NULL,
  `description` varchar(255) NOT NULL,
  `qty` decimal(10,2) NOT NULL DEFAULT 1.00,
  `unit_price` decimal(14,2) NOT NULL DEFAULT 0.00,
  `amount` decimal(14,2) NOT NULL DEFAULT 0.00,
  `bill_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('POSTED','BILLED','CANCELLED') NOT NULL DEFAULT 'POSTED',
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_cppt`
--

CREATE TABLE `hms_cppt` (
  `id` int(10) UNSIGNED NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `visit_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `author_type` enum('DOKTER','PERAWAT','ADMIN','REKAM_MEDIS') NOT NULL DEFAULT 'DOKTER',
  `author_id` int(11) DEFAULT NULL,
  `note_type` enum('SOAP','CPPT','KEPERAWATAN','OBSERVASI','RESUME') NOT NULL DEFAULT 'CPPT',
  `subjective` text DEFAULT NULL,
  `objective` text DEFAULT NULL,
  `assessment` text DEFAULT NULL,
  `plan` text DEFAULT NULL,
  `diagnosis_code` varchar(20) DEFAULT NULL,
  `diagnosis_name` varchar(255) DEFAULT NULL,
  `action_text` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_cppt`
--

INSERT INTO `hms_cppt` (`id`, `patient_id`, `visit_id`, `admission_id`, `author_type`, `author_id`, `note_type`, `subjective`, `objective`, `assessment`, `plan`, `diagnosis_code`, `diagnosis_name`, `action_text`, `created_at`) VALUES
(1, 4, 1, NULL, 'ADMIN', 1, 'SOAP', 'xolitis colitis', 'Dalam Keadaan baik', 'pengobatab', 'ditindak lanjuti', 'A09', 'colitis', 'Beri Obat agar tdk menyebar kbagian lain', '2026-10-22 14:33:26'),
(2, 4, 1, NULL, 'ADMIN', 1, 'SOAP', 'riwayat kesehatan dan keluhan pasien', 'Pengukuran tekanan darah, suhu tubuh, denyut nadi, dan frekuensi pernapasan', 'mengevaluasi kondisi klinis, kebutuhan medis, keperawatan, dan risiko pasien guna menentukan rencana pelayanan yang tepat', 'Dilakukan penganan medis segera', 'I10', 'Suhu panas tinggi', 'Diberikan Obat Sementara', '2026-10-22 19:38:24'),
(3, 4, 1, NULL, 'ADMIN', 1, 'SOAP', 'tes tes', 'test tes tes', 'tes tes tes tes', 'tes test etes tes tes tes', 'R50.9', 'test', 'tes ulang', '2026-10-22 19:56:44'),
(4, 4, 1, NULL, 'ADMIN', 1, 'SOAP', 'tes tes tes', 'tes tes', 'tes tes', 'tes tes', 'J18.9', 'Pheumonia', 'di erikan obat', '2026-10-22 20:32:54');

-- --------------------------------------------------------

--
-- Table structure for table `hms_doctor_schedules`
--

CREATE TABLE `hms_doctor_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `poli_id` int(10) UNSIGNED DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `day_of_week` tinyint(3) UNSIGNED NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `quota` int(10) UNSIGNED NOT NULL DEFAULT 30,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `slot_duration_minutes` int(11) NOT NULL DEFAULT 30,
  `source_legacy_id` int(11) DEFAULT NULL,
  `available_date` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `source_availability_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_doctor_schedules`
--

INSERT INTO `hms_doctor_schedules` (`id`, `poli_id`, `doctor_id`, `day_of_week`, `start_time`, `end_time`, `quota`, `is_active`, `created_at`, `slot_duration_minutes`, `source_legacy_id`, `available_date`, `updated_at`, `source_availability_id`) VALUES
(1, NULL, 1, 1, '10:30:00', '13:00:00', 20, 1, '2026-11-13 16:02:52', 30, NULL, '2026-11-15 00:00:00', '0000-00-00 00:00:00', NULL),
(2, NULL, 1, 3, '10:00:00', '13:00:00', 25, 1, '2026-11-13 16:03:44', 30, NULL, '2026-11-13 00:00:00', '0000-00-00 00:00:00', NULL),
(3, NULL, 1, 6, '10:00:00', '13:00:00', 15, 1, '2026-11-13 16:05:01', 30, NULL, '2026-11-16 00:00:00', '0000-00-00 00:00:00', NULL),
(4, 4, 1, 0, '10:30:00', '13:00:00', 20, 1, '2026-11-13 17:06:41', 30, NULL, '2026-11-15 00:00:00', '2026-11-13 17:34:40', 4),
(5, 4, 1, 5, '10:00:00', '13:00:00', 25, 1, '2026-11-13 17:06:41', 30, NULL, '2026-11-13 00:00:00', '2026-11-13 17:34:40', 5),
(6, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:06:41', 30, NULL, '2026-11-16 00:00:00', '2026-11-13 17:34:40', 6),
(7, 4, 1, 0, '10:30:00', '13:00:00', 20, 1, '2026-11-13 17:31:40', 30, NULL, '2026-11-15 00:00:00', '2026-11-13 17:34:40', 1),
(8, 4, 1, 5, '10:00:00', '13:00:00', 25, 1, '2026-11-13 17:31:40', 30, NULL, '2026-11-13 00:00:00', '2026-11-13 17:34:40', 2),
(9, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:31:40', 30, NULL, '2026-11-16 00:00:00', '2026-11-13 17:34:40', 3),
(10, 4, 1, 0, '10:30:00', '13:00:00', 20, 1, '2026-11-13 17:31:46', 30, NULL, '2026-11-15 00:00:00', '2026-11-13 17:34:40', 7),
(11, 4, 1, 5, '10:00:00', '13:00:00', 25, 1, '2026-11-13 17:31:46', 30, NULL, '2026-11-13 00:00:00', '2026-11-13 17:34:40', 8),
(12, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:31:46', 30, NULL, '2026-11-16 00:00:00', '2026-11-13 17:34:40', 9),
(13, 4, 1, 0, '10:30:00', '13:00:00', 20, 1, '2026-11-13 17:34:34', 30, NULL, '2026-11-15 00:00:00', '2026-11-13 17:34:40', 10),
(14, 4, 1, 5, '10:00:00', '13:00:00', 25, 1, '2026-11-13 17:34:34', 30, NULL, '2026-11-13 00:00:00', '2026-11-13 17:34:40', 11),
(15, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:34:34', 30, NULL, '2026-11-16 00:00:00', '2026-11-13 17:34:40', 12),
(16, 4, 1, 0, '10:30:00', '13:00:00', 20, 1, '2026-11-13 17:34:36', 30, NULL, '2026-11-15 00:00:00', '2026-11-13 17:34:40', 13),
(17, 4, 1, 5, '10:00:00', '13:00:00', 25, 1, '2026-11-13 17:34:36', 30, NULL, '2026-11-13 00:00:00', '2026-11-13 17:34:40', 14),
(18, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:34:36', 30, NULL, '2026-11-16 00:00:00', '2026-11-13 17:34:40', 15),
(19, 4, 1, 0, '10:30:00', '13:00:00', 20, 1, '2026-11-13 17:34:40', 30, NULL, '2026-11-15 00:00:00', '0000-00-00 00:00:00', 16),
(20, 4, 1, 5, '10:00:00', '13:00:00', 25, 1, '2026-11-13 17:34:40', 30, NULL, '2026-11-13 00:00:00', '0000-00-00 00:00:00', 17),
(21, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:34:40', 30, NULL, '2026-11-16 00:00:00', '0000-00-00 00:00:00', 18),
(22, NULL, 21, 2, '08:00:00', '11:00:00', 10, 1, '2026-11-14 09:33:36', 30, NULL, '2026-11-18 00:00:00', '0000-00-00 00:00:00', NULL),
(23, 124, 13, 3, '09:00:00', '11:30:00', 1, 1, '2026-11-14 09:35:43', 30, NULL, '2026-11-19 00:00:00', '2026-11-14 14:55:52', NULL),
(24, 390, 21, 3, '15:00:00', '17:00:00', 30, 1, '2026-11-14 13:42:55', 30, NULL, '0620-11-13 00:00:00', '2026-11-14 14:02:54', NULL),
(25, 1, 21, 1, '09:00:00', '11:30:00', 20, 1, '2026-11-14 14:27:01', 30, NULL, '2026-11-19 00:00:00', '0000-00-00 00:00:00', NULL),
(26, 842, 10, 0, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(27, 842, 10, 2, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(28, 842, 10, 4, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(29, 848, 11, 1, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(30, 848, 11, 3, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(31, 848, 11, 5, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(32, 819, 12, 0, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(33, 819, 12, 3, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(34, 841, 13, 1, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(35, 841, 13, 3, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(36, 841, 13, 5, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(37, 838, 14, 1, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(38, 838, 14, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(39, 838, 14, 5, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(40, 848, 15, 0, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(41, 848, 15, 3, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(42, 830, 16, 0, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(43, 830, 16, 1, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(44, 830, 16, 2, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(45, 830, 16, 3, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(46, 830, 16, 4, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(47, 830, 16, 5, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(48, 852, 17, 0, '08:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(49, 852, 17, 3, '08:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(50, 841, 30, 1, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(51, 841, 30, 3, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(52, 841, 30, 5, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(53, 831, 18, 0, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(54, 831, 18, 3, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(55, 837, 19, 0, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(56, 837, 19, 1, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(57, 837, 19, 2, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(58, 837, 19, 3, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(59, 837, 19, 4, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(60, 837, 19, 5, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(61, 842, 24, 0, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(62, 842, 24, 1, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(63, 842, 24, 2, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(64, 842, 24, 3, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(65, 842, 24, 4, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(66, 842, 24, 5, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(67, 822, 20, 0, '09:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(68, 822, 20, 2, '09:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(69, 822, 20, 4, '09:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(70, 851, 21, 0, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(71, 851, 21, 1, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(72, 851, 21, 2, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(73, 851, 21, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(74, 851, 21, 4, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(75, 820, 12, 1, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(76, 820, 12, 4, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(77, 839, 62, 0, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(78, 839, 62, 2, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(79, 839, 62, 4, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(80, 824, 35, 0, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(81, 824, 35, 2, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(82, 824, 35, 4, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(83, 833, 49, 0, '07:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(84, 833, 49, 1, '07:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(85, 833, 49, 2, '07:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(86, 833, 49, 3, '07:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(87, 833, 49, 4, '07:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(88, 822, 31, 0, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(89, 822, 31, 1, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(90, 822, 31, 2, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(91, 822, 31, 3, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(92, 822, 31, 4, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(93, 821, 20, 1, '16:00:00', '20:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(94, 821, 20, 3, '16:00:00', '20:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(95, 821, 20, 5, '16:00:00', '20:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(96, 860, 18, 2, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(97, 860, 18, 5, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(98, 842, 13, 1, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(99, 842, 13, 3, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(100, 842, 13, 5, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(101, 847, 61, 2, '09:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(102, 847, 61, 5, '09:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(103, 839, 14, 2, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(104, 839, 14, 5, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(105, 852, 33, 0, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(106, 852, 33, 1, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(107, 852, 33, 2, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(108, 852, 33, 3, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(109, 852, 33, 4, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(110, 852, 33, 5, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(111, 848, 10, 0, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(112, 848, 10, 1, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(113, 848, 10, 2, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(114, 848, 10, 3, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(115, 848, 10, 4, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(116, 857, 24, 2, '08:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(117, 857, 24, 5, '08:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(118, 819, 20, 0, '08:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(119, 819, 20, 3, '08:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(120, 834, 49, 1, '13:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(121, 834, 49, 3, '13:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(122, 834, 49, 5, '13:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(123, 843, 22, 1, '16:00:00', '20:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(124, 843, 22, 3, '16:00:00', '20:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(125, 843, 22, 5, '16:00:00', '20:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(126, 866, 54, 1, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(127, 866, 54, 4, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(128, 829, 52, 1, '09:00:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(129, 829, 52, 3, '09:00:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(130, 829, 52, 5, '09:00:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(131, 842, 48, 0, '13:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(132, 842, 48, 2, '13:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(133, 842, 48, 4, '13:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(134, 864, 60, 2, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(135, 864, 60, 5, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(136, 866, 60, 0, '09:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(137, 866, 60, 2, '09:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(138, 866, 60, 4, '09:00:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(139, 853, 51, 0, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(140, 853, 51, 3, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(141, 848, 25, 0, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(142, 848, 25, 1, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(143, 848, 25, 2, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(144, 848, 25, 3, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(145, 848, 25, 4, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(146, 848, 25, 5, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(147, 864, 33, 1, '07:30:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(148, 864, 33, 4, '07:30:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(149, 823, 44, 0, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(150, 823, 44, 1, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(151, 823, 44, 2, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(152, 823, 44, 3, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(153, 823, 44, 4, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(154, 824, 48, 0, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(155, 824, 48, 3, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(156, 850, 43, 0, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(157, 850, 43, 1, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(158, 850, 43, 2, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(159, 850, 43, 3, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(160, 850, 43, 4, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(161, 850, 43, 5, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(162, 825, 47, 0, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(163, 825, 47, 1, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(164, 825, 47, 2, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(165, 825, 47, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(166, 825, 47, 4, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(167, 819, 18, 0, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(168, 819, 18, 1, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(169, 819, 18, 2, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(170, 819, 18, 3, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(171, 819, 18, 4, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(172, 841, 24, 0, '07:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(173, 841, 24, 1, '07:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(174, 841, 24, 2, '07:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(175, 841, 24, 3, '07:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(176, 841, 24, 4, '07:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(177, 831, 53, 0, '07:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(178, 831, 53, 1, '07:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(179, 831, 53, 2, '07:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(180, 831, 53, 3, '07:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(181, 831, 53, 4, '07:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(182, 842, 44, 0, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(183, 842, 44, 2, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(184, 842, 44, 4, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(185, 850, 45, 2, '07:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(186, 850, 45, 5, '07:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(187, 856, 45, 0, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(188, 856, 45, 1, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(189, 856, 45, 2, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(190, 856, 45, 3, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(191, 856, 45, 4, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(192, 856, 45, 5, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(193, 865, 11, 0, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(194, 865, 11, 3, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(195, 854, 51, 0, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(196, 854, 51, 1, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(197, 854, 51, 2, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(198, 854, 51, 3, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(199, 854, 51, 4, '09:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(200, 866, 34, 1, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(201, 866, 34, 4, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(202, 819, 26, 2, '08:30:00', '13:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(203, 819, 26, 5, '08:30:00', '13:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(204, 833, 55, 0, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(205, 833, 55, 3, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(206, 863, 12, 0, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(207, 863, 12, 2, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(208, 863, 12, 4, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(209, 856, 17, 1, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(210, 856, 17, 4, '07:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(211, 830, 52, 0, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(212, 830, 52, 2, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(213, 830, 52, 4, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(214, 841, 22, 0, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(215, 841, 22, 2, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(216, 841, 22, 4, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(217, 852, 45, 1, '08:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(218, 852, 45, 4, '08:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(219, 837, 57, 2, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(220, 837, 57, 5, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(221, 853, 50, 1, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(222, 853, 50, 3, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(223, 853, 50, 5, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(224, 820, 32, 1, '13:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(225, 820, 32, 3, '13:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(226, 820, 32, 5, '13:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(227, 866, 42, 0, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(228, 866, 42, 2, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(229, 866, 42, 4, '09:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(230, 843, 13, 2, '16:00:00', '20:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(231, 843, 13, 5, '16:00:00', '20:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(232, 848, 30, 0, '08:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(233, 848, 30, 3, '08:30:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(234, 827, 63, 2, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(235, 827, 63, 5, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(236, 832, 12, 0, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(237, 832, 12, 3, '08:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(238, 846, 65, 1, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(239, 846, 65, 3, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(240, 846, 65, 5, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(241, 864, 17, 0, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(242, 864, 17, 3, '09:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(243, 860, 39, 1, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(244, 860, 39, 3, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(245, 860, 39, 5, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(246, 866, 45, 0, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(247, 866, 45, 2, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(248, 866, 45, 4, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(249, 856, 33, 0, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(250, 856, 33, 1, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(251, 856, 33, 2, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(252, 856, 33, 3, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(253, 856, 33, 4, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(254, 856, 33, 5, '07:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(255, 841, 56, 0, '08:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(256, 841, 56, 3, '08:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(257, 832, 53, 0, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(258, 832, 53, 1, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(259, 832, 53, 2, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(260, 832, 53, 3, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(261, 832, 53, 4, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(262, 832, 53, 5, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(263, 838, 15, 0, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(264, 838, 15, 3, '07:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(265, 836, 19, 0, '09:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(266, 836, 19, 1, '09:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(267, 836, 19, 2, '09:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(268, 836, 19, 3, '09:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(269, 836, 19, 4, '09:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(270, 836, 19, 5, '09:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(271, 859, 56, 2, '08:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(272, 859, 56, 5, '08:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(273, 844, 11, 1, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(274, 844, 11, 3, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(275, 844, 11, 5, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(276, 829, 44, 1, '08:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(277, 829, 44, 4, '08:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(278, 822, 47, 0, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(279, 822, 47, 1, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(280, 822, 47, 2, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(281, 822, 47, 3, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(282, 822, 47, 4, '07:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(283, 831, 39, 0, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(284, 831, 39, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(285, 838, 55, 1, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(286, 838, 55, 4, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(287, 866, 27, 1, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(288, 866, 27, 4, '08:00:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(289, 846, 63, 0, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(290, 846, 63, 2, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(291, 846, 63, 4, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(292, 866, 33, 1, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(293, 866, 33, 4, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(294, 864, 45, 2, '07:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(295, 864, 45, 5, '07:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(296, 829, 35, 1, '08:30:00', '13:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(297, 829, 35, 3, '08:30:00', '13:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(298, 829, 35, 5, '08:30:00', '13:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(299, 821, 13, 1, '16:00:00', '20:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(300, 821, 13, 3, '16:00:00', '20:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(301, 821, 13, 5, '16:00:00', '20:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(302, 827, 36, 2, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(303, 827, 36, 5, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(304, 841, 10, 0, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(305, 841, 10, 1, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(306, 841, 10, 2, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(307, 841, 10, 3, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(308, 841, 10, 4, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(309, 841, 10, 5, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(310, 836, 57, 1, '07:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(311, 836, 57, 4, '07:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(312, 843, 65, 0, '16:00:00', '20:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(313, 843, 65, 2, '16:00:00', '20:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(314, 843, 65, 4, '16:00:00', '20:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(315, 866, 41, 0, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(316, 866, 41, 1, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(317, 866, 41, 2, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(318, 866, 41, 3, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(319, 866, 41, 4, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(320, 829, 16, 1, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(321, 829, 16, 3, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(322, 829, 16, 5, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(323, 820, 26, 1, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(324, 820, 26, 3, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(325, 820, 26, 5, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(326, 851, 45, 0, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(327, 851, 45, 1, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(328, 851, 45, 2, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(329, 851, 45, 3, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(330, 851, 45, 4, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(331, 851, 45, 5, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(332, 851, 58, 0, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(333, 851, 58, 1, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(334, 851, 58, 2, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(335, 851, 58, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(336, 851, 58, 4, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(337, 851, 58, 5, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(338, 850, 55, 0, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(339, 850, 55, 2, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(340, 850, 55, 4, '08:30:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(341, 832, 39, 0, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(342, 832, 39, 2, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(343, 832, 39, 4, '10:00:00', '16:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(344, 851, 17, 0, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(345, 851, 17, 1, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(346, 851, 17, 2, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(347, 851, 17, 3, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(348, 851, 17, 4, '08:00:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(349, 823, 35, 0, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(350, 823, 35, 1, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(351, 823, 35, 2, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(352, 823, 35, 3, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(353, 823, 35, 4, '08:00:00', '14:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(354, 849, 25, 1, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(355, 849, 25, 4, '10:00:00', '16:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(356, 836, 24, 0, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(357, 836, 24, 2, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(358, 836, 24, 4, '08:30:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(359, 829, 48, 0, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(360, 829, 48, 2, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(361, 829, 48, 4, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(362, 820, 53, 2, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(363, 820, 53, 5, '09:00:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(364, 866, 28, 0, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(365, 866, 28, 3, '08:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(366, 841, 37, 0, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(367, 841, 37, 2, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(368, 841, 37, 4, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(369, 823, 48, 1, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(370, 823, 48, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(371, 823, 48, 5, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(372, 861, 59, 0, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(373, 861, 59, 2, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(374, 861, 59, 4, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(375, 855, 33, 1, '08:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL);
INSERT INTO `hms_doctor_schedules` (`id`, `poli_id`, `doctor_id`, `day_of_week`, `start_time`, `end_time`, `quota`, `is_active`, `created_at`, `slot_duration_minutes`, `source_legacy_id`, `available_date`, `updated_at`, `source_availability_id`) VALUES
(376, 855, 33, 3, '08:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(377, 855, 33, 5, '08:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(378, 856, 60, 0, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(379, 856, 60, 1, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(380, 856, 60, 2, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(381, 856, 60, 3, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(382, 856, 60, 4, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(383, 856, 60, 5, '08:30:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(384, 844, 49, 2, '08:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(385, 844, 49, 5, '08:30:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(386, 821, 22, 2, '16:00:00', '20:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(387, 821, 22, 5, '16:00:00', '20:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(388, 866, 40, 0, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(389, 866, 40, 1, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(390, 866, 40, 2, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(391, 866, 40, 3, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(392, 866, 40, 4, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(393, 866, 40, 5, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(394, 826, 24, 0, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(395, 826, 24, 1, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(396, 826, 24, 2, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(397, 826, 24, 3, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(398, 826, 24, 4, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(399, 826, 24, 5, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(400, 838, 62, 0, '08:00:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(401, 838, 62, 2, '08:00:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(402, 838, 62, 4, '08:00:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(403, 819, 32, 0, '08:30:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(404, 819, 32, 1, '08:30:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(405, 819, 32, 2, '08:30:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(406, 819, 32, 3, '08:30:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(407, 819, 32, 4, '08:30:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(408, 819, 32, 5, '08:30:00', '13:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(409, 829, 19, 0, '08:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(410, 829, 19, 1, '08:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(411, 829, 19, 2, '08:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(412, 829, 19, 3, '08:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(413, 829, 19, 4, '08:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(414, 829, 19, 5, '08:30:00', '12:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(415, 847, 24, 0, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(416, 847, 24, 1, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(417, 847, 24, 2, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(418, 847, 24, 3, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(419, 847, 24, 4, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(420, 847, 24, 5, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(421, 832, 18, 1, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(422, 832, 18, 3, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(423, 832, 18, 5, '09:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(424, 862, 46, 0, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(425, 862, 46, 1, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(426, 862, 46, 2, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(427, 862, 46, 3, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(428, 862, 46, 4, '07:00:00', '21:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(429, 852, 60, 0, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(430, 852, 60, 2, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(431, 852, 60, 4, '08:00:00', '12:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(432, 828, 64, 0, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(433, 828, 64, 1, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(434, 828, 64, 2, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(435, 828, 64, 3, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(436, 828, 64, 4, '09:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(437, 851, 15, 2, '08:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(438, 851, 15, 5, '08:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(439, 851, 60, 0, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(440, 851, 60, 1, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(441, 851, 60, 2, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(442, 851, 60, 3, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(443, 851, 60, 4, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(444, 851, 60, 5, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(445, 866, 23, 0, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(446, 866, 23, 2, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(447, 866, 23, 4, '08:30:00', '12:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(448, 835, 56, 0, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(449, 835, 56, 1, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(450, 835, 56, 2, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(451, 835, 56, 3, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(452, 835, 56, 4, '08:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(453, 845, 65, 0, '07:30:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(454, 845, 65, 3, '07:30:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(455, 850, 38, 1, '08:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(456, 850, 38, 4, '08:30:00', '13:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(457, 824, 44, 0, '08:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(458, 824, 44, 3, '08:00:00', '12:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(459, 855, 24, 0, '08:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(460, 855, 24, 2, '08:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(461, 855, 24, 4, '08:00:00', '13:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(462, 860, 53, 0, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(463, 860, 53, 1, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(464, 860, 53, 2, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(465, 860, 53, 3, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(466, 860, 53, 4, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(467, 860, 53, 5, '07:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(468, 827, 65, 0, '08:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(469, 827, 65, 3, '08:00:00', '13:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(470, 827, 21, 0, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(471, 827, 21, 1, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(472, 827, 21, 2, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(473, 827, 21, 3, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(474, 827, 21, 4, '08:30:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(475, 840, 37, 0, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(476, 840, 37, 1, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(477, 840, 37, 2, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(478, 840, 37, 3, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(479, 840, 37, 4, '08:30:00', '14:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(480, 849, 15, 0, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(481, 849, 15, 3, '10:00:00', '16:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(482, 829, 51, 0, '08:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(483, 829, 51, 3, '08:00:00', '12:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(484, 833, 51, 1, '08:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(485, 833, 51, 4, '08:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(486, 835, 36, 0, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(487, 835, 36, 1, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(488, 835, 36, 2, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(489, 835, 36, 3, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(490, 835, 36, 4, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(491, 835, 36, 5, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(492, 842, 35, 0, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(493, 842, 35, 1, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(494, 842, 35, 2, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(495, 842, 35, 3, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(496, 842, 35, 4, '10:00:00', '16:00:00', 20, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(497, 851, 33, 1, '09:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(498, 851, 33, 4, '09:00:00', '14:00:00', 25, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-06 00:00:00', '2026-11-20 08:00:00', NULL),
(499, 858, 59, 0, '07:00:00', '21:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-02 00:00:00', '2026-11-20 08:00:00', NULL),
(500, 858, 59, 3, '07:00:00', '21:00:00', 30, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(501, 866, 29, 1, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(502, 866, 29, 3, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(503, 866, 29, 5, '09:00:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(504, 826, 61, 1, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-03 00:00:00', '2026-11-20 08:00:00', NULL),
(505, 826, 61, 3, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-05 00:00:00', '2026-11-20 08:00:00', NULL),
(506, 826, 61, 5, '09:00:00', '14:00:00', 15, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL),
(507, 823, 49, 2, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-04 00:00:00', '2026-11-20 08:00:00', NULL),
(508, 823, 49, 5, '08:30:00', '14:00:00', 40, 1, '2026-11-20 08:00:00', 30, NULL, '2026-11-07 00:00:00', '2026-11-20 08:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hms_icd10`
--

CREATE TABLE `hms_icd10` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `category` varchar(120) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_icd10`
--

INSERT INTO `hms_icd10` (`id`, `code`, `description`, `category`, `is_active`, `created_at`) VALUES
(1, 'R50.9', 'Fever, unspecified', 'Gejala', 1, '2026-10-20 22:44:55'),
(2, 'J06.9', 'Acute upper respiratory infection, unspecified', 'Respirasi', 1, '2026-10-20 22:44:55'),
(3, 'I10', 'Essential (primary) hypertension', 'Kardiovaskular', 1, '2026-10-20 22:44:55'),
(4, 'E11.9', 'Type 2 diabetes mellitus without complications', 'Endokrin', 1, '2026-10-20 22:44:55'),
(5, 'A09', 'Infectious gastroenteritis and colitis, unspecified', 'Pencernaan', 1, '2026-10-20 22:44:55'),
(6, 'J18.9', 'Pneumonia, unspecified organism', 'Respirasi', 1, '2026-10-20 22:44:55'),
(7, 'K30', 'Functional dyspepsia', 'Pencernaan', 1, '2026-10-20 22:44:55'),
(8, 'M54.5', 'Low back pain', 'Muskuloskeletal', 1, '2026-10-20 22:44:55');

-- --------------------------------------------------------

--
-- Table structure for table `hms_igd_visits`
--

CREATE TABLE `hms_igd_visits` (
  `id` int(10) UNSIGNED NOT NULL,
  `visit_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `registration_no` varchar(40) NOT NULL,
  `arrival_time` datetime NOT NULL DEFAULT current_timestamp(),
  `triage_level` enum('MERAH','KUNING','HIJAU','HITAM') NOT NULL DEFAULT 'HIJAU',
  `chief_complaint` text DEFAULT NULL,
  `vital_signs` text DEFAULT NULL,
  `emergency_action` text DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `disposition` enum('RAWAT_INAP','PULANG','RUJUK','OBSERVASI') NOT NULL DEFAULT 'OBSERVASI',
  `disposition_note` text DEFAULT NULL,
  `status` enum('AKTIF','SELESAI') NOT NULL DEFAULT 'AKTIF',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_master_poli`
--

CREATE TABLE `hms_master_poli` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `poli_code` varchar(30) DEFAULT NULL,
  `poli_name` varchar(120) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_master_poli`
--

INSERT INTO `hms_master_poli` (`id`, `code`, `is_active`, `created_at`, `poli_code`, `poli_name`, `updated_at`) VALUES
(1, 'UMUM', 1, '2026-11-13 08:02:03', 'PO-UMUM', 'Poli Umum', NULL),
(2, 'ANAK', 1, '2026-11-13 08:02:03', 'PO-ANAK', 'Poli Anak', NULL),
(4, 'BEDAH', 1, '2026-11-13 08:02:03', 'PO-BEDAH', 'Poli Bedah', NULL),
(5, 'OBGYN', 1, '2026-11-13 08:02:03', 'PO-BGYN', 'Poli Kandungan', NULL),
(6, 'MATA', 1, '2026-11-13 08:02:03', 'PO-MATA', 'Poli Mata', NULL),
(11, NULL, 1, '2026-11-13 10:33:05', 'PO-SYARAF', 'Poli Saraf', NULL),
(21, NULL, 1, '2026-11-13 10:38:24', 'PO-PARU', 'Poli Paru', NULL),
(24, NULL, 1, '2026-11-13 10:44:33', 'PO-JANTUNG', 'Poli Jantung (Eksekutif)', NULL),
(27, NULL, 1, '2026-11-13 10:49:32', 'PO-MCU', 'Poli Medical Check Up (MCU) / Umum', NULL),
(30, NULL, 1, '2026-11-13 10:50:21', 'PO-ORTH', 'Poli Orthopaedi & Traumatologi (Eksekutif)', NULL),
(33, NULL, 1, '2026-11-13 10:51:38', 'PO-KANDIO', 'Poli Anak Sub. Kardiologi', NULL),
(36, NULL, 1, '2026-11-13 11:01:57', 'PO-KUKEL', 'Poli Kulit & Kelamin', NULL),
(41, NULL, 1, '2026-11-13 11:04:19', 'PO-ANSO', 'Poli Anak (Sore)', NULL),
(44, NULL, 1, '2026-11-13 11:05:07', 'PO-KEKABER', 'Poli Kebidanan / Kamar Bersalin (VK Rajal)', NULL),
(47, NULL, 1, '2026-11-13 11:05:49', 'PO-REHME', 'Poli Rehabilitasi Medik', NULL),
(50, NULL, 1, '2026-11-13 11:06:32', 'PO-HEDIA', 'Unit Hemodialisa', NULL),
(53, NULL, 1, '2026-11-13 11:07:10', 'PO-UROGI', 'Poli Urologi', NULL),
(56, NULL, 1, '2026-11-13 11:07:30', 'PO-THTKL', 'Poli THT-KL', NULL),
(59, NULL, 1, '2026-11-13 11:08:21', 'PO-GASTOGI', 'Poli Gastroenterohepatologi', NULL),
(65, NULL, 1, '2026-11-13 11:09:23', 'PO-TUMKEM', 'Poli Tumbuh Kembang Anak', NULL),
(68, NULL, 1, '2026-11-13 11:09:57', 'PO-GIMU', 'Poli Gigi & Mulut', NULL),
(71, NULL, 1, '2026-11-13 11:11:12', 'PO-PSIKIATRI', 'Poli Jiwa (Psikiatri)', NULL),
(74, NULL, 1, '2026-11-13 11:12:44', 'INS_LAB', 'Instalasi Laboratorium', NULL),
(77, NULL, 1, '2026-11-13 11:13:04', 'PO_VCT', 'Poli VCT', NULL),
(80, NULL, 1, '2026-11-13 11:13:37', 'PO-GIGIANAK', 'Poli Gigi Anak', NULL),
(81, NULL, 1, '2026-11-13 11:15:09', 'PENYAKIT-DALEM', 'Penyakit Dalem', NULL),
(82, NULL, 1, '2026-11-13 11:15:09', 'POLI-PENYAKIT-DALAM', 'Poli Penyakit Dalam', NULL),
(83, NULL, 1, '2026-11-13 11:15:09', 'INS-PATKLI', 'Instalasi Laboratorium Patologi Klinik', NULL),
(112, NULL, 1, '2026-11-13 11:40:14', 'PO-PENDA', 'Poli Penyakit Dalam', NULL),
(124, NULL, 1, '2026-11-13 13:39:38', 'PO-PENDAEKS', 'Poli Penyakit Dalam (Eksekutif)', NULL),
(163, NULL, 1, '2026-11-13 14:14:20', 'PO-KANKEBID', 'Poli Kandungan & Kebidanan (Obgyn)', NULL),
(338, NULL, 1, '2026-11-13 19:44:08', 'POLI-BEDAH', 'Poli Bedah', NULL),
(390, NULL, 1, '2026-11-14 11:10:36', 'POLI-UMUM', 'Poli Umum', NULL),
(819, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-001', 'Poli Anak', NULL),
(820, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-002', 'Poli Anak (Eksekutif)', NULL),
(821, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-003', 'Poli Anak (Sore)', NULL),
(822, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-004', 'Poli Anak Sub. Kardiologi', NULL),
(823, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-005', 'Poli Bedah', NULL),
(824, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-006', 'Poli Bedah (Eksekutif)', NULL),
(825, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-007', 'Poli Dalam Sub. Gastroenterohepatologi', NULL),
(826, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-008', 'Poli Fisioterapi', NULL),
(827, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-009', 'Poli Gigi & Mulut', NULL),
(828, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-010', 'Poli Gigi Anak', NULL),
(829, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-011', 'Poli Jantung', NULL),
(830, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-012', 'Poli Jantung (Eksekutif)', NULL),
(831, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-013', 'Poli Kandungan', NULL),
(832, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-014', 'Poli Kandungan (Eksekutif)', NULL),
(833, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-015', 'Poli Kulit & Kelamin', NULL),
(834, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-016', 'Poli Kulit & Kelamin (Eksekutif)', NULL),
(835, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-017', 'Poli Mata', NULL),
(836, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-018', 'Poli Orthopaedi & Traumatologi', NULL),
(837, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-019', 'Poli Orthopaedi & Traumatologi (Eksekutif)', NULL),
(838, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-020', 'Poli Paru', NULL),
(839, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-021', 'Poli Paru (Eksekutif)', NULL),
(840, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-022', 'Poli Paru Sub. Onkologi Toraks', NULL),
(841, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-023', 'Poli Penyakit Dalam', NULL),
(842, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-024', 'Poli Penyakit Dalam (Eksekutif)', NULL),
(843, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-025', 'Poli Penyakit Dalam (Sore)', NULL),
(844, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-026', 'Poli Penyakit Jiwa', NULL),
(845, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-027', 'Poli Penyakit Mulut', NULL),
(846, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-028', 'Poli Periodonti', NULL),
(847, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-029', 'Poli Rehabilitasi Medik', NULL),
(848, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-030', 'Poli Saraf', NULL),
(849, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-031', 'Poli Saraf (Eksekutif)', NULL),
(850, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-032', 'Poli THT', NULL),
(851, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-033', 'Poli Umum', NULL),
(852, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-034', 'Poli Umum Tes Kesehatan P3K', NULL),
(853, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-035', 'Poli Urologi', NULL),
(854, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-036', 'Poli Urologi (Eksekutif)', NULL),
(855, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-037', 'Poli VCT', NULL),
(856, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-038', 'GCU : Surat Sehat Jasmani + Rohani', NULL),
(857, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-039', 'Hemodialisa', NULL),
(858, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-040', 'LABORATORIUM PATOLOGI KLINIK (SENTRAL)', NULL),
(859, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-041', 'Matahari', NULL),
(860, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-042', 'P. VK (Rajal)', NULL),
(861, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-043', 'PCR (LAB)', NULL),
(862, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-044', 'RADIOLOGI', NULL),
(863, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-045', 'TUMBUH KEMBANG ANAK', NULL),
(864, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-046', 'Tes Dewan', NULL),
(865, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-047', 'Tes P3K Tanpa Surat Sehat', NULL),
(866, NULL, 1, '2026-11-20 08:00:00', 'PO-XLS-048', 'Uji Kesehatan PNS (Paket)', NULL),
(869, NULL, 1, '2026-11-26 11:41:40', 'POLI-BEDAH-EKSEKUTIF', 'Poli Bedah (Eksekutif)', NULL),
(870, NULL, 1, '2026-11-26 11:41:40', 'POLI-PARU', 'Poli Paru', NULL),
(871, NULL, 1, '2026-11-26 11:41:40', 'POLI-SARAF', 'Poli Saraf', NULL),
(872, NULL, 1, '2026-11-26 11:41:40', 'POLI-UROLOGI', 'Poli Urologi', NULL),
(873, NULL, 1, '2026-11-26 11:41:40', 'UJI-KESEHATAN-PNS-PAKET', 'Uji Kesehatan PNS (Paket)', NULL),
(874, NULL, 1, '2026-11-26 11:41:40', 'GCU-SURAT-SEHAT-JASMANI-ROHANI', 'GCU : Surat Sehat Jasmani + Rohani', NULL),
(875, NULL, 1, '2026-11-26 11:41:40', 'P-VK-RAJAL', 'P. VK (Rajal)', NULL),
(876, NULL, 1, '2026-11-26 11:41:40', 'POLI-JANTUNG', 'Poli Jantung', NULL),
(877, NULL, 1, '2026-11-26 11:41:40', 'POLI-PERIODONTI', 'Poli Periodonti', NULL),
(878, NULL, 1, '2026-11-26 11:41:40', 'POLI-REHABILITASI-MEDIK', 'Poli Rehabilitasi Medik', NULL),
(880, NULL, 1, '2026-11-26 11:41:40', 'POLI-VCT', 'Poli VCT', NULL),
(881, NULL, 1, '2026-11-26 11:41:40', 'MATAHARI', 'Matahari', NULL),
(882, NULL, 1, '2026-11-26 11:41:40', 'POLI-ANAK-SORE', 'Poli Anak (Sore)', NULL),
(883, NULL, 1, '2026-11-26 11:41:40', 'POLI-ANAK-SUB-KARDIOLOGI', 'Poli Anak Sub. Kardiologi', NULL),
(884, NULL, 1, '2026-11-26 11:41:40', 'POLI-GIGI-MULUT', 'Poli Gigi & Mulut', NULL),
(885, NULL, 1, '2026-11-26 11:41:40', 'POLI-PENYAKIT-DALAM-EKSEKUTIF', 'Poli Penyakit Dalam (Eksekutif)', NULL),
(886, NULL, 1, '2026-11-26 11:41:40', 'POLI-PENYAKIT-DALAM-SORE', 'Poli Penyakit Dalam (Sore)', NULL),
(887, NULL, 1, '2026-11-26 11:41:40', 'POLI-THT', 'Poli THT', NULL),
(888, NULL, 1, '2026-11-26 11:41:40', 'TES-DEWAN', 'Tes Dewan', NULL),
(889, NULL, 1, '2026-11-26 11:41:40', 'LABORATORIUM-PATOLOGI-KLINIK-S', 'LABORATORIUM PATOLOGI KLINIK (SENTRAL)', NULL),
(890, NULL, 1, '2026-11-26 11:41:40', 'POLI-ANAK', 'Poli Anak', NULL),
(892, NULL, 1, '2026-11-26 11:41:40', 'POLI-DALAM-SUB-GASTROENTEROHEP', 'Poli Dalam Sub. Gastroenterohepatologi', NULL),
(893, NULL, 1, '2026-11-26 11:41:40', 'POLI-FISIOTERAPI', 'Poli Fisioterapi', NULL),
(894, NULL, 1, '2026-11-26 11:41:40', 'POLI-KANDUNGAN', 'Poli Kandungan', NULL),
(895, NULL, 1, '2026-11-26 11:41:40', 'POLI-UMUM-TES-KESEHATAN-P3K', 'Poli Umum Tes Kesehatan P3K', NULL),
(896, NULL, 1, '2026-11-26 11:41:40', 'TES-P3K-TANPA-SURAT-SEHAT', 'Tes P3K Tanpa Surat Sehat', NULL),
(897, NULL, 1, '2026-11-26 11:41:40', 'PCR-LAB', 'PCR (LAB)', NULL),
(898, NULL, 1, '2026-11-26 11:41:40', 'POLI-GIGI-ANAK', 'Poli Gigi Anak', NULL),
(899, NULL, 1, '2026-11-26 11:41:40', 'POLI-MATA', 'Poli Mata', NULL),
(900, NULL, 1, '2026-11-26 11:41:40', 'POLI-PARU-EKSEKUTIF', 'Poli Paru (Eksekutif)', NULL),
(901, NULL, 1, '2026-11-26 11:41:40', 'POLI-KANDUNGAN-EKSEKUTIF', 'Poli Kandungan (Eksekutif)', NULL),
(902, NULL, 1, '2026-11-26 11:41:40', 'POLI-ORTHOPAEDI-TRAUMATOLOGI', 'Poli Orthopaedi & Traumatologi', NULL),
(903, NULL, 1, '2026-11-26 11:41:40', 'POLI-ORTHOPAEDI-TRAUMATOLOGI-E', 'Poli Orthopaedi & Traumatologi (Eksekutif)', NULL),
(904, NULL, 1, '2026-11-26 11:41:40', 'POLI-PENYAKIT-MULUT', 'Poli Penyakit Mulut', NULL),
(905, NULL, 1, '2026-11-26 11:41:40', 'TUMBUH-KEMBANG-ANAK', 'TUMBUH KEMBANG ANAK', NULL),
(906, NULL, 1, '2026-11-26 11:41:40', 'POLI-SARAF-EKSEKUTIF', 'Poli Saraf (Eksekutif)', NULL),
(907, NULL, 1, '2026-11-26 11:41:40', 'POLI-JANTUNG-EKSEKUTIF', 'Poli Jantung (Eksekutif)', NULL),
(908, NULL, 1, '2026-11-26 11:41:40', 'POLI-PENYAKIT-JIWA', 'Poli Penyakit Jiwa', NULL),
(909, NULL, 1, '2026-11-26 11:41:40', 'RADIOLOGI', 'RADIOLOGI', NULL),
(910, NULL, 1, '2026-11-26 11:41:40', 'POLI-ANAK-EKSEKUTIF', 'Poli Anak (Eksekutif)', NULL),
(911, NULL, 1, '2026-11-26 11:41:40', 'POLI-KULIT-KELAMIN', 'Poli Kulit & Kelamin', NULL),
(912, NULL, 1, '2026-11-26 11:41:40', 'POLI-KULIT-KELAMIN-EKSEKUTIF', 'Poli Kulit & Kelamin (Eksekutif)', NULL),
(913, NULL, 1, '2026-11-26 11:41:40', 'HEMODIALISA', 'Hemodialisa', NULL),
(914, NULL, 1, '2026-11-26 11:41:40', 'POLI-PARU-SUB-ONKOLOGI-TORAKS', 'Poli Paru Sub. Onkologi Toraks', NULL),
(915, NULL, 1, '2026-11-26 11:41:40', 'POLI-UROLOGI-EKSEKUTIF', 'Poli Urologi (Eksekutif)', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hms_module_sequences`
--

CREATE TABLE `hms_module_sequences` (
  `code_key` varchar(80) NOT NULL,
  `next_value` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_module_sequences`
--

INSERT INTO `hms_module_sequences` (`code_key`, `next_value`) VALUES
('QUEUE|20261022|PENYAKIT DALEM', 1),
('QUEUE|20261022|POLI PENYAKIT DALAM', 1),
('QUEUE|20261110|POLI PENYAKIT DALAM', 1),
('QUEUE|20261114|POLI PENYAKIT DALAM', 1),
('QUEUE|20261115|POLI BEDAH', 1),
('QUEUE|20261116|POLI BEDAH', 1),
('QUEUE|20261118|POLI UMUM', 1),
('QUEUE|20261119|POLI UMUM', 1),
('REG20261022', 2),
('REG20261110', 1),
('REG20261113', 1),
('REG20261114', 4);

-- --------------------------------------------------------

--
-- Table structure for table `hms_outpatient_encounters`
--

CREATE TABLE `hms_outpatient_encounters` (
  `id` int(10) UNSIGNED NOT NULL,
  `visit_id` int(10) UNSIGNED NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `poli` varchar(120) NOT NULL,
  `anamnesis` text DEFAULT NULL,
  `physical_exam` text DEFAULT NULL,
  `assessment` text DEFAULT NULL,
  `plan` text DEFAULT NULL,
  `diagnosis_code` varchar(20) DEFAULT NULL,
  `diagnosis_name` varchar(255) DEFAULT NULL,
  `action_text` text DEFAULT NULL,
  `referral_id` int(11) DEFAULT NULL,
  `status` enum('TERDAFTAR','DIPANGGIL','DILAYANI','SELESAI','BATAL') NOT NULL DEFAULT 'TERDAFTAR',
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_outpatient_encounters`
--

INSERT INTO `hms_outpatient_encounters` (`id`, `visit_id`, `patient_id`, `doctor_id`, `poli`, `anamnesis`, `physical_exam`, `assessment`, `plan`, `diagnosis_code`, `diagnosis_name`, `action_text`, `referral_id`, `status`, `started_at`, `completed_at`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 4, 'Dalam', 'tes tes tes', 'tes tes', 'tes tes', 'tes tes', 'J18.9', 'Pheumonia', 'di erikan obat', NULL, 'DILAYANI', '2026-10-22 14:33:26', NULL, '2026-10-22 14:29:39', '2026-10-22 20:32:54'),
(2, 5, 15, 21, 'UMUM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TERDAFTAR', NULL, NULL, '2026-11-14 09:42:06', NULL),
(3, 4, 7, 1, 'Poli Bedah', '', '', '', '', 'J18.9', '', '', NULL, 'DILAYANI', '2026-11-14 11:18:57', NULL, '2026-11-14 11:18:57', '2026-11-14 11:19:28'),
(4, 7, 16, 1, 'Poli Bedah', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DILAYANI', '2026-11-14 11:38:29', NULL, '2026-11-14 11:38:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hms_patient_user_map`
--

CREATE TABLE `hms_patient_user_map` (
  `user_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_patient_user_map`
--

INSERT INTO `hms_patient_user_map` (`user_id`, `patient_id`, `created_at`) VALUES
(5, 18, '2026-11-14 16:32:46');

-- --------------------------------------------------------

--
-- Table structure for table `hms_patient_visits`
--

CREATE TABLE `hms_patient_visits` (
  `id` int(10) UNSIGNED NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `mr_type` enum('BARU','LAMA') NOT NULL DEFAULT 'LAMA',
  `registration_no` varchar(40) NOT NULL,
  `visit_date` date NOT NULL,
  `visit_type` enum('RAWAT_JALAN','IGD','RAWAT_INAP') NOT NULL DEFAULT 'RAWAT_JALAN',
  `poli` varchar(120) DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `queue_no` varchar(20) DEFAULT NULL,
  `source` enum('ONLINE','OFFLINE') NOT NULL DEFAULT 'OFFLINE',
  `online_booking_token` varchar(80) DEFAULT NULL,
  `registration_counter` varchar(40) DEFAULT NULL,
  `status` enum('MENUNGGU','DIPANGGIL','DILAYANI','SELESAI','BATAL') NOT NULL DEFAULT 'MENUNGGU',
  `called_at` datetime DEFAULT NULL,
  `served_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `arrived_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_patient_visits`
--

INSERT INTO `hms_patient_visits` (`id`, `patient_id`, `mr_type`, `registration_no`, `visit_date`, `visit_type`, `poli`, `doctor_id`, `appointment_id`, `queue_no`, `source`, `online_booking_token`, `registration_counter`, `status`, `called_at`, `served_at`, `completed_at`, `created_at`, `arrived_at`, `updated_at`) VALUES
(1, 4, 'LAMA', 'REG202610220001', '2026-10-22', 'RAWAT_JALAN', 'Penyakit Dalem', 1, NULL, 'P001', 'ONLINE', '996aae3f81eadc31cd48317f', '1', 'MENUNGGU', NULL, NULL, NULL, '2026-10-22 05:19:31', '2026-11-14 11:23:14', '2026-11-14 11:23:14'),
(2, 5, 'LAMA', 'REG202610220002', '2026-10-22', 'RAWAT_JALAN', 'Poli Penyakit Dalam', NULL, NULL, 'P001', 'ONLINE', NULL, 'Portal Publik', 'MENUNGGU', NULL, NULL, NULL, '2026-10-22 13:30:06', NULL, NULL),
(3, 6, 'LAMA', 'REG202611100001', '2026-11-10', 'RAWAT_JALAN', 'Poli Penyakit Dalam', NULL, NULL, 'P001', 'ONLINE', NULL, 'Portal Publik', 'SELESAI', '2026-11-10 10:45:05', '2026-11-10 10:45:33', '2026-11-13 19:52:30', '2026-11-10 09:48:42', NULL, '2026-11-13 19:52:30'),
(4, 7, 'LAMA', 'REG202611130001', '2026-11-15', 'RAWAT_JALAN', 'Poli Bedah', 1, NULL, 'P001', 'OFFLINE', NULL, '', 'DILAYANI', '2026-11-13 19:52:07', '2026-11-13 19:52:49', NULL, '2026-11-13 19:37:03', NULL, '2026-11-13 19:52:49'),
(5, 15, 'LAMA', 'REG202611140001', '2026-11-18', 'RAWAT_JALAN', 'Poli Umum', 21, NULL, 'P001', 'ONLINE', NULL, 'Portal Publik', 'SELESAI', '2026-11-14 09:39:54', '2026-11-14 09:55:39', '2026-11-14 09:58:36', '2026-11-14 09:38:12', '2026-11-14 09:39:34', '2026-11-14 09:58:36'),
(6, 16, 'LAMA', 'REG202611140002', '2026-11-14', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 1, NULL, 'P001', 'ONLINE', NULL, 'Portal Publik - Tanpa Jadwal', 'MENUNGGU', NULL, NULL, NULL, '2026-11-14 11:12:46', NULL, NULL),
(7, 16, 'LAMA', 'REG202611140003', '2026-11-16', 'RAWAT_JALAN', 'Poli Bedah', 1, NULL, 'P001', 'OFFLINE', NULL, '', 'DILAYANI', '2026-11-14 11:27:07', '2026-11-14 11:38:29', NULL, '2026-11-14 11:16:23', NULL, '2026-11-14 11:38:29'),
(8, 18, 'LAMA', 'REG202611140004', '2026-11-19', 'RAWAT_JALAN', 'Poli Umum', 21, 6, 'P001', 'ONLINE', NULL, 'Appointment Online', 'DIPANGGIL', '2026-11-15 07:48:59', NULL, NULL, '2026-11-14 16:32:46', '2026-11-15 07:48:54', '2026-11-15 07:48:59'),
(9, 19, 'LAMA', 'REG202611180001', '2026-11-18', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 33, 7, '025-15', 'ONLINE', 'APT-202611-0001', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(10, 20, 'LAMA', 'REG202611180002', '2026-11-18', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 35, 8, '017-11', 'ONLINE', 'APT-202611-0002', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(11, 21, 'LAMA', 'REG202611110003', '2026-11-11', 'RAWAT_JALAN', 'Poli Bedah', 35, 9, '100-03', 'OFFLINE', 'APT-202611-0003', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-11 11:41:00', NULL, '2026-11-20 08:00:00', '2026-11-11 11:02:00', '2026-11-20 08:00:00'),
(12, 22, 'LAMA', 'REG202611230004', '2026-11-23', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 47, 10, '079-07', 'ONLINE', 'APT-202611-0004', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(13, 23, 'LAMA', 'REG202611280005', '2026-11-28', 'RAWAT_JALAN', 'Poli Penyakit Jiwa', 49, 11, '111-05', 'ONLINE', 'APT-202611-0005', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-28 09:20:00', '2026-11-28 09:20:00', '2026-11-20 08:00:00', '2026-11-28 08:35:00', '2026-11-20 08:00:00'),
(14, 24, 'LAMA', 'REG202611280006', '2026-11-28', 'RAWAT_JALAN', 'Poli Kulit & Kelamin (Eksekutif)', 49, 12, '029-06', 'ONLINE', 'APT-202611-0006', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(15, 25, 'LAMA', 'REG202611160007', '2026-11-16', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 49, 13, '018-27', 'ONLINE', 'APT-202611-0007', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(16, 26, 'LAMA', 'REG202611160008', '2026-11-16', 'RAWAT_JALAN', 'Poli Kandungan', 18, 14, '010-08', 'ONLINE', 'APT-202611-0008', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(17, 27, 'LAMA', 'REG202611180009', '2026-11-18', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi (Eksekutif)', 57, 15, '059-11', 'ONLINE', 'APT-202611-0009', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 11:37:00', '2026-11-18 11:37:00', '2026-11-20 08:00:00', '2026-11-18 11:01:00', '2026-11-20 08:00:00'),
(18, 28, 'LAMA', 'REG202611240010', '2026-11-24', 'RAWAT_JALAN', 'Poli Jantung', 44, 16, '078-31', 'OFFLINE', 'APT-202611-0010', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-24 10:52:00', '2026-11-24 10:52:00', '2026-11-20 08:00:00', '2026-11-24 10:08:00', '2026-11-20 08:00:00'),
(19, 29, 'LAMA', 'REG202611260011', '2026-11-26', 'RAWAT_JALAN', 'Poli Saraf', 15, 17, '006-27', 'OFFLINE', 'APT-202611-0011', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-26 10:24:00', NULL, '2026-11-20 08:00:00', '2026-11-26 10:00:00', '2026-11-20 08:00:00'),
(20, 30, 'LAMA', 'REG202611230012', '2026-11-23', 'RAWAT_JALAN', 'RADIOLOGI', 46, 18, '120-05', 'ONLINE', 'APT-202611-0012', 'Mobile JKN', 'SELESAI', NULL, '2026-11-23 18:25:00', '2026-11-23 18:25:00', '2026-11-20 08:00:00', '2026-11-23 18:13:00', '2026-11-20 08:00:00'),
(21, 31, 'LAMA', 'REG202611020013', '2026-11-02', 'RAWAT_JALAN', 'Poli Saraf', 30, 19, '064-05', 'ONLINE', 'APT-202611-0013', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-02 12:26:00', '2026-11-02 12:26:00', '2026-11-20 08:00:00', '2026-11-02 11:35:00', '2026-11-20 08:00:00'),
(22, 32, 'LAMA', 'REG202611230014', '2026-11-23', 'RAWAT_JALAN', 'Poli THT', 43, 20, '041-11', 'ONLINE', 'APT-202611-0014', 'Website RS', 'SELESAI', NULL, '2026-11-23 09:54:00', '2026-11-23 09:54:00', '2026-11-20 08:00:00', '2026-11-23 09:20:00', '2026-11-20 08:00:00'),
(23, 33, 'LAMA', 'REG202611090015', '2026-11-09', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 41, 21, '092-04', 'ONLINE', 'APT-202611-0015', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(24, 34, 'LAMA', 'REG202611130016', '2026-11-13', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 34, 22, '051-14', 'ONLINE', 'APT-202611-0016', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-13 09:44:00', '2026-11-13 09:44:00', '2026-11-20 08:00:00', '2026-11-13 09:11:00', '2026-11-20 08:00:00'),
(25, 35, 'LAMA', 'REG202611090017', '2026-11-09', 'RAWAT_JALAN', 'Poli Periodonti', 63, 23, '083-40', 'ONLINE', 'APT-202611-0017', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-09 10:17:00', '2026-11-09 10:17:00', '2026-11-20 08:00:00', '2026-11-09 09:43:00', '2026-11-20 08:00:00'),
(26, 36, 'LAMA', 'REG202611160018', '2026-11-16', 'RAWAT_JALAN', 'Poli Bedah', 35, 24, '100-01', 'OFFLINE', 'APT-202611-0018', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(27, 37, 'LAMA', 'REG202611210019', '2026-11-21', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 53, 25, '104-14', 'ONLINE', 'APT-202611-0019', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(28, 38, 'LAMA', 'REG202611050020', '2026-11-05', 'RAWAT_JALAN', 'Poli Bedah', 44, 26, '039-19', 'ONLINE', 'APT-202611-0020', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(29, 39, 'LAMA', 'REG202611120021', '2026-11-12', 'RAWAT_JALAN', 'Poli Urologi', 51, 27, '036-32', 'ONLINE', 'APT-202611-0021', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-12 09:30:00', NULL, '2026-11-20 08:00:00', '2026-11-12 08:42:00', '2026-11-20 08:00:00'),
(30, 40, 'LAMA', 'REG202611230022', '2026-11-23', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 48, 28, '040-13', 'ONLINE', 'APT-202611-0022', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(31, 41, 'LAMA', 'REG202611200023', '2026-11-20', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 51, 29, '137-05', 'OFFLINE', 'APT-202611-0023', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(32, 42, 'LAMA', 'REG202611270024', '2026-11-27', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 53, 30, '073-30', 'ONLINE', 'APT-202611-0024', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-27 12:08:00', '2026-11-27 12:08:00', '2026-11-20 08:00:00', '2026-11-27 11:26:00', '2026-11-20 08:00:00'),
(33, 43, 'LAMA', 'REG202611270025', '2026-11-27', 'RAWAT_JALAN', 'P. VK (Rajal)', 53, 31, '131-05', 'ONLINE', 'APT-202611-0025', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(34, 44, 'LAMA', 'REG202611040026', '2026-11-04', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 45, 32, '048-04', 'OFFLINE', 'APT-202611-0026', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-04 11:27:00', '2026-11-04 11:27:00', '2026-11-20 08:00:00', '2026-11-04 10:43:00', '2026-11-20 08:00:00'),
(35, 45, 'LAMA', 'REG202611050027', '2026-11-05', 'RAWAT_JALAN', 'Poli Fisioterapi', 61, 33, '143-01', 'ONLINE', 'APT-202611-0027', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(36, 46, 'LAMA', 'REG202611230028', '2026-11-23', 'RAWAT_JALAN', 'Poli Anak', 32, 34, '116-02', 'ONLINE', 'APT-202611-0028', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-23 10:09:00', '2026-11-23 10:09:00', '2026-11-20 08:00:00', '2026-11-23 09:57:00', '2026-11-20 08:00:00'),
(37, 47, 'LAMA', 'REG202611160029', '2026-11-16', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 35, 35, '139-19', 'ONLINE', 'APT-202611-0029', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-16 14:37:00', '2026-11-16 14:37:00', '2026-11-20 08:00:00', '2026-11-16 14:01:00', '2026-11-20 08:00:00'),
(38, 48, 'LAMA', 'REG202611110030', '2026-11-11', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 48, 36, '033-06', 'ONLINE', 'APT-202611-0030', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(39, 49, 'LAMA', 'REG202611230031', '2026-11-23', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 41, 37, '092-13', 'ONLINE', 'APT-202611-0031', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-23 11:18:00', NULL, '2026-11-20 08:00:00', '2026-11-23 11:05:00', '2026-11-20 08:00:00'),
(40, 50, 'LAMA', 'REG202611230032', '2026-11-23', 'RAWAT_JALAN', 'Poli Umum', 58, 38, '096-22', 'ONLINE', 'APT-202611-0032', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-23 12:46:00', NULL, '2026-11-20 08:00:00', '2026-11-23 12:33:00', '2026-11-20 08:00:00'),
(41, 51, 'LAMA', 'REG202611200033', '2026-11-20', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 24, 39, '012-13', 'OFFLINE', 'APT-202611-0033', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-20 12:05:00', '2026-11-20 12:05:00', '2026-11-20 08:00:00', '2026-11-20 11:46:00', '2026-11-20 08:00:00'),
(42, 52, 'LAMA', 'REG202611050034', '2026-11-05', 'RAWAT_JALAN', 'Poli Anak', 18, 40, '043-12', 'ONLINE', 'APT-202611-0034', 'Website RS', 'SELESAI', NULL, '2026-11-05 10:42:00', '2026-11-05 10:42:00', '2026-11-20 08:00:00', '2026-11-05 10:32:00', '2026-11-20 08:00:00'),
(43, 53, 'LAMA', 'REG202611060035', '2026-11-06', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 35, 41, '139-16', 'OFFLINE', 'APT-202611-0035', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-06 13:31:00', NULL, '2026-11-20 08:00:00', '2026-11-06 13:17:00', '2026-11-20 08:00:00'),
(44, 54, 'LAMA', 'REG202611210036', '2026-11-21', 'RAWAT_JALAN', 'Poli VCT', 33, 42, '109-13', 'ONLINE', 'APT-202611-0036', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(45, 55, 'LAMA', 'REG202611170037', '2026-11-17', 'RAWAT_JALAN', 'Poli Bedah', 48, 43, '107-29', 'ONLINE', 'APT-202611-0037', 'Mobile JKN', 'SELESAI', NULL, '2026-11-17 14:22:00', '2026-11-17 14:22:00', '2026-11-20 08:00:00', '2026-11-17 13:27:00', '2026-11-20 08:00:00'),
(46, 56, 'LAMA', 'REG202611230038', '2026-11-23', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 12, 44, '066-11', 'ONLINE', 'APT-202611-0038', 'Website RS', 'MENUNGGU', NULL, '2026-11-23 11:47:00', NULL, '2026-11-20 08:00:00', '2026-11-23 10:52:00', '2026-11-20 08:00:00'),
(47, 57, 'LAMA', 'REG202611050039', '2026-11-05', 'RAWAT_JALAN', 'Poli Anak', 12, 45, '003-07', 'ONLINE', 'APT-202611-0039', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-05 14:02:00', '2026-11-05 14:02:00', '2026-11-20 08:00:00', '2026-11-05 13:39:00', '2026-11-20 08:00:00'),
(48, 58, 'LAMA', 'REG202611160040', '2026-11-16', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 60, 46, '035-22', 'OFFLINE', 'APT-202611-0040', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-16 10:20:00', '2026-11-16 10:20:00', '2026-11-20 08:00:00', '2026-11-16 09:50:00', '2026-11-20 08:00:00'),
(49, 59, 'LAMA', 'REG202611060041', '2026-11-06', 'RAWAT_JALAN', 'Poli THT', 38, 47, '128-36', 'ONLINE', 'APT-202611-0041', 'Website RS', 'SELESAI', NULL, '2026-11-06 10:36:00', '2026-11-06 10:36:00', '2026-11-20 08:00:00', '2026-11-06 10:18:00', '2026-11-20 08:00:00'),
(50, 60, 'LAMA', 'REG202611130042', '2026-11-13', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 22, 48, '057-13', 'ONLINE', 'APT-202611-0042', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(51, 61, 'LAMA', 'REG202611200043', '2026-11-20', 'RAWAT_JALAN', 'Poli Saraf (Eksekutif)', 25, 49, '101-28', 'OFFLINE', 'APT-202611-0043', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-20 12:17:00', '2026-11-20 12:17:00', '2026-11-20 08:00:00', '2026-11-20 11:53:00', '2026-11-20 08:00:00'),
(52, 62, 'LAMA', 'REG202611090044', '2026-11-09', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 42, 50, '062-11', 'ONLINE', 'APT-202611-0044', 'Website RS', 'MENUNGGU', NULL, '2026-11-09 11:52:00', NULL, '2026-11-20 08:00:00', '2026-11-09 11:03:00', '2026-11-20 08:00:00'),
(53, 63, 'LAMA', 'REG202611240045', '2026-11-24', 'RAWAT_JALAN', 'Tes Dewan', 33, 51, '038-06', 'ONLINE', 'APT-202611-0045', 'Website RS', 'SELESAI', NULL, '2026-11-24 10:15:00', '2026-11-24 10:15:00', '2026-11-20 08:00:00', '2026-11-24 10:05:00', '2026-11-20 08:00:00'),
(54, 64, 'LAMA', 'REG202611040046', '2026-11-04', 'RAWAT_JALAN', 'Poli THT', 43, 52, '041-15', 'ONLINE', 'APT-202611-0046', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-04 13:36:00', '2026-11-04 13:36:00', '2026-11-20 08:00:00', '2026-11-04 13:00:00', '2026-11-20 08:00:00'),
(55, 65, 'LAMA', 'REG202611230047', '2026-11-23', 'RAWAT_JALAN', 'TUMBUH KEMBANG ANAK', 12, 53, '054-25', 'ONLINE', 'APT-202611-0047', 'Mobile JKN', 'SELESAI', NULL, '2026-11-23 08:25:00', '2026-11-23 08:25:00', '2026-11-20 08:00:00', '2026-11-23 08:05:00', '2026-11-20 08:00:00'),
(56, 66, 'LAMA', 'REG202611230048', '2026-11-23', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 10, 54, '001-09', 'ONLINE', 'APT-202611-0048', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(57, 67, 'LAMA', 'REG202611240049', '2026-11-24', 'RAWAT_JALAN', 'Poli Fisioterapi', 61, 55, '143-04', 'ONLINE', 'APT-202611-0049', 'Website RS', 'MENUNGGU', NULL, '2026-11-24 13:15:00', NULL, '2026-11-20 08:00:00', '2026-11-24 13:03:00', '2026-11-20 08:00:00'),
(58, 68, 'LAMA', 'REG202611260050', '2026-11-26', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 22, 56, '030-04', 'ONLINE', 'APT-202611-0050', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-26 16:58:00', '2026-11-26 16:58:00', '2026-11-20 08:00:00', '2026-11-26 16:28:00', '2026-11-20 08:00:00'),
(59, 69, 'LAMA', 'REG202611190051', '2026-11-19', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 22, 57, '030-12', 'ONLINE', 'APT-202611-0051', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-19 19:52:00', '2026-11-19 19:52:00', '2026-11-20 08:00:00', '2026-11-19 19:07:00', '2026-11-20 08:00:00'),
(60, 70, 'LAMA', 'REG202611060052', '2026-11-06', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 54, 58, '031-13', 'OFFLINE', 'APT-202611-0052', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-06 11:58:00', NULL, '2026-11-20 08:00:00', '2026-11-06 11:12:00', '2026-11-20 08:00:00'),
(61, 71, 'LAMA', 'REG202611270053', '2026-11-27', 'RAWAT_JALAN', 'Poli Umum', 17, 59, '099-24', 'ONLINE', 'APT-202611-0053', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(62, 72, 'LAMA', 'REG202611190054', '2026-11-19', 'RAWAT_JALAN', 'Poli Anak (Sore)', 20, 60, '020-10', 'ONLINE', 'APT-202611-0054', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(63, 73, 'LAMA', 'REG202611180055', '2026-11-18', 'RAWAT_JALAN', 'Poli Bedah', 49, 61, '144-10', 'ONLINE', 'APT-202611-0055', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 13:20:00', '2026-11-18 13:20:00', '2026-11-20 08:00:00', '2026-11-18 12:48:00', '2026-11-20 08:00:00'),
(64, 74, 'LAMA', 'REG202611070056', '2026-11-07', 'RAWAT_JALAN', 'Poli Bedah', 48, 62, '107-32', 'ONLINE', 'APT-202611-0056', 'Website RS', 'SELESAI', NULL, '2026-11-07 13:41:00', '2026-11-07 13:41:00', '2026-11-20 08:00:00', '2026-11-07 12:51:00', '2026-11-20 08:00:00'),
(65, 75, 'LAMA', 'REG202611300057', '2026-11-30', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 19, 63, '075-03', 'ONLINE', 'APT-202611-0057', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-30 12:02:00', '2026-11-30 12:02:00', '2026-11-20 08:00:00', '2026-11-30 11:24:00', '2026-11-20 08:00:00'),
(66, 76, 'LAMA', 'REG202611130058', '2026-11-13', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 31, 64, '019-15', 'ONLINE', 'APT-202611-0058', 'Mobile JKN', 'SELESAI', NULL, '2026-11-13 11:12:00', '2026-11-13 11:12:00', '2026-11-20 08:00:00', '2026-11-13 10:33:00', '2026-11-20 08:00:00'),
(67, 77, 'LAMA', 'REG202611230059', '2026-11-23', 'RAWAT_JALAN', 'Tes Dewan', 17, 65, '068-15', 'ONLINE', 'APT-202611-0059', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(68, 78, 'LAMA', 'REG202611200060', '2026-11-20', 'RAWAT_JALAN', 'Poli THT', 38, 66, '128-22', 'ONLINE', 'APT-202611-0060', 'Website RS', 'SELESAI', NULL, '2026-11-20 09:27:00', '2026-11-20 09:27:00', '2026-11-20 08:00:00', '2026-11-20 09:11:00', '2026-11-20 08:00:00'),
(69, 79, 'LAMA', 'REG202611160061', '2026-11-16', 'RAWAT_JALAN', 'Poli Kandungan', 53, 67, '045-12', 'OFFLINE', 'APT-202611-0061', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-16 10:18:00', NULL, '2026-11-20 08:00:00', '2026-11-16 09:58:00', '2026-11-20 08:00:00'),
(70, 80, 'LAMA', 'REG202611270062', '2026-11-27', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 12, 68, '015-11', 'OFFLINE', 'APT-202611-0062', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(71, 81, 'LAMA', 'REG202611300063', '2026-11-30', 'RAWAT_JALAN', 'Poli Paru', 62, 69, '115-05', 'OFFLINE', 'APT-202611-0063', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-30 09:43:00', '2026-11-30 09:43:00', '2026-11-20 08:00:00', '2026-11-30 08:56:00', '2026-11-20 08:00:00'),
(72, 82, 'LAMA', 'REG202611110064', '2026-11-11', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 10, 70, '001-21', 'ONLINE', 'APT-202611-0064', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(73, 83, 'LAMA', 'REG202611180065', '2026-11-18', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 53, 71, '073-06', 'OFFLINE', 'APT-202611-0065', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-18 10:59:00', '2026-11-18 10:59:00', '2026-11-20 08:00:00', '2026-11-18 10:30:00', '2026-11-20 08:00:00'),
(74, 84, 'LAMA', 'REG202611070066', '2026-11-07', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 18, 72, '119-25', 'OFFLINE', 'APT-202611-0066', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-07 09:42:00', '2026-11-07 09:42:00', '2026-11-20 08:00:00', '2026-11-07 09:00:00', '2026-11-20 08:00:00'),
(75, 85, 'LAMA', 'REG202611090067', '2026-11-09', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 45, 73, '070-13', 'ONLINE', 'APT-202611-0067', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(76, 86, 'LAMA', 'REG202611170068', '2026-11-17', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 26, 74, '094-18', 'OFFLINE', 'APT-202611-0068', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-17 15:39:00', '2026-11-17 15:39:00', '2026-11-20 08:00:00', '2026-11-17 15:15:00', '2026-11-20 08:00:00'),
(77, 87, 'LAMA', 'REG202611240069', '2026-11-24', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 29, 75, '142-19', 'ONLINE', 'APT-202611-0069', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(78, 88, 'LAMA', 'REG202611060070', '2026-11-06', 'RAWAT_JALAN', 'P. VK (Rajal)', 53, 76, '131-36', 'ONLINE', 'APT-202611-0070', 'Website RS', 'SELESAI', NULL, '2026-11-06 10:16:00', '2026-11-06 10:16:00', '2026-11-20 08:00:00', '2026-11-06 09:43:00', '2026-11-20 08:00:00'),
(79, 89, 'LAMA', 'REG202611110071', '2026-11-11', 'RAWAT_JALAN', 'Tes Dewan', 60, 77, '034-03', 'ONLINE', 'APT-202611-0071', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-11 09:46:00', NULL, '2026-11-20 08:00:00', '2026-11-11 09:09:00', '2026-11-20 08:00:00'),
(80, 90, 'LAMA', 'REG202611180072', '2026-11-18', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 39, 78, '098-06', 'ONLINE', 'APT-202611-0072', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 13:25:00', '2026-11-18 13:25:00', '2026-11-20 08:00:00', '2026-11-18 13:10:00', '2026-11-20 08:00:00'),
(81, 91, 'LAMA', 'REG202611270073', '2026-11-27', 'RAWAT_JALAN', 'Poli Rehabilitasi Medik', 24, 79, '118-30', 'ONLINE', 'APT-202611-0073', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-27 09:42:00', '2026-11-27 09:42:00', '2026-11-20 08:00:00', '2026-11-27 09:14:00', '2026-11-20 08:00:00'),
(82, 92, 'LAMA', 'REG202611040074', '2026-11-04', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 20, 80, '013-18', 'ONLINE', 'APT-202611-0074', 'Mobile JKN', 'SELESAI', NULL, '2026-11-04 09:16:00', '2026-11-04 09:16:00', '2026-11-20 08:00:00', '2026-11-04 08:57:00', '2026-11-20 08:00:00'),
(83, 93, 'LAMA', 'REG202611050075', '2026-11-05', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 17, 81, '008-21', 'ONLINE', 'APT-202611-0075', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(84, 94, 'LAMA', 'REG202611230076', '2026-11-23', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 60, 82, '035-05', 'ONLINE', 'APT-202611-0076', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-23 14:08:00', NULL, '2026-11-20 08:00:00', '2026-11-23 13:13:00', '2026-11-20 08:00:00'),
(85, 95, 'LAMA', 'REG202611100077', '2026-11-10', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 57, 83, '090-34', 'ONLINE', 'APT-202611-0077', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-10 08:25:00', NULL, '2026-11-20 08:00:00', '2026-11-10 08:11:00', '2026-11-20 08:00:00'),
(86, 96, 'LAMA', 'REG202611120078', '2026-11-12', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 55, 84, '053-04', 'ONLINE', 'APT-202611-0078', 'Website RS', 'SELESAI', NULL, '2026-11-12 09:19:00', '2026-11-12 09:19:00', '2026-11-20 08:00:00', '2026-11-12 08:47:00', '2026-11-20 08:00:00'),
(87, 97, 'LAMA', 'REG202611190079', '2026-11-19', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 13, 85, '004-06', 'ONLINE', 'APT-202611-0079', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(88, 98, 'LAMA', 'REG202611250080', '2026-11-25', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 10, 86, '001-02', 'ONLINE', 'APT-202611-0080', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(89, 99, 'LAMA', 'REG202611110081', '2026-11-11', 'RAWAT_JALAN', 'RADIOLOGI', 46, 87, '120-18', 'OFFLINE', 'APT-202611-0081', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(90, 100, 'LAMA', 'REG202612010082', '2026-12-01', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 45, 88, '058-12', 'ONLINE', 'APT-202611-0082', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-12-01 11:26:00', '2026-12-01 11:26:00', '2026-11-20 08:00:00', '2026-12-01 11:09:00', '2026-11-20 08:00:00'),
(91, 101, 'LAMA', 'REG202611090083', '2026-11-09', 'RAWAT_JALAN', 'Poli Dalam Sub. Gastroenterohepatologi', 47, 89, '042-32', 'ONLINE', 'APT-202611-0083', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(92, 102, 'LAMA', 'REG202611180084', '2026-11-18', 'RAWAT_JALAN', 'Poli Umum', 15, 90, '123-21', 'ONLINE', 'APT-202611-0084', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 11:41:00', '2026-11-18 11:41:00', '2026-11-20 08:00:00', '2026-11-18 11:13:00', '2026-11-20 08:00:00'),
(93, 103, 'LAMA', 'REG202611240085', '2026-11-24', 'RAWAT_JALAN', 'Poli Kulit & Kelamin (Eksekutif)', 49, 91, '029-15', 'OFFLINE', 'APT-202611-0085', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-24 15:24:00', '2026-11-24 15:24:00', '2026-11-20 08:00:00', '2026-11-24 14:52:00', '2026-11-20 08:00:00'),
(94, 104, 'LAMA', 'REG202611050086', '2026-11-05', 'RAWAT_JALAN', 'Poli Kandungan', 39, 92, '080-26', 'ONLINE', 'APT-202611-0086', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(95, 105, 'LAMA', 'REG202611240087', '2026-11-24', 'RAWAT_JALAN', 'Poli Penyakit Jiwa', 11, 93, '077-08', 'OFFLINE', 'APT-202611-0087', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-24 10:49:00', '2026-11-24 10:49:00', '2026-11-20 08:00:00', '2026-11-24 10:35:00', '2026-11-20 08:00:00'),
(96, 106, 'LAMA', 'REG202611140088', '2026-11-14', 'RAWAT_JALAN', 'Poli Jantung', 35, 94, '086-25', 'ONLINE', 'APT-202611-0088', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(97, 107, 'LAMA', 'REG202611090089', '2026-11-09', 'RAWAT_JALAN', 'TUMBUH KEMBANG ANAK', 12, 95, '054-17', 'ONLINE', 'APT-202611-0089', 'Website RS', 'SELESAI', NULL, '2026-11-09 08:56:00', '2026-11-09 08:56:00', '2026-11-20 08:00:00', '2026-11-09 08:15:00', '2026-11-20 08:00:00'),
(98, 108, 'LAMA', 'REG202611110090', '2026-11-11', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 63, 96, '065-02', 'ONLINE', 'APT-202611-0090', 'Mobile JKN', 'SELESAI', NULL, '2026-11-11 13:11:00', '2026-11-11 13:11:00', '2026-11-20 08:00:00', '2026-11-11 12:49:00', '2026-11-20 08:00:00'),
(99, 109, 'LAMA', 'REG202611050091', '2026-11-05', 'RAWAT_JALAN', 'LABORATORIUM PATOLOGI KLINIK (SENTRAL)', 59, 97, '141-03', 'OFFLINE', 'APT-202611-0091', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-05 19:30:00', '2026-11-05 19:30:00', '2026-11-20 08:00:00', '2026-11-05 18:35:00', '2026-11-20 08:00:00'),
(100, 110, 'LAMA', 'REG202611270092', '2026-11-27', 'RAWAT_JALAN', 'Poli Bedah', 35, 98, '100-07', 'ONLINE', 'APT-202611-0092', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-27 11:11:00', NULL, '2026-11-20 08:00:00', '2026-11-27 10:54:00', '2026-11-20 08:00:00'),
(101, 111, 'LAMA', 'REG202611200093', '2026-11-20', 'RAWAT_JALAN', 'Poli Mata', 36, 99, '138-13', 'ONLINE', 'APT-202611-0093', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(102, 112, 'LAMA', 'REG202611180094', '2026-11-18', 'RAWAT_JALAN', 'Poli Rehabilitasi Medik', 24, 100, '118-27', 'ONLINE', 'APT-202611-0094', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(103, 113, 'LAMA', 'REG202611060095', '2026-11-06', 'RAWAT_JALAN', 'Poli Gigi Anak', 64, 101, '122-03', 'ONLINE', 'APT-202611-0095', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-06 13:21:00', NULL, '2026-11-20 08:00:00', '2026-11-06 12:34:00', '2026-11-20 08:00:00'),
(104, 114, 'LAMA', 'REG202611070096', '2026-11-07', 'RAWAT_JALAN', 'P. VK (Rajal)', 18, 102, '021-08', 'ONLINE', 'APT-202611-0096', 'Website RS', 'SELESAI', NULL, '2026-11-07 10:20:00', '2026-11-07 10:20:00', '2026-11-20 08:00:00', '2026-11-07 09:50:00', '2026-11-20 08:00:00'),
(105, 115, 'LAMA', 'REG202611070097', '2026-11-07', 'RAWAT_JALAN', 'Poli Anak (Sore)', 20, 103, '020-03', 'ONLINE', 'APT-202611-0097', 'Website RS', 'SELESAI', NULL, '2026-11-07 19:38:00', '2026-11-07 19:38:00', '2026-11-20 08:00:00', '2026-11-07 18:54:00', '2026-11-20 08:00:00'),
(106, 116, 'LAMA', 'REG202611120098', '2026-11-12', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 60, 104, '110-02', 'ONLINE', 'APT-202611-0098', 'Website RS', 'MENUNGGU', NULL, '2026-11-12 11:53:00', NULL, '2026-11-20 08:00:00', '2026-11-12 11:42:00', '2026-11-20 08:00:00'),
(107, 117, 'LAMA', 'REG202611230099', '2026-11-23', 'RAWAT_JALAN', 'Poli Urologi (Eksekutif)', 51, 105, '050-35', 'OFFLINE', 'APT-202611-0099', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(108, 118, 'LAMA', 'REG202611120100', '2026-11-12', 'RAWAT_JALAN', 'Poli Saraf', 15, 106, '006-29', 'ONLINE', 'APT-202611-0100', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-12 10:54:00', '2026-11-12 10:54:00', '2026-11-20 08:00:00', '2026-11-12 10:34:00', '2026-11-20 08:00:00'),
(109, 119, 'LAMA', 'REG202611130101', '2026-11-13', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 42, 107, '062-14', 'ONLINE', 'APT-202611-0101', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(110, 120, 'LAMA', 'REG202611130102', '2026-11-13', 'RAWAT_JALAN', 'Poli THT', 55, 108, '097-04', 'ONLINE', 'APT-202611-0102', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(111, 121, 'LAMA', 'REG202611140103', '2026-11-14', 'RAWAT_JALAN', 'Poli Jantung', 52, 109, '032-08', 'OFFLINE', 'APT-202611-0103', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(112, 122, 'LAMA', 'REG202611180104', '2026-11-18', 'RAWAT_JALAN', 'Poli Anak', 26, 110, '052-10', 'ONLINE', 'APT-202611-0104', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(113, 123, 'LAMA', 'REG202611100105', '2026-11-10', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 30, 111, '009-10', 'ONLINE', 'APT-202611-0105', 'Website RS', 'SELESAI', NULL, '2026-11-10 10:50:00', '2026-11-10 10:50:00', '2026-11-20 08:00:00', '2026-11-10 10:37:00', '2026-11-20 08:00:00'),
(114, 124, 'LAMA', 'REG202612020106', '2026-12-02', 'RAWAT_JALAN', 'Tes Dewan', 60, 112, '034-05', 'OFFLINE', 'APT-202611-0106', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(115, 125, 'LAMA', 'REG202611050107', '2026-11-05', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 44, 113, '129-36', 'ONLINE', 'APT-202611-0107', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-05 10:45:00', NULL, '2026-11-20 08:00:00', '2026-11-05 10:12:00', '2026-11-20 08:00:00'),
(116, 126, 'LAMA', 'REG202611280108', '2026-11-28', 'RAWAT_JALAN', 'Poli Fisioterapi', 24, 114, '114-20', 'ONLINE', 'APT-202611-0108', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(117, 127, 'LAMA', 'REG202611140109', '2026-11-14', 'RAWAT_JALAN', 'Poli Umum', 15, 115, '123-33', 'ONLINE', 'APT-202611-0109', 'Website RS', 'SELESAI', NULL, '2026-11-14 12:18:00', '2026-11-14 12:18:00', '2026-11-20 08:00:00', '2026-11-14 11:30:00', '2026-11-20 08:00:00'),
(118, 128, 'LAMA', 'REG202611270110', '2026-11-27', 'RAWAT_JALAN', 'Poli Jantung (Eksekutif)', 16, 116, '007-10', 'OFFLINE', 'APT-202611-0110', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-27 14:25:00', NULL, '2026-11-20 08:00:00', '2026-11-27 14:06:00', '2026-11-20 08:00:00'),
(119, 129, 'LAMA', 'REG202611200111', '2026-11-20', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi (Eksekutif)', 19, 117, '011-16', 'ONLINE', 'APT-202611-0111', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-20 13:43:00', NULL, '2026-11-20 08:00:00', '2026-11-20 12:59:00', '2026-11-20 08:00:00'),
(120, 130, 'LAMA', 'REG202611160112', '2026-11-16', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 24, 118, '044-20', 'OFFLINE', 'APT-202611-0112', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-16 12:54:00', '2026-11-16 12:54:00', '2026-11-20 08:00:00', '2026-11-16 12:43:00', '2026-11-20 08:00:00'),
(121, 131, 'LAMA', 'REG202611180113', '2026-11-18', 'RAWAT_JALAN', 'Hemodialisa', 24, 119, '027-25', 'ONLINE', 'APT-202611-0113', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-18 10:31:00', NULL, '2026-11-20 08:00:00', '2026-11-18 09:42:00', '2026-11-20 08:00:00'),
(122, 132, 'LAMA', 'REG202611110114', '2026-11-11', 'RAWAT_JALAN', 'Poli THT', 45, 120, '047-11', 'ONLINE', 'APT-202611-0114', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(123, 133, 'LAMA', 'REG202612010115', '2026-12-01', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 32, 121, '061-05', 'ONLINE', 'APT-202611-0115', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(124, 134, 'LAMA', 'REG202611070116', '2026-11-07', 'RAWAT_JALAN', 'Poli Saraf', 25, 122, '037-06', 'ONLINE', 'APT-202611-0116', 'Website RS', 'MENUNGGU', NULL, '2026-11-07 13:05:00', NULL, '2026-11-20 08:00:00', '2026-11-07 12:21:00', '2026-11-20 08:00:00'),
(125, 135, 'LAMA', 'REG202611120117', '2026-11-12', 'RAWAT_JALAN', 'Poli Paru', 15, 123, '074-04', 'OFFLINE', 'APT-202611-0117', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-12 09:15:00', '2026-11-12 09:15:00', '2026-11-20 08:00:00', '2026-11-12 08:20:00', '2026-11-20 08:00:00'),
(126, 136, 'LAMA', 'REG202611120118', '2026-11-12', 'RAWAT_JALAN', 'Poli Saraf', 11, 124, '002-15', 'OFFLINE', 'APT-202611-0118', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-12 09:14:00', NULL, '2026-11-20 08:00:00', '2026-11-12 08:40:00', '2026-11-20 08:00:00'),
(127, 137, 'LAMA', 'REG202611240119', '2026-11-24', 'RAWAT_JALAN', 'P. VK (Rajal)', 39, 125, '069-05', 'ONLINE', 'APT-202611-0119', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-24 09:44:00', '2026-11-24 09:44:00', '2026-11-20 08:00:00', '2026-11-24 08:53:00', '2026-11-20 08:00:00'),
(128, 138, 'LAMA', 'REG202611090120', '2026-11-09', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 44, 126, '129-16', 'ONLINE', 'APT-202611-0120', 'Website RS', 'MENUNGGU', NULL, '2026-11-09 09:04:00', NULL, '2026-11-20 08:00:00', '2026-11-09 08:39:00', '2026-11-20 08:00:00'),
(129, 139, 'LAMA', 'REG202611120121', '2026-11-12', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 33, 127, '025-02', 'ONLINE', 'APT-202611-0121', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(130, 140, 'LAMA', 'REG202611180122', '2026-11-18', 'RAWAT_JALAN', 'Poli THT', 55, 128, '097-02', 'ONLINE', 'APT-202611-0122', 'Website RS', 'SELESAI', NULL, '2026-11-18 10:35:00', '2026-11-18 10:35:00', '2026-11-20 08:00:00', '2026-11-18 10:07:00', '2026-11-20 08:00:00'),
(131, 141, 'LAMA', 'REG202611280123', '2026-11-28', 'RAWAT_JALAN', 'Poli Penyakit Jiwa', 11, 129, '077-06', 'ONLINE', 'APT-202611-0123', 'Mobile JKN', 'SELESAI', NULL, '2026-11-28 10:26:00', '2026-11-28 10:26:00', '2026-11-20 08:00:00', '2026-11-28 09:45:00', '2026-11-20 08:00:00'),
(132, 142, 'LAMA', 'REG202611130124', '2026-11-13', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 27, 130, '082-11', 'ONLINE', 'APT-202611-0124', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(133, 143, 'LAMA', 'REG202611130125', '2026-11-13', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 35, 131, '017-15', 'ONLINE', 'APT-202611-0125', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(134, 144, 'LAMA', 'REG202611230126', '2026-11-23', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 60, 132, '121-13', 'ONLINE', 'APT-202611-0126', 'Website RS', 'SELESAI', NULL, '2026-11-23 11:48:00', '2026-11-23 11:48:00', '2026-11-20 08:00:00', '2026-11-23 10:59:00', '2026-11-20 08:00:00'),
(135, 145, 'LAMA', 'REG202611100127', '2026-11-10', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 57, 133, '090-21', 'ONLINE', 'APT-202611-0127', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(136, 146, 'LAMA', 'REG202611120128', '2026-11-12', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 19, 134, '075-09', 'ONLINE', 'APT-202611-0128', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-12 10:38:00', NULL, '2026-11-20 08:00:00', '2026-11-12 10:28:00', '2026-11-20 08:00:00'),
(137, 147, 'LAMA', 'REG202611140129', '2026-11-14', 'RAWAT_JALAN', 'Poli Umum', 15, 135, '123-08', 'OFFLINE', 'APT-202611-0129', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-14 12:13:00', NULL, '2026-11-20 08:00:00', '2026-11-14 11:19:00', '2026-11-20 08:00:00'),
(138, 148, 'LAMA', 'REG202611060130', '2026-11-06', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 24, 136, '012-10', 'ONLINE', 'APT-202611-0130', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(139, 149, 'LAMA', 'REG202611280131', '2026-11-28', 'RAWAT_JALAN', 'Matahari', 56, 137, '076-39', 'ONLINE', 'APT-202611-0131', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(140, 150, 'LAMA', 'REG202611040132', '2026-11-04', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 48, 138, '033-09', 'ONLINE', 'APT-202611-0132', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-04 15:53:00', NULL, '2026-11-20 08:00:00', '2026-11-04 15:07:00', '2026-11-20 08:00:00'),
(141, 151, 'LAMA', 'REG202611250133', '2026-11-25', 'RAWAT_JALAN', 'Poli Jantung', 48, 139, '103-03', 'ONLINE', 'APT-202611-0133', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(142, 152, 'LAMA', 'REG202611200134', '2026-11-20', 'RAWAT_JALAN', 'Poli Jantung', 44, 140, '078-20', 'ONLINE', 'APT-202611-0134', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-20 09:11:00', NULL, '2026-11-20 08:00:00', '2026-11-20 08:18:00', '2026-11-20 08:00:00'),
(143, 153, 'LAMA', 'REG202611040135', '2026-11-04', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 36, 141, '088-12', 'ONLINE', 'APT-202611-0135', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(144, 154, 'LAMA', 'REG202611110136', '2026-11-11', 'RAWAT_JALAN', 'Poli Anak', 32, 142, '116-14', 'ONLINE', 'APT-202611-0136', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-11 10:48:00', '2026-11-11 10:48:00', '2026-11-20 08:00:00', '2026-11-11 09:57:00', '2026-11-20 08:00:00'),
(145, 155, 'LAMA', 'REG202611090137', '2026-11-09', 'RAWAT_JALAN', 'Poli Penyakit Mulut', 65, 143, '127-18', 'ONLINE', 'APT-202611-0137', 'Website RS', 'SELESAI', NULL, '2026-11-09 13:07:00', '2026-11-09 13:07:00', '2026-11-20 08:00:00', '2026-11-09 12:46:00', '2026-11-20 08:00:00'),
(146, 156, 'LAMA', 'REG202611120138', '2026-11-12', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 32, 144, '061-24', 'ONLINE', 'APT-202611-0138', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(147, 157, 'LAMA', 'REG202611060139', '2026-11-06', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 27, 145, '082-13', 'ONLINE', 'APT-202611-0139', 'Website RS', 'SELESAI', NULL, '2026-11-06 09:04:00', '2026-11-06 09:04:00', '2026-11-20 08:00:00', '2026-11-06 08:52:00', '2026-11-20 08:00:00'),
(148, 158, 'LAMA', 'REG202611050140', '2026-11-05', 'RAWAT_JALAN', 'Poli Umum', 45, 146, '095-39', 'ONLINE', 'APT-202611-0140', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(149, 159, 'LAMA', 'REG202611190141', '2026-11-19', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 53, 147, '073-10', 'ONLINE', 'APT-202611-0141', 'Website RS', 'SELESAI', NULL, '2026-11-19 10:20:00', '2026-11-19 10:20:00', '2026-11-20 08:00:00', '2026-11-19 09:38:00', '2026-11-20 08:00:00'),
(150, 160, 'LAMA', 'REG202611230142', '2026-11-23', 'RAWAT_JALAN', 'Poli Saraf (Eksekutif)', 15, 148, '135-09', 'ONLINE', 'APT-202611-0142', 'Website RS', 'SELESAI', NULL, '2026-11-23 14:56:00', '2026-11-23 14:56:00', '2026-11-20 08:00:00', '2026-11-23 14:27:00', '2026-11-20 08:00:00'),
(151, 161, 'LAMA', 'REG202611200143', '2026-11-20', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 44, 149, '046-13', 'ONLINE', 'APT-202611-0143', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-20 11:54:00', '2026-11-20 11:54:00', '2026-11-20 08:00:00', '2026-11-20 11:03:00', '2026-11-20 08:00:00'),
(152, 162, 'LAMA', 'REG202611260144', '2026-11-26', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 47, 150, '079-04', 'OFFLINE', 'APT-202611-0144', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(153, 163, 'LAMA', 'REG202611190145', '2026-11-19', 'RAWAT_JALAN', 'Poli Umum', 60, 151, '124-36', 'ONLINE', 'APT-202611-0145', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(154, 164, 'LAMA', 'REG202611160146', '2026-11-16', 'RAWAT_JALAN', 'Poli Jantung (Eksekutif)', 16, 152, '007-01', 'ONLINE', 'APT-202611-0146', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-16 13:40:00', '2026-11-16 13:40:00', '2026-11-20 08:00:00', '2026-11-16 13:18:00', '2026-11-20 08:00:00'),
(155, 165, 'LAMA', 'REG202611270147', '2026-11-27', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 45, 153, '048-18', 'ONLINE', 'APT-202611-0147', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(156, 166, 'LAMA', 'REG202611100148', '2026-11-10', 'RAWAT_JALAN', 'Poli Paru', 55, 154, '081-12', 'ONLINE', 'APT-202611-0148', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-10 11:39:00', '2026-11-10 11:39:00', '2026-11-20 08:00:00', '2026-11-10 11:14:00', '2026-11-20 08:00:00'),
(157, 167, 'LAMA', 'REG202611160149', '2026-11-16', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 24, 155, '102-12', 'OFFLINE', 'APT-202611-0149', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(158, 168, 'LAMA', 'REG202611270150', '2026-11-27', 'RAWAT_JALAN', 'Poli Paru', 55, 156, '081-07', 'ONLINE', 'APT-202611-0150', 'Website RS', 'SELESAI', NULL, '2026-11-27 09:49:00', '2026-11-27 09:49:00', '2026-11-20 08:00:00', '2026-11-27 09:19:00', '2026-11-20 08:00:00'),
(159, 169, 'LAMA', 'REG202611200151', '2026-11-20', 'RAWAT_JALAN', 'Poli Urologi (Eksekutif)', 51, 157, '050-27', 'ONLINE', 'APT-202611-0151', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(160, 170, 'LAMA', 'REG202612010152', '2026-12-01', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 54, 158, '031-18', 'OFFLINE', 'APT-202611-0152', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(161, 171, 'LAMA', 'REG202611170153', '2026-11-17', 'RAWAT_JALAN', 'Poli Urologi', 50, 159, '060-23', 'ONLINE', 'APT-202611-0153', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(162, 172, 'LAMA', 'REG202611190154', '2026-11-19', 'RAWAT_JALAN', 'Poli Saraf (Eksekutif)', 15, 160, '135-14', 'ONLINE', 'APT-202611-0154', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-19 10:05:00', '2026-11-19 10:05:00', '2026-11-20 08:00:00', '2026-11-19 09:55:00', '2026-11-20 08:00:00'),
(163, 173, 'LAMA', 'REG202611180155', '2026-11-18', 'RAWAT_JALAN', 'Poli THT', 45, 161, '047-22', 'ONLINE', 'APT-202611-0155', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-18 10:09:00', '2026-11-18 10:09:00', '2026-11-20 08:00:00', '2026-11-18 09:19:00', '2026-11-20 08:00:00'),
(164, 174, 'LAMA', 'REG202611030156', '2026-11-03', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 33, 162, '084-05', 'ONLINE', 'APT-202611-0156', 'Website RS', 'MENUNGGU', NULL, '2026-11-03 08:44:00', NULL, '2026-11-20 08:00:00', '2026-11-03 08:00:00', '2026-11-20 08:00:00'),
(165, 175, 'LAMA', 'REG202611050157', '2026-11-05', 'RAWAT_JALAN', 'Poli Jantung', 19, 163, '117-10', 'OFFLINE', 'APT-202611-0157', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-05 10:56:00', '2026-11-05 10:56:00', '2026-11-20 08:00:00', '2026-11-05 10:34:00', '2026-11-20 08:00:00'),
(166, 176, 'LAMA', 'REG202611180158', '2026-11-18', 'RAWAT_JALAN', 'Poli Anak', 26, 164, '052-22', 'ONLINE', 'APT-202611-0158', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 11:12:00', '2026-11-18 11:12:00', '2026-11-20 08:00:00', '2026-11-18 10:43:00', '2026-11-20 08:00:00'),
(167, 177, 'LAMA', 'REG202611180159', '2026-11-18', 'RAWAT_JALAN', 'Poli THT', 55, 165, '097-01', 'ONLINE', 'APT-202611-0159', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(168, 178, 'LAMA', 'REG202611300160', '2026-11-30', 'RAWAT_JALAN', 'LABORATORIUM PATOLOGI KLINIK (SENTRAL)', 59, 166, '141-07', 'OFFLINE', 'APT-202611-0160', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-30 08:38:00', NULL, '2026-11-20 08:00:00', '2026-11-30 08:14:00', '2026-11-20 08:00:00'),
(169, 179, 'LAMA', 'REG202611090161', '2026-11-09', 'RAWAT_JALAN', 'Poli Anak', 20, 167, '028-05', 'ONLINE', 'APT-202611-0161', 'Mobile JKN', 'SELESAI', NULL, '2026-11-09 11:16:00', '2026-11-09 11:16:00', '2026-11-20 08:00:00', '2026-11-09 10:29:00', '2026-11-20 08:00:00'),
(170, 180, 'LAMA', 'REG202611280162', '2026-11-28', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 10, 168, '089-15', 'ONLINE', 'APT-202611-0162', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(171, 181, 'LAMA', 'REG202611190163', '2026-11-19', 'RAWAT_JALAN', 'Poli Jantung', 51, 169, '136-14', 'ONLINE', 'APT-202611-0163', 'Mobile JKN', 'SELESAI', NULL, '2026-11-19 11:04:00', '2026-11-19 11:04:00', '2026-11-20 08:00:00', '2026-11-19 10:48:00', '2026-11-20 08:00:00'),
(172, 182, 'LAMA', 'REG202611240164', '2026-11-24', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 29, 170, '142-32', 'OFFLINE', 'APT-202611-0164', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(173, 183, 'LAMA', 'REG202611040165', '2026-11-04', 'RAWAT_JALAN', 'Poli Anak (Sore)', 22, 171, '112-12', 'ONLINE', 'APT-202611-0165', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-04 19:35:00', NULL, '2026-11-20 08:00:00', '2026-11-04 19:10:00', '2026-11-20 08:00:00'),
(174, 184, 'LAMA', 'REG202611250166', '2026-11-25', 'RAWAT_JALAN', 'PCR (LAB)', 59, 172, '108-03', 'OFFLINE', 'APT-202611-0166', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-25 13:52:00', '2026-11-25 13:52:00', '2026-11-20 08:00:00', '2026-11-25 13:36:00', '2026-11-20 08:00:00'),
(175, 185, 'LAMA', 'REG202611070167', '2026-11-07', 'RAWAT_JALAN', 'Poli Paru', 14, 173, '005-36', 'ONLINE', 'APT-202611-0167', 'Mobile JKN', 'SELESAI', NULL, '2026-11-07 08:54:00', '2026-11-07 08:54:00', '2026-11-20 08:00:00', '2026-11-07 08:16:00', '2026-11-20 08:00:00'),
(176, 186, 'LAMA', 'REG202611240168', '2026-11-24', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 51, 174, '137-10', 'ONLINE', 'APT-202611-0168', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-24 13:15:00', '2026-11-24 13:15:00', '2026-11-20 08:00:00', '2026-11-24 13:05:00', '2026-11-20 08:00:00'),
(177, 187, 'LAMA', 'REG202611230169', '2026-11-23', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 12, 175, '066-05', 'OFFLINE', 'APT-202611-0169', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-23 10:32:00', '2026-11-23 10:32:00', '2026-11-20 08:00:00', '2026-11-23 10:12:00', '2026-11-20 08:00:00'),
(178, 188, 'LAMA', 'REG202611180170', '2026-11-18', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 53, 176, '104-10', 'ONLINE', 'APT-202611-0170', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(179, 189, 'LAMA', 'REG202611230171', '2026-11-23', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 22, 177, '057-03', 'ONLINE', 'APT-202611-0171', 'Mobile JKN', 'SELESAI', NULL, '2026-11-23 10:27:00', '2026-11-23 10:27:00', '2026-11-20 08:00:00', '2026-11-23 10:11:00', '2026-11-20 08:00:00'),
(180, 190, 'LAMA', 'REG202611280172', '2026-11-28', 'RAWAT_JALAN', 'Matahari', 56, 178, '076-28', 'OFFLINE', 'APT-202611-0172', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-28 12:44:00', '2026-11-28 12:44:00', '2026-11-20 08:00:00', '2026-11-28 12:13:00', '2026-11-20 08:00:00'),
(181, 191, 'LAMA', 'REG202611140173', '2026-11-14', 'RAWAT_JALAN', 'Poli Paru (Eksekutif)', 14, 179, '024-19', 'OFFLINE', 'APT-202611-0173', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-14 11:17:00', '2026-11-14 11:17:00', '2026-11-20 08:00:00', '2026-11-14 10:36:00', '2026-11-20 08:00:00'),
(182, 192, 'LAMA', 'REG202611050174', '2026-11-05', 'RAWAT_JALAN', 'Poli Paru', 14, 180, '005-12', 'ONLINE', 'APT-202611-0174', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-05 13:14:00', '2026-11-05 13:14:00', '2026-11-20 08:00:00', '2026-11-05 12:30:00', '2026-11-20 08:00:00'),
(183, 193, 'LAMA', 'REG202611280175', '2026-11-28', 'RAWAT_JALAN', 'Poli Bedah', 49, 181, '144-32', 'OFFLINE', 'APT-202611-0175', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(184, 194, 'LAMA', 'REG202611270176', '2026-11-27', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 65, 182, '091-08', 'ONLINE', 'APT-202611-0176', 'Website RS', 'SELESAI', NULL, '2026-11-27 18:27:00', '2026-11-27 18:27:00', '2026-11-20 08:00:00', '2026-11-27 17:39:00', '2026-11-20 08:00:00'),
(185, 195, 'LAMA', 'REG202611240177', '2026-11-24', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 10, 183, '089-15', 'ONLINE', 'APT-202611-0177', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-24 13:30:00', NULL, '2026-11-20 08:00:00', '2026-11-24 12:40:00', '2026-11-20 08:00:00'),
(186, 196, 'LAMA', 'REG202611090178', '2026-11-09', 'RAWAT_JALAN', 'Poli Gigi Anak', 64, 184, '122-11', 'OFFLINE', 'APT-202611-0178', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-09 12:08:00', NULL, '2026-11-20 08:00:00', '2026-11-09 11:22:00', '2026-11-20 08:00:00'),
(187, 197, 'LAMA', 'REG202611110179', '2026-11-11', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 48, 185, '033-10', 'ONLINE', 'APT-202611-0179', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-11 14:49:00', NULL, '2026-11-20 08:00:00', '2026-11-11 14:04:00', '2026-11-20 08:00:00'),
(188, 198, 'LAMA', 'REG202611260180', '2026-11-26', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 48, 186, '040-08', 'OFFLINE', 'APT-202611-0180', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-26 11:16:00', '2026-11-26 11:16:00', '2026-11-20 08:00:00', '2026-11-26 11:05:00', '2026-11-20 08:00:00'),
(189, 199, 'LAMA', 'REG202611160181', '2026-11-16', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 44, 187, '129-34', 'OFFLINE', 'APT-202611-0181', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-16 09:46:00', '2026-11-16 09:46:00', '2026-11-20 08:00:00', '2026-11-16 09:23:00', '2026-11-20 08:00:00');
INSERT INTO `hms_patient_visits` (`id`, `patient_id`, `mr_type`, `registration_no`, `visit_date`, `visit_type`, `poli`, `doctor_id`, `appointment_id`, `queue_no`, `source`, `online_booking_token`, `registration_counter`, `status`, `called_at`, `served_at`, `completed_at`, `created_at`, `arrived_at`, `updated_at`) VALUES
(190, 200, 'LAMA', 'REG202611140182', '2026-11-14', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi (Eksekutif)', 57, 188, '059-04', 'OFFLINE', 'APT-202611-0182', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-14 11:06:00', '2026-11-14 11:06:00', '2026-11-20 08:00:00', '2026-11-14 10:11:00', '2026-11-20 08:00:00'),
(191, 201, 'LAMA', 'REG202611190183', '2026-11-19', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 28, 189, '105-36', 'ONLINE', 'APT-202611-0183', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-19 09:45:00', NULL, '2026-11-20 08:00:00', '2026-11-19 09:14:00', '2026-11-20 08:00:00'),
(192, 202, 'LAMA', 'REG202611230184', '2026-11-23', 'RAWAT_JALAN', 'Poli Fisioterapi', 24, 190, '114-13', 'ONLINE', 'APT-202611-0184', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(193, 203, 'LAMA', 'REG202611020185', '2026-11-02', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 40, 191, '113-26', 'ONLINE', 'APT-202611-0185', 'Website RS', 'SELESAI', NULL, '2026-11-02 11:06:00', '2026-11-02 11:06:00', '2026-11-20 08:00:00', '2026-11-02 10:11:00', '2026-11-20 08:00:00'),
(194, 204, 'LAMA', 'REG202611160186', '2026-11-16', 'RAWAT_JALAN', 'Tes P3K Tanpa Surat Sehat', 11, 192, '049-21', 'ONLINE', 'APT-202611-0186', 'Website RS', 'SELESAI', NULL, '2026-11-16 09:47:00', '2026-11-16 09:47:00', '2026-11-20 08:00:00', '2026-11-16 09:04:00', '2026-11-20 08:00:00'),
(195, 205, 'LAMA', 'REG202611230187', '2026-11-23', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 21, 193, '133-12', 'ONLINE', 'APT-202611-0187', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(196, 206, 'LAMA', 'REG202611050188', '2026-11-05', 'RAWAT_JALAN', 'Poli Anak', 12, 194, '003-06', 'ONLINE', 'APT-202611-0188', 'Website RS', 'SELESAI', NULL, '2026-11-05 09:35:00', '2026-11-05 09:35:00', '2026-11-20 08:00:00', '2026-11-05 09:14:00', '2026-11-20 08:00:00'),
(197, 207, 'LAMA', 'REG202611140189', '2026-11-14', 'RAWAT_JALAN', 'P. VK (Rajal)', 39, 195, '069-09', 'ONLINE', 'APT-202611-0189', 'Website RS', 'SELESAI', NULL, '2026-11-14 11:14:00', '2026-11-14 11:14:00', '2026-11-20 08:00:00', '2026-11-14 10:24:00', '2026-11-20 08:00:00'),
(198, 208, 'LAMA', 'REG202611120190', '2026-11-12', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 33, 196, '071-20', 'OFFLINE', 'APT-202611-0190', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(199, 209, 'LAMA', 'REG202611190191', '2026-11-19', 'RAWAT_JALAN', 'Poli Mata', 36, 197, '138-08', 'ONLINE', 'APT-202611-0191', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(200, 210, 'LAMA', 'REG202611210192', '2026-11-21', 'RAWAT_JALAN', 'Poli Penyakit Jiwa', 49, 198, '111-09', 'ONLINE', 'APT-202611-0192', 'Website RS', 'SELESAI', NULL, '2026-11-21 08:42:00', '2026-11-21 08:42:00', '2026-11-20 08:00:00', '2026-11-21 08:30:00', '2026-11-20 08:00:00'),
(201, 211, 'LAMA', 'REG202611250193', '2026-11-25', 'RAWAT_JALAN', 'Poli Paru (Eksekutif)', 62, 199, '016-18', 'ONLINE', 'APT-202611-0193', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(202, 212, 'LAMA', 'REG202611210194', '2026-11-21', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 53, 200, '104-15', 'ONLINE', 'APT-202611-0194', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(203, 213, 'LAMA', 'REG202611100195', '2026-11-10', 'RAWAT_JALAN', 'Poli Periodonti', 65, 201, '067-08', 'ONLINE', 'APT-202611-0195', 'Website RS', 'SELESAI', NULL, '2026-11-10 09:19:00', '2026-11-10 09:19:00', '2026-11-20 08:00:00', '2026-11-10 09:02:00', '2026-11-20 08:00:00'),
(204, 214, 'LAMA', 'REG202611090196', '2026-11-09', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 65, 202, '091-13', 'ONLINE', 'APT-202611-0196', 'Website RS', 'SELESAI', NULL, '2026-11-09 18:48:00', '2026-11-09 18:48:00', '2026-11-20 08:00:00', '2026-11-09 18:25:00', '2026-11-20 08:00:00'),
(205, 215, 'LAMA', 'REG202611130197', '2026-11-13', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 17, 203, '055-09', 'ONLINE', 'APT-202611-0197', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-13 14:09:00', '2026-11-13 14:09:00', '2026-11-20 08:00:00', '2026-11-13 13:23:00', '2026-11-20 08:00:00'),
(206, 216, 'LAMA', 'REG202611300198', '2026-11-30', 'RAWAT_JALAN', 'Poli Jantung', 19, 204, '117-03', 'ONLINE', 'APT-202611-0198', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-30 11:25:00', '2026-11-30 11:25:00', '2026-11-20 08:00:00', '2026-11-30 11:00:00', '2026-11-20 08:00:00'),
(207, 217, 'LAMA', 'REG202611250199', '2026-11-25', 'RAWAT_JALAN', 'Poli THT', 45, 205, '047-14', 'ONLINE', 'APT-202611-0199', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(208, 218, 'LAMA', 'REG202611240200', '2026-11-24', 'RAWAT_JALAN', 'Poli Mata', 56, 206, '126-08', 'ONLINE', 'APT-202611-0200', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(209, 219, 'LAMA', 'REG202612010201', '2026-12-01', 'RAWAT_JALAN', 'Poli Umum', 33, 207, '140-14', 'ONLINE', 'APT-202611-0201', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-12-01 09:55:00', NULL, '2026-11-20 08:00:00', '2026-12-01 09:32:00', '2026-11-20 08:00:00'),
(210, 220, 'LAMA', 'REG202611190202', '2026-11-19', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 17, 208, '008-11', 'ONLINE', 'APT-202611-0202', 'Mobile JKN', 'SELESAI', NULL, '2026-11-19 13:47:00', '2026-11-19 13:47:00', '2026-11-20 08:00:00', '2026-11-19 13:06:00', '2026-11-20 08:00:00'),
(211, 221, 'LAMA', 'REG202611170203', '2026-11-17', 'RAWAT_JALAN', 'Poli Anak (Sore)', 13, 209, '087-23', 'OFFLINE', 'APT-202611-0203', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-17 18:20:00', '2026-11-17 18:20:00', '2026-11-20 08:00:00', '2026-11-17 17:58:00', '2026-11-20 08:00:00'),
(212, 222, 'LAMA', 'REG202611110204', '2026-11-11', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 39, 210, '098-07', 'ONLINE', 'APT-202611-0204', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-11 10:40:00', '2026-11-11 10:40:00', '2026-11-20 08:00:00', '2026-11-11 10:27:00', '2026-11-20 08:00:00'),
(213, 223, 'LAMA', 'REG202611090205', '2026-11-09', 'RAWAT_JALAN', 'Poli Anak', 20, 211, '028-08', 'ONLINE', 'APT-202611-0205', 'Mobile JKN', 'SELESAI', NULL, '2026-11-09 12:34:00', '2026-11-09 12:34:00', '2026-11-20 08:00:00', '2026-11-09 11:47:00', '2026-11-20 08:00:00'),
(214, 224, 'LAMA', 'REG202611250206', '2026-11-25', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 20, 212, '013-03', 'ONLINE', 'APT-202611-0206', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(215, 225, 'LAMA', 'REG202611120207', '2026-11-12', 'RAWAT_JALAN', 'Poli Saraf', 11, 213, '002-13', 'ONLINE', 'APT-202611-0207', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(216, 226, 'LAMA', 'REG202611170208', '2026-11-17', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 18, 214, '119-07', 'ONLINE', 'APT-202611-0208', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(217, 227, 'LAMA', 'REG202611060209', '2026-11-06', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 60, 215, '121-12', 'OFFLINE', 'APT-202611-0209', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-06 09:21:00', '2026-11-06 09:21:00', '2026-11-20 08:00:00', '2026-11-06 08:47:00', '2026-11-20 08:00:00'),
(218, 228, 'LAMA', 'REG202611090210', '2026-11-09', 'RAWAT_JALAN', 'Poli Urologi', 51, 216, '036-02', 'ONLINE', 'APT-202611-0210', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(219, 229, 'LAMA', 'REG202611230211', '2026-11-23', 'RAWAT_JALAN', 'Poli Anak', 32, 217, '116-04', 'ONLINE', 'APT-202611-0211', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-23 09:23:00', '2026-11-23 09:23:00', '2026-11-20 08:00:00', '2026-11-23 08:49:00', '2026-11-20 08:00:00'),
(220, 230, 'LAMA', 'REG202611120212', '2026-11-12', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 56, 218, '072-28', 'OFFLINE', 'APT-202611-0212', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(221, 231, 'LAMA', 'REG202611040213', '2026-11-04', 'RAWAT_JALAN', 'Poli Rehabilitasi Medik', 61, 219, '023-14', 'ONLINE', 'APT-202611-0213', 'Mobile JKN', 'SELESAI', NULL, '2026-11-04 11:31:00', '2026-11-04 11:31:00', '2026-11-20 08:00:00', '2026-11-04 11:05:00', '2026-11-20 08:00:00'),
(222, 232, 'LAMA', 'REG202611260214', '2026-11-26', 'RAWAT_JALAN', 'Poli VCT', 33, 220, '109-12', 'ONLINE', 'APT-202611-0214', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(223, 233, 'LAMA', 'REG202611040215', '2026-11-04', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 13, 221, '063-11', 'ONLINE', 'APT-202611-0215', 'Website RS', 'SELESAI', NULL, '2026-11-04 18:38:00', '2026-11-04 18:38:00', '2026-11-20 08:00:00', '2026-11-04 17:54:00', '2026-11-20 08:00:00'),
(224, 234, 'LAMA', 'REG202611250216', '2026-11-25', 'RAWAT_JALAN', 'Poli Periodonti', 63, 222, '083-28', 'ONLINE', 'APT-202611-0216', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-25 10:07:00', '2026-11-25 10:07:00', '2026-11-20 08:00:00', '2026-11-25 09:52:00', '2026-11-20 08:00:00'),
(225, 235, 'LAMA', 'REG202611050217', '2026-11-05', 'RAWAT_JALAN', 'P. VK (Rajal)', 39, 223, '069-03', 'ONLINE', 'APT-202611-0217', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(226, 236, 'LAMA', 'REG202611090218', '2026-11-09', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 17, 224, '008-25', 'OFFLINE', 'APT-202611-0218', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-09 11:19:00', '2026-11-09 11:19:00', '2026-11-20 08:00:00', '2026-11-09 11:02:00', '2026-11-20 08:00:00'),
(227, 237, 'LAMA', 'REG202611100219', '2026-11-10', 'RAWAT_JALAN', 'Poli Anak (Sore)', 13, 225, '087-16', 'ONLINE', 'APT-202611-0219', 'Website RS', 'MENUNGGU', NULL, '2026-11-10 19:31:00', NULL, '2026-11-20 08:00:00', '2026-11-10 19:17:00', '2026-11-20 08:00:00'),
(228, 238, 'LAMA', 'REG202611160220', '2026-11-16', 'RAWAT_JALAN', 'Tes Dewan', 17, 226, '068-04', 'ONLINE', 'APT-202611-0220', 'Website RS', 'SELESAI', NULL, '2026-11-16 10:07:00', '2026-11-16 10:07:00', '2026-11-20 08:00:00', '2026-11-16 09:21:00', '2026-11-20 08:00:00'),
(229, 239, 'LAMA', 'REG202611040221', '2026-11-04', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 65, 227, '091-03', 'ONLINE', 'APT-202611-0221', 'Website RS', 'SELESAI', NULL, '2026-11-04 18:18:00', '2026-11-04 18:18:00', '2026-11-20 08:00:00', '2026-11-04 17:59:00', '2026-11-20 08:00:00'),
(230, 240, 'LAMA', 'REG202611160222', '2026-11-16', 'RAWAT_JALAN', 'RADIOLOGI', 46, 228, '120-19', 'ONLINE', 'APT-202611-0222', 'Mobile JKN', 'SELESAI', NULL, '2026-11-16 19:23:00', '2026-11-16 19:23:00', '2026-11-20 08:00:00', '2026-11-16 19:09:00', '2026-11-20 08:00:00'),
(231, 241, 'LAMA', 'REG202611030223', '2026-11-03', 'RAWAT_JALAN', 'Poli Umum', 60, 229, '124-20', 'ONLINE', 'APT-202611-0223', 'Mobile JKN', 'SELESAI', NULL, '2026-11-03 12:57:00', '2026-11-03 12:57:00', '2026-11-20 08:00:00', '2026-11-03 12:29:00', '2026-11-20 08:00:00'),
(232, 242, 'LAMA', 'REG202611130224', '2026-11-13', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 17, 230, '055-15', 'ONLINE', 'APT-202611-0224', 'Website RS', 'SELESAI', NULL, '2026-11-13 12:57:00', '2026-11-13 12:57:00', '2026-11-20 08:00:00', '2026-11-13 12:32:00', '2026-11-20 08:00:00'),
(233, 243, 'LAMA', 'REG202611060225', '2026-11-06', 'RAWAT_JALAN', 'Poli Mata', 36, 231, '138-01', 'ONLINE', 'APT-202611-0225', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(234, 244, 'LAMA', 'REG202612020226', '2026-12-02', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 13, 232, '063-10', 'ONLINE', 'APT-202611-0226', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(235, 245, 'LAMA', 'REG202611060227', '2026-11-06', 'RAWAT_JALAN', 'Poli Umum', 21, 233, '014-34', 'OFFLINE', 'APT-202611-0227', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-06 09:54:00', '2026-11-06 09:54:00', '2026-11-20 08:00:00', '2026-11-06 09:30:00', '2026-11-20 08:00:00'),
(236, 246, 'LAMA', 'REG202611060228', '2026-11-06', 'RAWAT_JALAN', 'PCR (LAB)', 59, 234, '108-03', 'ONLINE', 'APT-202611-0228', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(237, 247, 'LAMA', 'REG202612020229', '2026-12-02', 'RAWAT_JALAN', 'Poli Rehabilitasi Medik', 61, 235, '023-21', 'ONLINE', 'APT-202611-0229', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(238, 248, 'LAMA', 'REG202611260230', '2026-11-26', 'RAWAT_JALAN', 'Poli Urologi', 51, 236, '036-29', 'OFFLINE', 'APT-202611-0230', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-26 09:56:00', '2026-11-26 09:56:00', '2026-11-20 08:00:00', '2026-11-26 09:36:00', '2026-11-20 08:00:00'),
(239, 249, 'LAMA', 'REG202611160231', '2026-11-16', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 24, 237, '044-09', 'ONLINE', 'APT-202611-0231', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(240, 250, 'LAMA', 'REG202611040232', '2026-11-04', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 44, 238, '046-08', 'ONLINE', 'APT-202611-0232', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-04 09:54:00', '2026-11-04 09:54:00', '2026-11-20 08:00:00', '2026-11-04 09:39:00', '2026-11-20 08:00:00'),
(241, 251, 'LAMA', 'REG202612010233', '2026-12-01', 'RAWAT_JALAN', 'Tes Dewan', 33, 239, '038-18', 'ONLINE', 'APT-202611-0233', 'Mobile JKN', 'SELESAI', NULL, '2026-12-01 09:37:00', '2026-12-01 09:37:00', '2026-11-20 08:00:00', '2026-12-01 08:59:00', '2026-11-20 08:00:00'),
(242, 252, 'LAMA', 'REG202611020234', '2026-11-02', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 48, 240, '040-14', 'OFFLINE', 'APT-202611-0234', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-02 09:20:00', '2026-11-02 09:20:00', '2026-11-20 08:00:00', '2026-11-02 08:58:00', '2026-11-20 08:00:00'),
(243, 253, 'LAMA', 'REG202612010235', '2026-12-01', 'RAWAT_JALAN', 'Tes Dewan', 33, 241, '038-21', 'ONLINE', 'APT-202611-0235', 'Aplikasi RS', 'SELESAI', NULL, '2026-12-01 08:09:00', '2026-12-01 08:09:00', '2026-11-20 08:00:00', '2026-12-01 07:47:00', '2026-11-20 08:00:00'),
(244, 254, 'LAMA', 'REG202611030236', '2026-11-03', 'RAWAT_JALAN', 'Poli Rehabilitasi Medik', 24, 242, '118-16', 'ONLINE', 'APT-202611-0236', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-03 10:20:00', NULL, '2026-11-20 08:00:00', '2026-11-03 09:45:00', '2026-11-20 08:00:00'),
(245, 255, 'LAMA', 'REG202611090237', '2026-11-09', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 24, 243, '102-02', 'OFFLINE', 'APT-202611-0237', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-09 10:02:00', '2026-11-09 10:02:00', '2026-11-20 08:00:00', '2026-11-09 09:43:00', '2026-11-20 08:00:00'),
(246, 256, 'LAMA', 'REG202611040238', '2026-11-04', 'RAWAT_JALAN', 'Tes Dewan', 45, 244, '085-27', 'ONLINE', 'APT-202611-0238', 'Website RS', 'SELESAI', NULL, '2026-11-04 08:31:00', '2026-11-04 08:31:00', '2026-11-20 08:00:00', '2026-11-04 08:13:00', '2026-11-20 08:00:00'),
(247, 257, 'LAMA', 'REG202611170239', '2026-11-17', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 31, 245, '019-12', 'ONLINE', 'APT-202611-0239', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(248, 258, 'LAMA', 'REG202611100240', '2026-11-10', 'RAWAT_JALAN', 'Poli Jantung', 16, 246, '093-17', 'ONLINE', 'APT-202611-0240', 'Website RS', 'SELESAI', NULL, '2026-11-10 08:55:00', '2026-11-10 08:55:00', '2026-11-20 08:00:00', '2026-11-10 08:15:00', '2026-11-20 08:00:00'),
(249, 259, 'LAMA', 'REG202611110241', '2026-11-11', 'RAWAT_JALAN', 'Poli Penyakit Jiwa', 49, 247, '111-02', 'ONLINE', 'APT-202611-0241', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(250, 260, 'LAMA', 'REG202611090242', '2026-11-09', 'RAWAT_JALAN', 'Poli Anak', 20, 248, '028-01', 'ONLINE', 'APT-202611-0242', 'Website RS', 'SELESAI', NULL, '2026-11-09 13:47:00', '2026-11-09 13:47:00', '2026-11-20 08:00:00', '2026-11-09 13:00:00', '2026-11-20 08:00:00'),
(251, 261, 'LAMA', 'REG202611190243', '2026-11-19', 'RAWAT_JALAN', 'Poli Mata', 56, 249, '126-02', 'ONLINE', 'APT-202611-0243', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-19 10:56:00', '2026-11-19 10:56:00', '2026-11-20 08:00:00', '2026-11-19 10:44:00', '2026-11-20 08:00:00'),
(252, 262, 'LAMA', 'REG202611030244', '2026-11-03', 'RAWAT_JALAN', 'Poli Periodonti', 65, 250, '067-11', 'OFFLINE', 'APT-202611-0244', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-03 08:59:00', NULL, '2026-11-20 08:00:00', '2026-11-03 08:41:00', '2026-11-20 08:00:00'),
(253, 263, 'LAMA', 'REG202611270245', '2026-11-27', 'RAWAT_JALAN', 'PCR (LAB)', 59, 251, '108-12', 'ONLINE', 'APT-202611-0245', 'Website RS', 'MENUNGGU', NULL, '2026-11-27 09:05:00', NULL, '2026-11-20 08:00:00', '2026-11-27 08:51:00', '2026-11-20 08:00:00'),
(254, 264, 'LAMA', 'REG202611090246', '2026-11-09', 'RAWAT_JALAN', 'Poli Paru', 15, 252, '074-13', 'OFFLINE', 'APT-202611-0246', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(255, 265, 'LAMA', 'REG202611300247', '2026-11-30', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Sore)', 65, 253, '091-05', 'ONLINE', 'APT-202611-0247', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(256, 266, 'LAMA', 'REG202612020248', '2026-12-02', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 36, 254, '088-11', 'ONLINE', 'APT-202611-0248', 'Website RS', 'SELESAI', NULL, '2026-12-02 11:59:00', '2026-12-02 11:59:00', '2026-11-20 08:00:00', '2026-12-02 11:11:00', '2026-11-20 08:00:00'),
(257, 267, 'LAMA', 'REG202611100249', '2026-11-10', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 13, 255, '022-29', 'OFFLINE', 'APT-202611-0249', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-10 11:03:00', '2026-11-10 11:03:00', '2026-11-20 08:00:00', '2026-11-10 10:13:00', '2026-11-20 08:00:00'),
(258, 268, 'LAMA', 'REG202611240250', '2026-11-24', 'RAWAT_JALAN', 'Poli Dalam Sub. Gastroenterohepatologi', 47, 256, '042-01', 'ONLINE', 'APT-202611-0250', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-24 08:11:00', '2026-11-24 08:11:00', '2026-11-20 08:00:00', '2026-11-24 07:55:00', '2026-11-20 08:00:00'),
(259, 269, 'LAMA', 'REG202611160251', '2026-11-16', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 49, 257, '018-27', 'ONLINE', 'APT-202611-0251', 'Website RS', 'MENUNGGU', NULL, '2026-11-16 10:44:00', NULL, '2026-11-20 08:00:00', '2026-11-16 10:28:00', '2026-11-20 08:00:00'),
(260, 270, 'LAMA', 'REG202611270252', '2026-11-27', 'RAWAT_JALAN', 'Poli Umum', 45, 258, '095-17', 'ONLINE', 'APT-202611-0252', 'Mobile JKN', 'SELESAI', NULL, '2026-11-27 08:53:00', '2026-11-27 08:53:00', '2026-11-20 08:00:00', '2026-11-27 08:23:00', '2026-11-20 08:00:00'),
(261, 271, 'LAMA', 'REG202611250253', '2026-11-25', 'RAWAT_JALAN', 'Poli Saraf', 10, 259, '026-10', 'ONLINE', 'APT-202611-0253', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-25 09:00:00', NULL, '2026-11-20 08:00:00', '2026-11-25 08:29:00', '2026-11-20 08:00:00'),
(262, 272, 'LAMA', 'REG202611030254', '2026-11-03', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 60, 260, '110-07', 'OFFLINE', 'APT-202611-0254', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-03 09:05:00', '2026-11-03 09:05:00', '2026-11-20 08:00:00', '2026-11-03 08:43:00', '2026-11-20 08:00:00'),
(263, 273, 'LAMA', 'REG202611200255', '2026-11-20', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 51, 261, '137-05', 'OFFLINE', 'APT-202611-0255', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(264, 274, 'LAMA', 'REG202611180256', '2026-11-18', 'RAWAT_JALAN', 'Tes Dewan', 60, 262, '034-06', 'ONLINE', 'APT-202611-0256', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 08:20:00', '2026-11-18 08:20:00', '2026-11-20 08:00:00', '2026-11-18 07:57:00', '2026-11-20 08:00:00'),
(265, 275, 'LAMA', 'REG202611170257', '2026-11-17', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 13, 263, '022-06', 'ONLINE', 'APT-202611-0257', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-17 10:50:00', '2026-11-17 10:50:00', '2026-11-20 08:00:00', '2026-11-17 10:16:00', '2026-11-20 08:00:00'),
(266, 276, 'LAMA', 'REG202611160258', '2026-11-16', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 42, 264, '062-10', 'ONLINE', 'APT-202611-0258', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-16 11:15:00', '2026-11-16 11:15:00', '2026-11-20 08:00:00', '2026-11-16 10:48:00', '2026-11-20 08:00:00'),
(267, 277, 'LAMA', 'REG202611270259', '2026-11-27', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi (Eksekutif)', 19, 265, '011-25', 'ONLINE', 'APT-202611-0259', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(268, 278, 'LAMA', 'REG202611190260', '2026-11-19', 'RAWAT_JALAN', 'Poli Kulit & Kelamin', 55, 266, '053-05', 'ONLINE', 'APT-202611-0260', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-19 13:33:00', NULL, '2026-11-20 08:00:00', '2026-11-19 12:53:00', '2026-11-20 08:00:00'),
(269, 279, 'LAMA', 'REG202611270261', '2026-11-27', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 23, 267, '125-20', 'ONLINE', 'APT-202611-0261', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(270, 280, 'LAMA', 'REG202611270262', '2026-11-27', 'RAWAT_JALAN', 'Poli Bedah', 44, 268, '039-03', 'ONLINE', 'APT-202611-0262', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-27 09:33:00', '2026-11-27 09:33:00', '2026-11-20 08:00:00', '2026-11-27 08:56:00', '2026-11-20 08:00:00'),
(271, 281, 'LAMA', 'REG202611130263', '2026-11-13', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 24, 269, '102-13', 'OFFLINE', 'APT-202611-0263', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-13 09:31:00', '2026-11-13 09:31:00', '2026-11-20 08:00:00', '2026-11-13 08:46:00', '2026-11-20 08:00:00'),
(272, 282, 'LAMA', 'REG202611190264', '2026-11-19', 'RAWAT_JALAN', 'Poli Urologi', 50, 270, '060-10', 'ONLINE', 'APT-202611-0264', 'Mobile JKN', 'SELESAI', NULL, '2026-11-19 11:54:00', '2026-11-19 11:54:00', '2026-11-20 08:00:00', '2026-11-19 11:35:00', '2026-11-20 08:00:00'),
(273, 283, 'LAMA', 'REG202611160265', '2026-11-16', 'RAWAT_JALAN', 'Tes P3K Tanpa Surat Sehat', 11, 271, '049-32', 'ONLINE', 'APT-202611-0265', 'Mobile JKN', 'SELESAI', NULL, '2026-11-16 12:20:00', '2026-11-16 12:20:00', '2026-11-20 08:00:00', '2026-11-16 11:29:00', '2026-11-20 08:00:00'),
(274, 284, 'LAMA', 'REG202611230266', '2026-11-23', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 23, 272, '125-02', 'OFFLINE', 'APT-202611-0266', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(275, 285, 'LAMA', 'REG202611100267', '2026-11-10', 'RAWAT_JALAN', 'Poli Saraf', 10, 273, '026-14', 'OFFLINE', 'APT-202611-0267', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-10 12:26:00', '2026-11-10 12:26:00', '2026-11-20 08:00:00', '2026-11-10 11:55:00', '2026-11-20 08:00:00'),
(276, 286, 'LAMA', 'REG202611300268', '2026-11-30', 'RAWAT_JALAN', 'Poli Jantung (Eksekutif)', 52, 274, '056-13', 'OFFLINE', 'APT-202611-0268', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-30 10:30:00', '2026-11-30 10:30:00', '2026-11-20 08:00:00', '2026-11-30 09:52:00', '2026-11-20 08:00:00'),
(277, 287, 'LAMA', 'REG202611090269', '2026-11-09', 'RAWAT_JALAN', 'Poli Paru (Eksekutif)', 62, 275, '016-17', 'ONLINE', 'APT-202611-0269', 'Mobile JKN', 'SELESAI', NULL, '2026-11-09 10:35:00', '2026-11-09 10:35:00', '2026-11-20 08:00:00', '2026-11-09 09:54:00', '2026-11-20 08:00:00'),
(278, 288, 'LAMA', 'REG202611170270', '2026-11-17', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 33, 276, '084-03', 'ONLINE', 'APT-202611-0270', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-17 09:31:00', NULL, '2026-11-20 08:00:00', '2026-11-17 09:20:00', '2026-11-20 08:00:00'),
(279, 289, 'LAMA', 'REG202611030271', '2026-11-03', 'RAWAT_JALAN', 'Poli VCT', 33, 277, '109-04', 'OFFLINE', 'APT-202611-0271', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(280, 290, 'LAMA', 'REG202611240272', '2026-11-24', 'RAWAT_JALAN', 'Poli Jantung', 35, 278, '086-20', 'ONLINE', 'APT-202611-0272', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-24 09:16:00', '2026-11-24 09:16:00', '2026-11-20 08:00:00', '2026-11-24 08:35:00', '2026-11-20 08:00:00'),
(281, 291, 'LAMA', 'REG202611250273', '2026-11-25', 'RAWAT_JALAN', 'Poli Kandungan', 53, 279, '045-03', 'ONLINE', 'APT-202611-0273', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(282, 292, 'LAMA', 'REG202611300274', '2026-11-30', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 65, 280, '132-04', 'OFFLINE', 'APT-202611-0274', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(283, 293, 'LAMA', 'REG202611190275', '2026-11-19', 'RAWAT_JALAN', 'Poli Kandungan', 18, 281, '010-13', 'ONLINE', 'APT-202611-0275', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-19 11:57:00', '2026-11-19 11:57:00', '2026-11-20 08:00:00', '2026-11-19 11:09:00', '2026-11-20 08:00:00'),
(284, 294, 'LAMA', 'REG202611180276', '2026-11-18', 'RAWAT_JALAN', 'Poli Anak (Sore)', 22, 282, '112-04', 'OFFLINE', 'APT-202611-0276', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-18 18:06:00', '2026-11-18 18:06:00', '2026-11-20 08:00:00', '2026-11-18 17:40:00', '2026-11-20 08:00:00'),
(285, 295, 'LAMA', 'REG202611180277', '2026-11-18', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi (Eksekutif)', 57, 283, '059-10', 'ONLINE', 'APT-202611-0277', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-18 14:12:00', NULL, '2026-11-20 08:00:00', '2026-11-18 13:24:00', '2026-11-20 08:00:00'),
(286, 296, 'LAMA', 'REG202611300278', '2026-11-30', 'RAWAT_JALAN', 'Poli Umum', 17, 284, '099-10', 'ONLINE', 'APT-202611-0278', 'Mobile JKN', 'SELESAI', NULL, '2026-11-30 10:37:00', '2026-11-30 10:37:00', '2026-11-20 08:00:00', '2026-11-30 10:15:00', '2026-11-20 08:00:00'),
(287, 297, 'LAMA', 'REG202611250279', '2026-11-25', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 63, 285, '065-08', 'OFFLINE', 'APT-202611-0279', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(288, 298, 'LAMA', 'REG202611210280', '2026-11-21', 'RAWAT_JALAN', 'Poli Umum', 15, 286, '123-15', 'OFFLINE', 'APT-202611-0280', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-21 11:49:00', NULL, '2026-11-20 08:00:00', '2026-11-21 11:18:00', '2026-11-20 08:00:00'),
(289, 299, 'LAMA', 'REG202611110281', '2026-11-11', 'RAWAT_JALAN', 'Poli Anak Sub. Kardiologi', 47, 287, '079-03', 'ONLINE', 'APT-202611-0281', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(290, 300, 'LAMA', 'REG202611090282', '2026-11-09', 'RAWAT_JALAN', 'Poli Bedah (Eksekutif)', 48, 288, '040-13', 'OFFLINE', 'APT-202611-0282', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-09 11:00:00', '2026-11-09 11:00:00', '2026-11-20 08:00:00', '2026-11-09 10:24:00', '2026-11-20 08:00:00'),
(291, 301, 'LAMA', 'REG202611040283', '2026-11-04', 'RAWAT_JALAN', 'Poli Jantung', 48, 289, '103-03', 'ONLINE', 'APT-202611-0283', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-04 12:13:00', NULL, '2026-11-20 08:00:00', '2026-11-04 11:24:00', '2026-11-20 08:00:00'),
(292, 302, 'LAMA', 'REG202611190284', '2026-11-19', 'RAWAT_JALAN', 'Poli Penyakit Mulut', 65, 290, '127-02', 'ONLINE', 'APT-202611-0284', 'Aplikasi RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(293, 303, 'LAMA', 'REG202611060285', '2026-11-06', 'RAWAT_JALAN', 'Poli Paru (Eksekutif)', 62, 291, '016-06', 'ONLINE', 'APT-202611-0285', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(294, 304, 'LAMA', 'REG202611040286', '2026-11-04', 'RAWAT_JALAN', 'P. VK (Rajal)', 18, 292, '021-19', 'ONLINE', 'APT-202611-0286', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-04 11:29:00', '2026-11-04 11:29:00', '2026-11-20 08:00:00', '2026-11-04 11:09:00', '2026-11-20 08:00:00'),
(295, 305, 'LAMA', 'REG202611230287', '2026-11-23', 'RAWAT_JALAN', 'Poli Urologi', 51, 293, '036-28', 'ONLINE', 'APT-202611-0287', 'WhatsApp Reservasi', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(296, 306, 'LAMA', 'REG202611020288', '2026-11-02', 'RAWAT_JALAN', 'Poli Paru', 62, 294, '115-01', 'ONLINE', 'APT-202611-0288', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-02 10:42:00', NULL, '2026-11-20 08:00:00', '2026-11-02 10:31:00', '2026-11-20 08:00:00'),
(297, 307, 'LAMA', 'REG202611160289', '2026-11-16', 'RAWAT_JALAN', 'Poli Urologi', 51, 295, '036-05', 'OFFLINE', 'APT-202611-0289', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-16 13:31:00', NULL, '2026-11-20 08:00:00', '2026-11-16 13:11:00', '2026-11-20 08:00:00'),
(298, 308, 'LAMA', 'REG202611180290', '2026-11-18', 'RAWAT_JALAN', 'Hemodialisa', 24, 296, '027-22', 'OFFLINE', 'APT-202611-0290', 'Loket Pendaftaran', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(299, 309, 'LAMA', 'REG202611270291', '2026-11-27', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 21, 297, '133-12', 'ONLINE', 'APT-202611-0291', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-27 12:09:00', '2026-11-27 12:09:00', '2026-11-20 08:00:00', '2026-11-27 11:45:00', '2026-11-20 08:00:00'),
(300, 310, 'LAMA', 'REG202611050292', '2026-11-05', 'RAWAT_JALAN', 'Poli Kandungan', 18, 298, '010-11', 'ONLINE', 'APT-202611-0292', 'WhatsApp Reservasi', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(301, 311, 'LAMA', 'REG202611230293', '2026-11-23', 'RAWAT_JALAN', 'Poli THT', 55, 299, '097-04', 'ONLINE', 'APT-202611-0293', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(302, 312, 'LAMA', 'REG202611050294', '2026-11-05', 'RAWAT_JALAN', 'Poli Dalam Sub. Gastroenterohepatologi', 47, 300, '042-10', 'ONLINE', 'APT-202611-0294', 'Mobile JKN', 'SELESAI', NULL, '2026-11-05 13:09:00', '2026-11-05 13:09:00', '2026-11-20 08:00:00', '2026-11-05 12:15:00', '2026-11-20 08:00:00'),
(303, 313, 'LAMA', 'REG202611110295', '2026-11-11', 'RAWAT_JALAN', 'Poli VCT', 24, 301, '130-27', 'ONLINE', 'APT-202611-0295', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(304, 314, 'LAMA', 'REG202611170296', '2026-11-17', 'RAWAT_JALAN', 'Poli Anak (Sore)', 20, 302, '020-17', 'OFFLINE', 'APT-202611-0296', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-17 17:03:00', NULL, '2026-11-20 08:00:00', '2026-11-17 16:37:00', '2026-11-20 08:00:00'),
(305, 315, 'LAMA', 'REG202611190297', '2026-11-19', 'RAWAT_JALAN', 'Poli Fisioterapi', 61, 303, '143-04', 'ONLINE', 'APT-202611-0297', 'Mobile JKN', 'SELESAI', NULL, '2026-11-19 13:50:00', '2026-11-19 13:50:00', '2026-11-20 08:00:00', '2026-11-19 13:19:00', '2026-11-20 08:00:00'),
(306, 316, 'LAMA', 'REG202611230298', '2026-11-23', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi', 19, 304, '075-03', 'OFFLINE', 'APT-202611-0298', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-23 11:28:00', '2026-11-23 11:28:00', '2026-11-20 08:00:00', '2026-11-23 10:46:00', '2026-11-20 08:00:00'),
(307, 317, 'LAMA', 'REG202611170299', '2026-11-17', 'RAWAT_JALAN', 'Poli Jantung', 35, 305, '086-10', 'OFFLINE', 'APT-202611-0299', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-17 08:40:00', '2026-11-17 08:40:00', '2026-11-20 08:00:00', '2026-11-17 08:28:00', '2026-11-20 08:00:00'),
(308, 318, 'LAMA', 'REG202612010300', '2026-12-01', 'RAWAT_JALAN', 'Poli Saraf (Eksekutif)', 25, 306, '101-21', 'OFFLINE', 'APT-202611-0300', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(309, 319, 'LAMA', 'REG202611130301', '2026-11-13', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 10, 307, '089-07', 'ONLINE', 'APT-202611-0301', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-13 12:31:00', '2026-11-13 12:31:00', '2026-11-20 08:00:00', '2026-11-13 12:14:00', '2026-11-20 08:00:00'),
(310, 320, 'LAMA', 'REG202611240302', '2026-11-24', 'RAWAT_JALAN', 'Poli VCT', 33, 308, '109-12', 'ONLINE', 'APT-202611-0302', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-24 10:02:00', '2026-11-24 10:02:00', '2026-11-20 08:00:00', '2026-11-24 09:08:00', '2026-11-20 08:00:00'),
(311, 321, 'LAMA', 'REG202611280303', '2026-11-28', 'RAWAT_JALAN', 'Poli Paru (Eksekutif)', 14, 309, '024-15', 'ONLINE', 'APT-202611-0303', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(312, 322, 'LAMA', 'REG202611170304', '2026-11-17', 'RAWAT_JALAN', 'Poli Penyakit Dalam (Eksekutif)', 24, 310, '012-01', 'OFFLINE', 'APT-202611-0304', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-17 14:48:00', '2026-11-17 14:48:00', '2026-11-20 08:00:00', '2026-11-17 14:10:00', '2026-11-20 08:00:00'),
(313, 323, 'LAMA', 'REG202611260305', '2026-11-26', 'RAWAT_JALAN', 'Poli Paru Sub. Onkologi Toraks', 37, 311, '134-19', 'OFFLINE', 'APT-202611-0305', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(314, 324, 'LAMA', 'REG202611170306', '2026-11-17', 'RAWAT_JALAN', 'Poli Saraf', 10, 312, '026-11', 'ONLINE', 'APT-202611-0306', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(315, 325, 'LAMA', 'REG202611190307', '2026-11-19', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 26, 313, '094-28', 'ONLINE', 'APT-202611-0307', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(316, 326, 'LAMA', 'REG202611100308', '2026-11-10', 'RAWAT_JALAN', 'Poli Jantung', 16, 314, '093-21', 'ONLINE', 'APT-202611-0308', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-10 09:16:00', NULL, '2026-11-20 08:00:00', '2026-11-10 08:31:00', '2026-11-20 08:00:00'),
(317, 327, 'LAMA', 'REG202611270309', '2026-11-27', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 45, 315, '070-06', 'ONLINE', 'APT-202611-0309', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-27 13:33:00', '2026-11-27 13:33:00', '2026-11-20 08:00:00', '2026-11-27 12:55:00', '2026-11-20 08:00:00'),
(318, 328, 'LAMA', 'REG202611040310', '2026-11-04', 'RAWAT_JALAN', 'Matahari', 56, 316, '076-39', 'ONLINE', 'APT-202611-0310', 'Website RS', 'MENUNGGU', NULL, '2026-11-04 10:42:00', NULL, '2026-11-20 08:00:00', '2026-11-04 10:27:00', '2026-11-20 08:00:00'),
(319, 329, 'LAMA', 'REG202611120311', '2026-11-12', 'RAWAT_JALAN', 'Poli Anak', 18, 317, '043-11', 'OFFLINE', 'APT-202611-0311', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-12 10:01:00', '2026-11-12 10:01:00', '2026-11-20 08:00:00', '2026-11-12 09:22:00', '2026-11-20 08:00:00'),
(320, 330, 'LAMA', 'REG202611020312', '2026-11-02', 'RAWAT_JALAN', 'Poli Urologi', 51, 318, '036-36', 'ONLINE', 'APT-202611-0312', 'Mobile JKN', 'SELESAI', NULL, '2026-11-02 12:37:00', '2026-11-02 12:37:00', '2026-11-20 08:00:00', '2026-11-02 12:09:00', '2026-11-20 08:00:00'),
(321, 331, 'LAMA', 'REG202611050313', '2026-11-05', 'RAWAT_JALAN', 'Tes P3K Tanpa Surat Sehat', 11, 319, '049-08', 'ONLINE', 'APT-202611-0313', 'Aplikasi RS', 'MENUNGGU', NULL, '2026-11-05 10:19:00', NULL, '2026-11-20 08:00:00', '2026-11-05 09:57:00', '2026-11-20 08:00:00'),
(322, 332, 'LAMA', 'REG202611260314', '2026-11-26', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 56, 320, '072-19', 'ONLINE', 'APT-202611-0314', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-26 12:40:00', '2026-11-26 12:40:00', '2026-11-20 08:00:00', '2026-11-26 11:47:00', '2026-11-20 08:00:00'),
(323, 333, 'LAMA', 'REG202611270315', '2026-11-27', 'RAWAT_JALAN', 'Poli Umum Tes Kesehatan P3K', 45, 321, '058-16', 'ONLINE', 'APT-202611-0315', 'Website RS', 'MENUNGGU', NULL, '2026-11-27 09:31:00', NULL, '2026-11-20 08:00:00', '2026-11-27 08:44:00', '2026-11-20 08:00:00'),
(324, 334, 'LAMA', 'REG202611230316', '2026-11-23', 'RAWAT_JALAN', 'Poli Umum', 21, 322, '014-39', 'OFFLINE', 'APT-202611-0316', 'Loket Pendaftaran', 'MENUNGGU', NULL, '2026-11-23 10:49:00', NULL, '2026-11-20 08:00:00', '2026-11-23 10:13:00', '2026-11-20 08:00:00'),
(325, 335, 'LAMA', 'REG202611060317', '2026-11-06', 'RAWAT_JALAN', 'Poli VCT', 24, 323, '130-27', 'ONLINE', 'APT-202611-0317', 'Website RS', 'MENUNGGU', NULL, '2026-11-06 12:07:00', NULL, '2026-11-20 08:00:00', '2026-11-06 11:38:00', '2026-11-20 08:00:00'),
(326, 336, 'LAMA', 'REG202611230318', '2026-11-23', 'RAWAT_JALAN', 'Poli Kandungan (Eksekutif)', 12, 324, '066-05', 'ONLINE', 'APT-202611-0318', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(327, 337, 'LAMA', 'REG202611190319', '2026-11-19', 'RAWAT_JALAN', 'Poli Umum', 58, 325, '096-27', 'ONLINE', 'APT-202611-0319', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-19 12:38:00', NULL, '2026-11-20 08:00:00', '2026-11-19 11:46:00', '2026-11-20 08:00:00'),
(328, 338, 'LAMA', 'REG202611140320', '2026-11-14', 'RAWAT_JALAN', 'Tes Dewan', 45, 326, '085-18', 'OFFLINE', 'APT-202611-0320', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-14 08:44:00', '2026-11-14 08:44:00', '2026-11-20 08:00:00', '2026-11-14 08:22:00', '2026-11-20 08:00:00'),
(329, 339, 'LAMA', 'REG202611090321', '2026-11-09', 'RAWAT_JALAN', 'Poli Saraf', 30, 327, '064-27', 'ONLINE', 'APT-202611-0321', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-09 11:51:00', NULL, '2026-11-20 08:00:00', '2026-11-09 11:19:00', '2026-11-20 08:00:00'),
(330, 340, 'LAMA', 'REG202611140322', '2026-11-14', 'RAWAT_JALAN', 'Poli Kulit & Kelamin (Eksekutif)', 49, 328, '029-22', 'ONLINE', 'APT-202611-0322', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-14 14:47:00', NULL, '2026-11-20 08:00:00', '2026-11-14 13:53:00', '2026-11-20 08:00:00'),
(331, 341, 'LAMA', 'REG202611190323', '2026-11-19', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 41, 329, '092-20', 'ONLINE', 'APT-202611-0323', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-19 08:40:00', '2026-11-19 08:40:00', '2026-11-20 08:00:00', '2026-11-19 08:18:00', '2026-11-20 08:00:00'),
(332, 342, 'LAMA', 'REG202611270324', '2026-11-27', 'RAWAT_JALAN', 'Poli Anak (Eksekutif)', 12, 330, '015-03', 'ONLINE', 'APT-202611-0324', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-27 12:03:00', '2026-11-27 12:03:00', '2026-11-20 08:00:00', '2026-11-27 11:42:00', '2026-11-20 08:00:00'),
(333, 343, 'LAMA', 'REG202611120325', '2026-11-12', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 28, 331, '105-38', 'ONLINE', 'APT-202611-0325', 'Mobile JKN', 'SELESAI', NULL, '2026-11-12 12:47:00', '2026-11-12 12:47:00', '2026-11-20 08:00:00', '2026-11-12 12:27:00', '2026-11-20 08:00:00'),
(334, 344, 'LAMA', 'REG202611090326', '2026-11-09', 'RAWAT_JALAN', 'Poli Kandungan', 39, 332, '080-40', 'ONLINE', 'APT-202611-0326', 'WhatsApp Reservasi', 'MENUNGGU', NULL, '2026-11-09 10:43:00', NULL, '2026-11-20 08:00:00', '2026-11-09 09:53:00', '2026-11-20 08:00:00'),
(335, 345, 'LAMA', 'REG202611200327', '2026-11-20', 'RAWAT_JALAN', 'Poli Umum', 33, 333, '140-17', 'ONLINE', 'APT-202611-0327', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-20 11:14:00', '2026-11-20 11:14:00', '2026-11-20 08:00:00', '2026-11-20 11:00:00', '2026-11-20 08:00:00'),
(336, 346, 'LAMA', 'REG202611090328', '2026-11-09', 'RAWAT_JALAN', 'Poli VCT', 24, 334, '130-07', 'ONLINE', 'APT-202611-0328', 'Website RS', 'SELESAI', NULL, '2026-11-09 11:15:00', '2026-11-09 11:15:00', '2026-11-20 08:00:00', '2026-11-09 10:47:00', '2026-11-20 08:00:00'),
(337, 347, 'LAMA', 'REG202611160329', '2026-11-16', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 37, 335, '106-10', 'ONLINE', 'APT-202611-0329', 'Mobile JKN', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(338, 348, 'LAMA', 'REG202611100330', '2026-11-10', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 40, 336, '113-10', 'ONLINE', 'APT-202611-0330', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(339, 349, 'LAMA', 'REG202611180331', '2026-11-18', 'RAWAT_JALAN', 'Poli Penyakit Jiwa', 49, 337, '111-17', 'ONLINE', 'APT-202611-0331', 'Mobile JKN', 'SELESAI', NULL, '2026-11-18 08:58:00', '2026-11-18 08:58:00', '2026-11-20 08:00:00', '2026-11-18 08:28:00', '2026-11-20 08:00:00'),
(340, 350, 'LAMA', 'REG202611230332', '2026-11-23', 'RAWAT_JALAN', 'Poli Jantung', 51, 338, '136-07', 'ONLINE', 'APT-202611-0332', 'Mobile JKN', 'SELESAI', NULL, '2026-11-23 10:59:00', '2026-11-23 10:59:00', '2026-11-20 08:00:00', '2026-11-23 10:43:00', '2026-11-20 08:00:00'),
(341, 351, 'LAMA', 'REG202611050333', '2026-11-05', 'RAWAT_JALAN', 'Poli Gigi & Mulut', 65, 339, '132-13', 'ONLINE', 'APT-202611-0333', 'Website RS', 'SELESAI', NULL, '2026-11-05 08:43:00', '2026-11-05 08:43:00', '2026-11-20 08:00:00', '2026-11-05 08:22:00', '2026-11-20 08:00:00'),
(342, 352, 'LAMA', 'REG202611140334', '2026-11-14', 'RAWAT_JALAN', 'GCU : Surat Sehat Jasmani + Rohani', 33, 340, '071-13', 'OFFLINE', 'APT-202611-0334', 'Loket Pendaftaran', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(343, 353, 'LAMA', 'REG202611030335', '2026-11-03', 'RAWAT_JALAN', 'Poli Jantung', 44, 341, '078-40', 'ONLINE', 'APT-202611-0335', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(344, 354, 'LAMA', 'REG202611120336', '2026-11-12', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 30, 342, '009-10', 'ONLINE', 'APT-202611-0336', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-12 11:53:00', '2026-11-12 11:53:00', '2026-11-20 08:00:00', '2026-11-12 11:38:00', '2026-11-20 08:00:00'),
(345, 355, 'LAMA', 'REG202611090337', '2026-11-09', 'RAWAT_JALAN', 'Poli Saraf', 25, 343, '037-07', 'ONLINE', 'APT-202611-0337', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(346, 356, 'LAMA', 'REG202611070338', '2026-11-07', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 13, 344, '004-20', 'ONLINE', 'APT-202611-0338', 'Website RS', 'SELESAI', NULL, '2026-11-07 08:22:00', '2026-11-07 08:22:00', '2026-11-20 08:00:00', '2026-11-07 07:36:00', '2026-11-20 08:00:00'),
(347, 357, 'LAMA', 'REG202611100339', '2026-11-10', 'RAWAT_JALAN', 'Poli Saraf (Eksekutif)', 25, 345, '101-28', 'ONLINE', 'APT-202611-0339', 'Aplikasi RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(348, 358, 'LAMA', 'REG202611060340', '2026-11-06', 'RAWAT_JALAN', 'Uji Kesehatan PNS (Paket)', 34, 346, '051-19', 'ONLINE', 'APT-202611-0340', 'Website RS', 'BATAL', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(349, 359, 'LAMA', 'REG202611100341', '2026-11-10', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 13, 347, '004-11', 'ONLINE', 'APT-202611-0341', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-10 08:48:00', '2026-11-10 08:48:00', '2026-11-20 08:00:00', '2026-11-10 08:07:00', '2026-11-20 08:00:00'),
(350, 360, 'LAMA', 'REG202611090342', '2026-11-09', 'RAWAT_JALAN', 'Poli Orthopaedi & Traumatologi (Eksekutif)', 19, 348, '011-15', 'ONLINE', 'APT-202611-0342', 'Website RS', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00'),
(351, 361, 'LAMA', 'REG202611210343', '2026-11-21', 'RAWAT_JALAN', 'Poli Urologi', 50, 349, '060-11', 'OFFLINE', 'APT-202611-0343', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-21 13:22:00', '2026-11-21 13:22:00', '2026-11-20 08:00:00', '2026-11-21 12:45:00', '2026-11-20 08:00:00'),
(352, 362, 'LAMA', 'REG202611110344', '2026-11-11', 'RAWAT_JALAN', 'Poli Jantung (Eksekutif)', 52, 350, '056-08', 'OFFLINE', 'APT-202611-0344', 'Loket Pendaftaran', 'SELESAI', NULL, '2026-11-11 11:08:00', '2026-11-11 11:08:00', '2026-11-20 08:00:00', '2026-11-11 10:28:00', '2026-11-20 08:00:00'),
(353, 363, 'LAMA', 'REG202611090345', '2026-11-09', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 56, 351, '072-07', 'ONLINE', 'APT-202611-0345', 'Mobile JKN', 'SELESAI', NULL, '2026-11-09 09:08:00', '2026-11-09 09:08:00', '2026-11-20 08:00:00', '2026-11-09 08:24:00', '2026-11-20 08:00:00'),
(354, 364, 'LAMA', 'REG202611230346', '2026-11-23', 'RAWAT_JALAN', 'Poli Penyakit Dalam', 37, 352, '106-13', 'ONLINE', 'APT-202611-0346', 'Mobile JKN', 'MENUNGGU', NULL, '2026-11-23 10:02:00', NULL, '2026-11-20 08:00:00', '2026-11-23 09:27:00', '2026-11-20 08:00:00'),
(355, 365, 'LAMA', 'REG202611240347', '2026-11-24', 'RAWAT_JALAN', 'Poli Jantung', 52, 353, '032-08', 'ONLINE', 'APT-202611-0347', 'Aplikasi RS', 'SELESAI', NULL, '2026-11-24 12:51:00', '2026-11-24 12:51:00', '2026-11-20 08:00:00', '2026-11-24 12:16:00', '2026-11-20 08:00:00'),
(356, 366, 'LAMA', 'REG202611030348', '2026-11-03', 'RAWAT_JALAN', 'P. VK (Rajal)', 39, 354, '069-03', 'ONLINE', 'APT-202611-0348', 'WhatsApp Reservasi', 'SELESAI', NULL, '2026-11-03 12:26:00', '2026-11-03 12:26:00', '2026-11-20 08:00:00', '2026-11-03 11:33:00', '2026-11-20 08:00:00'),
(357, 367, 'LAMA', 'REG202611250349', '2026-11-25', 'RAWAT_JALAN', 'Poli Umum', 45, 355, '095-32', 'ONLINE', 'APT-202611-0349', 'Mobile JKN', 'SELESAI', NULL, '2026-11-25 12:38:00', '2026-11-25 12:38:00', '2026-11-20 08:00:00', '2026-11-25 12:14:00', '2026-11-20 08:00:00'),
(358, 368, 'LAMA', 'REG202611180350', '2026-11-18', 'RAWAT_JALAN', 'Poli Paru Sub. Onkologi Toraks', 37, 356, '134-16', 'ONLINE', 'APT-202611-0350', 'Mobile JKN', 'MENUNGGU', NULL, NULL, NULL, '2026-11-20 08:00:00', NULL, '2026-11-20 08:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `hms_payments`
--

CREATE TABLE `hms_payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `bill_id` int(10) UNSIGNED NOT NULL,
  `payment_date` datetime NOT NULL DEFAULT current_timestamp(),
  `amount` decimal(14,2) NOT NULL DEFAULT 0.00,
  `method` enum('TUNAI','TRANSFER','KARTU','BPJS','ASURANSI','PERUSAHAAN') NOT NULL DEFAULT 'TUNAI',
  `reference_no` varchar(100) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_referrals`
--

CREATE TABLE `hms_referrals` (
  `id` int(10) UNSIGNED NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `visit_id` int(10) UNSIGNED DEFAULT NULL,
  `referral_date` date NOT NULL,
  `destination` varchar(255) NOT NULL,
  `diagnosis` varchar(255) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('DRAFT','DIKIRIM','DITERIMA','SELESAI') NOT NULL DEFAULT 'DRAFT',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_scheduling_evaluation`
--

CREATE TABLE `hms_scheduling_evaluation` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `visit_id` int(10) UNSIGNED NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `experiment_arm` enum('STATIC','FUZZY_ONLY','ADABOOST','HYBRID') NOT NULL,
  `recommendation_shown` tinyint(1) NOT NULL DEFAULT 0,
  `recommendation_accepted` tinyint(1) DEFAULT NULL,
  `recommendation_ref` varchar(100) DEFAULT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `accepted_at` datetime DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hms_service_catalog`
--

CREATE TABLE `hms_service_catalog` (
  `id` int(10) UNSIGNED NOT NULL,
  `service_code` varchar(40) NOT NULL,
  `service_name` varchar(180) NOT NULL,
  `service_type` varchar(80) NOT NULL,
  `unit` varchar(40) DEFAULT NULL,
  `price` decimal(14,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_service_catalog`
--

INSERT INTO `hms_service_catalog` (`id`, `service_code`, `service_name`, `service_type`, `unit`, `price`, `is_active`, `created_at`) VALUES
(1, 'CONSULT', 'KONSULTASI DOKTER', 'KONSULTASI', NULL, 150000.00, 1, '2026-10-20 22:44:55'),
(2, 'TINDAKAN', 'TINDAKAN MEDIS', 'TINDAKAN', NULL, 100000.00, 1, '2026-10-20 22:44:55'),
(3, 'IGD', 'TINDAKAN IGD', 'IGD', NULL, 150000.00, 1, '2026-10-20 22:44:55'),
(4, 'VISITE', 'VISITE DOKTER', 'RAWAT_INAP', NULL, 100000.00, 1, '2026-10-20 22:44:55'),
(5, 'KAMAR', 'KAMAR RAWAT INAP', 'KAMAR', NULL, 0.00, 1, '2026-10-20 22:44:55');

-- --------------------------------------------------------

--
-- Table structure for table `hms_visit_schedules`
--

CREATE TABLE `hms_visit_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `visit_id` int(10) UNSIGNED NOT NULL,
  `schedule_id` int(10) UNSIGNED NOT NULL,
  `service_date` date NOT NULL,
  `quota_snapshot` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_visit_schedules`
--

INSERT INTO `hms_visit_schedules` (`id`, `visit_id`, `schedule_id`, `service_date`, `quota_snapshot`, `created_at`) VALUES
(1, 4, 4, '2026-11-15', 20, '2026-11-13 19:37:03'),
(2, 5, 22, '2026-11-18', 10, '2026-11-14 09:38:12'),
(3, 7, 6, '2026-11-16', 15, '2026-11-14 11:16:23'),
(4, 8, 25, '2026-11-19', 20, '2026-11-14 16:32:46'),
(5, 9, 107, '2026-11-18', 15, '2026-11-20 08:00:00'),
(6, 10, 81, '2026-11-18', 20, '2026-11-20 08:00:00'),
(7, 11, 351, '2026-11-11', 20, '2026-11-20 08:00:00'),
(8, 12, 278, '2026-11-23', 15, '2026-11-20 08:00:00'),
(9, 13, 385, '2026-11-28', 20, '2026-11-20 08:00:00'),
(10, 14, 122, '2026-11-28', 25, '2026-11-20 08:00:00'),
(11, 15, 83, '2026-11-16', 30, '2026-11-20 08:00:00'),
(12, 16, 53, '2026-11-16', 15, '2026-11-20 08:00:00'),
(13, 17, 219, '2026-11-18', 30, '2026-11-20 08:00:00'),
(14, 18, 276, '2026-11-24', 40, '2026-11-20 08:00:00'),
(15, 19, 41, '2026-11-26', 40, '2026-11-20 08:00:00'),
(16, 20, 424, '2026-11-23', 25, '2026-11-20 08:00:00'),
(17, 21, 232, '2026-11-02', 30, '2026-11-20 08:00:00'),
(18, 22, 156, '2026-11-23', 20, '2026-11-20 08:00:00'),
(19, 23, 315, '2026-11-09', 20, '2026-11-20 08:00:00'),
(20, 24, 201, '2026-11-13', 20, '2026-11-20 08:00:00'),
(21, 25, 289, '2026-11-09', 40, '2026-11-20 08:00:00'),
(22, 26, 349, '2026-11-16', 20, '2026-11-20 08:00:00'),
(23, 27, 363, '2026-11-21', 25, '2026-11-20 08:00:00'),
(24, 28, 152, '2026-11-05', 30, '2026-11-20 08:00:00'),
(25, 29, 140, '2026-11-12', 40, '2026-11-20 08:00:00'),
(26, 30, 154, '2026-11-23', 15, '2026-11-20 08:00:00'),
(27, 31, 485, '2026-11-20', 25, '2026-11-20 08:00:00'),
(28, 32, 261, '2026-11-27', 30, '2026-11-20 08:00:00'),
(29, 33, 466, '2026-11-27', 40, '2026-11-20 08:00:00'),
(30, 34, 189, '2026-11-04', 20, '2026-11-20 08:00:00'),
(31, 35, 505, '2026-11-05', 15, '2026-11-20 08:00:00'),
(32, 36, 403, '2026-11-23', 20, '2026-11-20 08:00:00'),
(33, 37, 492, '2026-11-16', 20, '2026-11-20 08:00:00'),
(34, 38, 132, '2026-11-11', 15, '2026-11-20 08:00:00'),
(35, 39, 315, '2026-11-23', 20, '2026-11-20 08:00:00'),
(36, 40, 332, '2026-11-23', 40, '2026-11-20 08:00:00'),
(37, 41, 65, '2026-11-20', 15, '2026-11-20 08:00:00'),
(38, 42, 170, '2026-11-05', 20, '2026-11-20 08:00:00'),
(39, 43, 496, '2026-11-06', 20, '2026-11-20 08:00:00'),
(40, 44, 377, '2026-11-21', 15, '2026-11-20 08:00:00'),
(41, 45, 369, '2026-11-17', 40, '2026-11-20 08:00:00'),
(42, 46, 236, '2026-11-23', 25, '2026-11-20 08:00:00'),
(43, 47, 33, '2026-11-05', 15, '2026-11-20 08:00:00'),
(44, 48, 136, '2026-11-16', 30, '2026-11-20 08:00:00'),
(45, 49, 456, '2026-11-06', 40, '2026-11-20 08:00:00'),
(46, 50, 216, '2026-11-13', 15, '2026-11-20 08:00:00'),
(47, 51, 355, '2026-11-20', 30, '2026-11-20 08:00:00'),
(48, 52, 227, '2026-11-09', 15, '2026-11-20 08:00:00'),
(49, 53, 147, '2026-11-24', 25, '2026-11-20 08:00:00'),
(50, 54, 158, '2026-11-04', 20, '2026-11-20 08:00:00'),
(51, 55, 206, '2026-11-23', 25, '2026-11-20 08:00:00'),
(52, 56, 26, '2026-11-23', 25, '2026-11-20 08:00:00'),
(53, 57, 504, '2026-11-24', 15, '2026-11-20 08:00:00'),
(54, 58, 124, '2026-11-26', 20, '2026-11-20 08:00:00'),
(55, 59, 124, '2026-11-19', 20, '2026-11-20 08:00:00'),
(56, 60, 127, '2026-11-06', 30, '2026-11-20 08:00:00'),
(57, 61, 348, '2026-11-27', 40, '2026-11-20 08:00:00'),
(58, 62, 94, '2026-11-19', 25, '2026-11-20 08:00:00'),
(59, 63, 507, '2026-11-18', 40, '2026-11-20 08:00:00'),
(60, 64, 371, '2026-11-07', 40, '2026-11-20 08:00:00'),
(61, 65, 265, '2026-11-30', 30, '2026-11-20 08:00:00'),
(62, 66, 92, '2026-11-13', 25, '2026-11-20 08:00:00'),
(63, 67, 241, '2026-11-23', 20, '2026-11-20 08:00:00'),
(64, 68, 456, '2026-11-20', 40, '2026-11-20 08:00:00'),
(65, 69, 177, '2026-11-16', 25, '2026-11-20 08:00:00'),
(66, 70, 76, '2026-11-27', 20, '2026-11-20 08:00:00'),
(67, 71, 400, '2026-11-30', 20, '2026-11-20 08:00:00'),
(68, 72, 27, '2026-11-11', 25, '2026-11-20 08:00:00'),
(69, 73, 259, '2026-11-18', 30, '2026-11-20 08:00:00'),
(70, 74, 423, '2026-11-07', 30, '2026-11-20 08:00:00'),
(71, 75, 246, '2026-11-09', 15, '2026-11-20 08:00:00'),
(72, 76, 323, '2026-11-17', 30, '2026-11-20 08:00:00'),
(73, 77, 501, '2026-11-24', 40, '2026-11-20 08:00:00'),
(74, 78, 466, '2026-11-06', 40, '2026-11-20 08:00:00'),
(75, 79, 134, '2026-11-11', 20, '2026-11-20 08:00:00'),
(76, 80, 342, '2026-11-18', 15, '2026-11-20 08:00:00'),
(77, 81, 419, '2026-11-27', 30, '2026-11-20 08:00:00'),
(78, 82, 68, '2026-11-04', 30, '2026-11-20 08:00:00'),
(79, 83, 49, '2026-11-05', 25, '2026-11-20 08:00:00'),
(80, 84, 136, '2026-11-23', 30, '2026-11-20 08:00:00'),
(81, 85, 310, '2026-11-10', 40, '2026-11-20 08:00:00'),
(82, 86, 205, '2026-11-12', 15, '2026-11-20 08:00:00'),
(83, 87, 35, '2026-11-19', 20, '2026-11-20 08:00:00'),
(84, 88, 27, '2026-11-25', 25, '2026-11-20 08:00:00'),
(85, 89, 426, '2026-11-11', 25, '2026-11-20 08:00:00'),
(86, 90, 217, '2026-12-01', 20, '2026-11-20 08:00:00'),
(87, 91, 162, '2026-11-09', 40, '2026-11-20 08:00:00'),
(88, 92, 437, '2026-11-18', 40, '2026-11-20 08:00:00'),
(89, 93, 120, '2026-11-24', 25, '2026-11-20 08:00:00'),
(90, 94, 284, '2026-11-05', 40, '2026-11-20 08:00:00'),
(91, 95, 273, '2026-11-24', 25, '2026-11-20 08:00:00'),
(92, 96, 298, '2026-11-14', 25, '2026-11-20 08:00:00'),
(93, 97, 206, '2026-11-09', 25, '2026-11-20 08:00:00'),
(94, 98, 234, '2026-11-11', 15, '2026-11-20 08:00:00'),
(95, 99, 500, '2026-11-05', 30, '2026-11-20 08:00:00'),
(96, 100, 353, '2026-11-27', 20, '2026-11-20 08:00:00'),
(97, 101, 490, '2026-11-20', 15, '2026-11-20 08:00:00'),
(98, 102, 417, '2026-11-18', 30, '2026-11-20 08:00:00'),
(99, 103, 436, '2026-11-06', 15, '2026-11-20 08:00:00'),
(100, 104, 97, '2026-11-07', 20, '2026-11-20 08:00:00'),
(101, 105, 95, '2026-11-07', 25, '2026-11-20 08:00:00'),
(102, 106, 381, '2026-11-12', 15, '2026-11-20 08:00:00'),
(103, 107, 195, '2026-11-23', 40, '2026-11-20 08:00:00'),
(104, 108, 41, '2026-11-12', 40, '2026-11-20 08:00:00'),
(105, 109, 229, '2026-11-13', 15, '2026-11-20 08:00:00'),
(106, 110, 340, '2026-11-13', 20, '2026-11-20 08:00:00'),
(107, 111, 130, '2026-11-14', 20, '2026-11-20 08:00:00'),
(108, 112, 202, '2026-11-18', 25, '2026-11-20 08:00:00'),
(109, 113, 50, '2026-11-10', 25, '2026-11-20 08:00:00'),
(110, 114, 134, '2026-12-02', 20, '2026-11-20 08:00:00'),
(111, 115, 458, '2026-11-05', 40, '2026-11-20 08:00:00'),
(112, 116, 399, '2026-11-28', 20, '2026-11-20 08:00:00'),
(113, 117, 438, '2026-11-14', 40, '2026-11-20 08:00:00'),
(114, 118, 46, '2026-11-27', 15, '2026-11-20 08:00:00'),
(115, 119, 59, '2026-11-20', 25, '2026-11-20 08:00:00'),
(116, 120, 172, '2026-11-16', 30, '2026-11-20 08:00:00'),
(117, 121, 116, '2026-11-18', 25, '2026-11-20 08:00:00'),
(118, 122, 185, '2026-11-11', 30, '2026-11-20 08:00:00'),
(119, 123, 224, '2026-12-01', 30, '2026-11-20 08:00:00'),
(120, 124, 146, '2026-11-07', 15, '2026-11-20 08:00:00'),
(121, 125, 264, '2026-11-12', 15, '2026-11-20 08:00:00'),
(122, 126, 30, '2026-11-12', 15, '2026-11-20 08:00:00'),
(123, 127, 243, '2026-11-24', 15, '2026-11-20 08:00:00'),
(124, 128, 457, '2026-11-09', 40, '2026-11-20 08:00:00'),
(125, 129, 108, '2026-11-12', 15, '2026-11-20 08:00:00'),
(126, 130, 339, '2026-11-18', 20, '2026-11-20 08:00:00'),
(127, 131, 275, '2026-11-28', 25, '2026-11-20 08:00:00'),
(128, 132, 288, '2026-11-13', 15, '2026-11-20 08:00:00'),
(129, 133, 82, '2026-11-13', 20, '2026-11-20 08:00:00'),
(130, 134, 429, '2026-11-23', 20, '2026-11-20 08:00:00'),
(131, 135, 310, '2026-11-10', 40, '2026-11-20 08:00:00'),
(132, 136, 268, '2026-11-12', 30, '2026-11-20 08:00:00'),
(133, 137, 438, '2026-11-14', 40, '2026-11-20 08:00:00'),
(134, 138, 65, '2026-11-06', 15, '2026-11-20 08:00:00'),
(135, 139, 272, '2026-11-28', 40, '2026-11-20 08:00:00'),
(136, 140, 132, '2026-11-04', 15, '2026-11-20 08:00:00'),
(137, 141, 360, '2026-11-25', 25, '2026-11-20 08:00:00'),
(138, 142, 277, '2026-11-20', 40, '2026-11-20 08:00:00'),
(139, 143, 302, '2026-11-04', 25, '2026-11-20 08:00:00'),
(140, 144, 405, '2026-11-11', 20, '2026-11-20 08:00:00'),
(141, 145, 453, '2026-11-09', 25, '2026-11-20 08:00:00'),
(142, 146, 225, '2026-11-12', 30, '2026-11-20 08:00:00'),
(143, 147, 288, '2026-11-06', 15, '2026-11-20 08:00:00'),
(144, 148, 329, '2026-11-05', 40, '2026-11-20 08:00:00'),
(145, 149, 260, '2026-11-19', 30, '2026-11-20 08:00:00'),
(146, 150, 480, '2026-11-23', 25, '2026-11-20 08:00:00'),
(147, 151, 184, '2026-11-20', 20, '2026-11-20 08:00:00'),
(148, 152, 281, '2026-11-26', 15, '2026-11-20 08:00:00'),
(149, 153, 442, '2026-11-19', 40, '2026-11-20 08:00:00'),
(150, 154, 42, '2026-11-16', 15, '2026-11-20 08:00:00'),
(151, 155, 191, '2026-11-27', 20, '2026-11-20 08:00:00'),
(152, 156, 285, '2026-11-10', 15, '2026-11-20 08:00:00'),
(153, 157, 356, '2026-11-16', 30, '2026-11-20 08:00:00'),
(154, 158, 286, '2026-11-27', 15, '2026-11-20 08:00:00'),
(155, 159, 199, '2026-11-20', 40, '2026-11-20 08:00:00'),
(156, 160, 126, '2026-12-01', 30, '2026-11-20 08:00:00'),
(157, 161, 221, '2026-11-17', 40, '2026-11-20 08:00:00'),
(158, 162, 481, '2026-11-19', 25, '2026-11-20 08:00:00'),
(159, 163, 185, '2026-11-18', 30, '2026-11-20 08:00:00'),
(160, 164, 292, '2026-11-03', 15, '2026-11-20 08:00:00'),
(161, 165, 412, '2026-11-05', 15, '2026-11-20 08:00:00'),
(162, 166, 202, '2026-11-18', 25, '2026-11-20 08:00:00'),
(163, 167, 339, '2026-11-18', 20, '2026-11-20 08:00:00'),
(164, 168, 499, '2026-11-30', 30, '2026-11-20 08:00:00'),
(165, 169, 118, '2026-11-09', 30, '2026-11-20 08:00:00'),
(166, 170, 309, '2026-11-28', 15, '2026-11-20 08:00:00'),
(167, 171, 483, '2026-11-19', 30, '2026-11-20 08:00:00'),
(168, 172, 501, '2026-11-24', 40, '2026-11-20 08:00:00'),
(169, 173, 386, '2026-11-04', 15, '2026-11-20 08:00:00'),
(170, 174, 373, '2026-11-25', 25, '2026-11-20 08:00:00'),
(171, 175, 39, '2026-11-07', 40, '2026-11-20 08:00:00'),
(172, 176, 484, '2026-11-24', 25, '2026-11-20 08:00:00'),
(173, 177, 236, '2026-11-23', 25, '2026-11-20 08:00:00'),
(174, 178, 362, '2026-11-18', 25, '2026-11-20 08:00:00'),
(175, 179, 214, '2026-11-23', 15, '2026-11-20 08:00:00'),
(176, 180, 272, '2026-11-28', 40, '2026-11-20 08:00:00'),
(177, 181, 104, '2026-11-14', 25, '2026-11-20 08:00:00'),
(178, 182, 38, '2026-11-05', 40, '2026-11-20 08:00:00'),
(179, 183, 508, '2026-11-28', 40, '2026-11-20 08:00:00'),
(180, 184, 314, '2026-11-27', 15, '2026-11-20 08:00:00'),
(181, 185, 305, '2026-11-24', 15, '2026-11-20 08:00:00'),
(182, 186, 432, '2026-11-09', 15, '2026-11-20 08:00:00'),
(183, 187, 132, '2026-11-11', 15, '2026-11-20 08:00:00'),
(184, 188, 155, '2026-11-26', 15, '2026-11-20 08:00:00'),
(185, 189, 457, '2026-11-16', 40, '2026-11-20 08:00:00'),
(186, 190, 220, '2026-11-14', 30, '2026-11-20 08:00:00'),
(187, 191, 365, '2026-11-19', 40, '2026-11-20 08:00:00'),
(188, 192, 394, '2026-11-23', 20, '2026-11-20 08:00:00'),
(189, 193, 388, '2026-11-02', 30, '2026-11-20 08:00:00'),
(190, 194, 193, '2026-11-16', 40, '2026-11-20 08:00:00'),
(191, 195, 470, '2026-11-23', 15, '2026-11-20 08:00:00'),
(192, 196, 33, '2026-11-05', 15, '2026-11-20 08:00:00'),
(193, 197, 245, '2026-11-14', 15, '2026-11-20 08:00:00'),
(194, 198, 252, '2026-11-12', 20, '2026-11-20 08:00:00'),
(195, 199, 489, '2026-11-19', 15, '2026-11-20 08:00:00'),
(196, 200, 385, '2026-11-21', 20, '2026-11-20 08:00:00'),
(197, 201, 78, '2026-11-25', 20, '2026-11-20 08:00:00'),
(198, 202, 363, '2026-11-21', 25, '2026-11-20 08:00:00'),
(199, 203, 238, '2026-11-10', 20, '2026-11-20 08:00:00'),
(200, 204, 312, '2026-11-09', 15, '2026-11-20 08:00:00'),
(201, 205, 210, '2026-11-13', 20, '2026-11-20 08:00:00'),
(202, 206, 409, '2026-11-30', 15, '2026-11-20 08:00:00'),
(203, 207, 185, '2026-11-25', 30, '2026-11-20 08:00:00'),
(204, 208, 449, '2026-11-24', 15, '2026-11-20 08:00:00'),
(205, 209, 497, '2026-12-01', 25, '2026-11-20 08:00:00'),
(206, 210, 49, '2026-11-19', 25, '2026-11-20 08:00:00'),
(207, 211, 299, '2026-11-17', 25, '2026-11-20 08:00:00'),
(208, 212, 342, '2026-11-11', 15, '2026-11-20 08:00:00'),
(209, 213, 118, '2026-11-09', 30, '2026-11-20 08:00:00'),
(210, 214, 68, '2026-11-25', 30, '2026-11-20 08:00:00'),
(211, 215, 30, '2026-11-12', 15, '2026-11-20 08:00:00'),
(212, 216, 421, '2026-11-17', 30, '2026-11-20 08:00:00'),
(213, 217, 431, '2026-11-06', 20, '2026-11-20 08:00:00'),
(214, 218, 139, '2026-11-09', 40, '2026-11-20 08:00:00'),
(215, 219, 403, '2026-11-23', 20, '2026-11-20 08:00:00'),
(216, 220, 256, '2026-11-12', 30, '2026-11-20 08:00:00'),
(217, 221, 101, '2026-11-04', 40, '2026-11-20 08:00:00'),
(218, 222, 376, '2026-11-26', 15, '2026-11-20 08:00:00'),
(219, 223, 230, '2026-11-04', 30, '2026-11-20 08:00:00'),
(220, 224, 290, '2026-11-25', 40, '2026-11-20 08:00:00'),
(221, 225, 244, '2026-11-05', 15, '2026-11-20 08:00:00'),
(222, 226, 48, '2026-11-09', 25, '2026-11-20 08:00:00'),
(223, 227, 299, '2026-11-10', 25, '2026-11-20 08:00:00'),
(224, 228, 241, '2026-11-16', 20, '2026-11-20 08:00:00'),
(225, 229, 313, '2026-11-04', 15, '2026-11-20 08:00:00'),
(226, 230, 424, '2026-11-16', 25, '2026-11-20 08:00:00'),
(227, 231, 440, '2026-11-03', 40, '2026-11-20 08:00:00'),
(228, 232, 210, '2026-11-13', 20, '2026-11-20 08:00:00'),
(229, 233, 490, '2026-11-06', 15, '2026-11-20 08:00:00'),
(230, 234, 230, '2026-12-02', 30, '2026-11-20 08:00:00'),
(231, 235, 74, '2026-11-06', 40, '2026-11-20 08:00:00'),
(232, 236, 374, '2026-11-06', 25, '2026-11-20 08:00:00'),
(233, 237, 101, '2026-12-02', 40, '2026-11-20 08:00:00'),
(234, 238, 140, '2026-11-26', 40, '2026-11-20 08:00:00'),
(235, 239, 172, '2026-11-16', 30, '2026-11-20 08:00:00'),
(236, 240, 183, '2026-11-04', 20, '2026-11-20 08:00:00'),
(237, 241, 147, '2026-12-01', 25, '2026-11-20 08:00:00'),
(238, 242, 154, '2026-11-02', 15, '2026-11-20 08:00:00'),
(239, 243, 147, '2026-12-01', 25, '2026-11-20 08:00:00'),
(240, 244, 416, '2026-11-03', 30, '2026-11-20 08:00:00'),
(241, 245, 356, '2026-11-09', 30, '2026-11-20 08:00:00'),
(242, 246, 294, '2026-11-04', 40, '2026-11-20 08:00:00'),
(243, 247, 89, '2026-11-17', 25, '2026-11-20 08:00:00'),
(244, 248, 320, '2026-11-10', 25, '2026-11-20 08:00:00'),
(245, 249, 384, '2026-11-11', 20, '2026-11-20 08:00:00'),
(246, 250, 118, '2026-11-09', 30, '2026-11-20 08:00:00'),
(247, 251, 451, '2026-11-19', 15, '2026-11-20 08:00:00'),
(248, 252, 238, '2026-11-03', 20, '2026-11-20 08:00:00'),
(249, 253, 374, '2026-11-27', 25, '2026-11-20 08:00:00'),
(250, 254, 263, '2026-11-09', 15, '2026-11-20 08:00:00'),
(251, 255, 312, '2026-11-30', 15, '2026-11-20 08:00:00'),
(252, 256, 302, '2026-12-02', 25, '2026-11-20 08:00:00'),
(253, 257, 98, '2026-11-10', 30, '2026-11-20 08:00:00'),
(254, 258, 163, '2026-11-24', 40, '2026-11-20 08:00:00'),
(255, 259, 83, '2026-11-16', 30, '2026-11-20 08:00:00'),
(256, 260, 330, '2026-11-27', 40, '2026-11-20 08:00:00'),
(257, 261, 113, '2026-11-25', 15, '2026-11-20 08:00:00'),
(258, 262, 379, '2026-11-03', 15, '2026-11-20 08:00:00'),
(259, 263, 485, '2026-11-20', 25, '2026-11-20 08:00:00'),
(260, 264, 134, '2026-11-18', 20, '2026-11-20 08:00:00'),
(261, 265, 98, '2026-11-17', 30, '2026-11-20 08:00:00'),
(262, 266, 227, '2026-11-16', 15, '2026-11-20 08:00:00'),
(263, 267, 59, '2026-11-27', 25, '2026-11-20 08:00:00'),
(264, 268, 205, '2026-11-19', 15, '2026-11-20 08:00:00'),
(265, 269, 447, '2026-11-27', 25, '2026-11-20 08:00:00'),
(266, 270, 153, '2026-11-27', 30, '2026-11-20 08:00:00'),
(267, 271, 358, '2026-11-13', 30, '2026-11-20 08:00:00'),
(268, 272, 222, '2026-11-19', 40, '2026-11-20 08:00:00'),
(269, 273, 193, '2026-11-16', 40, '2026-11-20 08:00:00'),
(270, 274, 445, '2026-11-23', 25, '2026-11-20 08:00:00'),
(271, 275, 112, '2026-11-10', 15, '2026-11-20 08:00:00'),
(272, 276, 211, '2026-11-30', 15, '2026-11-20 08:00:00'),
(273, 277, 77, '2026-11-09', 20, '2026-11-20 08:00:00'),
(274, 278, 292, '2026-11-17', 15, '2026-11-20 08:00:00'),
(275, 279, 375, '2026-11-03', 15, '2026-11-20 08:00:00'),
(276, 280, 296, '2026-11-24', 25, '2026-11-20 08:00:00'),
(277, 281, 179, '2026-11-25', 25, '2026-11-20 08:00:00'),
(278, 282, 468, '2026-11-30', 15, '2026-11-20 08:00:00'),
(279, 283, 54, '2026-11-19', 15, '2026-11-20 08:00:00'),
(280, 284, 386, '2026-11-18', 15, '2026-11-20 08:00:00'),
(281, 285, 219, '2026-11-18', 30, '2026-11-20 08:00:00'),
(282, 286, 344, '2026-11-30', 40, '2026-11-20 08:00:00'),
(283, 287, 234, '2026-11-25', 15, '2026-11-20 08:00:00'),
(284, 288, 438, '2026-11-21', 40, '2026-11-20 08:00:00'),
(285, 289, 280, '2026-11-11', 15, '2026-11-20 08:00:00'),
(286, 290, 154, '2026-11-09', 15, '2026-11-20 08:00:00'),
(287, 291, 360, '2026-11-04', 25, '2026-11-20 08:00:00'),
(288, 292, 454, '2026-11-19', 25, '2026-11-20 08:00:00'),
(289, 293, 79, '2026-11-06', 20, '2026-11-20 08:00:00'),
(290, 294, 96, '2026-11-04', 20, '2026-11-20 08:00:00'),
(291, 295, 139, '2026-11-23', 40, '2026-11-20 08:00:00'),
(292, 296, 400, '2026-11-02', 20, '2026-11-20 08:00:00'),
(293, 297, 139, '2026-11-16', 40, '2026-11-20 08:00:00'),
(294, 298, 116, '2026-11-18', 25, '2026-11-20 08:00:00'),
(295, 299, 474, '2026-11-27', 15, '2026-11-20 08:00:00'),
(296, 300, 54, '2026-11-05', 15, '2026-11-20 08:00:00'),
(297, 301, 338, '2026-11-23', 20, '2026-11-20 08:00:00'),
(298, 302, 165, '2026-11-05', 40, '2026-11-20 08:00:00'),
(299, 303, 460, '2026-11-11', 30, '2026-11-20 08:00:00'),
(300, 304, 93, '2026-11-17', 25, '2026-11-20 08:00:00'),
(301, 305, 505, '2026-11-19', 15, '2026-11-20 08:00:00'),
(302, 306, 265, '2026-11-23', 30, '2026-11-20 08:00:00'),
(303, 307, 296, '2026-11-17', 25, '2026-11-20 08:00:00'),
(304, 308, 354, '2026-12-01', 30, '2026-11-20 08:00:00'),
(305, 309, 308, '2026-11-13', 15, '2026-11-20 08:00:00'),
(306, 310, 375, '2026-11-24', 15, '2026-11-20 08:00:00'),
(307, 311, 104, '2026-11-28', 25, '2026-11-20 08:00:00'),
(308, 312, 62, '2026-11-17', 15, '2026-11-20 08:00:00'),
(309, 313, 478, '2026-11-26', 30, '2026-11-20 08:00:00'),
(310, 314, 112, '2026-11-17', 15, '2026-11-20 08:00:00'),
(311, 315, 324, '2026-11-19', 30, '2026-11-20 08:00:00'),
(312, 316, 320, '2026-11-10', 25, '2026-11-20 08:00:00'),
(313, 317, 248, '2026-11-27', 15, '2026-11-20 08:00:00'),
(314, 318, 271, '2026-11-04', 40, '2026-11-20 08:00:00'),
(315, 319, 170, '2026-11-12', 20, '2026-11-20 08:00:00'),
(316, 320, 139, '2026-11-02', 40, '2026-11-20 08:00:00'),
(317, 321, 194, '2026-11-05', 40, '2026-11-20 08:00:00'),
(318, 322, 256, '2026-11-26', 30, '2026-11-20 08:00:00'),
(319, 323, 218, '2026-11-27', 20, '2026-11-20 08:00:00'),
(320, 324, 70, '2026-11-23', 40, '2026-11-20 08:00:00'),
(321, 325, 461, '2026-11-06', 30, '2026-11-20 08:00:00'),
(322, 326, 236, '2026-11-23', 25, '2026-11-20 08:00:00'),
(323, 327, 335, '2026-11-19', 40, '2026-11-20 08:00:00'),
(324, 328, 295, '2026-11-14', 40, '2026-11-20 08:00:00'),
(325, 329, 232, '2026-11-09', 30, '2026-11-20 08:00:00'),
(326, 330, 122, '2026-11-14', 25, '2026-11-20 08:00:00'),
(327, 331, 318, '2026-11-19', 20, '2026-11-20 08:00:00'),
(328, 332, 76, '2026-11-27', 20, '2026-11-20 08:00:00'),
(329, 333, 365, '2026-11-12', 40, '2026-11-20 08:00:00'),
(330, 334, 283, '2026-11-09', 40, '2026-11-20 08:00:00'),
(331, 335, 498, '2026-11-20', 25, '2026-11-20 08:00:00'),
(332, 336, 459, '2026-11-09', 30, '2026-11-20 08:00:00'),
(333, 337, 366, '2026-11-16', 15, '2026-11-20 08:00:00'),
(334, 338, 389, '2026-11-10', 30, '2026-11-20 08:00:00'),
(335, 339, 384, '2026-11-18', 20, '2026-11-20 08:00:00'),
(336, 340, 482, '2026-11-23', 30, '2026-11-20 08:00:00'),
(337, 341, 469, '2026-11-05', 15, '2026-11-20 08:00:00'),
(338, 342, 254, '2026-11-14', 20, '2026-11-20 08:00:00'),
(339, 343, 276, '2026-11-03', 40, '2026-11-20 08:00:00'),
(340, 344, 51, '2026-11-12', 25, '2026-11-20 08:00:00'),
(341, 345, 141, '2026-11-09', 15, '2026-11-20 08:00:00'),
(342, 346, 36, '2026-11-07', 20, '2026-11-20 08:00:00'),
(343, 347, 354, '2026-11-10', 30, '2026-11-20 08:00:00'),
(344, 348, 201, '2026-11-06', 20, '2026-11-20 08:00:00'),
(345, 349, 34, '2026-11-10', 20, '2026-11-20 08:00:00'),
(346, 350, 55, '2026-11-09', 25, '2026-11-20 08:00:00'),
(347, 351, 223, '2026-11-21', 40, '2026-11-20 08:00:00'),
(348, 352, 212, '2026-11-11', 15, '2026-11-20 08:00:00'),
(349, 353, 255, '2026-11-09', 30, '2026-11-20 08:00:00'),
(350, 354, 366, '2026-11-23', 15, '2026-11-20 08:00:00'),
(351, 355, 128, '2026-11-24', 20, '2026-11-20 08:00:00'),
(352, 356, 243, '2026-11-03', 15, '2026-11-20 08:00:00'),
(353, 357, 328, '2026-11-25', 40, '2026-11-20 08:00:00'),
(354, 358, 477, '2026-11-18', 30, '2026-11-20 08:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `hms_workflow_events`
--

CREATE TABLE `hms_workflow_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `visit_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `igd_id` int(11) DEFAULT NULL,
  `event_type` varchar(80) NOT NULL,
  `event_status` varchar(40) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `actor_role` varchar(40) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hms_workflow_events`
--

INSERT INTO `hms_workflow_events` (`id`, `patient_id`, `visit_id`, `admission_id`, `igd_id`, `event_type`, `event_status`, `description`, `actor_id`, `actor_role`, `created_at`) VALUES
(1, 4, 1, NULL, NULL, 'REGISTRASI', 'MENUNGGU', 'Kunjungan REG202610220001 terdaftar.', 1, 'admin', '2026-10-22 05:19:31'),
(2, 5, 2, NULL, NULL, 'ANTRIAN', 'MENUNGGU', 'Antrean P001 dibuat melalui portal publik.', 0, '', '2026-10-22 13:30:06'),
(3, 4, 1, NULL, NULL, 'RAWAT_JALAN', 'TERDAFTAR', 'Pelayanan rawat jalan dibuat.', 1, 'admin', '2026-10-22 14:29:39'),
(4, 4, 1, NULL, NULL, 'RME_ENTRY', 'SELESAI', 'SOAP rawat jalan terintegrasi ke RME.', 1, 'admin', '2026-10-22 20:32:54'),
(5, 6, 3, NULL, NULL, 'ANTRIAN', 'MENUNGGU', 'Antrean P001 dibuat melalui portal publik.', 0, '', '2026-11-10 09:48:42'),
(6, 6, 3, NULL, NULL, 'ANTRIAN', 'DIPANGGIL', 'Status antrean DIPANGGIL.', 1, 'admin', '2026-11-10 10:45:05'),
(7, 6, 3, NULL, NULL, 'ANTRIAN', 'DILAYANI', 'Status antrean DILAYANI.', 1, 'admin', '2026-11-10 10:45:33'),
(8, 7, 4, NULL, NULL, 'REGISTRASI', 'MENUNGGU', 'Registrasi terintegrasi REG202611130001 dengan antrean P001.', 1, 'admin', '2026-11-13 19:37:03'),
(9, 7, 4, NULL, NULL, 'ANTRIAN', 'DIPANGGIL', 'Status antrean DIPANGGIL.', 1, 'admin', '2026-11-13 19:52:07'),
(10, 6, 3, NULL, NULL, 'ANTRIAN', 'SELESAI', 'Status antrean SELESAI.', 1, 'admin', '2026-11-13 19:52:30'),
(11, 7, 4, NULL, NULL, 'ANTRIAN', 'DILAYANI', 'Status antrean DILAYANI.', 1, 'admin', '2026-11-13 19:52:49'),
(12, 15, 5, NULL, NULL, 'ANTRIAN', 'MENUNGGU', 'Antrean P001 dibuat untuk drg. Mohammad Qirom.', 1, 'admin', '2026-11-14 09:38:12'),
(13, 15, 5, NULL, NULL, 'ANTRIAN', 'DIPANGGIL', 'Status antrean DIPANGGIL.', 1, 'admin', '2026-11-14 09:39:54'),
(14, 15, 5, NULL, NULL, 'RAWAT_JALAN', 'TERDAFTAR', 'Pelayanan rawat jalan dibuat.', 1, 'admin', '2026-11-14 09:42:06'),
(15, 15, 5, NULL, NULL, 'ANTRIAN', 'DILAYANI', 'Status antrean DILAYANI.', 1, 'admin', '2026-11-14 09:55:39'),
(16, 15, 5, NULL, NULL, 'ANTRIAN', 'SELESAI', 'Status antrean SELESAI.', 1, 'admin', '2026-11-14 09:58:36'),
(17, 16, 6, NULL, NULL, 'ANTRIAN', 'MENUNGGU', 'Antrean langsung tanpa jadwal dibuat; menunggu check-in petugas.', 1, 'admin', '2026-11-14 11:12:46'),
(18, 16, 7, NULL, NULL, 'REGISTRASI', 'MENUNGGU', 'Registrasi terintegrasi REG202611140003 dengan antrean P001.', 1, 'admin', '2026-11-14 11:16:23'),
(19, 7, 4, NULL, NULL, 'RAWAT_JALAN', 'DILAYANI', 'Pelayanan rawat jalan dimulai.', 1, 'admin', '2026-11-14 11:18:57'),
(20, 16, 7, NULL, NULL, 'ANTRIAN', 'DIPANGGIL', 'Status antrean DIPANGGIL.', 1, 'admin', '2026-11-14 11:27:07'),
(21, 16, 7, NULL, NULL, 'RAWAT_JALAN', 'DILAYANI', 'Pelayanan rawat jalan dimulai.', 1, 'admin', '2026-11-14 11:38:29'),
(22, 16, 7, NULL, NULL, 'ANTRIAN', 'DILAYANI', 'Status antrean DILAYANI.', 1, 'admin', '2026-11-14 11:38:29'),
(23, 18, 8, NULL, NULL, 'APPOINTMENT_TERHUBUNG', 'MENUNGGU', 'Appointment #6 terhubung ke antrean P001.', 5, 'patient', '2026-11-14 16:32:46'),
(24, 18, 8, NULL, NULL, 'ANTRIAN', 'DIPANGGIL', 'Status antrean DIPANGGIL.', 1, 'admin', '2026-11-15 07:48:59');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_type`, `user_id`, `title`, `message`, `is_read`, `created_at`, `read_at`) VALUES
(1, 'patient', 1, 'Prescription available', 'Your prescription for appointment #1 is ready to download.', 0, '2026-06-15 22:06:25', NULL),
(2, 'patient', 1, 'Appointment status updated', 'Your appointment is now Completed.', 0, '2026-06-15 22:06:51', NULL),
(3, 'admin', NULL, 'Appointment status updated', 'Doctor updated appointment #1 to Completed.', 1, '2026-06-15 22:06:51', '2026-06-21 21:49:01'),
(4, 'patient', 1, 'Prescription available', 'Your prescription for appointment #1 is ready to download.', 0, '2026-06-15 22:07:28', NULL),
(5, 'patient', 1, 'Workflow verification', 'Prescription workflow verified.', 0, '2026-06-15 22:14:59', NULL),
(6, 'patient', 2, 'Appointment status updated', 'Your appointment is now Cancelled.', 0, '2026-06-15 22:30:32', NULL),
(7, 'doctor', 2, 'Appointment status updated', 'Appointment #2 is now Cancelled.', 0, '2026-06-15 22:30:32', NULL),
(8, 'admin', NULL, 'New appointment request', 'A patient booked appointment #4.', 1, '2026-06-18 12:43:11', '2026-06-21 21:49:01'),
(9, 'doctor', 8, 'New appointment request', 'A patient booked appointment #4.', 0, '2026-06-18 12:43:11', NULL),
(10, 'patient', 3, 'Appointment status updated', 'Your appointment is now Approved.', 0, '2026-06-18 12:51:27', NULL),
(11, 'admin', NULL, 'Appointment status updated', 'Doctor updated appointment #4 to Approved.', 1, '2026-06-18 12:51:27', '2026-06-21 21:49:01'),
(12, 'patient', 3, 'Prescription available', 'Your prescription for appointment #4 is ready to download.', 0, '2026-06-18 13:02:15', NULL),
(13, 'admin', NULL, 'New appointment request', 'A patient booked appointment #5.', 1, '2026-06-21 21:47:00', '2026-06-21 21:49:01'),
(14, 'doctor', 9, 'New appointment request', 'A patient booked appointment #5.', 0, '2026-06-21 21:47:00', NULL),
(15, 'patient', 4, 'Appointment status updated', 'Your appointment is now Completed.', 0, '2026-06-21 21:47:19', NULL),
(16, 'admin', NULL, 'Appointment status updated', 'Doctor updated appointment #5 to Completed.', 1, '2026-06-21 21:47:19', '2026-06-21 21:49:01'),
(17, 'patient', 4, 'Prescription available', 'Your prescription for appointment #5 is ready to download.', 0, '2026-06-21 21:47:50', NULL),
(18, 'patient', 1, 'Janji Temu status updated', 'Your appointment is now Completed.', 0, '2026-11-12 15:00:02', NULL),
(19, 'admin', NULL, 'Janji Temu status updated', 'Doctor updated appointment #3 to Completed.', 0, '2026-11-12 15:00:02', NULL),
(20, 'patient', 1, 'Janji Temu status updated', 'Your appointment is now Completed.', 0, '2026-11-12 15:00:05', NULL),
(21, 'admin', NULL, 'Janji Temu status updated', 'Doctor updated appointment #1 to Completed.', 0, '2026-11-12 15:00:05', NULL),
(22, 'admin', NULL, 'New appointment request', 'A patient booked appointment #6.', 0, '2026-11-14 16:32:46', NULL),
(23, 'doctor', 21, 'New appointment request', 'A patient booked appointment #6.', 0, '2026-11-14 16:32:46', NULL),
(24, 'patient', 5, 'Janji Temu status updated', 'Your appointment is now Approved.', 0, '2026-11-15 07:47:25', NULL),
(25, 'admin', NULL, 'Janji Temu status updated', 'Doctor updated appointment #6 to Approved.', 0, '2026-11-15 07:47:25', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `id` int(11) NOT NULL,
  `appointment_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `patient_user_id` int(11) NOT NULL,
  `diagnosis` text NOT NULL,
  `treatment` text NOT NULL,
  `medicines` text NOT NULL,
  `notes` text DEFAULT NULL,
  `followup_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescriptions`
--

INSERT INTO `prescriptions` (`id`, `appointment_id`, `doctor_id`, `patient_user_id`, `diagnosis`, `treatment`, `medicines`, `notes`, `followup_date`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'Fever', 'Take Reset', 'Dolo 600 Mg', 'NA', '2026-06-30', '2026-06-15 22:06:25', '2026-06-15 22:07:28'),
(3, 3, 1, 1, 'Workflow verification diagnosis', 'Workflow verification treatment', 'Workflow verification medicine', 'Created during completion check', '2026-06-22', '2026-06-15 22:14:59', '2026-06-15 22:14:59'),
(4, 4, 8, 3, 'Have sensitivity in teeth', 'A cleaning session must be taken twice in month', 'Vinarge Tooth Paste and Mouth Gargle', 'Not take carbonated drinks', '2026-06-27', '2026-06-18 13:02:15', '2026-06-18 13:02:15'),
(5, 5, 9, 4, 'RCT', 'RCT in two teeths', 'RX Tab 1, Tab2', 'NA', '2026-06-26', '2026-06-21 21:47:50', '2026-06-21 21:47:50');

-- --------------------------------------------------------

--
-- Table structure for table `tblcontactus`
--

CREATE TABLE `tblcontactus` (
  `id` int(11) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contactno` bigint(12) DEFAULT NULL,
  `message` mediumtext DEFAULT NULL,
  `PostingDate` timestamp NULL DEFAULT current_timestamp(),
  `AdminRemark` mediumtext DEFAULT NULL,
  `LastupdationDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `IsRead` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblcontactus`
--

INSERT INTO `tblcontactus` (`id`, `fullname`, `email`, `contactno`, `message`, `PostingDate`, `AdminRemark`, `LastupdationDate`, `IsRead`) VALUES
(1, 'Anuj kumar', 'anujk30@test.com', 1425362514, 'This is for testing purposes.   This is for testing purposes.This is for testing purposes.This is for testing purposes.This is for testing purposes.This is for testing purposes.This is for testing purposes.This is for testing purposes.This is for testing purposes.', '2024-04-20 16:52:03', NULL, '2024-05-14 09:27:15', NULL),
(2, 'Anuj kumar', 'ak@gmail.com', 1111122233, 'This is for testing', '2024-04-23 13:13:41', 'Contact the patient', '2024-04-27 13:13:57', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tblmedicalhistory`
--

CREATE TABLE `tblmedicalhistory` (
  `ID` int(10) NOT NULL,
  `PatientID` int(10) DEFAULT NULL,
  `BloodPressure` varchar(200) DEFAULT NULL,
  `BloodSugar` varchar(200) NOT NULL,
  `Weight` varchar(100) DEFAULT NULL,
  `Temperature` varchar(200) DEFAULT NULL,
  `MedicalPres` mediumtext DEFAULT NULL,
  `CreationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblmedicalhistory`
--

INSERT INTO `tblmedicalhistory` (`ID`, `PatientID`, `BloodPressure`, `BloodSugar`, `Weight`, `Temperature`, `MedicalPres`, `CreationDate`) VALUES
(1, 2, '80/120', '110', '85', '97', 'Dolo,\r\nLevocit 5mg', '2024-05-16 09:07:16'),
(2, 3, '101/60', '110/120', '52', '98', 'uyuikhkjhjkgh', '2026-06-18 08:01:20');

-- --------------------------------------------------------

--
-- Table structure for table `tblpage`
--

CREATE TABLE `tblpage` (
  `ID` int(10) NOT NULL,
  `PageType` varchar(200) DEFAULT NULL,
  `PageTitle` varchar(200) DEFAULT NULL,
  `PageDescription` mediumtext DEFAULT NULL,
  `Email` varchar(120) DEFAULT NULL,
  `MobileNumber` bigint(10) DEFAULT NULL,
  `UpdationDate` timestamp NULL DEFAULT current_timestamp(),
  `OpenningTime` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tblpage`
--

INSERT INTO `tblpage` (`ID`, `PageType`, `PageTitle`, `PageDescription`, `Email`, `MobileNumber`, `UpdationDate`, `OpenningTime`) VALUES
(1, 'aboutus', 'About Us', '<ul style=\"padding: 0px; margin-right: 0px; margin-bottom: 1.313em; margin-left: 1.655em;\" times=\"\" new=\"\" roman\";=\"\" font-size:=\"\" 14px;=\"\" text-align:=\"\" center;=\"\" background-color:=\"\" rgb(255,=\"\" 246,=\"\" 246);\"=\"\"><li style=\"text-align: left;\"><font color=\"#000000\">The Hospital Management System (HMS) is designed for Any Hospital to replace their existing manual, paper based system. The new system is to control the following information; patient information, room availability, staff and operating room schedules, and patient invoices. These services are to be provided in an efficient, cost effective manner, with the goal of reducing the time and resources currently required for such tasks.</font></li><li style=\"text-align: left;\"><font color=\"#000000\">A significant part of the operation of any hospital involves the acquisition, management and timely retrieval of great volumes of information. This information typically involves; patient personal information and medical history, staff information, room and ward scheduling, staff scheduling, operating theater scheduling and various facilities waiting lists. All of this information must be managed in an efficient and cost wise fashion so that an institution\'s resources may be effectively utilized HMS will automate the management of the hospital making it more efficient and error free. It aims at standardizing data, consolidating data ensuring data integrity and reducing inconsistencies.&nbsp;</font></li></ul>', NULL, NULL, '2020-05-20 07:21:52', NULL),
(2, 'contactus', 'Contact Details', 'Hole Town South West', 'info@gmail.com', 215155476, '2020-05-20 07:24:07', '');

-- --------------------------------------------------------

--
-- Table structure for table `tblpatient`
--

CREATE TABLE `tblpatient` (
  `ID` int(10) NOT NULL,
  `Docid` int(10) DEFAULT NULL,
  `PatientName` varchar(200) DEFAULT NULL,
  `PatientContno` bigint(10) DEFAULT NULL,
  `PatientEmail` varchar(200) DEFAULT NULL,
  `PatientGender` varchar(50) DEFAULT NULL,
  `PatientAdd` mediumtext DEFAULT NULL,
  `PatientAge` int(10) DEFAULT NULL,
  `PatientMedhis` mediumtext DEFAULT NULL,
  `CreationDate` timestamp NULL DEFAULT current_timestamp(),
  `UpdationDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `medical_record_no` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblpatient`
--

INSERT INTO `tblpatient` (`ID`, `Docid`, `PatientName`, `PatientContno`, `PatientEmail`, `PatientGender`, `PatientAdd`, `PatientAge`, `PatientMedhis`, `CreationDate`, `UpdationDate`, `medical_record_no`) VALUES
(1, 1, 'Rahul Singyh', 452463210, 'rahul12@gmail.com', 'male', 'NA', 32, 'Fever, Cold', '2024-05-16 05:23:35', '2026-10-20 15:44:55', 'RM2024000001'),
(2, 1, 'Amit', 4545454545, 'amitk@gmail.com', 'Perempuan', 'NA', 45, 'Fever', '2024-05-16 09:01:26', '2026-11-12 07:59:46', 'RM2024000002'),
(3, 8, 'Seema', 1562368974, 'seema@gmail.com', 'Female', 'NA', 38, 'Not Yet', '2026-06-18 07:34:16', '2026-10-20 15:44:55', 'RM2026000003'),
(4, NULL, 'Roberta Suares', 8558765456, '', 'female', 'JL. Lot 9 Singapura', 29, 'NIK: 312677877660009', '2026-10-21 22:18:47', '2026-10-21 22:18:47', 'RM2026000004'),
(5, NULL, 'Kapargam', 85765456788, '', 'female', 'New Delhi India', 25, 'NIK: 3178787878665001', '2026-10-22 06:29:28', '2026-10-22 06:29:28', 'RM2026000005'),
(6, NULL, 'Bobby JacksOn', 8174567389, '', 'male', '-', 30, 'NIK: 3274588991001', '2026-11-10 02:47:56', '2026-11-10 02:47:56', 'RM2026000006'),
(7, NULL, 'Ratna Anggraini', 858675454656, 'ratna@gmail.com', 'female', 'Depok', 35, 'NIK: 32767568870006', '2026-11-13 08:47:21', '2026-11-13 08:47:21', 'RM2026000007'),
(8, NULL, 'Rizky Anggraini', 868877887777, 'rizky@gmail.com', 'male', 'Depok', 13, '', '2026-11-13 09:07:25', '2026-11-13 09:07:25', 'RM2026000008'),
(9, NULL, 'Ratna Anggraini', 628786898998, '', 'female', 'Jakarta', 63, '', '2026-11-13 09:15:38', '2026-11-13 09:15:38', 'RM2026000009'),
(10, NULL, 'Ratna Anggraini', 628786898998, '', 'female', 'Jakarta', 63, '', '2026-11-13 09:29:52', '2026-11-13 09:29:52', 'RM2026000010'),
(11, NULL, 'Ratna Anggraini', 867776767, '', 'female', '-', 63, '', '2026-11-13 09:31:23', '2026-11-13 09:31:23', 'RM2026000011'),
(12, NULL, 'Ratna Anggraini', 867776767, '', 'female', '-', 63, '', '2026-11-13 09:47:24', '2026-11-13 09:47:24', 'RM2026000012'),
(13, NULL, 'Amir', 878676777777, '', 'male', '', 47, '', '2026-11-13 09:58:47', '2026-11-13 09:58:47', 'RM2026000013'),
(14, NULL, 'Ratna', 86687878, '', 'female', '', 63, '', '2026-11-13 10:11:24', '2026-11-13 10:11:24', 'RM2026000014'),
(15, NULL, 'Eko Hidayat', 8587677889, '', 'male', '', 45, '', '2026-11-14 02:37:50', '2026-11-14 02:37:50', 'RM2026000015'),
(16, NULL, 'Surya Nugroho', 8578896754, '', 'male', '', 30, '', '2026-11-14 04:11:18', '2026-11-14 04:11:18', 'RM2026000016'),
(17, NULL, 'Mega Pratama', 88567667888, '', 'female', '', 29, '', '2026-11-14 04:13:18', '2026-11-14 04:13:18', 'RM2026000017'),
(18, NULL, 'Surya Nugroho', NULL, 'SuryaNugroho@gmail.com', 'male', 'Jakarta Pusat', 0, 'Dibuat otomatis dari akun portal pasien', '2026-11-14 09:32:46', '2026-11-14 09:32:46', 'RM2026000018'),
(19, 33, 'Gilang Hidayat', 628130000019, '', 'male', '-', 61, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-704238'),
(20, 35, 'Ayu Mulyadi', 628130000020, '', 'female', '-', 12, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-713762'),
(21, 35, 'Kurniawan Gunawan', 628130000021, '', 'male', '-', 64, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-999398'),
(22, 47, 'Gilang Nasution', 628130000022, '', 'male', '-', 0, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-438977'),
(23, 49, 'Yuni Mulyadi', 628130000023, '', 'female', '-', 57, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-643623'),
(24, 49, 'Dewi Santoso', 628130000024, '', 'female', '-', 78, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-832168'),
(25, 49, 'Citra Setiawan', 628130000025, '', 'female', '-', 15, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-114338'),
(26, 18, 'Tiara Hakim', 628130000026, '', 'female', '-', 35, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-851413'),
(27, 57, 'Muhammad Nugraha', 628130000027, '', 'male', '-', 77, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-678043'),
(28, 44, 'Rina Puspitasari', 628130000028, '', 'female', '-', 75, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-396578'),
(29, 15, 'Ratna Ramadhan', 628130000029, '', 'female', '-', 25, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-678727'),
(30, 46, 'Erna Nasution', 628130000030, '', 'female', '-', 50, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-880879'),
(31, 30, 'Dewi Handayani', 628130000031, '', 'female', '-', 59, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-986088'),
(32, 43, 'Lestari Lestari', 628130000032, '', 'female', '-', 51, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-919488'),
(33, 41, 'Hendra Utomo', 628130000033, '', 'male', '-', 37, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-137642'),
(34, 34, 'Tri Santoso', 628130000034, '', 'female', '-', 6, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-274446'),
(35, 63, 'Wulan Firmansyah', 628130000035, '', 'female', '-', 24, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-656968'),
(36, 35, 'Hendra Susanto', 628130000036, '', 'male', '-', 33, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-711484'),
(37, 53, 'Cahyo Susanto', 628130000037, '', 'male', '-', 11, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-810526'),
(38, 44, 'Gita Nasution', 628130000038, '', 'female', '-', 62, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-986365'),
(39, 51, 'Ani Firmansyah', 628130000039, '', 'female', '-', 51, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-410244'),
(40, 48, 'Hani Utomo', 628130000040, '', 'female', '-', 25, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-736553'),
(41, 51, 'Joko Susanto', 628130000041, '', 'male', '-', 5, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-757937'),
(42, 53, 'Fitri Nugraha', 628130000042, '', 'female', '-', 17, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-442589'),
(43, 53, 'Nurul Wibowo', 628130000043, '', 'female', '-', 44, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-369452'),
(44, 45, 'Siti Rahmawati', 628130000044, '', 'female', '-', 47, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-809176'),
(45, 61, 'Wulan Nasution', 628130000045, '', 'female', '-', 48, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-805511'),
(46, 32, 'Agus Susanto', 628130000046, '', 'male', '-', 9, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-332120'),
(47, 35, 'Hendra Rahmawati', 628130000047, '', 'male', '-', 18, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-221761'),
(48, 48, 'Ilham Mulyadi', 628130000048, '', 'male', '-', 53, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-786735'),
(49, 41, 'Rendra Siregar', 628130000049, '', 'male', '-', 13, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-566297'),
(50, 58, 'Citra Firmansyah', 628130000050, '', 'female', '-', 28, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-228093'),
(51, 24, 'Cahyo Rahmawati', 628130000051, '', 'male', '-', 27, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-925206'),
(52, 18, 'Slamet Permana', 628130000052, '', 'male', '-', 5, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-251716'),
(53, 35, 'Fajar Permana', 628130000053, '', 'male', '-', 7, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-439498'),
(54, 33, 'Oki Handayani', 628130000054, '', 'male', '-', 29, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-638169'),
(55, 48, 'Budi Mulyadi', 628130000055, '', 'male', '-', 52, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-774591'),
(56, 12, 'Cahyo Kusuma', 628130000056, '', 'male', '-', 36, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-437758'),
(57, 12, 'Ratna Handayani', 628130000057, '', 'female', '-', 13, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-656329'),
(58, 60, 'Rina Susanto', 628130000058, '', 'female', '-', 52, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-533914'),
(59, 38, 'Citra Pratama', 628130000059, '', 'female', '-', 11, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-260053'),
(60, 22, 'Dian Saputra', 628130000060, '', 'female', '-', 53, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-688866'),
(61, 25, 'Maya Saputra', 628130000061, '', 'female', '-', 74, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-401601'),
(62, 42, 'Dewi Permana', 628130000062, '', 'female', '-', 74, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-986438'),
(63, 33, 'Ani Hidayat', 628130000063, '', 'female', '-', 35, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-789786'),
(64, 43, 'Citra Kusuma', 628130000064, '', 'female', '-', 4, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-789275'),
(65, 12, 'Intan Ramadhan', 628130000065, '', 'female', '-', 73, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-488028'),
(66, 10, 'Dian Gunawan', 628130000066, '', 'female', '-', 63, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-385320'),
(67, 61, 'Putri Saputra', 628130000067, '', 'female', '-', 37, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-219346'),
(68, 22, 'Galih Wibowo', 628130000068, '', 'male', '-', 28, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-157443'),
(69, 22, 'Fitri Kusuma', 628130000069, '', 'female', '-', 49, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-883301'),
(70, 54, 'Nugroho Santoso', 628130000070, '', 'male', '-', 59, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-878086'),
(71, 17, 'Ani Ramadhan', 628130000071, '', 'female', '-', 22, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-220768'),
(72, 20, 'Hendra Gunawan', 628130000072, '', 'male', '-', 12, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-985506'),
(73, 49, 'Cahyo Handayani', 628130000073, '', 'male', '-', 15, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-449247'),
(74, 48, 'Gita Hidayat', 628130000074, '', 'female', '-', 78, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-253557'),
(75, 19, 'Dian Puspitasari', 628130000075, '', 'female', '-', 42, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-896788'),
(76, 31, 'Nurul Permana', 628130000076, '', 'female', '-', 1, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-762055'),
(77, 17, 'Citra Utomo', 628130000077, '', 'female', '-', 12, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-486649'),
(78, 38, 'Kurniawan Lestari', 628130000078, '', 'male', '-', 61, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-949153'),
(79, 53, 'Budi Setiawan', 628130000079, '', 'male', '-', 57, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-777513'),
(80, 12, 'Melati Ramadhan', 628130000080, '', 'female', '-', 1, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-506235'),
(81, 62, 'Kartika Permana', 628130000081, '', 'female', '-', 78, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-199096'),
(82, 10, 'Eka Lestari', 628130000082, '', 'female', '-', 11, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-787923'),
(83, 53, 'Agus Firmansyah', 628130000083, '', 'male', '-', 55, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-802667'),
(84, 18, 'Gita Setiawan', 628130000084, '', 'female', '-', 18, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-903373'),
(85, 45, 'Wahyu Nasution', 628130000085, '', 'male', '-', 20, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-903531'),
(86, 26, 'Maya Firmansyah', 628130000086, '', 'female', '-', 7, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-145814'),
(87, 29, 'Tri Nugraha', 628130000087, '', 'female', '-', 48, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-947903'),
(88, 53, 'Fitri Nugraha', 628130000088, '', 'female', '-', 78, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-653081'),
(89, 60, 'Joko Pratama', 628130000089, '', 'male', '-', 21, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-992512'),
(90, 39, 'Nugroho Wijaya', 628130000090, '', 'male', '-', 51, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-466566'),
(91, 24, 'Ilham Hakim', 628130000091, '', 'male', '-', 43, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-434165'),
(92, 20, 'Ratna Lestari', 628130000092, '', 'female', '-', 0, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-895702'),
(93, 17, 'Hani Wibowo', 628130000093, '', 'female', '-', 16, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-913875'),
(94, 60, 'Yuni Rahmawati', 628130000094, '', 'female', '-', 3, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-216242'),
(95, 57, 'Hani Puspitasari', 628130000095, '', 'female', '-', 54, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-101640'),
(96, 55, 'Agus Nasution', 628130000096, '', 'male', '-', 48, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-592972'),
(97, 13, 'Eka Wijaya', 628130000097, '', 'female', '-', 46, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-870899'),
(98, 10, 'Hadi Kusuma', 628130000098, '', 'male', '-', 9, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-762423'),
(99, 46, 'Surya Wijaya', 628130000099, '', 'male', '-', 41, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-145934'),
(100, 45, 'Joko Siregar', 628130000100, '', 'male', '-', 7, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-138399'),
(101, 47, 'Tri Nasution', 628130000101, '', 'female', '-', 44, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-879414'),
(102, 15, 'Farhan Gunawan', 628130000102, '', 'male', '-', 11, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-379676'),
(103, 49, 'Kartika Susanto', 628130000103, '', 'female', '-', 78, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-443848'),
(104, 39, 'Indah Utomo', 628130000104, '', 'female', '-', 8, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-744718'),
(105, 11, 'Ahmad Kusuma', 628130000105, '', 'male', '-', 78, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-940010'),
(106, 35, 'Wahyu Kusuma', 628130000106, '', 'male', '-', 58, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-501451'),
(107, 12, 'Nadia Ramadhan', 628130000107, '', 'female', '-', 36, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-244383'),
(108, 63, 'Melati Permana', 628130000108, '', 'female', '-', 58, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-223481'),
(109, 59, 'Surya Hakim', 628130000109, '', 'male', '-', 57, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-574001'),
(110, 35, 'Dimas Hakim', 628130000110, '', 'male', '-', 23, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-992717'),
(111, 36, 'Ani Siregar', 628130000111, '', 'female', '-', 71, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-928766'),
(112, 24, 'Joko Nasution', 628130000112, '', 'male', '-', 62, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-190403'),
(113, 64, 'Oki Susanto', 628130000113, '', 'male', '-', 11, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-432427'),
(114, 18, 'Ilham Saputra', 628130000114, '', 'male', '-', 67, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-627290'),
(115, 20, 'Irwan Nugraha', 628130000115, '', 'male', '-', 8, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-397846'),
(116, 60, 'Fajar Firmansyah', 628130000116, '', 'male', '-', 78, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-708851'),
(117, 51, 'Gilang Puspitasari', 628130000117, '', 'male', '-', 54, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-377511'),
(118, 15, 'Hadi Firmansyah', 628130000118, '', 'male', '-', 52, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-606404'),
(119, 42, 'Kurniawan Lestari', 628130000119, '', 'male', '-', 19, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-587002'),
(120, 55, 'Tiara Rahmawati', 628130000120, '', 'female', '-', 14, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-237118'),
(121, 52, 'Dedi Wijaya', 628130000121, '', 'male', '-', 38, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-359961'),
(122, 26, 'Gita Hidayat', 628130000122, '', 'female', '-', 15, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-705748'),
(123, 30, 'Tiara Susanto', 628130000123, '', 'female', '-', 31, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-194423'),
(124, 60, 'Kartika Rahmawati', 628130000124, '', 'female', '-', 2, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-983791'),
(125, 44, 'Maya Wijaya', 628130000125, '', 'female', '-', 52, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-900961'),
(126, 24, 'Melati Rahmawati', 628130000126, '', 'female', '-', 36, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-505116'),
(127, 15, 'Maya Ramadhan', 628130000127, '', 'female', '-', 72, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-201377'),
(128, 16, 'Budi Kusuma', 628130000128, '', 'male', '-', 43, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-142210'),
(129, 19, 'Fitri Nasution', 628130000129, '', 'female', '-', 39, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-742848'),
(130, 24, 'Lukman Ramadhan', 628130000130, '', 'male', '-', 15, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-955374'),
(131, 24, 'Farhan Wijaya', 628130000131, '', 'male', '-', 75, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-787436'),
(132, 45, 'Budi Puspitasari', 628130000132, '', 'male', '-', 15, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-961574'),
(133, 32, 'Nugroho Handayani', 628130000133, '', 'male', '-', 15, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-533020'),
(134, 25, 'Tiara Nasution', 628130000134, '', 'female', '-', 41, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-440839'),
(135, 15, 'Hendra Permana', 628130000135, '', 'male', '-', 72, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-607699'),
(136, 11, 'Utami Maulana', 628130000136, '', 'female', '-', 36, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-603110'),
(137, 39, 'Joko Wijaya', 628130000137, '', 'male', '-', 37, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-910616'),
(138, 44, 'Vina Rahmawati', 628130000138, '', 'female', '-', 35, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-311883'),
(139, 33, 'Budi Saputra', 628130000139, '', 'male', '-', 53, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-336633'),
(140, 55, 'Nugroho Utomo', 628130000140, '', 'male', '-', 61, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-677086'),
(141, 11, 'Yusuf Hidayat', 628130000141, '', 'male', '-', 54, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-343500'),
(142, 27, 'Wulan Lestari', 628130000142, '', 'female', '-', 14, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-109717'),
(143, 35, 'Indah Nugraha', 628130000143, '', 'female', '-', 15, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-992400'),
(144, 60, 'Nurul Wibowo', 628130000144, '', 'female', '-', 73, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-114768'),
(145, 57, 'Muhammad Firmansyah', 628130000145, '', 'male', '-', 13, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-443856'),
(146, 19, 'Hani Susanto', 628130000146, '', 'female', '-', 35, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-373453'),
(147, 15, 'Oki Wibowo', 628130000147, '', 'male', '-', 21, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-165142'),
(148, 24, 'Hendra Kusuma', 628130000148, '', 'male', '-', 62, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-744481'),
(149, 56, 'Melati Rahmawati', 628130000149, '', 'female', '-', 28, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-836038'),
(150, 48, 'Citra Puspitasari', 628130000150, '', 'female', '-', 15, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-568449'),
(151, 48, 'Dewi Firmansyah', 628130000151, '', 'female', '-', 27, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-444056'),
(152, 44, 'Rizky Gunawan', 628130000152, '', 'male', '-', 59, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-575458'),
(153, 36, 'Farhan Nugraha', 628130000153, '', 'male', '-', 75, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-366817'),
(154, 32, 'Yusuf Mulyadi', 628130000154, '', 'male', '-', 1, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-163182'),
(155, 65, 'Nadia Pratama', 628130000155, '', 'female', '-', 70, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-570325'),
(156, 32, 'Ilham Santoso', 628130000156, '', 'male', '-', 0, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-233533'),
(157, 27, 'Hendra Susanto', 628130000157, '', 'male', '-', 45, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-497700'),
(158, 45, 'Hendra Nugraha', 628130000158, '', 'male', '-', 9, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-903265'),
(159, 53, 'Muhammad Susanto', 628130000159, '', 'male', '-', 30, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-876513'),
(160, 15, 'Hani Wibowo', 628130000160, '', 'female', '-', 19, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-434394'),
(161, 44, 'Agus Firmansyah', 628130000161, '', 'male', '-', 55, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-720407'),
(162, 47, 'Joko Nasution', 628130000162, '', 'male', '-', 5, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-528090'),
(163, 60, 'Hadi Susanto', 628130000163, '', 'male', '-', 8, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-999197'),
(164, 16, 'Gita Ramadhan', 628130000164, '', 'female', '-', 11, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-354655'),
(165, 45, 'Rendra Pratama', 628130000165, '', 'male', '-', 25, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-806396'),
(166, 55, 'Kartika Santoso', 628130000166, '', 'female', '-', 28, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-319036'),
(167, 24, 'Melati Wibowo', 628130000167, '', 'female', '-', 49, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-350956'),
(168, 55, 'Ratna Saputra', 628130000168, '', 'female', '-', 61, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-477114'),
(169, 51, 'Ahmad Permana', 628130000169, '', 'male', '-', 71, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-332022'),
(170, 54, 'Hani Nasution', 628130000170, '', 'female', '-', 73, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-305721'),
(171, 50, 'Intan Utomo', 628130000171, '', 'female', '-', 63, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-900441'),
(172, 15, 'Fitri Rahmawati', 628130000172, '', 'female', '-', 8, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-855303'),
(173, 45, 'Ahmad Nugraha', 628130000173, '', 'male', '-', 65, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-171269'),
(174, 33, 'Slamet Rahmawati', 628130000174, '', 'male', '-', 53, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-116495'),
(175, 19, 'Nurul Hidayat', 628130000175, '', 'female', '-', 14, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-952657'),
(176, 26, 'Citra Siregar', 628130000176, '', 'female', '-', 12, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-380310'),
(177, 55, 'Nadia Nasution', 628130000177, '', 'female', '-', 71, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-198042'),
(178, 59, 'Ayu Ramadhan', 628130000178, '', 'female', '-', 73, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-624139'),
(179, 20, 'Bambang Permana', 628130000179, '', 'male', '-', 1, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-148823'),
(180, 10, 'Taufik Setiawan', 628130000180, '', 'male', '-', 73, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-413814'),
(181, 51, 'Hadi Hakim', 628130000181, '', 'male', '-', 11, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-892313'),
(182, 29, 'Melati Ramadhan', 628130000182, '', 'female', '-', 4, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-457137'),
(183, 22, 'Putri Hidayat', 628130000183, '', 'female', '-', 12, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-679902'),
(184, 59, 'Muhammad Hakim', 628130000184, '', 'male', '-', 20, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-380989'),
(185, 14, 'Melati Permana', 628130000185, '', 'female', '-', 14, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-566339'),
(186, 51, 'Lukman Rahmawati', 628130000186, '', 'male', '-', 12, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-127537'),
(187, 12, 'Farhan Rahmawati', 628130000187, '', 'male', '-', 32, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-917018'),
(188, 53, 'Eka Pratama', 628130000188, '', 'female', '-', 5, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-381444'),
(189, 22, 'Hani Maulana', 628130000189, '', 'female', '-', 64, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-478666'),
(190, 56, 'Rina Lestari', 628130000190, '', 'female', '-', 49, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-514913'),
(191, 14, 'Putra Ramadhan', 628130000191, '', 'male', '-', 23, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-436241'),
(192, 14, 'Rina Nasution', 628130000192, '', 'female', '-', 47, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-494322'),
(193, 49, 'Oki Wibowo', 628130000193, '', 'male', '-', 9, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-842776'),
(194, 65, 'Dian Kusuma', 628130000194, '', 'female', '-', 55, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-353777'),
(195, 10, 'Utami Wijaya', 628130000195, '', 'female', '-', 47, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-631221'),
(196, 64, 'Bambang Firmansyah', 628130000196, '', 'male', '-', 11, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-906306'),
(197, 48, 'Dewi Santoso', 628130000197, '', 'female', '-', 13, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-934908'),
(198, 48, 'Ratna Firmansyah', 628130000198, '', 'female', '-', 76, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-492292'),
(199, 44, 'Dedi Maulana', 628130000199, '', 'male', '-', 19, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-536181'),
(200, 57, 'Oki Maulana', 628130000200, '', 'male', '-', 58, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-599292'),
(201, 28, 'Bambang Hidayat', 628130000201, '', 'male', '-', 32, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-779445'),
(202, 24, 'Ayu Hidayat', 628130000202, '', 'female', '-', 24, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-343118'),
(203, 40, 'Wulan Gunawan', 628130000203, '', 'female', '-', 50, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-306909'),
(204, 11, 'Lukman Ramadhan', 628130000204, '', 'male', '-', 26, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-206694'),
(205, 21, 'Lukman Siregar', 628130000205, '', 'male', '-', 59, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-511612'),
(206, 12, 'Bambang Kusuma', 628130000206, '', 'male', '-', 10, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-718836'),
(207, 39, 'Yuni Kusuma', 628130000207, '', 'female', '-', 74, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-507333'),
(208, 33, 'Kartika Kusuma', 628130000208, '', 'female', '-', 24, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-274971'),
(209, 36, 'Eka Nugraha', 628130000209, '', 'female', '-', 50, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-110048'),
(210, 49, 'Sari Hidayat', 628130000210, '', 'female', '-', 11, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-535820'),
(211, 62, 'Gilang Susanto', 628130000211, '', 'male', '-', 73, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-402692'),
(212, 53, 'Melati Rahmawati', 628130000212, '', 'female', '-', 11, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-219754'),
(213, 65, 'Joko Wijaya', 628130000213, '', 'male', '-', 58, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-207391'),
(214, 65, 'Siti Hakim', 628130000214, '', 'female', '-', 55, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-822608'),
(215, 17, 'Yuni Rahmawati', 628130000215, '', 'female', '-', 22, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-467856'),
(216, 19, 'Vina Wijaya', 628130000216, '', 'female', '-', 36, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-886530'),
(217, 45, 'Sari Kusuma', 628130000217, '', 'female', '-', 74, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-898462'),
(218, 56, 'Muhammad Handayani', 628130000218, '', 'male', '-', 36, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-179184'),
(219, 33, 'Farhan Susanto', 628130000219, '', 'male', '-', 46, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-102593'),
(220, 17, 'Rina Wibowo', 628130000220, '', 'female', '-', 44, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-381581'),
(221, 13, 'Ani Saputra', 628130000221, '', 'female', '-', 5, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-204411'),
(222, 39, 'Citra Utomo', 628130000222, '', 'female', '-', 47, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-266699'),
(223, 20, 'Dimas Saputra', 628130000223, '', 'male', '-', 0, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-550081'),
(224, 20, 'Rina Saputra', 628130000224, '', 'female', '-', 13, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-108454'),
(225, 11, 'Dedi Ramadhan', 628130000225, '', 'male', '-', 48, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-193670'),
(226, 18, 'Wahyu Utomo', 628130000226, '', 'male', '-', 22, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-171734'),
(227, 60, 'Siti Nugraha', 628130000227, '', 'female', '-', 12, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-746002'),
(228, 51, 'Hendra Permana', 628130000228, '', 'male', '-', 11, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-929504'),
(229, 32, 'Farhan Nasution', 628130000229, '', 'male', '-', 9, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-642899'),
(230, 56, 'Rizky Santoso', 628130000230, '', 'male', '-', 47, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-769077'),
(231, 61, 'Gilang Mulyadi', 628130000231, '', 'male', '-', 10, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-672896'),
(232, 33, 'Tiara Wibowo', 628130000232, '', 'female', '-', 65, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-927630'),
(233, 13, 'Irwan Pratama', 628130000233, '', 'male', '-', 40, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-771652'),
(234, 63, 'Joko Hakim', 628130000234, '', 'male', '-', 56, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-765105'),
(235, 39, 'Joko Firmansyah', 628130000235, '', 'male', '-', 23, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-742039'),
(236, 17, 'Tiara Handayani', 628130000236, '', 'female', '-', 34, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-620526'),
(237, 13, 'Indah Handayani', 628130000237, '', 'female', '-', 2, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-946313'),
(238, 17, 'Putra Puspitasari', 628130000238, '', 'male', '-', 22, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-477617'),
(239, 65, 'Rendra Santoso', 628130000239, '', 'male', '-', 32, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-102693'),
(240, 46, 'Hani Ramadhan', 628130000240, '', 'female', '-', 32, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-942127'),
(241, 60, 'Fajar Setiawan', 628130000241, '', 'male', '-', 67, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-626428'),
(242, 17, 'Ani Siregar', 628130000242, '', 'female', '-', 26, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-679958'),
(243, 36, 'Farhan Rahmawati', 628130000243, '', 'male', '-', 32, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-617326'),
(244, 13, 'Kurniawan Santoso', 628130000244, '', 'male', '-', 49, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-463251'),
(245, 21, 'Nugroho Mulyadi', 628130000245, '', 'male', '-', 8, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-655550'),
(246, 59, 'Taufik Saputra', 628130000246, '', 'male', '-', 65, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-580728'),
(247, 61, 'Hendra Wibowo', 628130000247, '', 'male', '-', 34, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-794622'),
(248, 51, 'Cahyo Nugraha', 628130000248, '', 'male', '-', 18, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-385166'),
(249, 24, 'Slamet Siregar', 628130000249, '', 'male', '-', 27, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-526259'),
(250, 44, 'Rina Hakim', 628130000250, '', 'female', '-', 78, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-265271'),
(251, 33, 'Bambang Wibowo', 628130000251, '', 'male', '-', 34, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-638401'),
(252, 48, 'Hadi Kusuma', 628130000252, '', 'male', '-', 16, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-584487'),
(253, 33, 'Taufik Puspitasari', 628130000253, '', 'male', '-', 34, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-819622'),
(254, 24, 'Dewi Wijaya', 628130000254, '', 'female', '-', 60, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-196446'),
(255, 24, 'Fitri Siregar', 628130000255, '', 'female', '-', 28, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-816400'),
(256, 45, 'Tri Rahmawati', 628130000256, '', 'female', '-', 62, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-623125'),
(257, 31, 'Muhammad Hakim', 628130000257, '', 'male', '-', 11, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-361250'),
(258, 16, 'Ahmad Ramadhan', 628130000258, '', 'male', '-', 77, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-383572'),
(259, 49, 'Dedi Setiawan', 628130000259, '', 'male', '-', 31, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-344068'),
(260, 20, 'Maya Hidayat', 628130000260, '', 'female', '-', 5, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-987624'),
(261, 56, 'Taufik Nugraha', 628130000261, '', 'male', '-', 64, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-690984'),
(262, 65, 'Ahmad Handayani', 628130000262, '', 'male', '-', 62, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-730889'),
(263, 59, 'Eko Puspitasari', 628130000263, '', 'male', '-', 19, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-162448'),
(264, 15, 'Kartika Ramadhan', 628130000264, '', 'female', '-', 18, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-205939'),
(265, 65, 'Hani Firmansyah', 628130000265, '', 'female', '-', 76, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-282664'),
(266, 36, 'Dimas Puspitasari', 628130000266, '', 'male', '-', 51, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-286340'),
(267, 13, 'Eka Ramadhan', 628130000267, '', 'female', '-', 10, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-209167'),
(268, 47, 'Irwan Nugraha', 628130000268, '', 'male', '-', 32, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-568325'),
(269, 49, 'Fitri Gunawan', 628130000269, '', 'female', '-', 64, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-559507'),
(270, 45, 'Fajar Susanto', 628130000270, '', 'male', '-', 10, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-782591'),
(271, 10, 'Surya Nasution', 628130000271, '', 'male', '-', 21, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-458411'),
(272, 60, 'Wahyu Gunawan', 628130000272, '', 'male', '-', 21, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-552275'),
(273, 51, 'Dedi Wijaya', 628130000273, '', 'male', '-', 51, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-411847'),
(274, 60, 'Citra Wibowo', 628130000274, '', 'female', '-', 77, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-104000'),
(275, 13, 'Joko Nasution', 628130000275, '', 'male', '-', 61, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-596574'),
(276, 42, 'Oki Wijaya', 628130000276, '', 'male', '-', 34, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-487345'),
(277, 19, 'Cahyo Firmansyah', 628130000277, '', 'male', '-', 45, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-888775'),
(278, 55, 'Rina Handayani', 628130000278, '', 'female', '-', 54, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-163946'),
(279, 23, 'Rizky Puspitasari', 628130000279, '', 'male', '-', 67, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-995420'),
(280, 44, 'Fitri Hidayat', 628130000280, '', 'female', '-', 28, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-893969'),
(281, 24, 'Ilham Lestari', 628130000281, '', 'male', '-', 34, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-962520'),
(282, 50, 'Vina Santoso', 628130000282, '', 'female', '-', 76, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-644932'),
(283, 11, 'Hadi Wibowo', 628130000283, '', 'male', '-', 69, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-690016'),
(284, 23, 'Nadia Kusuma', 628130000284, '', 'female', '-', 78, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-280564'),
(285, 10, 'Budi Maulana', 628130000285, '', 'male', '-', 61, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-824056'),
(286, 52, 'Siti Hakim', 628130000286, '', 'female', '-', 13, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-393964'),
(287, 62, 'Yuni Utomo', 628130000287, '', 'female', '-', 12, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-864201'),
(288, 33, 'Cahyo Wibowo', 628130000288, '', 'male', '-', 65, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-640299'),
(289, 33, 'Hendra Wijaya', 628130000289, '', 'male', '-', 59, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-977633'),
(290, 35, 'Tiara Nasution', 628130000290, '', 'female', '-', 16, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-963508'),
(291, 53, 'Maya Hidayat', 628130000291, '', 'female', '-', 34, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-597635'),
(292, 65, 'Fajar Puspitasari', 628130000292, '', 'male', '-', 28, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-505343'),
(293, 18, 'Tiara Santoso', 628130000293, '', 'female', '-', 2, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-783238'),
(294, 22, 'Erna Hakim', 628130000294, '', 'female', '-', 8, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-364650'),
(295, 57, 'Wulan Saputra', 628130000295, '', 'female', '-', 1, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-810091'),
(296, 17, 'Kurniawan Permana', 628130000296, '', 'male', '-', 42, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-605139'),
(297, 63, 'Dian Ramadhan', 628130000297, '', 'female', '-', 18, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-944554'),
(298, 15, 'Nadia Maulana', 628130000298, '', 'female', '-', 5, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-538897'),
(299, 47, 'Siti Hidayat', 628130000299, '', 'female', '-', 5, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-631958'),
(300, 48, 'Bambang Ramadhan', 628130000300, '', 'male', '-', 12, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-899977'),
(301, 48, 'Ratna Saputra', 628130000301, '', 'female', '-', 61, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-373216'),
(302, 65, 'Rendra Firmansyah', 628130000302, '', 'male', '-', 49, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-624788'),
(303, 62, 'Putri Puspitasari', 628130000303, '', 'female', '-', 59, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-310026'),
(304, 18, 'Kurniawan Utomo', 628130000304, '', 'male', '-', 8, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-448787'),
(305, 51, 'Eko Lestari', 628130000305, '', 'male', '-', 56, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-923353'),
(306, 62, 'Slamet Nugraha', 628130000306, '', 'male', '-', 48, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-104895'),
(307, 51, 'Kartika Kusuma', 628130000307, '', 'female', '-', 14, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-827213'),
(308, 24, 'Intan Handayani', 628130000308, '', 'female', '-', 77, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-404955'),
(309, 21, 'Melati Nugraha', 628130000309, '', 'female', '-', 22, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-613989'),
(310, 18, 'Taufik Handayani', 628130000310, '', 'male', '-', 22, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-869735'),
(311, 55, 'Melati Rahmawati', 628130000311, '', 'female', '-', 7, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-771425'),
(312, 47, 'Nugroho Susanto', 628130000312, '', 'male', '-', 49, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-823255'),
(313, 24, 'Dian Saputra', 628130000313, '', 'female', '-', 67, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-415743'),
(314, 20, 'Joko Saputra', 628130000314, '', 'male', '-', 3, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-853681'),
(315, 61, 'Kartika Hidayat', 628130000315, '', 'female', '-', 6, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-837606'),
(316, 19, 'Yusuf Saputra', 628130000316, '', 'male', '-', 74, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-804258'),
(317, 35, 'Oki Wibowo', 628130000317, '', 'male', '-', 34, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-775636'),
(318, 25, 'Dedi Wijaya', 628130000318, '', 'male', '-', 2, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-546688'),
(319, 10, 'Yuni Permana', 628130000319, '', 'female', '-', 12, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-474894'),
(320, 33, 'Erna Mulyadi', 628130000320, '', 'female', '-', 54, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-385037'),
(321, 14, 'Vina Puspitasari', 628130000321, '', 'female', '-', 62, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-208751'),
(322, 24, 'Yuni Santoso', 628130000322, '', 'female', '-', 17, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-498197'),
(323, 37, 'Ani Hakim', 628130000323, '', 'female', '-', 68, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-786789'),
(324, 10, 'Nugroho Firmansyah', 628130000324, '', 'male', '-', 32, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-644315'),
(325, 26, 'Ahmad Utomo', 628130000325, '', 'male', '-', 5, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-979789'),
(326, 16, 'Lestari Setiawan', 628130000326, '', 'female', '-', 43, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-887931'),
(327, 45, 'Cahyo Susanto', 628130000327, '', 'male', '-', 57, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-956794'),
(328, 56, 'Dedi Nasution', 628130000328, '', 'male', '-', 53, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-881439'),
(329, 18, 'Agus Firmansyah', 628130000329, '', 'male', '-', 14, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-689648'),
(330, 51, 'Dewi Saputra', 628130000330, '', 'female', '-', 29, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-850689'),
(331, 11, 'Putra Kusuma', 628130000331, '', 'male', '-', 53, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-148001'),
(332, 56, 'Dimas Ramadhan', 628130000332, '', 'male', '-', 14, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-579247');
INSERT INTO `tblpatient` (`ID`, `Docid`, `PatientName`, `PatientContno`, `PatientEmail`, `PatientGender`, `PatientAdd`, `PatientAge`, `PatientMedhis`, `CreationDate`, `UpdationDate`, `medical_record_no`) VALUES
(333, 45, 'Putra Santoso', 628130000333, '', 'male', '-', 68, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-579605'),
(334, 21, 'Dedi Nasution', 628130000334, '', 'male', '-', 77, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-282085'),
(335, 24, 'Kartika Susanto', 628130000335, '', 'female', '-', 18, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-517196'),
(336, 12, 'Galih Nugraha', 628130000336, '', 'male', '-', 38, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-763311'),
(337, 58, 'Erna Saputra', 628130000337, '', 'female', '-', 46, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-668843'),
(338, 45, 'Rizky Saputra', 628130000338, '', 'male', '-', 4, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-947568'),
(339, 30, 'Eka Wijaya', 628130000339, '', 'female', '-', 38, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-816586'),
(340, 49, 'Farhan Utomo', 628130000340, '', 'male', '-', 72, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-746036'),
(341, 41, 'Nurul Firmansyah', 628130000341, '', 'female', '-', 41, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-506380'),
(342, 12, 'Melati Puspitasari', 628130000342, '', 'female', '-', 6, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-764575'),
(343, 28, 'Muhammad Wijaya', 628130000343, '', 'male', '-', 55, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-870786'),
(344, 39, 'Erna Kusuma', 628130000344, '', 'female', '-', 6, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-446620'),
(345, 33, 'Citra Hakim', 628130000345, '', 'female', '-', 41, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-928278'),
(346, 24, 'Citra Siregar', 628130000346, '', 'female', '-', 29, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-669460'),
(347, 37, 'Dedi Firmansyah', 628130000347, '', 'male', '-', 45, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-963699'),
(348, 40, 'Nadia Saputra', 628130000348, '', 'female', '-', 50, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-815706'),
(349, 49, 'Tiara Handayani', 628130000349, '', 'female', '-', 58, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-962043'),
(350, 51, 'Agus Pratama', 628130000350, '', 'male', '-', 27, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-275526'),
(351, 65, 'Ahmad Susanto', 628130000351, '', 'male', '-', 43, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-883171'),
(352, 33, 'Yusuf Permana', 628130000352, '', 'male', '-', 53, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-173863'),
(353, 44, 'Dian Saputra', 628130000353, '', 'female', '-', 69, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-117711'),
(354, 30, 'Lukman Handayani', 628130000354, '', 'male', '-', 14, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-147727'),
(355, 25, 'Putra Hidayat', 628130000355, '', 'male', '-', 69, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-514306'),
(356, 13, 'Ani Rahmawati', 628130000356, '', 'female', '-', 72, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-412534'),
(357, 25, 'Joko Nugraha', 628130000357, '', 'male', '-', 45, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-674122'),
(358, 34, 'Wahyu Permana', 628130000358, '', 'male', '-', 25, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-292930'),
(359, 13, 'Joko Firmansyah', 628130000359, '', 'male', '-', 9, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-583671'),
(360, 19, 'Dedi Wibowo', 628130000360, '', 'male', '-', 9, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-803904'),
(361, 50, 'Erna Puspitasari', 628130000361, '', 'female', '-', 20, 'Penjamin: BPJS Kesehatan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-791454'),
(362, 52, 'Dimas Maulana', 628130000362, '', 'male', '-', 56, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-358133'),
(363, 56, 'Sari Rahmawati', 628130000363, '', 'female', '-', 14, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-912402'),
(364, 37, 'Surya Santoso', 628130000364, '', 'male', '-', 65, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-862760'),
(365, 52, 'Utami Rahmawati', 628130000365, '', 'female', '-', 61, 'Penjamin: Asuransi Swasta', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-678388'),
(366, 39, 'Muhammad Siregar', 628130000366, '', 'male', '-', 65, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-587274'),
(367, 45, 'Taufik Puspitasari', 628130000367, '', 'male', '-', 19, 'Penjamin: Umum / Pribadi', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-266956'),
(368, 37, 'Hani Wijaya', 628130000368, '', 'female', '-', 27, 'Penjamin: Jaminan Perusahaan', '2026-11-20 08:00:00', '2026-11-20 08:00:00', 'RM-377198');

-- --------------------------------------------------------

--
-- Table structure for table `userlog`
--

CREATE TABLE `userlog` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `userip` binary(16) DEFAULT NULL,
  `loginTime` timestamp NULL DEFAULT current_timestamp(),
  `logout` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `userlog`
--

INSERT INTO `userlog` (`id`, `uid`, `username`, `userip`, `loginTime`, `logout`, `status`) VALUES
(1, 1, 'johndoe12@test.com', 0x3a3a3100000000000000000000000000, '2024-05-15 03:41:48', NULL, 1),
(2, 2, 'amitk@gmail.com', 0x3a3a3100000000000000000000000000, '2024-05-16 09:08:06', '16-05-2024 02:41:06 PM', 1),
(3, 1, 'johndoe12@test.com', 0x3a3a3100000000000000000000000000, '2026-06-15 16:24:54', '15-06-2026 09:55:07 PM', 1),
(4, 1, 'johndoe12@test.com', 0x3a3a3100000000000000000000000000, '2026-06-15 16:30:42', '15-06-2026 10:01:25 PM', 1),
(5, NULL, 'anujk123@test.com', 0x3a3a3100000000000000000000000000, '2026-06-16 15:35:31', NULL, 0),
(6, 1, 'johndoe12@test.com', 0x3a3a3100000000000000000000000000, '2026-06-16 15:36:03', '16-06-2026 09:09:00 PM', 1),
(7, 3, 'john@gmail.com', 0x3a3a3100000000000000000000000000, '2026-06-18 06:41:51', '18-06-2026 12:46:02 PM', 1),
(8, 4, 'amit12@test.com', 0x3a3a3100000000000000000000000000, '2026-06-21 16:16:37', '21-06-2026 09:50:04 PM', 1),
(9, NULL, 'widiawan@gmail.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:14:36', NULL, 0),
(10, 1, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:15:18', NULL, 1),
(11, NULL, 'anujk123@test.co', 0x3132372e302e302e3100000000000000, '2026-10-21 15:16:34', NULL, 0),
(12, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:17:04', NULL, 0),
(13, 1, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-10-21 15:20:05', NULL, 1),
(14, 1, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 10:07:55', NULL, 1),
(15, NULL, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 12:48:10', NULL, 0),
(16, 1, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 12:54:49', NULL, 1),
(17, 1, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-11-14 01:48:11', NULL, 1),
(18, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 04:48:21', NULL, 1),
(19, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 05:20:40', NULL, 1),
(20, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 05:37:57', NULL, 1),
(21, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 06:38:32', NULL, 1),
(22, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 06:43:51', NULL, 1),
(23, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 07:43:39', NULL, 1),
(24, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-14 09:05:22', NULL, 1),
(25, 5, 'SuryaNugroho@gmail.com', 0x3132372e302e302e3100000000000000, '2026-11-15 01:30:31', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `regDate` timestamp NULL DEFAULT current_timestamp(),
  `updationDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullName`, `address`, `city`, `gender`, `email`, `password`, `regDate`, `updationDate`) VALUES
(1, 'John Doe', ' ABC Apartment GZB 201017', 'United State', 'male', 'johndoe12@test.com', '$2y$10$2J0mUm83Va63L5fQ.i9Ekeuaat/EH2cRHPVheD8r3yGyeyssQdKIi', '2024-04-20 12:13:56', '2026-09-26 09:42:00'),
(2, 'Amit kumar', 'German Berlin', 'New Delhi', 'male', 'amitk@gmail.com', 'f925916e2754e5e03f75dd58a5733251', '2024-04-21 13:15:32', '2026-09-26 09:42:39'),
(3, 'John Karie', 'German ', 'Kanpur', 'male', 'john@gmail.com', '$2y$10$XzL2wJx1MRRlU32LYwEbce08uWvACAJ62fDfCBhfYLHR3Mnwqw5xS', '2026-06-18 06:33:15', NULL),
(4, 'Amit', 'New Delhi', 'Delhi', 'male', 'amit12@test.com', '$2y$10$TAFjLEAVIO4O/FPLbr288ePVb7rqaf89VqszIs4Q5goIaGOuL.22C', '2026-06-21 16:16:30', NULL),
(5, 'Surya Nugroho', 'Jakarta Pusat', 'Jakarta', 'male', 'SuryaNugroho@gmail.com', '$2y$10$viEsGlNYNSQUKYwl8Ybhru1egl2kQMRGSfMH5G7WKKvfaNmBt49Om', '2026-11-14 04:47:24', NULL);

-- --------------------------------------------------------

--
-- Structure for view `doctor_availability`
--
DROP TABLE IF EXISTS `doctor_availability`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `doctor_availability`  AS SELECT `hms_doctor_schedules`.`id` AS `id`, `hms_doctor_schedules`.`doctor_id` AS `doctor_id`, `hms_doctor_schedules`.`day_of_week` AS `day_of_week`, `hms_doctor_schedules`.`available_date` AS `available_date`, `hms_doctor_schedules`.`start_time` AS `start_time`, `hms_doctor_schedules`.`end_time` AS `end_time`, `hms_doctor_schedules`.`slot_duration_minutes` AS `slot_duration_minutes`, `hms_doctor_schedules`.`quota` AS `max_appointments`, `hms_doctor_schedules`.`is_active` AS `is_active`, `hms_doctor_schedules`.`created_at` AS `created_at`, `hms_doctor_schedules`.`updated_at` AS `updated_at` FROM `hms_doctor_schedules` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_actor` (`actor_type`,`actor_id`),
  ADD KEY `idx_audit_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_audit_created` (`created_at`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctorslog`
--
ALTER TABLE `doctorslog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctorspecilization`
--
ALTER TABLE `doctorspecilization`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctor_availability_backup`
--
ALTER TABLE `doctor_availability_backup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_doctor_day` (`doctor_id`,`day_of_week`),
  ADD KEY `idx_doctor_date` (`doctor_id`,`available_date`);

--
-- Indexes for table `hms_admissions`
--
ALTER TABLE `hms_admissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admission_no` (`admission_no`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `bed_id` (`bed_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `status` (`status`),
  ADD KEY `idx_admission_patient_status` (`patient_id`,`status`),
  ADD KEY `fk_admission_doctor` (`attending_doctor_id`);

--
-- Indexes for table `hms_audit_events`
--
ALTER TABLE `hms_audit_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_created` (`created_at`),
  ADD KEY `idx_audit_actor` (`actor_id`,`actor_role`),
  ADD KEY `idx_audit_record` (`table_name`,`record_id`),
  ADD KEY `idx_audit_action` (`action_name`);

--
-- Indexes for table `hms_beds`
--
ALTER TABLE `hms_beds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_bed` (`room_no`,`bed_no`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `hms_bed_movements`
--
ALTER TABLE `hms_bed_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admission_id` (`admission_id`);

--
-- Indexes for table `hms_bills`
--
ALTER TABLE `hms_bills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_no` (`invoice_no`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `status` (`status`),
  ADD KEY `idx_bill_patient_status` (`patient_id`,`status`);

--
-- Indexes for table `hms_bill_items`
--
ALTER TABLE `hms_bill_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_id` (`bill_id`);

--
-- Indexes for table `hms_clinical_charges`
--
ALTER TABLE `hms_clinical_charges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_charge_patient` (`patient_id`),
  ADD KEY `idx_charge_visit` (`visit_id`),
  ADD KEY `idx_charge_admission` (`admission_id`),
  ADD KEY `idx_charge_cppt` (`cppt_id`),
  ADD KEY `idx_charge_igd` (`igd_id`),
  ADD KEY `idx_charge_service` (`service_id`),
  ADD KEY `idx_charge_bill` (`bill_id`),
  ADD KEY `idx_charge_status` (`status`);

--
-- Indexes for table `hms_cppt`
--
ALTER TABLE `hms_cppt`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `author_id` (`author_id`),
  ADD KEY `idx_cppt_patient_created` (`patient_id`,`created_at`);

--
-- Indexes for table `hms_doctor_schedules`
--
ALTER TABLE `hms_doctor_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_hms_schedule_legacy_source` (`source_legacy_id`),
  ADD UNIQUE KEY `uq_schedule_source_availability` (`source_availability_id`),
  ADD UNIQUE KEY `uq_hms_schedule_availability_source` (`source_availability_id`),
  ADD KEY `idx_schedule_poli_day` (`poli_id`,`day_of_week`,`is_active`);

--
-- Indexes for table `hms_icd10`
--
ALTER TABLE `hms_icd10`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_icd_category` (`category`),
  ADD KEY `idx_icd_active` (`is_active`);

--
-- Indexes for table `hms_igd_visits`
--
ALTER TABLE `hms_igd_visits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `triage_level` (`triage_level`),
  ADD KEY `disposition` (`disposition`),
  ADD KEY `idx_igd_visit_patient` (`visit_id`,`patient_id`);

--
-- Indexes for table `hms_master_poli`
--
ALTER TABLE `hms_master_poli`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `poli_code` (`poli_code`),
  ADD KEY `idx_poli_active` (`is_active`);

--
-- Indexes for table `hms_module_sequences`
--
ALTER TABLE `hms_module_sequences`
  ADD PRIMARY KEY (`code_key`);

--
-- Indexes for table `hms_outpatient_encounters`
--
ALTER TABLE `hms_outpatient_encounters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `visit_id` (`visit_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `poli` (`poli`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `hms_patient_user_map`
--
ALTER TABLE `hms_patient_user_map`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `patient_id` (`patient_id`),
  ADD KEY `idx_user_map_patient` (`patient_id`);

--
-- Indexes for table `hms_patient_visits`
--
ALTER TABLE `hms_patient_visits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `registration_no` (`registration_no`),
  ADD UNIQUE KEY `uq_visit_appointment` (`appointment_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `visit_date` (`visit_date`),
  ADD KEY `status` (`status`),
  ADD KEY `visit_date_2` (`visit_date`,`poli`,`queue_no`),
  ADD KEY `idx_visit_patient_date` (`patient_id`,`visit_date`),
  ADD KEY `fk_visit_doctor` (`doctor_id`);

--
-- Indexes for table `hms_payments`
--
ALTER TABLE `hms_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_id` (`bill_id`);

--
-- Indexes for table `hms_referrals`
--
ALTER TABLE `hms_referrals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `status` (`status`),
  ADD KEY `idx_referral_patient_date` (`patient_id`,`referral_date`);

--
-- Indexes for table `hms_scheduling_evaluation`
--
ALTER TABLE `hms_scheduling_evaluation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_m7_visit` (`visit_id`),
  ADD KEY `idx_m7_arm_assigned` (`experiment_arm`,`assigned_at`),
  ADD KEY `idx_m7_appointment` (`appointment_id`);

--
-- Indexes for table `hms_service_catalog`
--
ALTER TABLE `hms_service_catalog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `service_code` (`service_code`),
  ADD KEY `idx_service_type` (`service_type`),
  ADD KEY `idx_service_active` (`is_active`);

--
-- Indexes for table `hms_visit_schedules`
--
ALTER TABLE `hms_visit_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `visit_id` (`visit_id`);

--
-- Indexes for table `hms_workflow_events`
--
ALTER TABLE `hms_workflow_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_wf_patient` (`patient_id`),
  ADD KEY `idx_wf_visit` (`visit_id`),
  ADD KEY `idx_wf_admission` (`admission_id`),
  ADD KEY `idx_wf_igd` (`igd_id`),
  ADD KEY `idx_wf_event` (`event_type`),
  ADD KEY `idx_wf_created` (`created_at`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user` (`user_type`,`user_id`,`is_read`),
  ADD KEY `idx_notifications_created` (`created_at`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_prescription_appointment` (`appointment_id`),
  ADD KEY `idx_prescription_doctor` (`doctor_id`),
  ADD KEY `idx_prescription_patient` (`patient_user_id`),
  ADD KEY `idx_prescription_followup` (`followup_date`);

--
-- Indexes for table `tblcontactus`
--
ALTER TABLE `tblcontactus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tblmedicalhistory`
--
ALTER TABLE `tblmedicalhistory`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tblpage`
--
ALTER TABLE `tblpage`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tblpatient`
--
ALTER TABLE `tblpatient`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `userlog`
--
ALTER TABLE `userlog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `doctorslog`
--
ALTER TABLE `doctorslog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `doctorspecilization`
--
ALTER TABLE `doctorspecilization`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `doctor_availability_backup`
--
ALTER TABLE `doctor_availability_backup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `hms_admissions`
--
ALTER TABLE `hms_admissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_audit_events`
--
ALTER TABLE `hms_audit_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `hms_beds`
--
ALTER TABLE `hms_beds`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_bed_movements`
--
ALTER TABLE `hms_bed_movements`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_bills`
--
ALTER TABLE `hms_bills`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_bill_items`
--
ALTER TABLE `hms_bill_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_clinical_charges`
--
ALTER TABLE `hms_clinical_charges`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_cppt`
--
ALTER TABLE `hms_cppt`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `hms_doctor_schedules`
--
ALTER TABLE `hms_doctor_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=509;

--
-- AUTO_INCREMENT for table `hms_icd10`
--
ALTER TABLE `hms_icd10`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4786;

--
-- AUTO_INCREMENT for table `hms_igd_visits`
--
ALTER TABLE `hms_igd_visits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_master_poli`
--
ALTER TABLE `hms_master_poli`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1210;

--
-- AUTO_INCREMENT for table `hms_outpatient_encounters`
--
ALTER TABLE `hms_outpatient_encounters`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `hms_patient_visits`
--
ALTER TABLE `hms_patient_visits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=359;

--
-- AUTO_INCREMENT for table `hms_payments`
--
ALTER TABLE `hms_payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_referrals`
--
ALTER TABLE `hms_referrals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_scheduling_evaluation`
--
ALTER TABLE `hms_scheduling_evaluation`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_service_catalog`
--
ALTER TABLE `hms_service_catalog`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2992;

--
-- AUTO_INCREMENT for table `hms_visit_schedules`
--
ALTER TABLE `hms_visit_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=355;

--
-- AUTO_INCREMENT for table `hms_workflow_events`
--
ALTER TABLE `hms_workflow_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tblcontactus`
--
ALTER TABLE `tblcontactus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tblmedicalhistory`
--
ALTER TABLE `tblmedicalhistory`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tblpage`
--
ALTER TABLE `tblpage`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tblpatient`
--
ALTER TABLE `tblpatient`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=369;

--
-- AUTO_INCREMENT for table `userlog`
--
ALTER TABLE `userlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hms_admissions`
--
ALTER TABLE `hms_admissions`
  ADD CONSTRAINT `fk_admission_doctor` FOREIGN KEY (`attending_doctor_id`) REFERENCES `doctors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_admission_visit` FOREIGN KEY (`visit_id`) REFERENCES `hms_patient_visits` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `hms_bills`
--
ALTER TABLE `hms_bills`
  ADD CONSTRAINT `fk_bill_admission` FOREIGN KEY (`admission_id`) REFERENCES `hms_admissions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bill_visit` FOREIGN KEY (`visit_id`) REFERENCES `hms_patient_visits` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `hms_bill_items`
--
ALTER TABLE `hms_bill_items`
  ADD CONSTRAINT `fk_hms_bill_items_bill` FOREIGN KEY (`bill_id`) REFERENCES `hms_bills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hms_clinical_charges`
--
ALTER TABLE `hms_clinical_charges`
  ADD CONSTRAINT `fk_charge_bill` FOREIGN KEY (`bill_id`) REFERENCES `hms_bills` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_charge_service` FOREIGN KEY (`service_id`) REFERENCES `hms_service_catalog` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `hms_doctor_schedules`
--
ALTER TABLE `hms_doctor_schedules`
  ADD CONSTRAINT `fk_schedule_poli` FOREIGN KEY (`poli_id`) REFERENCES `hms_master_poli` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `hms_patient_visits`
--
ALTER TABLE `hms_patient_visits`
  ADD CONSTRAINT `fk_visit_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `hms_payments`
--
ALTER TABLE `hms_payments`
  ADD CONSTRAINT `fk_hms_payments_bill` FOREIGN KEY (`bill_id`) REFERENCES `hms_bills` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `hms_referrals`
--
ALTER TABLE `hms_referrals`
  ADD CONSTRAINT `fk_referral_visit` FOREIGN KEY (`visit_id`) REFERENCES `hms_patient_visits` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `hms_scheduling_evaluation`
--
ALTER TABLE `hms_scheduling_evaluation`
  ADD CONSTRAINT `fk_m7_eval_visit` FOREIGN KEY (`visit_id`) REFERENCES `hms_patient_visits` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
