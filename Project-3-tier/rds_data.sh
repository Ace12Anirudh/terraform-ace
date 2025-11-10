#! /bin/bash

set -euo pipefail

DB_HOST="${DB_HOST}"
DB_USER="${DB_USER}"
DB_PASS="${DB_PASS}"

yum install mariadb105-server -y

# Wait for RDS to become available
echo "Waiting for ${DB_HOST}:3306..."
for i in {1..120}; do
  (echo > /dev/tcp/${DB_HOST}/3306) >/dev/null 2>&1 && break
  sleep 5
done

# Create SQL file directly from user data
cat > /tmp/init.sql <<'SQL'
-- Example SQL content goes here
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS test;

-- Use the test database
USE test;

-- Table structure for table `books`
CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL,
  `title` varchar(300) NOT NULL,
  `desc` varchar(500) NOT NULL,
  `price` float NOT NULL,
  `cover` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table `books`
INSERT INTO `books` (`id`, `title`, `desc`, `price`, `cover`) VALUES
(1, 'MultiCloud', 'this is mutlicloud with devops cource by veera sir nareshit ', 2343.2, 'https://docs.multy.dev/assets/images/multi-cloud-314609adeec670988dff0882a93fdcb0.png'),
(2, 'DevOps', 'if you understand the devops it is very easy', 2342.3, 'https://media.licdn.com/dms/image/v2/D5612AQHsA9dJVtZRdw/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1730826289071?e=2147483647&v=beta&t=JGr0gJH6RE9b1Dk7nHAYF14Kmv96Gm519UOy_rSa3xE');

-- Add primary key for the books table
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

-- Set auto increment for the `id` column
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

COMMIT;
-- You can put as many statements as needed here
SQL

# Run the SQL file against the RDS instance
mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" < /tmp/init.sql

echo "✅ SQL initialization completed successfully."