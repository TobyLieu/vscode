# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

x = np.linspace(-5, 5, 1000)
f = 54*pow(x, 6)+45*pow(x, 5)-102*pow(x, 4)-69*pow(x, 3)+35*pow(x, 2)+16*x-4
z = 0
#y = x**2

fig, ax = plt.subplots(figsize=(8, 16))
ax.plot(x, f, 'r', label='f(x)')
ax.plot(x, x-x)
ax.legend()
ax.set_xlabel('x')
ax.set_ylabel('f(x)')
ax.set_title('f(x) = 54x^6 + 45x^5 - 102x^4 - 69x^3 - 35x^2 + 16x - 4')
plt.xlim(-5, 5)
plt.ylim(-30, 30)
plt.show()
