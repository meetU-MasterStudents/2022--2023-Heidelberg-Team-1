#!/usr/bin/env bash

script_directory="/home/darius/tools/autodock_vina_extra_scripts"

generate_affinity_maps() {
  # hier muessen noch das gridcenter und die box_bounds eingestellt werden

  pythonsh $script_directory/prepare_gpf4zn.py -l $1.pdbqt -r protein_tz.pdbqt \
  -o protein_tz.gpf  -p npts=20,20,20 -p gridcenter=-14,11,-75 \
  –p parameter_file=AD4Zn.dat
  # –p parameter_file=/home/darius/tools/autodock_vina_extra_scripts/AD4Zn.dat
  
  /home/darius/anaconda3/envs/vina2/bin/autogrid4 -p protein_tz.gpf -l protein_tz.glg
}


run_vina() {
   # generate_affinity_maps $1

  # evtl scoring with vinardo better
  #vina --ligand $1.pdbqt --maps protein_tz --scoring vinardo \
  #     --exhaustiveness 32 --out $1.vinardo_out.pdbqt | echo $(grep -P '   1\s+([+-]*\d*.\d*)' -o) > vina_log.txt

  #  /usr/bin/vina --ligand $1.pdbqt --maps protein_tz --scoring ad4 \
  #      --exhaustiveness 32 --out $1.out.pdbqt | echo $(grep -P '   1\s+([+-]*\d*.\d*)' -o) | sed "s/1/$1/" >> vina_log.txt
  
    /usr/bin/vina --ligand $1.pdbqt --receptor protein.pdbqt --scoring vinardo \
        --config vinardo_config.txt --exhaustiveness 32 --out $1.out.pdbqt | echo $(grep -P '   1\s+([+-]*\d*.\d*)' -o) | sed "s/1/$1/" >> vina_log.txt
  # wenn das funktioniert das umändern, dass das in eine file geschrieben wird
  # >  $1.output

  # extract best affinity and append to some prepared csv
  # regex die ich brauche "   1\s+([+-]*\d*.\d*)"

  # delete vina outputs
    rm $1*pdbqt


  # delete affinity_maps outputs
    rm -rf protein_tz*.map

}





prepare_receptor_routine() {
    echo "got into prepare_receptor"

    # hier den Rezeptor aufs Cluster packen
    prepare_receptor -r "$PWD/protein.pdb" -o "$PWD/protein.pdbqt"
    # pythonsh $script_directory/zinc_pseudo.py -r protein.pdbqt -o protein_tz.pdbqt
}

# $1 soll die zinc_id sein
prepare_ligand() {
    # make hydrogens explicit
    /home/darius/anaconda3/envs/vina2/bin/obabel "$1.sdf" -O "$1.with_hydrogens.sdf" -h
    # obabel "$1.sdf" -O "$1.with_hydrogens.sdf" -h
    
    echo "obabel done"
    
    mk_prepare_ligand.py -i "$1.with_hydrogens.sdf" -o "$1.pdbqt"
    
    echo "meeko done"
}

# $1 soll die zinc_id sein
get_sdf_file_and_run_vina_for_one_molecule() {

    # get sdf file from Zinc15 database
    # WIEDER EINKOMMENTIEREN: Zeile drunter
    wget https://zinc15.docking.org/substances/$1.sdf

    prepare_ligand $1
  
    echo "ligand done"

    # evtl. dann spaeter in ein bestimmtes directory
    # echo "$PWD"
    if ! test -f "$PWD/protein.pdbqt"; then
        echo "protein affinity does not yet exists"
        prepare_receptor_routine
    fi

    echo "if block done"
        
    # run vina
    run_vina $1

    rm $1*.sdf
}

# 1 soll der Name der File sein
run_everything_for_every_zinc_id_in_file() {

    while read line; do
        echo "line"
        get_sdf_file_and_run_vina_for_one_molecule $line
    done <$1

}

run_for_every_split_file() {
    
    run_everything_for_every_zinc_id_in_file 500_random_aa &
    run_everything_for_every_zinc_id_in_file 500_random_ab &
    run_everything_for_every_zinc_id_in_file 500_random_ac &
    run_everything_for_every_zinc_id_in_file 500_random_ad &
    run_everything_for_every_zinc_id_in_file 500_random_ae &
    run_everything_for_every_zinc_id_in_file 500_random_af &
    run_everything_for_every_zinc_id_in_file 500_random_ag &
    run_everything_for_every_zinc_id_in_file 500_random_ah &
    run_everything_for_every_zinc_id_in_file 500_random_ai &
    run_everything_for_every_zinc_id_in_file 500_random_aj &
}


run_for_every_split_file


