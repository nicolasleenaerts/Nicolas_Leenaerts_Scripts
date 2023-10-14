#SCANPHYSLOGPREPROCESSER

import os
import glob
import pathlib
import json
import pandas as pd



# Getting the starting directory
start_dir = os.getcwd()

# Creating the output directory
outputdir = [start_dir,'/time_scans']
outputdir = ''.join(outputdir)
if not os.path.exists(outputdir):
    os.mkdir(outputdir)


# Getting the subjects
subjects = ['01','06','08','09','10','14','15','16','21','26','28','29','30','35','37','38','39',
'41','42','43','44','48','49','50','51','52','53','54','57','59','60','63','67','69','70','71','74','78',
'81','82','83','84','85','86','87','88','89','92','94','95','96','97','99','101','103','104','105','109','110','111',
'112','113','114','118','121','123','124','125','126','127','128','130','131','133','135','136','141','147','148',
'149','150','151','155','156','159','160','162','163','165','166','171','172','173','175','176','183','184','185',
'191','193','195','200','203','205','206','209']
# '01','06','08','09','10','14','15','21','26','28','29','30','35','37','38','39','41','42','43','44','48'
# ,'49','50','51','53','54','57','59','60','63','67','69','70','71','74','78','81','82','83','84','85','86',
# '87','88','89','92','94','95','96','97'


# Results directory
subjects_list = []
anat_start_times = []
dwi_start_times = []
rev_dwi_start_times = []
afmri1_start_times = []
afmri2_start_times = []
afmri3_start_times = []
rsfmri_start_times = []
asl_start_times = []
afmri_bdref_start_times = []
rsfmri_bdref_start_times = []

for subject in subjects:
    print('Extracting scan times of subject',subject)
    # Extracting the anatomical acuisition time
    anatdir_participant = [start_dir,'/sub-',subject,'/anat/']
    anatdir_participant = ''.join(anatdir_participant)
    try:
        try:
            os.chdir(anatdir_participant)
            anatfile_participant = ['sub-',subject,'_T1w.json']
            anatfile_participant = ''.join(anatfile_participant)
            anat_json = json.load(open(anatfile_participant))
            AcquisitionTime_anat = anat_json['AcquisitionTime']
        except:
            os.chdir(anatdir_participant)
            anatfile_participant = ['sub-',subject,'_run-01_T1w.json']
            anatfile_participant = ''.join(anatfile_participant)
            anat_json = json.load(open(anatfile_participant))
            AcquisitionTime_anat = anat_json['AcquisitionTime']
    except:
        print('No anat dir for subject, ', subject)
        AcquisitionTime_anat = 'NA'
