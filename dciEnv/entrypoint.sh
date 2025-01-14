#!/bin/bash
set -e

# Start MongoDB cluster
mongod --config /etc/service-config/mongo/mongod1.conf &
mongod --config /etc/service-config/mongo/mongod2.conf &
mongod --config /etc/service-config/mongo/mongod3.conf &

# Start ZooKeeper cluster
zookeeper-server-start /etc/service-config/zookeeper/zoo1.cfg &
zookeeper-server-start /etc/service-config/zookeeper/zoo2.cfg &
zookeeper-server-start /etc/service-config/zookeeper/zoo3.cfg &

# Start Kafka cluster
kafka-server-start /etc/service-config/kafka/server1.properties &
kafka-server-start /etc/service-config/kafka/server2.properties &
kafka-server-start /etc/service-config/kafka/server3.properties &

# Start Redis
redis-server &

# Start MySQL without running in the background
service mysql start

# Check if MySQL has already been initialized
if [ ! -f /var/lib/mysql/.mysql_initialized ]; then
  echo "Initializing MySQL..."

  # Set root password and grant remote access
  mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER 'root'@'%' IDENTIFIED WITH 'mysql_native_password' BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

  # Create a marker file to indicate initialization is complete
  touch /var/lib/mysql/.mysql_initialized

  echo "MySQL initialization complete."
else
  echo "MySQL is already initialized."
fi

# Keep the container running by tailing logs or running MySQL in the foreground
tail -f /dev/null

