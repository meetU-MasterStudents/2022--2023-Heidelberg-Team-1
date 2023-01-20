#while read p; do
#  echo "$p"
#done <peptides.txt

for f in ~/tools/zinc_download_scripts/split_zinc_smi_wget_*
do
  # python toxicology_checker_for_whole_dataset.py $f &

  while read line; do

    subdirectory=echo $wget_cmd | grep -o -P '(?<=mkdir -pv =).*(?= &&)'

    # get last 10 chars of string
    filename=${wget_cmd: -10}

    cd $subdirectory

    echo $subdirectory

    # if
    for f_sub in $subdirectory
    do
      if [[ $fsub == *_tox_results.csv ]]
      then
        split -n 20 filename filename_
      fi
    done



  done < "$f"

done
