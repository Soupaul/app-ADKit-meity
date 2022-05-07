# -*- coding: utf-8 -*-
"""
Created on Wed Jun 30 21:14:24 2021

@author: win10
"""
import cv2 
import numpy as np
from matplotlib import pyplot as plt
import imutils
import pandas as pandas
from scipy.signal import argrelextrema
#from scipy.ndimage import gaussian_filter
#from scipy.ndimage import laplace
import api.frame as frame
from django.conf import settings
import warnings
warnings.filterwarnings("ignore")


# count = 890

def exeCode(count,uid,ts):

    path = settings.STORAGE + '/{}/{}'.format(uid,ts)
    # #---------  Image Registration ----------      
    # frame=[]
    # for i in range(count):
    #     frame.append(i)
    #     im1 =  cv2.imread(path + '/frames/frame_0.png')
    #     im2 = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
        
    # #im2 =  cv2.imread("im_277.png")
    #     r1 = 200.0 / im1.shape[1]
    #     r2 = 200.0 / im2.shape[1]
    #     dim1 = (200, int(im1.shape[0] * r1))
    #     im1r = cv2.resize(im1, dim1, interpolation=cv2.INTER_AREA)
    #     dim2 = (200, int(im2.shape[0] * r2))
    #     im2r = cv2.resize(im2, dim2, interpolation=cv2.INTER_AREA)
    #     im1_gray = cv2.cvtColor(im1r,cv2.COLOR_BGR2GRAY)
    #     im2_gray = cv2.cvtColor(im2r,cv2.COLOR_BGR2GRAY)

    # # Find size of image1
    #     sz = im1r.shape

    # # Define the motion model
    #     #warp_mode = cv2.MOTION_TRANSLATION
    #     warp_mode = cv2.MOTION_AFFINE
    #     #warp_mode = cv2.MOTION_EUCLIDEAN

    # # Define 2x3 or 3x3 matrices and initialize the matrix to identity
    #     if warp_mode == cv2.MOTION_HOMOGRAPHY :
    #         warp_matrix = np.eye(3, 3, dtype=np.float32)
    #     else :
    #         warp_matrix = np.eye(2, 3, dtype=np.float32)

    # # Specify the number of iterations.
    #     number_of_iterations = 250

    # # Specify the threshold of the increment
    # # in the correlation coefficient between two iterations
    #     termination_eps = 1e-10

    # # Define termination criteria
    #     criteria = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, number_of_iterations,  termination_eps)

    # # Run the ECC algorithm. The results are stored in warp_matrix.
    #     (cc, warp_matrix) = cv2.findTransformECC (im1_gray,im2_gray,warp_matrix, warp_mode, criteria, inputMask=None, gaussFiltSize=1)

    #     if warp_mode == cv2.MOTION_HOMOGRAPHY :
    #     # Use warpPerspective for Homography 
    #         im2_aligned = cv2.warpPerspective (im2r, warp_matrix, (sz[1],sz[0]), flags=cv2.INTER_LINEAR + cv2.WARP_INVERSE_MAP)
    #     else :
    #     # Use warpAffine for Translation, Euclidean and Affine
    #         im2_aligned = cv2.warpAffine(im2r, warp_matrix, (sz[1],sz[0]), flags=cv2.INTER_LINEAR + cv2.WARP_INVERSE_MAP)
    #     cv2.imwrite(path + '/frames/ima_'+str(i)+'.png', im2_aligned)  
        


    #------- Contour Detection -----------
    for frame in range(count):
        image = cv2.imread(path + '/frames/frame_'+str(frame)+'.png')  # load the image
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)  #convert it to grayscale
            #gray = cv2.GaussianBlur(gray, (5, 5), 0)        #blur it slightly


            # threshold the image, then perform a series of erosions +
            # dilations to remove any small regions of noise
        thresh = cv2.threshold(gray, 20, 255, cv2.THRESH_BINARY)[1]
        thresh = cv2.erode(thresh, None, iterations=1)
        thresh = cv2.dilate(thresh, None, iterations=1)
    
            # find contours in thresholded image, then grab the largest
            # one
        cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
        cnts = imutils.grab_contours(cnts)
        c = max(cnts, key=cv2.contourArea)

            # determine the most extreme points along the contour
        extLeft = tuple(c[c[:, :, 0].argmin()][0])
        extRight = tuple(c[c[:, :, 0].argmax()][0])
        extTop = tuple(c[c[:, :, 1].argmin()][0])
        extBot = tuple(c[c[:, :, 1].argmax()][0])

        left=np.asarray(extLeft)
        lp=np.reshape(left,[2,1])
        right=np.asarray(extRight)
        rp=np.reshape(right,[2,1])
        top=np.asarray(extTop)
        tp=np.reshape(top,[2,1])
        bot=np.asarray(extBot)
        bp=np.reshape(bot,[2,1])
            
        r1=tp[1,0]
        r2=bp[1,0]
        cl1=lp[0,0]
        cl2=rp[0,0]
        
        #cropped=image[r1+50:r2-20,cl1+50:cl2-20]
        mid_row = int((r2-r1)/2) + r1
        mid_col = int ((cl2-cl1)/2) + cl1
            #print (mid_row, mid_col)
        cropped=image [mid_row-10:mid_row+18,mid_col-15:mid_col+15]
        cv2.imwrite(path + '/frames/im_'+str(frame)+'.png', cropped)



    #------------ Correlation ------------    
    frame=[]
    res1=[]
    imgr=cv2.imread(path + '/frames/im_0.png',0)
    for i in range(count):
        frame.append(i)
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png',0)
        #img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        hist = cv2.calcHist([imgr],[0],None,[256],[0,256])
        hist1 = cv2.calcHist([img],[0],None,[256],[0,256])
        comparisonC = cv2.compareHist(hist, hist1, cv2.HISTCMP_CORREL)
        res1.append(comparisonC)
        
    np.savetxt(path +'/csvs/corr.csv',res1,delimiter=",")


    #-------- modify correlation-----------------
    frame=[]
    res1=[]
    imgr=cv2.imread(path + '/frames/im_0.png',0)

    for i in range(count):
        frame.append(i)
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        hist = cv2.calcHist([imgr],[0],None,[256],[0,256])
        hist1 = cv2.calcHist([img],[0],None,[256],[0,256])
        comparisonC = cv2.compareHist(hist, hist1, cv2.HISTCMP_CORREL)
        res1.append(comparisonC)
        

    x=np.array(frame)
    y=np.array(res1)


    window_size = 50

    i = 0
    moving_averages = []
    while i < len(y) - window_size + 1:
        this_window = y[i : i + window_size]
        window_average = sum(this_window) / window_size
        moving_averages.append(window_average)
        i += 1

    np.savetxt(path +'/csvs/corr_50.csv',moving_averages,delimiter=",")


    #------------- gradient --------------------------
    nos=[]

    corr_value=np.loadtxt(path + '/csvs/corr_50.csv', delimiter=",")
    grad=np.gradient(corr_value)
    np.savetxt(path + '/csvs/grad_corr_50.csv',grad,delimiter=",")


    ln=int(len(corr_value)/2)
    arr1=grad[150:ln-100]
    arr2=grad[ln:]
    ind=np.argmin(arr1)
    ind1=(ind+150)
    newarr2=arr1[ind+50:len(arr1)-1]
    ind3=np.argmin(newarr2)+50+ind1
    idx=np.argmax(arr2)
    ind4=ln+np.argmax(arr2)
    nwar2=arr2[idx+1:-150]
    ind6=ind4+np.argmin(nwar2)+1
    dstart = ind1
    sstart = ind3
    sstop = ind4
    istop = ind6
    leng=len(grad)
    decolor=(sstart-dstart)/30
    stable=(sstop-sstart)/30
    color=(istop-sstop)/30

    dslope=((corr_value[sstart])-(corr_value[dstart]))/((sstart)-(dstart))
    oslope=(corr_value[istop]-corr_value[sstop])/(istop-sstop)
    color_ratio = decolor/color
    slope_ratio = dslope/oslope

    nos.append(decolor)
    nos.append(color)
    nos.append(dslope)
    nos.append(oslope)
    nos.append(color_ratio)
    nos.append(slope_ratio)

    nos = np.reshape(np.asanyarray(nos),(1, 6))
    np.savetxt(path + '/csvs/feature.csv',nos,delimiter=",")


    #-----------------red channel ---------------------

    red = []
    for i in range(10):
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(dstart-10,dstart+10):
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(sstart-10,sstart+10):
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(sstop -10,sstop+10):
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(istop-10,istop+10):
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
        
    reddy = np.asanyarray(red)
    reddy = np.reshape(red,(1,len(reddy)))

    np.savetxt(path + '/csvs/red.csv',reddy,delimiter=",")

    all_feat = np.concatenate((nos, reddy), axis = 1)
    np.savetxt(path + '/csvs/all_feat.csv', all_feat, delimiter = ",")



            
