DROP DATABASE IF EXISTS search_logger;
CREATE DATABASE search_logger;
USE search_logger;

CREATE TABLE google_results(
  id int auto_increment,
  searched_keyword varchar(250),
  title text,
  url text,
  description text,
  position int,
  created_at datetime,
  PRIMARY KEY(id)
) DEFAULT CHARACTER SET utf8;
CREATE INDEX position_idx ON google_results(position);