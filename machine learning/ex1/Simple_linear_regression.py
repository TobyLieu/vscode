# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


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
    parameters = theta.ravel().shape[1]  #theta内元素的个数
    cost = np.zeros(iters)  #代价函数，存储每次迭代

    for i in range(iters):
        error = (X * theta.T) - y

        for j in range(parameters):
            term = np.multiply(error, X[:, j])
            temp[0, j] = theta[0, j] - ((alpha / len(X)) * np.sum(term))

        theta = temp
        cost[i] = computeCost(X, y, theta)

    return theta, cost


#path是文件所在路径
path = '/home/liutuo/vscode/machine learning/data_sets/ex1data1.txt'
#read_csv是pandas中的一个函数，names是列名，在有列名的情况下header要设置为none
data = pd.read_csv(path, header=None, names=['Population', 'Profit'])
#plot是画图的函数，kind=scatter表明类型为散点图（否则默认连线），figsize是图的大小（长，宽）
data.plot(kind='scatter', x='Population', y='Profit', figsize=(12, 8))
plt.show()
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
theta = np.matrix(np.array([0, 0]))
#学习速率设置为0.01，迭代次数设置为1500
alpha = 0.01
iters = 1500
#梯度下降
g, cost = gradientDescent(X, y, theta, alpha, iters)
print(g)
#对两个数据进行预测
predict1 = [1, 3.5] * g.T
print("predict1:", predict1)
predict2 = [1, 7] * g.T
print("predict2:", predict2)

#下面进行回归直线的绘图
x = np.linspace(data.Population.min(), data.Population.max(), 100)
f = g[0, 0] + (g[0, 1] * x)

fig, ax = plt.subplots(figsize=(12, 8))
ax.plot(x, f, 'r', label='Prediction')
ax.scatter(data.Population, data.Profit, label='Traning Data')
ax.legend(loc=2)
ax.set_xlabel('Population')
ax.set_ylabel('Profit')
ax.set_title('Predicted Profit vs. Population Size')
plt.show()

#下面进行cost-iter曲线的绘制
fig, ax = plt.subplots(figsize=(12, 8))
ax.plot(cost, 'r', label='Cost')
ax.legend(loc=1)
ax.set_xlabel('Iter')
ax.set_ylabel('J(theta)')
ax.set_title('J(theta) change when iter increasing')
plt.show()