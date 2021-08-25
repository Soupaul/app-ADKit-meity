# -*- coding: utf-8 -*-
"""
Created on Wed Jun 30 21:49:05 2021

@author: win10
"""


import cv2
from django.conf import settings
import os

def FrameCapture(path,uid,ts):  
    vidObj = cv2.VideoCapture(path)   # Path to video file 
    count = 0                               # Used as counter variable 
    success = 1                             # checks whether frames were extracted

    
    path = settings.STORAGE + '/{}/{}'.format(uid,ts)
    if not os.path.exists(path):
        os.makedirs(path)
        os.makedirs(path + '/frames')
        os.makedirs(path + '/csvs')

    while success: 
        success, image = vidObj.read()      # vidObj object calls read function extract frames 
        if success:
            cv2.imwrite(path +"/frames/frame_%d.png" % count, image) # Saves the frames with frame-count 
            count += 1
        else:
            break
    return(count)

if __name__=="__main__":    
    count = FrameCapture()
    #print (count)