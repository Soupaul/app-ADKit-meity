# -*- coding: utf-8 -*-
"""
Created on Wed Jun 30 21:49:05 2021

@author: win10
"""


import cv2
from django.conf import settings
import os


def FrameCaptureNail(path, uid, ts):
    vidObj = cv2.VideoCapture(path)   # Path to video file
    count = 0                               # Used as counter variable
    success = 1                             # checks whether frames were extracted

    path = settings.STORAGE + '/{}/{}'.format(uid, ts)
    if not os.path.exists(path):
        os.makedirs(path)
        os.makedirs(path + '/frames')
        os.makedirs(path + '/csvs')

    while success:
        # vidObj object calls read function extract frames
        success, image = vidObj.read()
        if success:
            cv2.imwrite(path + "/frames/frame_%d.png" %
                        count, image)  # Saves the frames with frame-count
            count += 1
        else:
            break
    return (count)


def FrameCapturePalm(path, uid, ts):

    cap = cv2.VideoCapture(path)  # Path to video file

    path = settings.STORAGE + '/{}/{}'.format(uid, ts)
    if not os.path.exists(path):
        os.makedirs(path)
        os.makedirs(path + '/frames')
        os.makedirs(path + '/csvs')

    i = 0
    # a variable to set how many frames you want to skip
    frame_skip = 14
    # a variable to keep track of the frame to be saved
    frame_count = 0
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        if i > frame_skip - 1:
            frame_count += 1
            cv2.imwrite(path + "/frames/frame_"+str(frame_count)+".jpg", frame)
            i = 0
            continue
        i += 1

    cap.release()
    cv2.destroyAllWindows()
    return (frame_count)


# if __name__ == "__main__":
#     count = FrameCapture()
    #print (count)
