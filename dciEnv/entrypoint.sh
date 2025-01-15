#!/bin/bash
set -e

# Start MongoDB cluster
/opt/mongo/bin/mongod --config /opt/dciConfig/mongo/mongod1.conf &
/opt/mongo/bin/mongod --config /opt/dciConfig/mongo/mongod2.conf &
/opt/mongo/bin/mongod --config /opt/dciConfig/mongo/mongod3.conf &

# Start ZooKeeper cluster
/opt/zookeeper/bin/zkServer.sh --config /opt/dciConfig/zookeeper/1 &
/opt/zookeeper/bin/zkServer.sh --config /opt/dciConfig/zookeeper/2 &
/opt/zookeeper/bin/zkServer.sh --config /opt/dciConfig/zookeeper/3 &

# Start Kafka cluster
/opt/kafka/bin/kafka-server-start.sh /opt/dciConfig/kafka/server1.properties &
/opt/kafka/bin/kafka-server-start.sh /opt/dciConfig/kafka/server2.properties &
/opt/kafka/bin/kafka-server-start.sh /opt/dciConfig/kafka/server3.properties &

# Start Redis
#redis-server &

# Start MySQL without running in the background
#service mysql start

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

