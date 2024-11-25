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
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `course` varchar(100) DEFAULT NULL,
  `section` varchar(50) DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'nielle','123',NULL,NULL,NULL,NULL,NULL,NULL),(2,'wow','321',NULL,NULL,NULL,NULL,NULL,NULL),(3,'ewe','wew',NULL,NULL,NULL,NULL,NULL,NULL),(4,'ewe','wew',NULL,NULL,NULL,NULL,NULL,NULL),(5,'niellethebest@gmail.com','111',NULL,NULL,NULL,NULL,NULL,NULL),(6,'nielle@gmail.com','111','3333333','Batangas','Computer Science','CS-3103',NULL,NULL),(7,'b@gmail.com','1','23','232','23','23',NULL,NULL),(8,'w@gmail.com','11','09472649840','Batangas City','Computer Science','CS-3103','nielle','barcelona'),(9,'1@gmail.com','1','099999999','Batangas city','Computer shop','Lipa Campus','Nielle','Barcelona'),(10,'2@gmail.com','22','2','2','2','Pablo Borbon Campus','Niwwwwe','wweweww'),(11,'Pablo Borbon admin','admin',NULL,NULL,NULL,'Pablo Borbon Campus',NULL,NULL),(12,'Alangilan admin','admin',NULL,NULL,NULL,'Alangilan Campus',NULL,NULL),(13,'Arasof-Nasugbu admin','admin',NULL,NULL,NULL,'Arasof-Nasugbu Campus',NULL,NULL),(14,'Balayan admin','admin',NULL,NULL,NULL,'Balayan Campus',NULL,NULL),(15,'Lemery admin','admin',NULL,NULL,NULL,'Lemery Campus',NULL,NULL),(16,'Mabini admin','admin',NULL,NULL,NULL,'Mabini Campus',NULL,NULL),(17,'JPLPC-Malvar admin','admin',NULL,NULL,NULL,'JPLPC-Malvar Campus',NULL,NULL),(18,'Lipa admin','admin',NULL,NULL,NULL,'Lipa Campus',NULL,NULL),(19,'Rosario admin','admin',NULL,NULL,NULL,'Rosario Campus',NULL,NULL),(20,'San Juan admin','admin',NULL,NULL,NULL,'San Juan Campus',NULL,NULL),(21,'Lobo admin','admin',NULL,NULL,NULL,'Lobo Campus',NULL,NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-25 17:15:18
