#!/bin/bash
set -e

# Start MongoDB cluster
/usr/bin/mongod --config /opt/dciConfig/mongo/mongodb1.conf &
/usr/bin/mongod --config /opt/dciConfig/mongo/mongodb2.conf &
/usr/bin/mongod --config /opt/dciConfig/mongo/mongodb3.conf &
# service mongodb1 start
# service mongodb2 start
# service mongodb3 start

# Start ZooKeeper cluster
/opt/zookeeper/bin/zkServer.sh --config /opt/dciConfig/zookeeper/1 start &
/opt/zookeeper/bin/zkServer.sh --config /opt/dciConfig//zookeeper/2 start &
/opt/zookeeper/bin/zkServer.sh --config /opt/dciConfig//zookeeper/3 start &
# service zookeeper1 start
# service zookeeper2 start
# service zookeeper3 start

# Start Kafka cluster
/opt/kafka/bin/kafka-server-start.sh /opt/dciConfig//kafka/server1.properties &
/opt/kafka/bin/kafka-server-start.sh /opt/dciConfig//kafka/server2.properties &
/opt/kafka/bin/kafka-server-start.sh /opt/dciConfig//kafka/server3.properties &
# service kafka1 start
# service kafka2 start
# service kafka3 start

# Start Redis
#redis-server &

# Start MySQL without running in the background
service mysql start

# Check if MySQL has already been initialized
if [ ! -f /var/lib/mysql/.mysql_initialized ]; then
  echo "Initializing MySQL...${MYSQL_ROOT_PASSWORD}"

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
service mysql restart

# Check if Mongo has already been initialized
if [ ! -f /var/lib/mongodb/.mongodb_initialized ]; then
  echo "Initializing MongoDB as cluster..."

  # initial cluster
  /usr/bin/mongosh --host localhost:27017 --eval 'rs.initiate( {   _id : "sotn-set",   members: [      { _id: 0, host: "localhost:27017" , priority: 3},      { _id: 1, host: "localhost:27018", priority: 2 },      { _id: 2, host: "localhost:27019", priority: 1 }   ]})'

  # Create a marker file to indicate initialization is complete
  touch /var/lib/mongodb/.mongodb_initialized

  echo "MongoDB initialization complete."
else
  echo "MongoDB is already initialized."
fi

