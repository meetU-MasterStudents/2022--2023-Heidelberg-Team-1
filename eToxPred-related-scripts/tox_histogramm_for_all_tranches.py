import os
import re
import sys

def get_thresholded_data(wget_cmd):
    result = re.search('mkdir -pv (.*) &&', wget_cmd)

    subdirectory = result.group(1)


    split_by_slash = wget_cmd.split("/")
    filename = split_by_slash[-1].strip()


    tox_outputfile = subdirectory + "/" + filename + "_tox_results.csv"

    # etox_cmd = "python /home/darius/tools/eToxPred/etoxpred_predict.py --datafile " + subdirectory + "/" + filename + " --modelfile /home/darius/tools/eToxPred/etoxpred_best_model.joblib --outputfile " + tox_outputfile
    os.system(etox_cmd)

def check_toxicology_for_whole_dataset(smi_file):
    # os.system("conda activate etoxpred")
    file1 = open(smi_file, 'r')
    Lines = file1.readlines()

    # only_line_evaluated = Lines[0]

    #
    # WICHTIG: ENTKOMMENTIEREN FUER DAS LAUFEN AUF DEM CLUSTER WICHTIG
    #
    os.system("cd ~/data/zinc_data")

    # check_toxicology_for_one_tranch(only_line_evaluated)

    count = 0
    for line in Lines:

        check_toxicology_for_one_tranch(line)

        with open("/home/darius/tools/eToxPred/tranches_done.log", "a") as myfile:
            myfile.write(line + " " + str(count) + "\n")

        count += 1
        # irgendwie das loggen

# check_toxicology_for_whole_dataset('/home/darius/tools/zinc_download_scripts/ZINC-downloader-3D-smi.wget')

# os.system("cd ~/tools/zinc_download_scripts")

if __name__ == "__main__":
   check_toxicology_for_whole_dataset(sys.argv[1])
   # check_toxicology_for_one_tranch("mkdir -pv /home/darius/data/zinc_data/BA/AAML && wget http://files.docking.org/3D/BA/AAML/BAAAML.smi -O /home/darius/data/zinc_data/BA/AAML/BAAAML.smi")
