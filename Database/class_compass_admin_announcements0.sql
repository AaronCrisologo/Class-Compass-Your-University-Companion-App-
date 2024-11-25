CREATE DATABASE  IF NOT EXISTS `class_compass` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `class_compass`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: class_compass
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_announcements`
--

DROP TABLE IF EXISTS `admin_announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_announcements` (
  `announcement_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `campus` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`announcement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_announcements`
--

LOCK TABLES `admin_announcements` WRITE;
/*!40000 ALTER TABLE `admin_announcements` DISABLE KEYS */;
INSERT INTO `admin_announcements` VALUES (1,'Test','Hello this is a test.','Lipa Campus','2024-11-23 01:13:07','2024-11-23 01:13:07'),(2,'Alangilaan this ','Hello mga eabab.','Alangilan Campus','2024-11-23 01:15:44','2024-11-23 01:15:44'),(3,'AKo','The sun dipped below the horizon, casting a golden glow over the fields as the evening breeze whispered through the trees. Birds fluttered from branch to branch, their songs echoing in the cool air. In the distance, the soft murmur of a river could be heard, winding its way through the landscape. As twilight deepened, the sky turned a rich shade of purple, dotted with the first stars of the night. The world seemed to slow down, as if the day itself was taking a deep breath before the quiet of the night settled in.','Lipa Campus','2024-11-23 02:54:07','2024-11-23 02:54:07'),(4,'weew','LOLOLOLOLOL','Lipa Campus','2024-11-23 02:57:03','2024-11-23 02:57:03'),(5,'nice','SDFKJENUKDJFNUKEHNVKUENUVNJVBNBKUDNFVDVF','Lipa Campus','2024-11-23 02:57:14','2024-11-23 02:57:14'),(6,'alangilan only','ALANGILAN ONLY \n\n\nALANGILAN ONLY\n\nALANGILAN ONLY \n\n\nALANGILAN ONLY','Alangilan Campus','2024-11-23 03:23:30','2024-11-23 03:23:30'),(7,'borbon only','borbon only\nborbon only\nborbon only\nborbon only\nborbon only\nborbon onlyborbon only','Pablo Borbon Campus','2024-11-23 03:25:14','2024-11-23 03:25:14');
/*!40000 ALTER TABLE `admin_announcements` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-25 17:15:17
