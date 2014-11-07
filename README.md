docker-logfaces
====================

CentOS6 + logfaces v4.1.2 inside.

You could run it with your own configs, just map your storage to `/root/logFacesServer/conf` to save generated 
configs and put your initial configs to `./initial-config/`. 
E.g.: put your `lfs.xml`, `lfs.lic`, `realm.properties` to `/mnt/data/lfs/initial-config/` and map `/mnt/data/lfs/initial-config/` to `/root/logFacesServer/conf`.

### Environment variables
* `MONGO_URL` like mongo.example.com:27017

### How to run it
```
docker run -d -t -p 8050:8050 -p 55200:55200 -p 1468:1468 -p 55201:55201 -p 514:514/udp -e "MONGO_URL=mongo.example.com:27017" -v /mnt/data/lfs:/root/logFacesServer/conf --name lfs-prod lfs
```