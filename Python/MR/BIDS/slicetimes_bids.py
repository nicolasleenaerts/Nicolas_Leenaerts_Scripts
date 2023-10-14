#!/usr/bin/env python 3.7
# Adds slice times to json files of a BIDS folder

# Importing the necessary libraries
import sys
import getopt
import os
import json
import numpy as np

# Getting the command arguments
full_cmd_arguments = sys.argv
argument_list = full_cmd_arguments[1:]

# Creating the options
short_options = 'ht:s:n:m:r:'
long_options = ['help','task=','subjects=','nslices=','multiband=','repetition_time=']

# Getting the command line arguments
try:
    arguments, values = getopt.getopt(argument_list, short_options, long_options)
except getopt.error as err:
    # Output error, and return with an error code
    print (str(err))
    sys.exit(2)
for current_argument, current_value in arguments:
    if current_argument in ("-h", "--help"):
        print ("{ Arguments: --task --subjects --nslices --multiband --repetition_time \n  Example: --subjects=35,54 --task=ddt2 --multiband=2 --repetition_time=1.5 --nslices=46}")
        sys.exit(2)
    elif current_argument in ("-t", "--task"):
        task = current_value
    elif current_argument in ("-s", "--subjects"):
        subjects = current_value.split(',')
    elif current_argument in ("-n", "--nslices"):
        nslices = int(current_value)
    elif current_argument in ("-m", "--multiband"):
        MB = int(current_value)
    elif current_argument in ("-r", "--repetition_time"):
        TR = float(current_value)

# Getting the current working directory
cwd = os.getcwd()

# Calculating the initial slice times
slice_times_initial = np.arange(0,TR,(TR/(nslices/MB)))

# Calculting the total slice times
slice_times_total = np.array([])

for MB_index in range(MB):
    slice_times_total = np.append(slice_times_total,slice_times_initial)

slice_times_total = list(slice_times_total)

# Looping over subjects
for subject in subjects:
    # Moving to the directory of the subject
    new_dir = cwd + '/sub-'+ str(subject) + '/func/'
    os.chdir(new_dir)
    file_string = 'sub-'+ str(subject) + '_task-' + str(task)+'_bold.json'
    # Reading the json file and appending it with the slicetimes and MBAccelerationFactor
    with open(file_string, 'r') as file_handle:
        json_file = json.load(file_handle)
        json_file["MultibandAccelerationFactor"] = MB
        json_file["SliceTiming"] = slice_times_total
    # Writing the json file
    with open(file_string, 'w') as file_handle:
        json.dump(json_file,file_handle)

# Returning to the original directory
os.chdir(cwd)
