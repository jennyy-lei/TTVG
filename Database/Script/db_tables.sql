--
-- The data tables of TTVG
--

set sql_mode='';
set storage_engine=myisam;

-- Tables for the Users
-- Define all persons
CREATE TABLE IF NOT EXISTS person ( Id int unsigned not null, FatherId int, MotherId int, GuardianId int, GivenName char(128) binary DEFAULT '' NOT NULL, LastName char(128) binary DEFAULT '' NOT NULL, MiddleName char(128) binary DEFAULT '', ChineseName char(128) binary DEFAULT '', Image char(128) binary DEFAULT '', Phone char(128) binary DEFAULT '', Mobile char(128) binary DEFAULT '', Address char(255) binary DEFAULT '', Created DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY Id (Id), FOREIGN KEY (FatherId) REFERENCES person (Id), FOREIGN KEY (MotherId) REFERENCES person (Id), FOREIGN KEY (GuardianId) REFERENCES person (Id) ) engine=MyISAM CHARACTER SET utf8 COLLATE utf8_bin comment='Database privileges';

-- Define all user accounts and link to the person
CREATE TABLE IF NOT EXISTS account ( Id int unsigned not null, PersonId int unsigned not null, Role char(128) binary DEFAULT '', Email char(128) binary DEFAULT '' NOT NULL UNIQUE, Password char(128) binary DEFAULT '' NOT NULL, Created DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY Id (Id), FOREIGN KEY (PersonId) REFERENCES person (Id) ) engine=MyISAM CHARACTER SET utf8 COLLATE utf8_bin comment='Database privileges';

-- Define all forum items and link to the person
CREATE TABLE IF NOT EXISTS forum ( Id int unsigned not null, PersonId int unsigned not null, DateTime DATETIME not null, ForumId int unsigned, Title char(128) binary DEFAULT '', Content text BINARY DEFAULT '', Priority int unsigned, Created DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY Id (Id), FOREIGN KEY (PersonId) REFERENCES person (Id), FOREIGN KEY (ForumId) REFERENCES forum (Id) ) engine=MyISAM CHARACTER SET utf8 COLLATE utf8_bin comment='Database privileges';

-- Define all event items
CREATE TABLE IF NOT EXISTS event ( Id int unsigned not null, FromDate DATE, ToDate DATE, Title char(128) binary DEFAULT '', EventType char(128) binary DEFAULT '', EventCategory char(128) binary DEFAULT '', Content text BINARY DEFAULT '', DateTime DATETIME not null, Created DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY Id (Id) ) engine=MyISAM CHARACTER SET utf8 COLLATE utf8_bin comment='Database privileges';

-- Define the person to event link
CREATE TABLE IF NOT EXISTS person_event_link ( PersonId int unsigned not null, EventId int unsigned not null, Created DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY Id (PersonId, EventId), FOREIGN KEY (PersonId) REFERENCES person (Id), FOREIGN KEY (EventId) REFERENCES event (Id) ) engine=MyISAM CHARACTER SET utf8 COLLATE utf8_bin comment='Database privileges';

-- Define all audit items
CREATE TABLE IF NOT EXISTS action_audit ( Id int unsigned not null, AccountId int unsigned not null, Target char(64) BINARY DEFAULT '' NOT NULL, Content char(128) BINARY DEFAULT '', Action char(64) BINARY DEFAULT '' NOT NULL, Created DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY Id (Id) ) engine=MyISAM CHARACTER SET utf8 COLLATE utf8_bin comment='Database privileges';

