# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


#计算代价函数
def computeCost(X, y, theta):
    '''
    这个部分计算代价函数，X为矩阵（行数为样本数，列数为2）
    y为向量（列数为样本数），theta为行数为1列数为2的矩阵，.T为转置
    一个矩阵平方则内部的元素依次平方
    sum将一个向量内部的所有元素求和
    len返回一个矩阵的行数
    '''
    inner = np.power((X * theta.T - y), 2)
    return np.sum(inner) / (2 * len(X))


#梯度下降
def gradientDescent(X, y, theta, alpha, iters):
    temp = np.matrix(np.zeros(theta.shape))  #每一次迭代用来代替theta的矩阵
    parameters = int(theta.ravel().shape[1])  #theta内元素的个数
    cost = np.zeros(iters)  #代价函数，存储每次迭代

    for i in range(iters):
        error = (X * theta.T) - y

        for j in range(parameters):
            term = np.multiply(error, X[:, j])
            temp[0, j] = theta[0, j] - ((alpha / len(X)) * np.sum(term))

        theta = temp
        cost[i] = computeCost(X, y, theta)

    return theta, cost


#导入数据
path = '/home/liutuo/vscode/machine learning/data_sets/ex1data2.txt'
data = pd.read_csv(path, header=None, names=['Size', 'Bedrooms', 'Price'])
#print(data.head())

#特征归一化
data_ori = data
data = (data - data.mean()) / data.std()
#print(data.head())

#第一个参数为列数，第二个参数为列名，第三个参数为设定的数值
data.insert(0, 'Ones', 1)
#shape第一个元素为行数，第二个元素为列数
cols = data.shape[1]
#iloc中加上:,表示取列
X = data.iloc[:, :-1]
y = data.iloc[:, cols - 1:cols]
#values将dataframe中的数据以np.array的形式返回
X = np.matrix(X.values)
y = np.matrix(y.values)
theta = np.matrix(np.array([0, 0, 0]))
#学习速率设置为0.01，迭代次数设置为1500
alpha = 0.01
iters = 1500
#梯度下降
g, cost = gradientDescent(X, y, theta, alpha, iters)
print(g)

#下面进行回归直线的绘图
xx = np.linspace(data_ori.Size.min(), data_ori.Size.max(), 100)
yy = np.linspace(data_ori.Bedrooms.min(), data_ori.Bedrooms.max(), 100)
x, y = np.meshgrid(xx, yy)
f = g[0, 0] + g[0, 1] * x + g[0, 2] * y

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(x, y, f, cmap='Oranges')
ax.scatter3D(data_ori.Size, data_ori.Bedrooms, data_ori.Price, cmap='Blue')
plt.show()