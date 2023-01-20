for f in ~/tools/zinc_download_scripts/split_zinc_smi_wget_*
do
  python toxicology_checker_for_whole_dataset.py $f &
done
