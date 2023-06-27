# change directory to week5
cd bren-meds213-class-data/week5


# parse command line arguments
if [[ $# -ne 5 ]]; then
    echo "usage: $0 label num_reps query db_file csv_file"
    exit 1
fi

label=$1
reps=$2
query=$3
db_file=$4
csv_file=$5

# check if the CSV file exists
if [[ ! -f "$csv_file" ]]; then
    # create a blank CSV file with header
    echo "label,time_per_iteration" > "$csv_file"
fi

# get the current time in seconds since the Unix epoch
time1=$(date +%s)

# loop through the number of iterations specified
for i in $(seq $reps); do
    # execute the SQL query and redirect the output to stdout
    sqlite3 "$db_file" <<EOF > /dev/null 2>&1
    $query
EOF

    # print a message indicating the current loop iteration
    echo "this is loop iteration $i"
done

# get the current time in seconds since the Unix epoch
time2=$(date +%s)

# calculate the total elapsed time by subtracting the start time from the end time
total_elapsed_time=$((time2-time1))

# calculate the average time per loop iteration and store it in the 'elapsed' variable
elapsed=$(python -c "print($total_elapsed_time/$reps)")

# append the result to the CSV file
echo "$label,$elapsed" >> "$csv_file"

# print the average time per loop iteration
echo "average time per loop iteration: $elapsed seconds"

#bash my_sqlite_tester.sh NOT_IN 5000 'SELECT Code FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests)' database.db timings.csv

#bash my_sqlite_tester.sh OUTER_JOIN 5000 'SELECT Species.Code FROM Bird_nests RIGHT JOIN Species ON Bird_nests.Species = Species.Code WHERE Bird_nests.Nest_ID IS NULL)' database.db timings.csv

#bash my_sqlite_tester.sh SET_OPERATION 5000 'SELECT Code FROM Species EXCEPT SELECT DISTINCT Species FROM Bird_nests)' database.db timings.csv