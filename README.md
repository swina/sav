## Run Container

From the project root

```docker-compose up -d```

## Import Data

```
docker cp <src_path>savenergy_DB.sql sav_mysql_1:/tmp
```

```
docker cp <src_path>configuratore_DB.sql sav_mysql_1:/tmp
```



### Import to mySQL

```
mysql -u root -p savenergy < /tmp/savenergy_DB.sql
```

```
mysql -u root -p configuratore < /tmp/configuratore_DB.sql
```

## mySQL settings

```
mysql -u root -p 

set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

exit

```

## ColdFusion DSN settings

To create a Datasource use the following connection info:

```
datasource: savenergy
database : savenergy
server : sav_mysql_1
port: 3306
user: root
password: <password>
```
```
datasource: configuratore
database : configuratore
server : sav_mysql_1
port: 3306
user: root
password: <password>
```

