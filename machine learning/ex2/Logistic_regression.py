# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#sigmoid函数
def sigmoid(z):
    return 1/(1+np.exp(-z))

#读入数据
path = 'D:\\.vscode\\Python\\machine learning\\data_sets\\ex2data1.txt'
data = pd.read_csv(path, header=None, names=['Exam 1', 'Exam 2', 'Admitted'])
#print(data.head())

#将数据集分为两部分
positive = data[data['Admitted'].isin([1])]
negative = data[data['Admitted'].isin([0])]

#画出散点图
fig, ax = plt.subplots(figsize=(12, 8))
ax.scatter(positive['Exam 1'],
           positive['Exam 2'],
           s=50,
           c='b',
           marker='o',
           label='Admitted')
ax.scatter(negative['Exam 1'],
           negative['Exam 2'],
           s=50,
           c='r',
           marker='x',
           label='Not Admitted')
ax.legend()
ax.set_xlabel('Exam 1 Score')
ax.set_ylabel('Exam 2 Score')
plt.show()