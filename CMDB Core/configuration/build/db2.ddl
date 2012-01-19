-- This CLP file was created using DB2LOOK Version "9.7" 
-- Timestamp: December 13, 2011 11:09:10 AM CET
-- Database Name: T168D001       
-- Database Manager Version: DB2/SUN64 Version 9.7.3       
-- Database Codepage: 819
-- Database Collating Sequence is: UNIQUE


CONNECT TO T168D001;

------------------------------------------------
-- DDL Statements for Schemas
------------------------------------------------


CREATE SCHEMA "TST001  " AUTHORIZATION "T168    ";



------------------------------------------------
-- DDL Statements for table "TST001  "."ELEMENT"
------------------------------------------------
 

CREATE TABLE "TST001  "."ELEMENT"  (
		  "ELEMENTID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +2147483647  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "ELEMENTTYPEID" INTEGER NOT NULL , 
		  "NAME" VARCHAR(100) NOT NULL , 
		  "FROMTIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "TOTIMESTAMP" TIMESTAMP , 
		  "CREATEID" VARCHAR(10) , 
		  "CREATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "UPDATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "VERSION" INTEGER NOT NULL ,
		  "CONFIGURATION" XML NOT NULL )   
		 IN "GEMENSAM_TSP" INDEX IN "GEMENSAM_XSP" LONG IN "GEMENSAM_LSP" ; 


-- DDL Statements for primary key on Table "TST001  "."ELEMENT"

ALTER TABLE "TST001  "."ELEMENT" 
	ADD PRIMARY KEY
		("ELEMENTID");



-- DDL Statements for indexes on Table "TST001  "."ELEMENT"

CREATE INDEX "TST001  "."ATTRIDX" ON "TST001  "."ELEMENT" 
		("CONFIGURATION" ASC)
		GENERATE KEY USING XMLPATTERN '//@*'
		  AS SQL VARCHAR  HASHED IGNORE INVALID VALUES 
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."ELEMENT"

