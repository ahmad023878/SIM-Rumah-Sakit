-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 13, 2026 at 02:08 PM
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
(1, 'ENT', 1, 1, 500, '2024-05-30', '9:15 AM', '2024-05-15 03:42:11', 1, 1, '2026-11-12 08:00:05', 'Completed', '2026-11-12 15:00:05', 'doctor:1', NULL, NULL),
(2, 'Endocrinologists', 2, 2, 800, '2024-05-31', '2:45 PM', '2024-05-16 09:08:54', 1, 0, '2026-06-15 17:00:32', 'Cancelled', '2026-06-15 22:30:32', 'admin:1', NULL, NULL),
(3, 'ENT', 1, 1, 500, '2026-06-16', '10:30:00', '2026-06-15 16:44:59', 1, 1, '2026-11-12 08:00:02', 'Completed', '2026-11-12 15:00:02', 'doctor:1', NULL, NULL),
(4, 'Dental Care', 8, 3, 800, '2026-06-20', '11:42:00', '2026-06-18 07:13:11', 1, 1, '2026-06-18 07:32:15', 'Completed', '2026-06-18 13:02:15', 'doctor:8', NULL, NULL),
(5, 'Dental Care', 9, 4, 500, '2026-06-22', '11:50:00', '2026-06-21 16:17:00', 1, 1, '2026-06-21 16:17:50', 'Completed', '2026-06-21 21:47:50', 'doctor:9', NULL, NULL);

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
(104, 'admin', 1, 'doctor_updated', 'doctors', 1, 'Doctor updated: dr.Selonan Sp.PD', '127.0.0.1', '2026-11-13 19:48:48');

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
(1, 'Poli Bedah', 'dr.Selonan Sp.PD', 'Jl. Raya Kopo No.161, Situsaeur, Kec. Bojongloa Kidul, Kota Bandung, Jawa Barat 40233.', '500', 142536250, 'anujk123@test.com', '$2y$10$N9HN4tPs/lJZ.v/8BN0yxOiYJROLO7XsozsAdSJqREBNp2bLbtyXy', '2024-04-10 18:16:52', '2026-11-13 12:48:48'),
(2, 'Endocrinologists', 'dr.Charu Dua', 'ABC Apartment Laxmi Nagar Baru Delhi', '800', 1231231230, 'charudua12@test.com', 'f925916e2754e5e03f75dd58a5733251', '2024-04-11 01:06:41', '2026-11-13 07:31:24'),
(4, 'Pediatrics', 'dr.Patrisia', 'Jl. Perjuangan No.Kav. 8, Kebon Jeruk, Kec. Kb. Jeruk, Kota Jakarta Barat.', '700', 74561235, 'p12@gmail.com', 'f925916e2754e5e03f75dd58a5733251', '2024-05-16 09:12:23', '2026-11-13 07:31:11'),
(5, 'Orthopedics', 'dr Vipin Tayagi', 'Yasho Hospital Baru Delhi', '1200', 95214563210, 'vpint123@gmail.com', 'f925916e2754e5e03f75dd58a5733251', '2024-05-16 09:13:11', '2026-11-13 07:30:56'),
(6, 'Internal Medicine', 'dr Romil', 'Max Hospital Vaishali  GZB', '1500', 8563214751, 'drromil12@gmail.com', 'f925916e2754e5e03f75dd58a5733251', '2024-05-16 09:14:11', '2026-11-13 07:30:41'),
(7, 'Obstetrics and Gynecology', 'dr.Bhavya rathore', 'Shop 12 Indira Puram Ghaziabad', '800', 745621330, 'bhawya12@tt.com', 'f925916e2754e5e03f75dd58a5733251', '2024-05-16 09:15:18', '2026-11-13 07:30:24'),
(8, 'Dental Care', 'dr.Pankaj Sharma', 'P-907, Navi Market\r\nKanpur Uttar Pradeah', '800', 2255647899, 'pankaj@gmail.com', '$2y$10$P9bNKHNLlg/QJv9Jv6r42eaOOMen3Fzd5LoU.JGd4Ymy7pmhalsJK', '2026-06-18 07:10:41', '2026-11-13 07:29:54'),
(9, 'Dental Care', 'dr. Garima', 'Berlin German', '500', 5264123032, 'ga12@test.com', '$2y$10$wXLPRArKIuweC9fz1ibz0./zEC7v9bbbbaGdQdjv2VwQDPtkSBdky', '2026-06-21 16:14:46', '2026-11-13 07:30:10'),
(10, 'Poli Penyakit Dalam (Eksekutif)', 'dr. A. Dedi Rusmanto, Sp.PD.', 'Klinik Imanuel Serua Depok', '1000000', 628562177324, 'adedi@gmail.com', '$2y$10$21XlO/W5AIQpo1y4gs53YOiTChYnSEiEXZSuohWKQojAEaPPT/q9W', '2026-11-13 06:42:15', NULL),
(11, 'Poli Saraf', 'dr. Yekti Nurhaeni, Sp.KJ', 'Imanuek Depok', '1000000', 6285677455, 'YektiNurhaeni@gmail.com', '$2y$10$YF4LTxBD84b1YFT0SoMfKO/sqndQtnOt/ixFdx5dNTV2JwjOYAng6', '2026-11-13 06:44:01', NULL),
(12, 'Poli Anak', 'dr. Riza Maulina, Sp.A', 'RS Bromeus Dago Bandung', '1000000', 62085677456, 'RizaMaulina@gmail.com', '$2y$10$kgspt/1FZ76IcYdZi7zQB.oypxIxwEY4VmpTEVKa99MtY4KzE.nAW', '2026-11-13 06:47:11', NULL),
(13, 'Poli Penyakit Dalam (Eksekutif)', 'dr. Dwi Retno Puji Rahayu, Sp.PD', 'RS AL-IHSAN Bale Endah Bandung', '1000000', 62867877888, 'DwiRetno@gmail.com', '$2y$10$1EYSvX9tcrhNvqO6e/2Ve.JotqRYbeqsH3fbgOqcid1yTu1b3QcGG', '2026-11-13 06:48:42', NULL),
(14, 'Poli Paru', 'dr. Joko Susilo, Sp.P', 'RS Imanuel Bandung', '1000.000', 62882787656, 'JokoSusilo@gmail.com', '$2y$10$qylGyQfgXnGK5h5MiPmOa.QqP.TwKCDfxoKR7lIUgwjLQzr9vKGRa', '2026-11-13 06:50:51', NULL),
(15, 'Poli Saraf', 'dr. Rosari Listiana, Sp.S', 'RS Siloan Jakarta', '2000000', 628857876777, 'RosariListiana@gmail.com', '$2y$10$XqzJg96jtK5iZxmF4vLZeOun8eIAQ/au3tB75lkROwJ.3ZoHwzlaS', '2026-11-13 06:52:18', NULL),
(16, 'Poli Jantung (Eksekutif)', 'dr. Anna Budiarti, Sp.JP(K)', 'RS SILOAN JAKARTA', '2000000', 62885657767, 'AnnaBudiarti@gmail.com', '$2y$10$Bueuyz.MjOKNfBw4Vnw4fOBSqVU.TfV6FC8ooBvrasS2r1XIlOOsW', '2026-11-13 07:08:44', NULL),
(17, 'Poli Medical Check Up (MCU) / Umum', 'dr. Suryawan Widodo', 'RS SILOAN JAKARTA', '0', 63885787999, 'SuryawanWidodo@gmail.com', '$2y$10$/iJtwoiIRRDGyRpk9a7wy.psNHLrrAXgq6FvU1qUr3WDWvQost5Ay', '2026-11-13 07:10:13', NULL),
(18, 'Poli Kebidanan / Kamar Bersalin (VK Rajal)', 'dr. Meirosa Sibuea, Sp.OG.', 'RS SILOAN JAKARTA', '1000000', 62888598764, 'MeirosaSibuea@gmail.com', '$2y$10$ryreg/zLrwaqZ9giR.EmReRUWc2iAC5w2MxEb48AigexDvF1iP3tS', '2026-11-13 07:18:32', NULL),
(19, 'Poli Orthopaedi & Traumatologi (Eksekutif)', 'dr. Rachmat Saleh Raharjo, Sp.OT', 'RS SILOAN JAKARTA', '2000000', 88587877667, 'RachmatSaleh@gmail.com', '$2y$10$qbq4pSMTLAczPWAMiTOhF.YyDdTU6lNA4HK9XD.HQryKwCIijBTFi', '2026-11-13 07:20:25', NULL),
(20, 'Poli Anak Sub. Kardiologi', 'dr. Indana Lazulfa, Sp. A,M.Ked.Klin', 'RS SILOAN JAKARTA', '100000', 88543447777, 'IndanaLazulfa@gmail.com', '$2y$10$oIDTRM.kGpV0ajdLO/kwWO6JpG7v77WrqRHrYXfN9Iy9V2Xiw9/wW', '2026-11-13 07:22:13', NULL),
(21, 'Poli Umum', 'drg. Mohammad Qirom', '-', '1000000', 62885788999, 'MohammadQirom@gmail.com', '$2y$10$LbXTV4ULysDqNw9AoKrA5uSr2Pwr1xSWJRxCQQjPx53KDwntDhBVG', '2026-11-13 07:28:24', NULL);

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
(18, 1, 'anujk123@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 12:50:08', NULL, 1);

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
(47, 1, 'admin', 'admin', 'STATUS_CHANGE', 'REGISTRASI', 'hms_patient_visits', 4, 'Status antrean diubah', '{\"id\":4,\"patient_id\":7,\"mr_type\":\"LAMA\",\"registration_no\":\"REG202611130001\",\"visit_date\":\"2026-11-15\",\"visit_type\":\"RAWAT_JALAN\",\"poli\":\"Poli Bedah\",\"doctor_id\":1,\"appointment_id\":null,\"queue_no\":\"P001\",\"source\":\"OFFLINE\",\"online_booking_token\":null,\"registration_counter\":\"\",\"status\":\"DIPANGGIL\",\"called_at\":\"2026-11-13 19:52:07\",\"served_at\":null,\"completed_at\":null,\"created_at\":\"2026-11-13 19:37:03\",\"arrived_at\":null,\"updated_at\":\"2026-11-13 19:52:07\",\"appointment_status\":null}', '{\"status\":\"DILAYANI\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0', '2026-11-13 19:52:49');

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
(21, 4, 1, 1, '10:00:00', '13:00:00', 15, 1, '2026-11-13 17:34:40', 30, NULL, '2026-11-16 00:00:00', '0000-00-00 00:00:00', 18);

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
(338, NULL, 1, '2026-11-13 19:44:08', 'POLI-BEDAH', 'Poli Bedah', NULL);

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
('QUEUE|20261115|POLI BEDAH', 1),
('REG20261022', 2),
('REG20261110', 1),
('REG20261113', 1);

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
(1, 1, 4, 4, 'Dalam', 'tes tes tes', 'tes tes', 'tes tes', 'tes tes', 'J18.9', 'Pheumonia', 'di erikan obat', NULL, 'DILAYANI', '2026-10-22 14:33:26', NULL, '2026-10-22 14:29:39', '2026-10-22 20:32:54');

