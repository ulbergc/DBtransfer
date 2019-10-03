
echo "Type any key to confirm table is dropped from MySQL?"
#read response

# Spark input values
num_executors=6
executor_cores=6
executor_memory=4

# Input values
prog_name=process_data_s3.py
read_db_name=tmp4
read_table_name=c0
py_args=$( echo "$read_db_name $read_table_name" )

EXTRA_ARGS=$(--conf "spark.dynamicAllocation.enable = true" --conf "spark.dynamicAllocation.executorIdleTimeout = 2m" --conf "spark.dynamicAllocation.minExecutors = 1" --conf "spark.dynamicAllocation.maxExecutors = 2000" --conf "spark.stage.maxConsecutiveAttempts = 10" --conf "spark.memory.offHeap.enable = true" --conf "spark.memory.offHeap.size = 3g" --conf "spark.yarn.executor.memoryOverhead = 0.1 * (spark.executor.memory + spark.memory.offHeap.size)")
EXTRA_ARGS=



starttime=`date +%s`
SPARK_ARGS=$(echo "--num-executors ${num_executors} --executor-cores ${executor_cores} --executor-memory ${executor_memory}G")
#SPARK_ARGS=$(echo "--executor-memory 5G")
# could add driver-memory
PACKAGE=$(echo "--packages com.databricks:spark-csv_2.10:1.2.0,mysql:mysql-connector-java:8.0.17")

masterDNS=10.0.0.6
MASTER=$(echo "--master spark://$masterDNS:7077")
#MASTER=
echo $MASTER

echo "Calling spark-submit $PACKAGE $MASTER $SPARK_ARGS $prog_name $py_args"

spark-submit $PACKAGE $MASTER $SPARK_ARGS $EXTRA_ARGS $prog_name $py_args

endtimeFull=`date`
endtime=`date +%s`
runtime=$((endtime-starttime))
echo "Testing"
echo "$endtimeFull | $runtime | spark-submit $PACKAGE $MASTER $SPARK_ARGS $prog_name $py_args" >> ../logs/sparktime.log
