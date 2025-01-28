Question 1. Understanding docker first run:
Run the following command: docker container run -it --entrypoint=bash python:3.12.8

Question 2. Understanding Docker networking and docker-compose
based on the definition of the docker compose file, the port inside the postgres is 5432, and the host is db as we can see using the following command to test connection:
    * docker run -it --rm --network=homework_default busybox ping db
    * output :  Status: Downloaded newer image for busybox:latest
                9c0abc9c5bd3: Pull complete
                Digest: sha256:a5d0ce49aa801d475da48f8cb163c354ab95cab073cd3c138bd458fc8257fbf1
                Status: Downloaded newer image for busybox:latest
                PING db (172.20.0.3): 56 data bytes
                64 bytes from 172.20.0.3: seq=0 ttl=64 time=6.877 ms
                64 bytes from 172.20.0.3: seq=1 ttl=64 time=0.122 ms
                64 bytes from 172.20.0.3: seq=2 ttl=64 time=0.110 ms
                64 bytes from 172.20.0.3: seq=3 ttl=64 time=0.104 ms
                64 bytes from 172.20.0.3: seq=4 ttl=64 time=0.086 ms
                ...
                --- db ping statistics ---
                80 packets transmitted, 80 packets received, 0% packet loss
                round-trip min/avg/max = 0.070/0.219/6.877 ms

3. Question 3. Trip Segmentation Count:
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:
    3.1. Up to 1 mile
        SELECT * from public.green_taxi_trips
        where lpep_pickup_datetime >= '2019-10-01 00:00:00' and lpep_pickup_datetime <= '2019-10-31 23:59:59'
        and trip_distance <= 1;
        * Total trips = 104830
    3.2. In between 1 (exclusive) and 3 miles (inclusive)
        SELECT * from public.green_taxi_trips
        where lpep_pickup_datetime >= '2019-10-01 00:00:00' and lpep_pickup_datetime <= '2019-10-31 23:59:59'
        and trip_distance > 1 and trip_distance <= 3;
        * Total trips: 198995
    3.3. In between 3 (exclusive) and 7 miles (inclusive),
        SELECT * from public.green_taxi_trips
        where lpep_pickup_datetime >= '2019-10-01 00:00:00' and lpep_pickup_datetime <= '2019-10-31 23:59:59'
        and trip_distance > 3 and trip_distance <= 7;
        * Total trips: 109642
    3.4. In between 7 (exclusive) and 10 miles (inclusive):
        SELECT * from public.green_taxi_trips
        where lpep_pickup_datetime >= '2019-10-01 00:00:00' and lpep_pickup_datetime <= '2019-10-31 23:59:59'
        and trip_distance > 7 and trip_distance <= 10;
        * Total trips: 27686
    3.5 Over 10 miles:
        SELECT * from public.green_taxi_trips
        where lpep_pickup_datetime >= '2019-10-01 00:00:00' and lpep_pickup_datetime <= '2019-10-31 23:59:59'
        and trip_distance > 10;
        * Total trips: 35201
4. Question 4. Longest trip for each day:
    SELECT 
    DATE(lpep_pickup_datetime) AS pickup_day, 
    MAX(trip_distance) AS max_trip_distance
    FROM public.green_taxi_trips
    GROUP BY pickup_day
    ORDER BY max_trip_distance DESC;
    * 2019-10-31, with 515.89
5. Three biggest pickup zones:
    SELECT 
    pu."Zone" AS PU_Location_Name, 
    SUM(gtt."total_amount") AS total_amount
    FROM public.green_taxi_trips gtt
    LEFT JOIN public.lookup_table pu ON gtt."PULocationID" = pu."LocationID"
    LEFT JOIN public.lookup_table dol ON gtt."DOLocationID" = dol."LocationID"
    WHERE gtt."lpep_pickup_datetime" BETWEEN '2019-10-18 00:00:00' AND '2019-10-18 23:59:59'
    GROUP BY pu."Zone"
    HAVING SUM(gtt."total_amount") > 13000
    ORDER BY total_amount DESC;
6.  Question 6. Largest tip
    SELECT 
    dol."Zone" AS DO_Location_Name, 
    MAX(gtt."tip_amount") AS largest_tip
    FROM public.green_taxi_trips gtt
    LEFT JOIN public.lookup_table pu ON gtt."PULocationID" = pu."LocationID"
    LEFT JOIN public.lookup_table dol ON gtt."DOLocationID" = dol."LocationID"
    WHERE pu."Zone" = 'East Harlem North'
    AND gtt."lpep_pickup_datetime" BETWEEN '2019-10-01' AND '2019-10-31'
    GROUP BY dol."Zone"
    ORDER BY largest_tip DESC
    LIMIT 1;