def execPalmCode(count,uid,ts):
    
    path = settings.STORAGE + '/{}/{}'.format(uid,ts)
        
    #---------  Image Registration ----------      
    # frame=[]
    # for i in range(count):
    #     frame.append(i)
    #     # print(path + '/frames/frame_0.jpg')
    #     im1 =  cv2.imread(path + '/frames/frame_0.png')
    #     im2 = cv2.imread(path+ '/frames/frame_'+str(i)+'.png')
        
    #im2 =  cv2.imread("im_277.png");
    #     r1 = 200.0 / im1.shape[1]
    #     r2 = 200.0 / im2.shape[1]
    #     dim1 = (200, int(im1.shape[0] * r1))
    #     im1r = cv2.resize(im1, dim1, interpolation=cv2.INTER_AREA)
    #     dim2 = (200, int(im2.shape[0] * r2))
    #     im2r = cv2.resize(im2, dim2, interpolation=cv2.INTER_AREA)
    #     im1_gray = cv2.cvtColor(im1r,cv2.COLOR_BGR2GRAY)
    #     im2_gray = cv2.cvtColor(im2r,cv2.COLOR_BGR2GRAY)

    # # Find size of image1
    #     sz = im1r.shape

    # # Define the motion model
    #     #warp_mode = cv2.MOTION_TRANSLATION
    #     warp_mode = cv2.MOTION_AFFINE
    #     #warp_mode = cv2.MOTION_EUCLIDEAN

    # # Define 2x3 or 3x3 matrices and initialize the matrix to identity
    #     if warp_mode == cv2.MOTION_HOMOGRAPHY :
    #         warp_matrix = np.eye(3, 3, dtype=np.float32)
    #     else :
    #         warp_matrix = np.eye(2, 3, dtype=np.float32)

    # # Specify the number of iterations.
    #     number_of_iterations = 250

    # # Specify the threshold of the increment
    # # in the correlation coefficient between two iterations
    #     termination_eps = 1e-10

    # # Define termination criteria
    #     criteria = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, number_of_iterations,  termination_eps)

    # # Run the ECC algorithm. The results are stored in warp_matrix.
    #     (cc, warp_matrix) = cv2.findTransformECC (im1_gray,im2_gray,warp_matrix, warp_mode, criteria, inputMask=None)

    #     if warp_mode == cv2.MOTION_HOMOGRAPHY :
    #     # Use warpPerspective for Homography 
    #         im2_aligned = cv2.warpPerspective (im2r, warp_matrix, (sz[1],sz[0]), flags=cv2.INTER_LINEAR + cv2.WARP_INVERSE_MAP)
    #     else :
    #     # Use warpAffine for Translation, Euclidean and Affine
    #         im2_aligned = cv2.warpAffine(im2r, warp_matrix, (sz[1],sz[0]), flags=cv2.INTER_LINEAR + cv2.WARP_INVERSE_MAP)
    #     cv2.imwrite(path +'/frames/ima_'+str(i)+'.png', im2_aligned)  
        


    # #------- Contour Detection -----------
    # for frame in range(count):
    #     image = cv2.imread(path + "/frames/ima_"+str(frame)+".png")  # load the image
    #     gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)  #convert it to grayscale
    #         #gray = cv2.GaussianBlur(gray, (5, 5), 0)        #blur it slightly


    #         # threshold the image, then perform a series of erosions +
    #         # dilations to remove any small regions of noise
    #     thresh = cv2.threshold(gray, 20, 255, cv2.THRESH_BINARY)[1]
    #     thresh = cv2.erode(thresh, None, iterations=1)
    #     thresh = cv2.dilate(thresh, None, iterations=1)
    
    #         # find contours in thresholded image, then grab the largest
    #         # one
    #     cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    #     cnts = imutils.grab_contours(cnts)
    #     c = max(cnts, key=cv2.contourArea)

    #         # determine the most extreme points along the contour
    #     extLeft = tuple(c[c[:, :, 0].argmin()][0])
    #     extRight = tuple(c[c[:, :, 0].argmax()][0])
    #     extTop = tuple(c[c[:, :, 1].argmin()][0])
    #     extBot = tuple(c[c[:, :, 1].argmax()][0])

    #     left=np.asarray(extLeft)
    #     lp=np.reshape(left,[2,1])
    #     right=np.asarray(extRight)
    #     rp=np.reshape(right,[2,1])
    #     top=np.asarray(extTop)
    #     tp=np.reshape(top,[2,1])
    #     bot=np.asarray(extBot)
    #     bp=np.reshape(bot,[2,1])
            
    #     r1=tp[1,0]
    #     r2=bp[1,0]
    #     cl1=lp[0,0]
    #     cl2=rp[0,0]
        
    #     #cropped=image[r1+50:r2-20,cl1+50:cl2-20]
    #     mid_row = int((r2-r1)/2) + r1
    #     mid_col = int ((cl2-cl1)/2) + cl1
    #         #print (mid_row, mid_col)
    #     cropped=image [mid_row-50:mid_row+50,mid_col-50:mid_col+50]
    #     cv2.imwrite(path +'/frames/im_'+str(frame)+'.png', cropped)



    #------------ Correlation ------------    
    frame=[]
    res1=[]
    imgr=cv2.imread(path + '/frames/im_0.png',0)
    for i in range(count):
        frame.append(i)
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png',0)
        #img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        hist = cv2.calcHist([imgr],[0],None,[256],[0,256])
        hist1 = cv2.calcHist([img],[0],None,[256],[0,256])
        comparisonC = cv2.compareHist(hist, hist1, cv2.HISTCMP_CORREL)
        res1.append(comparisonC)
        
    np.savetxt(path + "/csvs/corr.csv",res1,delimiter=",")


    #-------- modify correlation-----------------
    frame=[]
    res1=[]
    imgr=cv2.imread(path + '/frames/im_0.png',0)

    for i in range(count):
        frame.append(i)
        img = cv2.imread(path + '/frames/im_'+str(i)+'.png')
        img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        hist = cv2.calcHist([imgr],[0],None,[256],[0,256])
        hist1 = cv2.calcHist([img],[0],None,[256],[0,256])
        comparisonC = cv2.compareHist(hist, hist1, cv2.HISTCMP_CORREL)
        res1.append(comparisonC)
        

    x=np.array(frame)
    y=np.array(res1)


    window_size = 250

    i = 0
    moving_averages = []
    while i < len(y) - window_size + 1:
        this_window = y[i : i + window_size]
        window_average = sum(this_window) / window_size
        moving_averages.append(window_average)
        i += 1

    np.savetxt(path + "/csvs/corr_250.csv",moving_averages,delimiter=",")


    #-------------polyfit--------------------------
    nos=[]

    y1 = pandas.read_csv(path + '/csvs/corr_250.csv')
    y2 = y1.values.tolist()
    y = [x[0] for x in y2]
    x=np.array(range(0, len(y)))
    z=np.polyfit(x,y,6)
    xp = np.linspace(0,len(y))
    p = np.poly1d(z)
    ab=p(x)
    p30 = np.poly1d(np.polyfit(x, y, 30))
    # _ = plt.plot(x, y, '.', xp, p(xp), '-')
    #plt.ylim()
    #plt.show()
    r=np.polyder(p)
    der=r(x)
    d=r(der)
    np.savetxt(path + "/csvs/fit.csv",ab,delimiter=",")

    #---------time-extract-----------
    nos = []  
    y1 = pandas.read_csv(path + '/csvs/fit.csv')
    y2 = y1.values.tolist()
    y3 = [x[0] for x in y2]
    a = np.array(y3)
    n = np.array_split(a, 3)
    fa = a[280:530]


    # determine the indices of the local maxima

    local_maxima = argrelextrema(fa, np.greater_equal, order = 15, mode = 'clip')
    p1=local_maxima[0]+280
    if len(p1)==1:
        pn1=p1[0]
    else:
        pn1=p1[1]
    local_minima = argrelextrema(n[1], np.less_equal, order = 15, mode = 'clip')
    p2=local_minima[0]+len(n[0])
    if len(p2)==1:
        pn2=p2[0]
    else:
        pn2=p2[1]
    local_maxima2 = argrelextrema(n[2], np.greater_equal, order = 15, mode = 'clip')
    p3=local_maxima2[0]+len(n[0])+len(n[1])
    if len(p3)==1:
        pn3=p3[0]
    else:
        pn3=p3[1]

    #print(pn1)
    #print(pn2)
    #print(pn3)
    dstart = pn1
    sstart = pn2
    sstop = pn2
    istop = pn3
    leng=len(a)
    decolor=(sstart-dstart)/30
    stable=(sstop-sstart)/30
    color=(istop-sstop)/30

    dslope=((a[sstart])-(a[dstart]))/((sstart)-(dstart))
    oslope=(a[istop]-a[sstop])/(istop-sstop)

    nos.append(decolor)
    nos.append(color)
    nos.append(dslope)
    nos.append(oslope)

    nos = np.reshape(np.asanyarray(nos),(1, 4))
    np.savetxt(path + "/csvs/feature.csv",nos,delimiter=",")


    #-----------------red channel and correlation ---------------------

    a = pn1
    b = pn2
    c = pn3
    red = []
    corr = []

    y1 = pandas.read_csv(path + '/csvs/corr_250.csv')
    y2 = y1.values.tolist()
    y3 = [x[0] for x in y2]

    arr = np.array(y3)

    for i in range(10):
        arrm = arr[i]
        corr.append(arrm)

    for i in range(a-5,a+5):
        arrm = arr[i]
        corr.append(arrm)
    for i in range(b-5,b+5):
        arrm = arr[i]
        corr.append(arrm)  
    for i in range(c-5,c+5):
        arrm = arr[i]
        corr.append(arrm)
    reddy1 = np.asanyarray(corr)
    reddy1 = np.reshape(corr,(1,len(reddy1))) 
    np.savetxt(path + "/csvs/corr_feat.csv",reddy1,delimiter=",")    

    #%%%%%%%%%%%
    for i in range(10):
        img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(a-5,a+5):
        img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(b-5,b+5):
        img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
    for i in range(c-5,c+5):
        img = cv2.imread(path+ '/frames/frame_'+str(i)+'.png')
        
        img_red = img[:,:,2]
        
        img_avg = np.median(img_red)
        
        red.append(img_avg)
        
        
    reddy = np.asanyarray(red)
    reddy = np.reshape(red,(1,len(reddy)))

    np.savetxt(path + "/csvs/red.csv",reddy,delimiter=",")

    #%%%%%%%%%%%%%%%%%

    blur=[]

    def vol(image):
        # compute the Laplacian of the image and then return the focus
        # measure, which is simply the variance of the Laplacian
        return cv2.Laplacian(image, cv2.CV_64F).var()


    im1 = cv2.imread(path + '/frames/frame_0.png')
    r1 = 200.0 / im1.shape[1]
    dim1 = (200, int(im1.shape[0] * r1))
    image = cv2.resize(im1, dim1, interpolation=cv2.INTER_AREA)
            #r2 = 200.0 / imgc.shape[1]
            #dim2 = (200, int(imgc.shape[0] * r2))
            #imagec = cv2.resize(imgc, dim2, interpolation=cv2.INTER_AREA)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)  #convert it to grayscale
            #gray = cv2.GaussianBlur(gray, (5, 5), 0)        #blur it slightly


            # threshold the image, then perform a series of erosions +
            # dilations to remove any small regions of noise
    thresh = cv2.threshold(gray, 20, 255, cv2.THRESH_BINARY)[1]
    thresh = cv2.erode(thresh, None, iterations=1)
    thresh = cv2.dilate(thresh, None, iterations=1)
    
            # find contours in thresholded image, then grab the largest
            # one
    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)
    c = max(cnts, key=cv2.contourArea)

            # determine the most extreme points along the contour
    extLeft = tuple(c[c[:, :, 0].argmin()][0])
    extRight = tuple(c[c[:, :, 0].argmax()][0])
    extTop = tuple(c[c[:, :, 1].argmin()][0])
    extBot = tuple(c[c[:, :, 1].argmax()][0])

    left=np.asarray(extLeft)
    lp=np.reshape(left,[2,1])
    right=np.asarray(extRight)
    rp=np.reshape(right,[2,1])
    top=np.asarray(extTop)
    tp=np.reshape(top,[2,1])
    bot=np.asarray(extBot)
    bp=np.reshape(bot,[2,1])
            
    r1=tp[1,0]
    r2=bp[1,0]
    cl1=lp[0,0]
    cl2=rp[0,0]
        
        #cropped=image[r1+50:r2-20,cl1+50:cl2-20]
    mid_row = int((r2-r1)/2) + r1
    mid_col = int ((cl2-cl1)/2) + cl1
            #print (mid_row, mid_col)
    img =image [mid_row-50:mid_row+50,mid_col-50:mid_col+50]
    gray1=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)


    i1=cv2.Canny(gray1,100,200)
    sobelx = cv2.Sobel(gray1,cv2.CV_64F,1,0,ksize=3)
    sobely = cv2.Sobel(gray1,cv2.CV_64F,0,1,ksize=3)
    i2 = sobelx+sobely
    b = (0.25*i1 + 0.75*i2)
    ab1=vol(b)
    blur.append(ab1)
    reddy2 = np.asanyarray(blur)
    reddy2 = np.reshape(blur,(1,len(reddy2)))

    all_feat = np.concatenate((nos, reddy1, reddy, reddy2), axis = 1)
    np.savetxt(path + "/csvs/all_feat.csv", all_feat, delimiter = ",")


