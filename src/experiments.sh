#!/bin/bash

if [ $# -le 2 ] 
then 
    echo "Usage: ./experiments.sh n iters cores";
    exit;
fi

n=$1;
iters=$2;
n_cores=$3

echo "n_cores;seq_time;threads_time;ff_time;omp_time" > "results.csv";
for cores in $(seq $n_cores)
do
    echo "$cores cores executed";
    seq_avg=0;
    threads_avg=0;
    ff_avg=0;
    omp_avg=0;
    for i in {1..1}
    do
        # getting times
        times=$(./main $n $cores $iters | cut -d " " -f2);
        seq_time=$(echo $times | cut -d " " -f1);
        threads_time=$(echo $times | cut -d " " -f2);
        ff_time=$(echo $times | cut -d " " -f3);
        omp_time=$(echo $times | cut -d " " -f4);

        seq_avg=$(echo $seq_avg+$seq_time | bc -l);
        threads_avg=$(echo $threads_time+$threads_avg | bc -l); 
        ff_avg=$(echo $ff_time+$ff_avg | bc -l); 
        omp_avg=$(echo $omp_time+$omp_avg | bc -l); 
    done
    seq_avg=$(echo $seq_avg/5 | bc -l);
    threads_avg=$(echo $threads_avg/5 | bc -l);
    ff_avg=$(echo $ff_avg/5 | bc -l);
    omp_avg=$(echo $omp_avg/5 | bc -l);
    
    # getting speedup
    # threads_sp=$(echo "$seq_avg / $threads_avg" | bc -l);
    # ff_sp=$(echo "$seq_avg / $ff_avg" | bc -l);
    # omp_sp=$(echo "$seq_avg / $omp_avg" | bc -l);

    echo "$cores;$seq_avg;$threads_avg;$ff_avg;$omp_avg" >> "results.csv";
done