#!/bin/bash
npx kill-port 3000
echo "Enter root password"
mysql -uroot -p << MYSQL_SCRIPT
DROP DATABASE IF EXISTS cs253_asgn4_data;
CREATE DATABASE cs253_asgn4_data;
USE cs253_asgn4_data;
CREATE TABLE user_data (
  id INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(50) NULL,
  password VARCHAR(50) NULL,
  PRIMARY KEY (id));
INSERT INTO user_data (email,password) values ('meow@meow.com','4b673ef9d9869d2661a128b4d115f5fc');
DESCRIBE user_data;
SELECT * FROM user_data;
MYSQL_SCRIPT
echo "Database created"

npm install
node $1