# Extracting the diffusion acuisition time
    dwidir_participant = [start_dir,'/sub-',subject,'/dwi/']
    dwidir_participant = ''.join(dwidir_participant)
    try:
        os.chdir(dwidir_participant)
        dwifile_participant = ['sub-',subject,'_run-01_dwi.json']
        dwifile_participant = ''.join(dwifile_participant)
        dwi_json = json.load(open(dwifile_participant))
        AcquisitionTime_dwi = dwi_json['AcquisitionTime']
        revdwifile_participant = ['sub-',subject,'_run-02_dwi.json']
        revdwifile_participant = ''.join(revdwifile_participant)
        revdwi_json = json.load(open(revdwifile_participant))
        AcquisitionTime_revdwi = revdwi_json['AcquisitionTime']
    except:
        print('No dwi dir for subject, ', subject)
        AcquisitionTime_dwi = 'NA'
        AcquisitionTime_revdwi = 'NA'
    # Extracting the functional acuisition time
    funcdir_participant = [start_dir,'/sub-',subject,'/func/']
    funcdir_participant = ''.join(funcdir_participant)
    try:
        os.chdir(funcdir_participant)
        afmri1file_participant = ['sub-',subject,'_task-ddt1_bold.json']
        afmri1file_participant = ''.join(afmri1file_participant)
        afmri1_json = json.load(open(afmri1file_participant))
        AcquisitionTime_fmri1 = afmri1_json['AcquisitionTime']
        afmri2file_participant = ['sub-',subject,'_task-ddt2_bold.json']
        afmri2file_participant = ''.join(afmri2file_participant)
        afmri2_json = json.load(open(afmri2file_participant))
        AcquisitionTime_fmri2 = afmri2_json['AcquisitionTime']
        afmri3file_participant = ['sub-',subject,'_task-ddt3_bold.json']
        afmri3file_participant = ''.join(afmri3file_participant)
        afmri3_json = json.load(open(afmri3file_participant))
        AcquisitionTime_fmri3 = afmri3_json['AcquisitionTime']
        rsfmrifile_participant = ['sub-',subject,'_task-rest_bold.json']
        rsfmrifile_participant = ''.join(rsfmrifile_participant)
        rsfmri_json = json.load(open(rsfmrifile_participant))
        AcquisitionTime_rsfmri = rsfmri_json['AcquisitionTime']
    except:
        print('No fmri dir for subject, ', subject)
        AcquisitionTime_fmri1 = 'NA'
        AcquisitionTime_fmri2 = 'NA'
        AcquisitionTime_fmri3 = 'NA'
        AcquisitionTime_rsfmri = 'NA'
    # Extracting the asl acuisition time
    tmpdir_participant = [start_dir,'/tmp_dcm2bids/sub-',subject,'/']
    tmpdir_participant = ''.join(tmpdir_participant)
    try:
        os.chdir(tmpdir_participant)
        files_list = glob.glob("*.json")
        for file in files_list:
            if 'WIP_3D_pCASL_6mm' in file:
                asl_json = json.load(open(file))
                AcquisitionTime_asl = asl_json['AcquisitionTime']
            if 'WIP_afMRI_MB2_SBref' in file:
                afmri_bref_json = json.load(open(file))
                AcquisitionTime_afmri_bref = afmri_bref_json['AcquisitionTime']
            if 'WIP_rsfMRI_MB6_SBREF' in file:
                rsfmri_bref_json = json.load(open(file))
                AcquisitionTime_rsfmri_bref = rsfmri_bref_json['AcquisitionTime']
    except:
        print('No tmp dir for subject, ', subject)
        AcquisitionTime_asl = 'NA'
        AcquisitionTime_afmri_bref = 'NA'
        AcquisitionTime_rsfmri_bref = 'NA'
    subjects_list.append(subject)
    anat_start_times.append(AcquisitionTime_anat)
    dwi_start_times.append(AcquisitionTime_dwi)
    rev_dwi_start_times.append(AcquisitionTime_revdwi)
    afmri1_start_times.append(AcquisitionTime_fmri1)
    afmri2_start_times.append(AcquisitionTime_fmri2)
    afmri3_start_times.append(AcquisitionTime_fmri3)
    rsfmri_start_times.append(AcquisitionTime_rsfmri)
    asl_start_times.append(AcquisitionTime_asl)
    afmri_bdref_start_times.append(AcquisitionTime_afmri_bref)
    rsfmri_bdref_start_times .append(AcquisitionTime_rsfmri_bref)

os.chdir(start_dir)

dictionary = {
'Subject':subjects_list,
'Anat_start_time':anat_start_times,
'Dwi_start_time':dwi_start_times,
'Revdwi_start_time':rev_dwi_start_times,
'Afmri1_start_time':afmri1_start_times,
'Afmri2_start_time':afmri2_start_times,
'Afmri3_start_time':afmri3_start_times,
'Rsfmri_start_time':rsfmri_start_times,
'Asl_start_time':asl_start_times,
'Afmri_bdref_start_time':afmri_bdref_start_times,
'Rsfmri_bdref_start_time':rsfmri_bdref_start_times
}

Results_dataframe = pd.DataFrame(dictionary)
Results_dataframe.to_excel("start_times_scans.xlsx")
