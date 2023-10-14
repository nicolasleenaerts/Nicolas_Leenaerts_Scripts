#SCANPHYSLOGPREPROCESSER
#Preprocesses scanphyslogfiles whcih are outputted by a Phillips MR machine

import os
import glob
import pathlib


# Getting the starting directory
start_dir = os.getcwd()

# Creating the output directory
outputdir = [start_dir,'/physiology_files_preprocessed']
outputdir = ''.join(outputdir)
if not os.path.exists(outputdir):
    os.mkdir(outputdir)

# Getting the subjects
subjects = ['189','191','193','195','200','203','205','206','209']
#'01','06','08','09','10','14','15','16','21','26','28','29','30','35','37','38','39',
#'41','42','43','44','48','49','50','51','52','53','54','57','59','60','63','67','69','70','71','74','78',
#'81','82','83','84','85','86','87','88','89','92','94','95','96','97','99','101','103','104','105','109','110','111',
#'112','113','114','118','121','123','124','125','126','127','128','130','131','133','135','136','141','147','148',
#'149','150','151','155','156','158','159','160','161','162','163','165','166','171','172','173','175','176','183','184','185',
#'189','191','193','195','200','203','205','206','209'
folder_name = '/sub-'

for subject in subjects:
    print('Preprocessing files of subject',subject)
    outputdir_subject = [outputdir,'/sub-',subject]
    outputdir_subject = ''.join(outputdir_subject)
    if not os.path.exists(outputdir_subject):
        os.mkdir(outputdir_subject)

    folder_directory = [start_dir,folder_name,subject]
    folder_directory = ''.join(folder_directory)
    os.chdir(folder_directory)

    # Getting the list of files
    files_list = glob.glob("SCANPHYS*.log")
    files_list.sort(key=os.path.getctime)

    for entry in files_list:
        individual_file = open(entry,'r')
        individual_file_contents = individual_file.readlines()
        individual_file_contents.pop(0)
        line_counter = 0
        individual_file_contents_new = []
        for line in individual_file_contents:
            line_counter = line_counter + 1
            if line_counter > 4:
                line = line[:-7]
            individual_file_contents_new.append(line)
        os.chdir(outputdir_subject)
        new_file = open(entry, "w+")
        line_counter = 0
        for line in individual_file_contents_new:
            line_counter = line_counter + 1
            new_file.write(line)
            if line_counter > 4:
                new_file.write('\n')
        os.chdir(folder_directory)