#
#
#              New and Modified Code, without Image Registration
#
#
#
#




def execPalmCode2(count,uid,ts):
    path = settings.STORAGE + '/{}/{}'.format(uid,ts)
     
    frame=[]

    #------- Contour Detection -----------
    for frame in range(count):
        im1 = cv2.imread(path+ "/frames/frame_"+str(frame)+".png")  # load the image
        r1 = 200.0 / im1.shape[1]
        dim1 = (200, int(im1.shape[0] * r1))
        image = cv2.resize(im1, dim1, interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)  #convert it to grayscale
            #gray = cv2.GaussianBlur(gray, (5, 5), 0)        #blur it slightly


            # threshold the image, then perform a series of erosions +
            # dilations to remove any small regions of noise
        thresh = cv2.threshold(gray, 20, 255, cv2.THRESH_BINARY)[1]
        thresh = cv2.erode(thresh, None, iterations=1)
        thresh = cv2.dilate(thresh, None, iterations=1)
    
            # find contours in thresholded image, then grab the largest
            # one
        cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
        cnts = imutils.grab_contours(cnts)
        c = max(cnts, key=cv2.contourArea)

            # determine the most extreme points along the contour
        extLeft = tuple(c[c[:, :, 0].argmin()][0])
        extRight = tuple(c[c[:, :, 0].argmax()][0])
        extTop = tuple(c[c[:, :, 1].argmin()][0])
        extBot = tuple(c[c[:, :, 1].argmax()][0])

        left=np.asarray(extLeft)
        lp=np.reshape(left,[2,1])
        right=np.asarray(extRight)
        rp=np.reshape(right,[2,1])
        top=np.asarray(extTop)
        tp=np.reshape(top,[2,1])
        bot=np.asarray(extBot)
        bp=np.reshape(bot,[2,1])
            
        r1=tp[1,0]
        r2=bp[1,0]
        cl1=lp[0,0]
        cl2=rp[0,0]
        
        #cropped=image[r1+50:r2-20,cl1+50:cl2-20]
        mid_row = int((r2-r1)/2) + r1
        mid_col = int ((cl2-cl1)/2) + cl1
            #print (mid_row, mid_col)
        cropped=image [mid_row-50:mid_row+50,mid_col-50:mid_col+50]
        cv2.imwrite(path + '/frames/imwir_'+str(frame)+'.png', cropped)




    #-------- modify correlation-----------------
    frame=[]
    res1=[]
    imgr=cv2.imread(path + '/frames/imwir_0.png',0)

    for i in range(count):
        frame.append(i)
        img = cv2.imread(path + '/frames/imwir_'+str(i)+'.png')
        img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        hist = cv2.calcHist([imgr],[0],None,[256],[0,256])
        hist1 = cv2.calcHist([img],[0],None,[256],[0,256])
        comparisonC = cv2.compareHist(hist, hist1, cv2.HISTCMP_CORREL)
        res1.append(comparisonC)
        

    x=np.array(frame)
    y=np.array(res1)


    window_size = 250

    i = 0
    moving_averages = []
    while i < len(y) - window_size + 1:
        this_window = y[i : i + window_size]
        window_average = sum(this_window) / window_size
        moving_averages.append(window_average)
        i += 1
    np.savetxt(path + "/csvs/corr_wir.csv",res1,delimiter=",")
    np.savetxt(path + "/csvs/corr_wir_250.csv",moving_averages,delimiter=",")

    try:

    #-------------polyfit--------------------------
        nos=[]

        y1 = pandas.read_csv(path + '/csvs/corr_wir_250.csv')
        # y2 = y1.values.tolist()
        test_y2 = y1.values.tolist()
        y2 =  [v for v in test_y2 if not np.isnan(v) and not np.isinf(v)]
        y = [x[0] for x in y2]
        x=np.array(range(0, len(y)))
        z=np.polyfit(x,y,6)
        # xp = np.linspace(0,len(y))
        p = np.poly1d(z)
        ab=p(x)
        # p30 = np.poly1d(np.polyfit(x, y, 30))
        # _ = plt.plot(x, y, '.', xp, p(xp), '-')
        #plt.ylim()
        #plt.show()
        r=np.polyder(p)
        der=r(x)
        d=r(der)
        np.savetxt(path + "/csvs/fit_wir.csv",ab,delimiter=",")
    
    finally:    

        #---------time-extract-----------
        nos = []  
        y1 = pandas.read_csv(path + '/csvs/fit_wir.csv')
        y2 = y1.values.tolist()
        y3 = [x[0] for x in y2]
        a = np.array(y3)
        n = np.array_split(a, 3)
        fa = a[280:530]


        # determine the indices of the local maxima

        local_maxima = argrelextrema(fa, np.greater_equal, order = 15, mode = 'clip')
        p1=local_maxima[0]+280
        if len(p1)==1:
            pn1=p1[0]
        else:
            pn1=p1[1]
        local_minima = argrelextrema(n[1], np.less_equal, order = 15, mode = 'clip')
        p2=local_minima[0]+len(n[0])
        if len(p2)==1:
            pn2=p2[0]
        else:
            pn2=p2[1]
        local_maxima2 = argrelextrema(n[2], np.greater_equal, order = 15, mode = 'clip')
        p3=local_maxima2[0]+len(n[0])+len(n[1])
        if len(p3)==1:
            pn3=p3[0]
        else:
            pn3=p3[1]

        #print(pn1)
        #print(pn2)
        #print(pn3)
        dstart = pn1
        sstart = pn2
        sstop = pn2
        istop = pn3
        leng=len(a)
        decolor=(sstart-dstart)/30
        stable=(sstop-sstart)/30
        color=(istop-sstop)/30

        dslope=((a[sstart])-(a[dstart]))/((sstart)-(dstart))
        oslope=(a[istop]-a[sstop])/(istop-sstop)

        nos.append(decolor)
        nos.append(color)
        nos.append(dslope)
        nos.append(oslope)

        nos = np.reshape(np.asanyarray(nos),(1, 4))
        np.savetxt(path + "/csvs/feature_wir.csv",nos,delimiter=",")


        #-----------------red channel and correlation ---------------------

        a = pn1
        b = pn2
        c = pn3
        red = []
        corr = []

        y1 = pandas.read_csv(path + '/csvs/corr_wir_250.csv')
        y2 = y1.values.tolist()
        y3 = [x[0] for x in y2]

        arr = np.array(y3)

        for i in range(10):
            arrm = arr[i]
            corr.append(arrm)

        for i in range(a,a+10):
            arrm = arr[i]
            corr.append(arrm)
        for i in range(b-5,b+5):
            arrm = arr[i]
            corr.append(arrm)  
        for i in range(c-10,c):
            arrm = arr[i]
            corr.append(arrm)
        reddy1 = np.asanyarray(corr)
        reddy1 = np.reshape(corr,(1,len(reddy1))) 
        np.savetxt(path + "/csvs/corr_feat_wir.csv",reddy1,delimiter=",")    

        #%%%%%%%%%%%
        for i in range(10):
            img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
            
            img_red = img[:,:,2]
            
            img_avg = np.median(img_red)
            
            red.append(img_avg)
            
        for i in range(a,a+10):
            img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
            
            img_red = img[:,:,2]
            
            img_avg = np.median(img_red)
            
            red.append(img_avg)
            
        for i in range(b-5,b+5):
            img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
            
            img_red = img[:,:,2]
            
            img_avg = np.median(img_red)
            
            red.append(img_avg)
            
        for i in range(c-10,c):
            img = cv2.imread(path + '/frames/frame_'+str(i)+'.png')
            
            img_red = img[:,:,2]
            
            img_avg = np.median(img_red)
            
            red.append(img_avg)
            
            
        reddy = np.asanyarray(red)
        reddy = np.reshape(red,(1,len(reddy)))

        np.savetxt(path + "/csvs/red_wir.csv",reddy,delimiter=",")

        #%%%%%%%%%%%%%%%%%

        blur=[]

        def vol(image):
            # compute the Laplacian of the image and then return the focus
            # measure, which is simply the variance of the Laplacian
            return cv2.Laplacian(image, cv2.CV_64F).var()


        im1 = cv2.imread(path + '/frames/frame_0.png')
        r1 = 200.0 / im1.shape[1]
        dim1 = (200, int(im1.shape[0] * r1))
        image = cv2.resize(im1, dim1, interpolation=cv2.INTER_AREA)
                #r2 = 200.0 / imgc.shape[1]
                #dim2 = (200, int(imgc.shape[0] * r2))
                #imagec = cv2.resize(imgc, dim2, interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)  #convert it to grayscale
                #gray = cv2.GaussianBlur(gray, (5, 5), 0)        #blur it slightly


                # threshold the image, then perform a series of erosions +
                # dilations to remove any small regions of noise
        thresh = cv2.threshold(gray, 20, 255, cv2.THRESH_BINARY)[1]
        thresh = cv2.erode(thresh, None, iterations=1)
        thresh = cv2.dilate(thresh, None, iterations=1)
        
                # find contours in thresholded image, then grab the largest
                # one
        cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
        cnts = imutils.grab_contours(cnts)
        c = max(cnts, key=cv2.contourArea)

                # determine the most extreme points along the contour
        extLeft = tuple(c[c[:, :, 0].argmin()][0])
        extRight = tuple(c[c[:, :, 0].argmax()][0])
        extTop = tuple(c[c[:, :, 1].argmin()][0])
        extBot = tuple(c[c[:, :, 1].argmax()][0])

        left=np.asarray(extLeft)
        lp=np.reshape(left,[2,1])
        right=np.asarray(extRight)
        rp=np.reshape(right,[2,1])
        top=np.asarray(extTop)
        tp=np.reshape(top,[2,1])
        bot=np.asarray(extBot)
        bp=np.reshape(bot,[2,1])
                
        r1=tp[1,0]
        r2=bp[1,0]
        cl1=lp[0,0]
        cl2=rp[0,0]
            
            #cropped=image[r1+50:r2-20,cl1+50:cl2-20]
        mid_row = int((r2-r1)/2) + r1
        mid_col = int ((cl2-cl1)/2) + cl1
                #print (mid_row, mid_col)
        img =image [mid_row-50:mid_row+50,mid_col-50:mid_col+50]
        gray1=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)


        i1=cv2.Canny(gray1,100,200)
        sobelx = cv2.Sobel(gray1,cv2.CV_64F,1,0,ksize=3)
        sobely = cv2.Sobel(gray1,cv2.CV_64F,0,1,ksize=3)
        i2 = sobelx+sobely
        b = (0.25*i1 + 0.75*i2)
        ab1=vol(b)
        blur.append(ab1)
        reddy2 = np.asanyarray(blur)
        reddy2 = np.reshape(blur,(1,len(reddy2)))

        all_feat = np.concatenate((nos, reddy1, reddy, reddy2), axis = 1)
        np.savetxt(path + "/csvs/all_feat_wir.csv", all_feat, delimiter = ",")