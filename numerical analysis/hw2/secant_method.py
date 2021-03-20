# -*- coding: utf-8 -*-
import numpy as np
from scipy.misc import derivative


def secant_method(f, x1, x2):  # 割线方法
    x = [x1, x2]
    print("%d    %.16f" % (0, x[0]))
    print("%d    %.16f" % (1, x[1]))
    for i in range(1, 50):
        if(x[i] == x[i-1]):  # 当x[i]与x[i-1]相等时，说明已经收敛
            df = derivative(f, x[i], 1e-6)
            print("The derivative of f(x[i]) is: %f" %
                  derivative(f, x[i], 1e-6))
            if(round(df, 6) == 0):  # 从一阶导数的情况判断是否是重根
                print("Linear convergence!")
            else:
                print("Superlinear convergence!")
            print("")
            return None  # 直接退出函数，避免继续执行出现除数为0的情况
        x.append(x[i]-(f(x[i])*(x[i]-x[i-1]))/(f(x[i])-f(x[i-1])))  # 更新x[i+1]
        print("%d    %.16f" % (i+1, x[i+1]))


def f(x):
    return 54*x**6+45*x**5-102*x**4-69*x**3+35*x**2+16*x-4


print("the 1st root:")
secant_method(f, -1.4, -1.3)
print("the 2nd root:")
secant_method(f, -0.7, -0.6)
print("the 3rd root:")
secant_method(f, 0.2, 0.3)
print("the 4nd root:")
secant_method(f, 0.4, 0.5)
print("the 5nd root:")
secant_method(f, 1.1, 1.2)
