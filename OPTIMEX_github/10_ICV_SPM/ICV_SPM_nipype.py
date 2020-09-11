
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 21 09:35:52 2019
@author: uqtshaw
"""

from os.path import join as opj
import os
from nipype.interfaces.base import (TraitedSpec,
                                    CommandLineInputSpec,
                                    CommandLine,
                                    File,
                                    traits)
import nipype.interfaces.spm as spm
#from nipype.interfaces.c3 import C3d
from nipype.pipeline.engine import Workflow, Node, MapNode
from nipype.interfaces.io import SelectFiles, DataSink
from nipype.interfaces.utility import IdentityInterface


#os.environ["FSLOUTPUTTYPE"] = "NIFTI_GZ"

#setup for Workstations

data_dir = '/90days/uqtshaw/optimex/bids/'
experiment_dir = '/90days/uqtshaw/optimex/'

##############
#the outdir
output_dir = 'output_dir'
#working_dir name
working_dir = 'derivatives/nipype_working_dir_ICV'

#other things to be set up
subject_list = sorted(os.listdir(experiment_dir+'bids/'))

#####################

wf = Workflow(name='Workflow_preprocess_ICV')
wf.base_dir = os.path.join(experiment_dir+working_dir)

# create infosource to iterate over iterables
infosource = Node(IdentityInterface(fields=['subject']),
                  name="infosource")



infosource.iterables = [('subject', subject_list)]

templates = {
            'mprage' : '{subject}/ses-01/anat/{subject}_ses-01_acq-mp2ragewip900075iso7TUNIDEN_run-1_T1w.nii.gz',
            }
selectfiles = Node(SelectFiles(templates, base_directory=data_dir), name='selectfiles')

wf.connect([(infosource, selectfiles, [('subject', 'subject')])])

############
## Step 1 ##
############
# SPM segment

#seg = spm.NewSegment()
#input_image not input
T1_segment_n = MapNode(seg(channel_info = (0.0001, 60, (True, True)),
                                      name = 'T1_seg_n', iterfield=['input_image']))

wf.connect([(selectfiles, T1_segment_n, [('mprage','channel_files')])])

################
## DATA SINK  ##
################
datasink = Node(DataSink(base_directory=experiment_dir+working_dir,
                         container=output_dir),
                name="datasink")

wf.connect([(T1_segment_n, datasink, [('native_class_images ','native_class_images_prob_maps')])]) #Step 1
wf.connect([(T1_segment_n, datasink, [('normalized_class_images ','normalized_class_images')])]) #Step 1

###################
## Run the thing ##
###################

wf.write_graph(graph2use='flat', format='png', simple_form=False)

#wf.run(plugin='SLURMGraph', plugin_args = {'dont_resubmit_completed_jobs': True} )
#wf.run()
wf.run(plugin='MultiProc', plugin_args = {'n_procs' : 30})
'''
# # run as MultiProc
wf.write_graph(graph2use='flat', format='png', simple_form=False)
#wf.run(plugin='SLURMGraph', plugin_args = {'dont_resubmit_completed_jobs': True} )
'''