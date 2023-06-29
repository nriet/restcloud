# -*- coding: utf-8 -*-
"""
Created on Mon May 16 18:23:53 2022

@author: nriet
"""
import time
import os,sys, getopt
import numpy as np
import datetime
from netCDF4 import Dataset
from shutil import copyfile
# 加减乘除计算
def cal_arithmetic(data_0,data_1,method):
    if method == 'add':
        data_out = data_0 + data_1
    elif method == 'sub':
        data_out = data_0 - data_1
    elif method == 'mul':
        data_out = data_0 * data_1
    elif method == 'div':
        data_out = data_0 / data_1
    return data_out
        
def cal_nwp(nc_list ,pmp):
    dict_out = {}
    dim_out = {}
    factor_in = pmp['factor_in']
    factor_out = pmp['factor_out']
    method = pmp['method']
    
    if method in ['max','min','mean','sum']:
        factor = factor_in[0]
        data_all = nc_list[0].variables[factor][:]
        data_all = data_all[np.newaxis,:]
        for nc_tmp in nc_list[1:]:
            data_tmp = nc_tmp.variables[factor][:]
            data_tmp = data_tmp[np.newaxis,:]
            data_all = np.concatenate((data_all,data_tmp),axis=0)
        data_out = eval('np.nan%s(%s,axis=0)'%(method,'data_all'))
        del data_all
        dict_out[factor_out] = data_out
    elif method in ['add','sub','mul','div']:
        factor_0 = factor_in[ 0]
        factor_1 = factor_in[-1]
        try:
            data_0 = nc_list[ 0].variables[factor_0][:]
        except:
            data_0 = nc_list[-1].variables[factor_1][:]*0
        try:
            data_1 = nc_list[-1].variables[factor_1][:]
        except:
            data_1 = nc_list[ 0].variables[factor_0][:]*0
        data_out = cal_arithmetic(data_0,data_1,method)
        dict_out[factor_out] = data_out
    dim_out[factor_out] = nc_list[0].variables[factor_in[0]].dimensions
    return dict_out,dim_out
# In[读取nc]
if __name__ == '__main__':
    input_argv = sys.argv[:]
    pmp_list = ['pmp%s='%(x+1) for x in range(len(input_argv)-5)]
    
    opts, args = getopt.getopt(input_argv[1:], "i:o:",pmp_list)
    pmps = []
    for op, value in opts:
        if op == "-i":
            file_in = value
        elif op == "-o":
            file_out = value
        elif op[:5] == "--pmp":
            tmp_dict = {}
            tmp_list = value.split(',')
            tmp_dict['factor_in'] = tmp_list[0].split('---')
            tmp_dict['method'] = tmp_list[1]
            tmp_dict['factor_out']  = tmp_list[2]
            pmps.append(tmp_dict)

# In[读取nc]
    # file_in = r'\\192.168.20.67\data3\NAFP\EC_THIN_0.4\2022\202205\20220523\PRODUCT_NAFP_ECFINE-0.4_20220523000000_000.nc,\\192.168.20.67\data3\NAFP\EC_THIN_0.4\2022\202205\20220523\PRODUCT_NAFP_ECFINE-0.4_20220523000000_012.nc,\\192.168.20.67\data3\NAFP\EC_THIN_0.4\2022\202205\20220523\PRODUCT_NAFP_ECFINE-0.4_20220523000000_018.nc'
    # file_out = r'E:\PRODUCT_NAFP_ECFINE-0.4_20220523000000_021.nc'
    # pmps = [{'factor_in':['TMP'],'method':'max','factor_out':'TMAX24H'},#24H最高温
            # {'factor_in':['ETO2M'],'method':'sub','factor_out':'DT2M24H'},#24H2M变温
            # {'factor_in':['TMP'],'method':'add','factor_out':'DT24H'}]

    file_in_list = file_in.split(',')



    # 读取NC
    nc_list = []
    for file in file_in_list:
        nc_tmp = Dataset(file,'r')
        nc_list.append(nc_tmp)


    '''
        'add':加  支持最多两个要素输入，支持多个文件输入，用第一个文件与最后一个文件进行计算
        'sub':减  
        'mul':乘
        'div':除
        
        'mean':平均  只支持单要素输入，支持多个文件输入(如果输入要素为多个，则取第一个)
        'sum':求和
        'max':最大
        'min':最小
    '''

    # In[处理nc]
    dict_out_all = {}
    dim_out_all = {}
    for pmp in pmps:
        try: 
            dict_tmp,dim_tmp = cal_nwp(nc_list ,pmp)
            dict_out_all.update(dict_tmp)
            dim_out_all.update(dim_tmp)
        except KeyError:
            print('Lost factor',pmp['factor_in'][0])
            continue

    for nc_tmp in nc_list:
        nc_tmp.close()    

    # In[写nc]
    #判断文件存不存在
    if os.path.exists(file_out):#存在  复写
        nc = Dataset(file_out, 'r+')
        for factor in dict_out_all.keys():
            try:
                nc.createVariable(factor, 'f', dim_out_all[factor], fill_value=9999.0)
            except RuntimeError:
                print('String match to name in use')
            nc.variables[factor][:] = dict_out_all[factor]
        nc.close()
    else:
        if not os.path.exists(os.path.dirname(file_out)):
            os.makedirs(os.path.dirname(file_out))
        copyfile(file_in_list[0],file_out)
        nc = Dataset(file_out, 'r+')
        for factor in dict_out_all.keys():
            try:
                nc.createVariable(factor, 'f', dim_out_all[factor], fill_value=9999.0)
            except RuntimeError:
                print('String match to name in use')
            nc.variables[factor][:] = dict_out_all[factor]
        nc.close()

