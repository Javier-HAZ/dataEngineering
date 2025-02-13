CREATE OR REPLACE EXTERNAL TABLE `dataengineeringcourse2024.zoomcamp.ny_taxi_trips`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de-datawarehousing-bucket2/yellow_tripdata_2024-*.parquet']
);

LOAD DATA INTO `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_mat_view`
FROM FILES (
  format = 'PARQUET',
  uris = ['gs://de-datawarehousing-bucket2/yellow_tripdata_2024-*.parquet']
);
 
CREATE OR REPLACE TABLE `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_partitioned`
PARTITION BY
  DATE(tpep_dropoff_datetime)
  CLUSTER BY VendorID AS
SELECT * FROM dataengineeringcourse2024.zoomcamp.ny_taxi_trips;

--- No cached results
select count(*) from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips`; --20332093, Bytes processed: 0B
select count(*) from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_mat_view`; --20332093, Bytes processed: 0B

select count(distinct PULocationID) from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips`; --155.12MB
select count(distinct PULocationID) from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_mat_view`; --1.06GB


select PULocationID from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_mat_view`; --1.67GB 
select PULocationID, DOLocationID from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_mat_view`; --3.33GB

select count(*) from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips`
where fare_amount = 0; --8333

select distinct vendorID from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_partitioned`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'; -- 26.84MB

select distinct vendorID from `dataengineeringcourse2024.zoomcamp.ny_taxi_trips_mat_view`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'; --3.94GB