-- --------------------------------------------------------

--
-- Table structure for table `hms_patient_user_map`
--

CREATE TABLE `hms_patient_user_map` (
  `user_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 4, 'LAMA', 'REG202610220001', '2026-10-22', 'RAWAT_JALAN', 'Penyakit Dalem', 1, NULL, 'P001', 'ONLINE', '996aae3f81eadc31cd48317f', '1', 'MENUNGGU', NULL, NULL, NULL, '2026-10-22 05:19:31', NULL, NULL),
(2, 5, 'LAMA', 'REG202610220002', '2026-10-22', 'RAWAT_JALAN', 'Poli Penyakit Dalam', NULL, NULL, 'P001', 'ONLINE', NULL, 'Portal Publik', 'MENUNGGU', NULL, NULL, NULL, '2026-10-22 13:30:06', NULL, NULL),
(3, 6, 'LAMA', 'REG202611100001', '2026-11-10', 'RAWAT_JALAN', 'Poli Penyakit Dalam', NULL, NULL, 'P001', 'ONLINE', NULL, 'Portal Publik', 'SELESAI', '2026-11-10 10:45:05', '2026-11-10 10:45:33', '2026-11-13 19:52:30', '2026-11-10 09:48:42', NULL, '2026-11-13 19:52:30'),
(4, 7, 'LAMA', 'REG202611130001', '2026-11-15', 'RAWAT_JALAN', 'Poli Bedah', 1, NULL, 'P001', 'OFFLINE', NULL, '', 'DILAYANI', '2026-11-13 19:52:07', '2026-11-13 19:52:49', NULL, '2026-11-13 19:37:03', NULL, '2026-11-13 19:52:49');

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
(1, 4, 4, '2026-11-15', 20, '2026-11-13 19:37:03');

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
(11, 7, 4, NULL, NULL, 'ANTRIAN', 'DILAYANI', 'Status antrean DILAYANI.', 1, 'admin', '2026-11-13 19:52:49');

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
(21, 'admin', NULL, 'Janji Temu status updated', 'Doctor updated appointment #1 to Completed.', 0, '2026-11-12 15:00:05', NULL);

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
(14, NULL, 'Ratna', 86687878, '', 'female', '', 63, '', '2026-11-13 10:11:24', '2026-11-13 10:11:24', 'RM2026000014');

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
(16, 1, 'johndoe12@test.com', 0x3132372e302e302e3100000000000000, '2026-11-13 12:54:49', NULL, 1);

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
(4, 'Amit', 'New Delhi', 'Delhi', 'male', 'amit12@test.com', '$2y$10$TAFjLEAVIO4O/FPLbr288ePVb7rqaf89VqszIs4Q5goIaGOuL.22C', '2026-06-21 16:16:30', NULL);

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
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
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
  ADD UNIQUE KEY `code` (`code`),
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
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `doctorslog`
--
ALTER TABLE `doctorslog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `hms_icd10`
--
ALTER TABLE `hms_icd10`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1506;

--
-- AUTO_INCREMENT for table `hms_igd_visits`
--
ALTER TABLE `hms_igd_visits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hms_master_poli`
--
ALTER TABLE `hms_master_poli`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=348;

--
-- AUTO_INCREMENT for table `hms_outpatient_encounters`
--
ALTER TABLE `hms_outpatient_encounters`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `hms_patient_visits`
--
ALTER TABLE `hms_patient_visits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
-- AUTO_INCREMENT for table `hms_service_catalog`
--
ALTER TABLE `hms_service_catalog`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=942;

--
-- AUTO_INCREMENT for table `hms_visit_schedules`
--
ALTER TABLE `hms_visit_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `hms_workflow_events`
--
ALTER TABLE `hms_workflow_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `userlog`
--
ALTER TABLE `userlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
