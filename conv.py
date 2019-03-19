# -*- coding: utf-8 -*-
"""
Created on Sun Oct 28 11:49:25 2018

@author: hasee
"""
import numpy as np

def sigmoid(x):
    return 1/(1+np.exp(-x))

def tanh(x):
    return (np.exp(x)-np.exp(-x))/((np.exp(x)+np.exp(-x)))

class Conv():
    def __init__(self,data,kenel,stride,ispadding):
        """
        data输入数据，格式为[batch size,DATA]，仅支持三维数据
        kenel为卷积核大小,[x_size,y_size,输入数据维度,卷积核个数]
        strid为步长，二维数组
        ispadding表示是否扩充，bool变量
        步长与卷积核大小应该适合于输入数据的尺寸，否则会导致部分数据永远无法进行卷积，
        而且在反向传播中会出现矩阵维度不一致错误
        """
        d=np.array(data)
        self.data=d
        self.batchsize=d.shape[0]
        self.d_size=d.shape[1:3]
        self.k_size=kenel[0:2]
        self.d_channel=d.shpae[3]
        self.k_channel=kenel[3]
        self.padding=ispadding
        self.weights=np.random.standard_normal(kenel)/(np.kenel[0]*np.kenel[1]*np.kenel[2]*np.kenel[3])
        self.stride=stride
        
    def forward(self):
        x=int(self.d_size[0]/2)
        y=int(self.d_size[1]/2)#只支持奇数尺寸的卷积核，偶数尺寸会导致矩阵维度不匹配
        if self.padding:
            d=np.pad(self.data,((0,0),(x,x),(y,y),(0,0)),'constant',constant_values=0)
        weights=self.weights.reshape([-1,self.k_channel])
        out=[]
        col=[]
        for k in range(0,self.batchsize):
            dd=[]
            for i in range(0,d.shape[0]-self.k_size[0]+1,self.stride[0]):
                for j in range(0,d.shape[1]-self.k_size[1]+1,self.stride[1]):
                    dd.append(d[k,i:i+self.k_size[0],j:j+self.k_size[1],:].reshape([-1]))
            dd=np.array(dd)
            col.append(dd.reshape[-1])
            out=out.append(np.dot(dd,weights).reshape([-1]))
        out=np.array(out)
        self.col=np.array(col).reshape([self.batchsize,-1,self.k_size[0]*self.k_size[1]*self.d_channel])
        self.out=out.reshape([self.batch_size,i+1,j+1,self.k_channel])
        
    def backward(self,lr,da):
        da=np.array(da).reshae([self.batchsize,-1,self.k_channel])
        dw=np.zeros(self.k_size[0]*self.k_size[1]*self.d_channel*self.k_channel,self.k_size)#参数更新
        for i in range(0,self.batchsize):
            dw=dw+np.dot(self.col[i,:,:].T,da[i])
        dw=dw.reshape(self.weights.shape)/self.batch_size
        self.weights=self.weights-lr*dw
        out2=[]#导数传递
        for i in range(0,self.out.shape[0]):#依照步长扩充
            out=self.out[i,0,:,:]
            for j in range(1,self.out.shape[1]):
                out=np.append(out,np.zeros(1,self.stride[0]-1,self.out.shape[2],self.k_channel),axis=1)
                out=np.append(out,self.out[i,j,:,:],axis=1)
            out1=out
            out=out[i,:,0,:]
            for j in range(1,self.out.shape[2]):
                out=np.append(out,np.zeros(1,out1.shape[1],self.stride[1]-1,self.k_channel),axis=2)
                out=np.append(out,out1[i,:,j,:],axis=2)  
            out2.append(out)
        out=np.array(out2)
        if self.padding:#依照padding方式扩充
             out=np.pad(out1,((0,0),(int(self.d_size[0]/2),int(self.d_size[0]/2)),
                                  (int(self.d_size[1]/2),int(self.d_size[1]/2)),(0,0)),'constant',constant_values=0)
        else:
             out=np.pad(out1,((0,0),(int(self.d_size[0]-1),int(self.d_size[0]-1)),
                                  (int(self.d_size[1]-1),int(self.d_size[1]-1)),(0,0)),'constant',constant_values=0) 
        flip_w=np.flipud(np.fliplr(self.weights))
        flip_w=flip_w.swapaxes(2,3).reshape(-1,self.d_channel)
        oo=[]
        for i in range(0,out.shape[0]-self.k_size[0]+1):
            for j in range(0,out.shape[1]-self.k_size[1]+1):
                oo.append(out[:,i:i+self.k_size[0],j:j+self.k_size[1],:].reshape([-1]))
        oo=oo.reshape([self.batchsize,(i+1)*(j+1),-1])
        re=[]
        for i in range(0,self.batchsize):
            re.append(np.dot(oo[i,:,:],flip_w))
        re=re.reshape([self.batchsize,self.d_size[0],self.d_size[1],self.d_channel])
        self.da=re