CREATE INDEX "TST001  "."ELEMENT_FK" ON "TST001  "."ELEMENT" 
		("ELEMENTTYPEID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."ELEMENT"

CREATE INDEX "TST001  "."ELEMENT_SK" ON "TST001  "."ELEMENT" 
		("ELEMENTTYPEID" ASC,
		 "NAME" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."ELEMENT"

CREATE INDEX "TST001  "."ELEMIDX" ON "TST001  "."ELEMENT" 
		("CONFIGURATION" ASC)
		GENERATE KEY USING XMLPATTERN '//*'
		  AS SQL VARCHAR  HASHED IGNORE INVALID VALUES 
		COMPRESS NO ALLOW REVERSE SCANS;
ALTER TABLE "TST001  "."ELEMENT" ALTER COLUMN "ELEMENTID" RESTART WITH 565700;

------------------------------------------------
-- DDL Statements for table "TST001  "."ELEMENTTYPE"
------------------------------------------------
 

CREATE TABLE "TST001  "."ELEMENTTYPE"  (
		  "ELEMENTTYPEID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +2147483647  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "NAME" VARCHAR(100) NOT NULL , 
		  "FROMTIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "TOTIMESTAMP" TIMESTAMP , 
		  "CREATEID" VARCHAR(10) , 
		  "CREATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "UPDATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP )   
		 IN "GEMENSAM_TSP" INDEX IN "GEMENSAM_XSP" LONG IN "GEMENSAM_LSP" ; 


-- DDL Statements for primary key on Table "TST001  "."ELEMENTTYPE"

ALTER TABLE "TST001  "."ELEMENTTYPE" 
	ADD PRIMARY KEY
		("ELEMENTTYPEID");


ALTER TABLE "TST001  "."ELEMENTTYPE" ALTER COLUMN "ELEMENTTYPEID" RESTART WITH 159;

------------------------------------------------
-- DDL Statements for table "TST001  "."RELATION"
------------------------------------------------
 

CREATE TABLE "TST001  "."RELATION"  (
		  "RELATIONID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +2147483647  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "RELATIONTYPEID" INTEGER NOT NULL , 
		  "SOURCEID" INTEGER NOT NULL , 
		  "DESTINATIONID" INTEGER NOT NULL , 
		  "FROMTIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "TOTIMESTAMP" TIMESTAMP , 
		  "CREATEID" VARCHAR(10) , 
		  "CREATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "UPDATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "VERSION" INTEGER NOT NULL ,
		  "CONFIGURATION" XML NOT NULL )   
		 IN "GEMENSAM_TSP" INDEX IN "GEMENSAM_XSP" LONG IN "GEMENSAM_LSP" ; 


-- DDL Statements for primary key on Table "TST001  "."RELATION"

ALTER TABLE "TST001  "."RELATION" 
	ADD PRIMARY KEY
		("RELATIONID");



-- DDL Statements for indexes on Table "TST001  "."RELATION"

CREATE INDEX "TST001  "."DEST_REL_FK" ON "TST001  "."RELATION" 
		("DESTINATIONID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."RELATION"

CREATE INDEX "TST001  "."RELAIDX" ON "TST001  "."RELATION" 
		("CONFIGURATION" ASC)
		GENERATE KEY USING XMLPATTERN '//*'
		  AS SQL VARCHAR  HASHED IGNORE INVALID VALUES 
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."RELATION"

CREATE INDEX "TST001  "."RELAIDX2" ON "TST001  "."RELATION" 
		("CONFIGURATION" ASC)
		GENERATE KEY USING XMLPATTERN '//@*'
		  AS SQL VARCHAR  HASHED IGNORE INVALID VALUES 
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."RELATION"

CREATE INDEX "TST001  "."RELATION_FK" ON "TST001  "."RELATION" 
		("RELATIONTYPEID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "TST001  "."RELATION"

CREATE INDEX "TST001  "."SOURCE_REL_FK" ON "TST001  "."RELATION" 
		("SOURCEID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;
ALTER TABLE "TST001  "."RELATION" ALTER COLUMN "RELATIONID" RESTART WITH 942939;

------------------------------------------------
-- DDL Statements for table "TST001  "."RELATIONTYPE"
------------------------------------------------
 

CREATE TABLE "TST001  "."RELATIONTYPE"  (
		  "RELATIONTYPEID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +2147483647  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "NAME" VARCHAR(100) NOT NULL , 
		  "FROMTIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "TOTIMESTAMP" TIMESTAMP , 
		  "CREATEID" VARCHAR(10) , 
		  "CREATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "UPDATETIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP )   
		 IN "GEMENSAM_TSP" INDEX IN "GEMENSAM_XSP" LONG IN "GEMENSAM_LSP" ; 


-- DDL Statements for primary key on Table "TST001  "."RELATIONTYPE"

ALTER TABLE "TST001  "."RELATIONTYPE" 
	ADD PRIMARY KEY
		("RELATIONTYPEID");


ALTER TABLE "TST001  "."RELATIONTYPE" ALTER COLUMN "RELATIONTYPEID" RESTART WITH 119;

-- DDL Statements for foreign keys on Table "TST001  "."ELEMENT"

ALTER TABLE "TST001  "."ELEMENT" 
	ADD CONSTRAINT "ELETYPEFK" FOREIGN KEY
		("ELEMENTTYPEID")
	REFERENCES "TST001  "."ELEMENTTYPE"
		("ELEMENTTYPEID")
	ON DELETE RESTRICT
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;

-- DDL Statements for foreign keys on Table "TST001  "."RELATION"

ALTER TABLE "TST001  "."RELATION" 
	ADD CONSTRAINT "RELDESTFK" FOREIGN KEY
		("DESTINATIONID")
	REFERENCES "TST001  "."ELEMENT"
		("ELEMENTID")
	ON DELETE RESTRICT
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;

ALTER TABLE "TST001  "."RELATION" 
	ADD CONSTRAINT "RELSRCFK" FOREIGN KEY
		("SOURCEID")
	REFERENCES "TST001  "."ELEMENT"
		("ELEMENTID")
	ON DELETE RESTRICT
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;

ALTER TABLE "TST001  "."RELATION" 
	ADD CONSTRAINT "RELTYPEFK" FOREIGN KEY
		("RELATIONTYPEID")
	REFERENCES "TST001  "."RELATIONTYPE"
		("RELATIONTYPEID")
	ON DELETE RESTRICT
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;








COMMIT WORK;

CONNECT RESET;

TERMINATE;