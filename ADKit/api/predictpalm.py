import numpy as np
from sklearn.preprocessing import MinMaxScaler
from django.conf import settings
import os

path_temp = settings.ML_FILES


def sigmoid(x):
    return (1 / (1 + np.exp(-x)))

# def palmpredictor(datacsv):
#     datacsv = np.reshape(datacsv,(1,len(datacsv)))
#     test = datacsv
#     # print("actual df shape")
#     # print(test.shape)
#     # test = np.loadtxt(path_temp + "test_data.csv", delimiter =",")
#     # test = np.reshape(test,(1,len(test)))

#     data=np.loadtxt(path_temp + "/palm/suffle_alldata.csv",delimiter=",")

#     alldata = np.concatenate((data[:,:-1],test),axis = 0)

#     mini = np.min(data[:,-1])
#     maxi = np.max(data[:,-1])

#     # 0-1 normalization
#     scaler = MinMaxScaler().fit(alldata)
#     D_x = scaler.transform(alldata)

#     norm_test = D_x[-1,:]
#     np.savetxt(path_temp + "/palm/norm_test.csv", D_x[-1,:], delimiter =",") # normalised
#     #print(norm_test.shape)
#     # mlp output

#     tr_w1 = np.loadtxt(path_temp + "/palm/trl_wt1_mlp.csv", delimiter=",")
#     tr_w2 = np.loadtxt(path_temp + "/palm/trl_wt2_mlp.csv", delimiter=",")
#     tr_w3 = np.loadtxt(path_temp + "/palm/trl_wt3_mlp.csv", delimiter=",")
#     tr_w4 = np.loadtxt(path_temp + "/palm/trl_wt4_mlp.csv", delimiter=",")

#     tr_b1 = np.loadtxt(path_temp + "/palm/trl_bias1_mlp.csv", delimiter=",")
#     tr_b2 = np.loadtxt(path_temp + "/palm/trl_bias2_mlp.csv", delimiter=",")
#     tr_b3 = np.loadtxt(path_temp + "/palm/trl_bias3_mlp.csv", delimiter=",")
#     tr_b4 = np.loadtxt(path_temp + "/palm/trl_bias4_mlp.csv", delimiter=",")

#     l1= sigmoid(np.matmul(norm_test, tr_w1)+tr_b1)
#     l2 = sigmoid(np.matmul(l1,tr_w2)+ tr_b2)
#     l3 = sigmoid(np.matmul(l2,tr_w3)+ tr_b3)
#     l4 = sigmoid(np.matmul(l3,tr_w4)+ tr_b4)


#     trl = l4*(maxi-mini)+mini

#     test_regr = []
#     #Regression output
#     # pred_svr = clf.predict(test)
#     # pred_lgb = lgb.predict(test)
#     # pred_gbr = gbr.predict(test)
#     # pred_bay = bay.predict(test)
#     # pred_elc = elc.predict(test)
#     pred_svr = settings.MODEL_OBJ.predictpalmclf(test)
#     pred_gbr = settings.MODEL_OBJ.predictpalmgbr(test)
#     pred_lgb = settings.MODEL_OBJ.predictpalmlgb(test)
#     pred_bay = settings.MODEL_OBJ.predictpalmbay(test)
#     pred_elc = settings.MODEL_OBJ.predictpalmelc(test)

#     test_regr.append(pred_svr)
#     test_regr.append(pred_lgb)
#     test_regr.append(pred_gbr)
#     test_regr.append(pred_bay)
#     test_regr.append(pred_elc)


#     test_regr_out = np.asanyarray(test_regr)
#     test_regr_out = np.reshape(test_regr_out,(1,5))

#     train_regr = np.loadtxt(path_temp + "/palm/regr5_merge_train.csv", delimiter = ",")


#     allregrdata = np.concatenate((train_regr,test_regr_out),axis = 0)


#     # 0-1 normalization
#     scaler = MinMaxScaler().fit(allregrdata)
#     D_xx = scaler.transform(allregrdata)

#     norm_test_regr = D_xx[-1,:]


#     sn_w1 = np.loadtxt(path_temp + "/palm/sn_wt1_5reg_mlp.csv", delimiter=",")
#     sn_w2 = np.loadtxt(path_temp + "/palm/sn_wt2_5reg_mlp.csv", delimiter=",")

#     sn_b1 = np.loadtxt(path_temp + "/palm/sn_bias1_5reg_mlp.csv", delimiter=",")
#     sn_b2 = np.loadtxt(path_temp + "/palm/sn_bias2_5reg_mlp.csv", delimiter=",")

#     l1= sigmoid(np.matmul(norm_test_regr, sn_w1)+sn_b1)
#     l2 = sigmoid(np.matmul(l1,sn_w2)+ sn_b2)

#     sn_pred_out_test = l2*(maxi-mini)+mini


#     w_1L = trl/(trl+sn_pred_out_test)

