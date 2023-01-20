for f in ~/data/zinc_data/dirs_no_tox_split/dirs_no_tox_*
do
  python large_files_etoxpred_runner.py $f &
done
