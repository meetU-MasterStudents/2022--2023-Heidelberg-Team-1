import os
import subprocess
import re
import sys
from os.path import exists
import re

def evaluate_one_tranch(no_tox_file_line):
    # execute the mkdir+wget command given
    # os.system(wget_cmd)

    # get subdirectories
    # result = re.search('mkdir -pv (.*) &&', wget_cmd)

    # subdirectory = result.group(1)
    # print(subdirectory)

    # split_by_slash = wget_cmd.split("/")
    # filename = split_by_slash[-1].strip()


    subdirectory = no_tox_file_line.split(" ")[1];


    '''
    path_to_tox_file = subdirectory + "/" + filename + "_tox_results.csv"

    if not exists(path_to_tox_file):

        f = open(subdirectory + "/" + filename)
        line_count = len(f.readlines())

        # What are 8 equal parts?
        part_number_of_lines = str(int(line_count / 20) + 1)
        print(part_number_of_lines)
        #print("cd " + subdirectory + " | split -l " + part_number_of_lines + " " + subdirectory + "/" + filename + " " + subdirectory)

        # os.system("cd " + subdirectory + " | split -l " + part_number_of_lines + " " + subdirectory + "/" + filename + " " + subdirectory)

        # directory = os.fsencode(subdirectory)
        '''

    for file in os.listdir(subdirectory):
        #filename = os.fsdecode(file)

        ends_with_suffix_one = re.search("_..$", file)
        ends_with_suffix_two = re.search("_....$", file)

        path_to_tox_file = subdirectory + "/" + file + "_tox_results.csv"


        if ends_with_suffix_one or ends_with_suffix_two:
            etox_cmd = "python /home/darius/tools/eToxPred/etoxpred_predict.py --datafile " + subdirectory + "/" + file + " --modelfile /home/darius/tools/eToxPred/etoxpred_best_model.joblib --outputfile " + path_to_tox_file

            os.system(etox_cmd)


        #
        # Hier den Code zum aufsplitten reinschreiben
        #



def run_etoxpred_for_large_file(smi_file):
    file1 = open(smi_file, 'r')
    Lines = file1.readlines()

    for line in Lines:
        evaluate_one_tranch(line)


if __name__ == "__main__":
   run_etoxpred_for_large_file(sys.argv[1])