#     w_s1 = (w_1L*trl)+((1-w_1L)*sn_pred_out_test)

#     # print (w_s1)
#     return w_s1

def palmpredictor(datacsv):
    datacsv = np.reshape(datacsv, (1, len(datacsv)))
    test = datacsv
    # print("actual df shape")
    # print(test.shape)
    # test = np.loadtxt(path_temp + "test_data.csv", delimiter =",")
    # test = np.reshape(test,(1,len(test)))

    data = np.loadtxt(
        path_temp + "/palm2FPS/suffle_alldata.csv", delimiter=",")

    alldata = np.concatenate((data[:, :-1], test), axis=0)

    mini = np.min(data[:, -1])
    maxi = np.max(data[:, -1])

    # 0-1 normalization
    scaler = MinMaxScaler().fit(alldata)
    D_x = scaler.transform(alldata)

    norm_test = D_x[-1, :]
    np.savetxt(path_temp + "/palm2FPS/norm_test.csv",
               D_x[-1, :], delimiter=",")  # normalised
    # print(norm_test.shape)
    # mlp output

    tr_w1 = np.loadtxt(path_temp + "/palm2FPS/trl_wt1_mlp.csv", delimiter=",")
    tr_w2 = np.loadtxt(path_temp + "/palm2FPS/trl_wt2_mlp.csv", delimiter=",")
    tr_w3 = np.loadtxt(path_temp + "/palm2FPS/trl_wt3_mlp.csv", delimiter=",")
    tr_w4 = np.loadtxt(path_temp + "/palm2FPS/trl_wt4_mlp.csv", delimiter=",")

    tr_b1 = np.loadtxt(
        path_temp + "/palm2FPS/trl_bias1_mlp.csv", delimiter=",")
    tr_b2 = np.loadtxt(
        path_temp + "/palm2FPS/trl_bias2_mlp.csv", delimiter=",")
    tr_b3 = np.loadtxt(
        path_temp + "/palm2FPS/trl_bias3_mlp.csv", delimiter=",")
    tr_b4 = np.loadtxt(
        path_temp + "/palm2FPS/trl_bias4_mlp.csv", delimiter=",")

    l1 = sigmoid(np.matmul(norm_test, tr_w1)+tr_b1)
    l2 = sigmoid(np.matmul(l1, tr_w2) + tr_b2)
    l3 = sigmoid(np.matmul(l2, tr_w3) + tr_b3)
    l4 = sigmoid(np.matmul(l3, tr_w4) + tr_b4)

    trl = l4*(maxi-mini)+mini

    test_regr = []
    # Regression output
    # pred_svr = clf.predict(test)
    # pred_lgb = lgb.predict(test)
    # pred_gbr = gbr.predict(test)
    # pred_bay = bay.predict(test)
    # pred_elc = elc.predict(test)
    pred_svr = settings.MODEL_OBJ.predictpalmclf(test)
    pred_gbr = settings.MODEL_OBJ.predictpalmgbr(test)
    pred_lgb = settings.MODEL_OBJ.predictpalmlgb(test)
    pred_bay = settings.MODEL_OBJ.predictpalmbay(test)
    pred_elc = settings.MODEL_OBJ.predictpalmelc(test)

    test_regr.append(pred_svr)
    test_regr.append(pred_lgb)
    test_regr.append(pred_gbr)
    test_regr.append(pred_bay)
    test_regr.append(pred_elc)

    test_regr_out = np.asanyarray(test_regr)
    test_regr_out = np.reshape(test_regr_out, (1, 5))

    train_regr = np.loadtxt(
        path_temp + "/palm2FPS/regr5_merge_train.csv", delimiter=",")

    allregrdata = np.concatenate((train_regr, test_regr_out), axis=0)

    # 0-1 normalization
    scaler = MinMaxScaler().fit(allregrdata)
    D_xx = scaler.transform(allregrdata)

    norm_test_regr = D_xx[-1, :]

    sn_w1 = np.loadtxt(
        path_temp + "/palm2FPS/sn_wt1_5reg_mlp.csv", delimiter=",")
    sn_w2 = np.loadtxt(
        path_temp + "/palm2FPS/sn_wt2_5reg_mlp.csv", delimiter=",")

    sn_b1 = np.loadtxt(
        path_temp + "/palm2FPS/sn_bias1_5reg_mlp.csv", delimiter=",")
    sn_b2 = np.loadtxt(
        path_temp + "/palm2FPS/sn_bias2_5reg_mlp.csv", delimiter=",")

    l1 = sigmoid(np.matmul(norm_test_regr, sn_w1)+sn_b1)
    l2 = sigmoid(np.matmul(l1, sn_w2) + sn_b2)

    sn_pred_out_test = l2*(maxi-mini)+mini

    w_1L = trl/(trl+sn_pred_out_test)

    w_s1 = (w_1L*trl)+((1-w_1L)*sn_pred_out_test)

    # print (w_s1)
    return w_s1
