# -*- coding: utf-8 -*-
"""
Created on Sat Jan 12 21:12:59 2019

@author: hasee
"""

import re
import jieba
import os
 
def check_contain_chinese(check_str):#中文判断
    flag = True
    for ch in check_str.decode('utf-8'):
        if u'\u4e00' >= ch or ch >= u'\u9fff':
            flag =  False
    return flag

def emailsplit(emailstring):
    estring=jieba.lcut(emailstring)
    listofemail=[re.sub(r'\W*','',s)for s in estring]
    zhPattern = re.compile(u'[\u4e00-\u9fa5]+')
    relist=[]
    for word in listofemail:
        if len(word)>=2 and zhPattern.search(word)and word not in relist:
            relist.append(word.lower())
    return relist
def bagofword(wordlist,wordnum,inputlist):#创建词袋
    for word in inputlist:
        if word in wordlist:
            wordnum[wordlist.index(word)] += 1
        else:
            wordlist.append(word)
            wordnum.append(1)
    return wordlist,wordnum

def train():#训练集
    norloc=r'D:\scripts\垃圾邮件\spam data\normal'
    traloc=r'D:\scripts\垃圾邮件\spam data\trash'
    wordlist=[]
    nwordnum=[]
    twordnum=[]
    for ite in os.listdir(norloc):
        item=norloc+'\\'+ite
        with open(item,'r',encoding='gb18030',errors='ignore')as f:
            string=f.read()
        inputlist=emailsplit(string)
        wordlist,nwordnum=bagofword(wordlist,nwordnum,inputlist)
    nwordnum=[(i+1)/(len(nwordnum)+2) for i in nwordnum]#拉普拉斯修正
    twordnum=[0]*len(wordlist)
    for ite in os.listdir(traloc):
        item=traloc+'\\'+ite
        with open(item,'r',encoding='gb18030',errors='ignore')as f:
            string=f.read()
        inputlist=emailsplit(string)
        wordlist,twordnum=bagofword(wordlist,twordnum,inputlist)
    nwordnum=nwordnum+[1/len(nwordnum)]*(len(wordlist)-len(nwordnum))
    twordnum=[(i+1)/(len(twordnum)+2) for i in twordnum]
    freq=[]
    t=len(twordnum)/(len(twordnum)+len(nwordnum))
    n=len(nwordnum)/(len(twordnum)+len(nwordnum))
    for i in range(len(wordlist)):
        freq.append((t*twordnum[i])/(t*twordnum[i]+n*nwordnum[i]))
    return wordlist,freq


def judge(emaillist,wordlist,freq):#假设先验概率为0.5,取概率最大15个计算
    tmp=[]
    for word in emaillist:
        if word in wordlist:
            tmp.append(freq[wordlist.index(word)])
        else: 
            tmp.append(0.4)
    tmp.sort()
    a=b=1
    try:
        for i in range(len(emaillist)):
            a=a*tmp[i]
            b=b*(1-tmp[i])
        return (a/(a+b))
    except:
        return (a/(a+b))

if __name__=='__main__':
    wordlist,freq=train()
    loc=r'D:\scripts\垃圾邮件\spam data\test'
    tp=fp=tn=fn=0
    for ite in os.listdir(loc):
        item=loc+'\\'+ite
        with open(item,'r',encoding='gb18030',errors='ignore')as f:
            string=f.read()
        inputlist=emailsplit(string)
        print("测试邮件%s，垃圾邮件判断率%f"%(ite,judge(inputlist,wordlist,freq)))
        if int(ite)<7000:
            if judge(inputlist,wordlist,freq)>0.99:
                tp+=1
            else:
                fn+=1
        else:
            if judge(inputlist,wordlist,freq)>0.99:
                fp+=1
            else:
                tn+=1
    count=tp+tn+fp+fn
    print("准确率：%4f，精确率：%4f，召回率：%4f"%((tp+tn)/count,tp/(tp+fp),tp/(tp+fn)))