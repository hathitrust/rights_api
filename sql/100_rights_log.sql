USE ht;
LOCK TABLES `rights_log` WRITE;
/*!40000 ALTER TABLE `rights_log` DISABLE KEYS */;
INSERT INTO `rights_log` VALUES ('test','pd_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','op_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','op_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic-world_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic-world_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic-world_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','nobody_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','nobody_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','nobody_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pdus_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pdus_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pdus_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-3.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-3.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-3.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-3.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-3.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-3.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-3.0_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-3.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-3.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-3.0_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-3.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-3.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-sa-3.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-zero_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-zero_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-zero_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und-world_page+lowres',2,1,1,4,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','icus_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','icus_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-4.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-4.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-4.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-4.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-4.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-4.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-4.0_page',2,1,1,3,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-4.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-4.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-4.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-4.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-sa-4.0_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-sa-4.0_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd-pvt_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd-pvt_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','supp_open',2,1,1,1,'libadm','2008-12-31 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','supp_google',2,1,1,2,'libadm','2008-12-31 05:00:00',NULL);

INSERT INTO `rights_log` VALUES ('test','pd_open',1,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd_google',1,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd_page',1,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic_open',2,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic_google',2,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic_page',2,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','op_open',3,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','op_google',3,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und_open',5,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und_google',5,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und_page',5,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic-world_open',7,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic-world_google',7,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','ic-world_page',7,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','nobody_open',8,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','nobody_google',8,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','nobody_page',8,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pdus_open',9,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pdus_google',9,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pdus_page',9,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-3.0_open',10,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-3.0_google',10,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-3.0_open',11,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-3.0_google',11,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-3.0_open',12,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-3.0_google',12,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-3.0_page',12,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-3.0_open',13,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-3.0_google',13,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-3.0_page',13,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-3.0_open',14,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-3.0_google',14,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-sa-3.0_google',15,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-zero_open',17,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-zero_google',17,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-zero_page',17,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','und-world_page+lowres',18,1,1,4,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','icus_open',19,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','icus_google',19,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-4.0_open',20,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-4.0_google',20,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-4.0_open',21,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nd-4.0_google',21,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-4.0_open',22,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-4.0_google',22,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-nd-4.0_page',22,1,1,3,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-4.0_open',23,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-4.0_google',23,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-4.0_open',24,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-nc-sa-4.0_google',24,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-sa-4.0_open',25,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','cc-by-sa-4.0_google',25,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd-pvt_open',26,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','pd-pvt_google',26,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','supp_open',27,1,1,1,'libadm','2009-01-01 05:00:00',NULL);
INSERT INTO `rights_log` VALUES ('test','supp_google',27,1,1,2,'libadm','2009-01-01 05:00:00',NULL);
/*!40000 ALTER TABLE `rights_log` ENABLE KEYS */;
UNLOCK TABLES;