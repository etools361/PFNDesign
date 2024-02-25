# PFNDesign
PFN(pulse-forming network) Design using matlab

## 支持的PFN类型
最初脉冲产生技术来源于传输线，当需要产生比较宽的脉冲时，传输线尺寸非常大，所以人们想到了使用集总参数的电容和电感代替传输线功能构建脉冲信号，这种方法就被称为脉冲成型网络PFN，其背后的基本原理在于，脉冲包含许多可以使用傅立叶分析定义的频率分量。 这些分量/谐波可以由单独的 LC 电路元件生成并组合起来以有效地“构建”脉冲。 PFN 的组件或级数越多，PFN 就越能近似真正的方波脉冲。

下图展示了具体构建过程：
![](./src/PFN_Fig1.gif)
方波可以由一系列的正弦波叠加来表示。但是从上述叠加过程可以看到使用傅里叶级数展开理想方波会出现明显的吉布斯效应，所以为了减小吉布斯效应所带来的过冲线性，Guillemin提出了二次多项式构造不连续的方法，解决了吉布斯效应从而让PFN电路应用到实际成了可能。以下是使用Guillemin线所构建的脉冲示意图：
![](./src/PFN_Fig2.gif)
按照此方法重新计算得到傅里叶系数$^{[1]}$：
$$
\begin{align}
a_{k}=\dfrac{4}{k \pi}\left[\frac{\sin \left(k \dfrac{\pi}{2} \dfrac{\epsilon}{\delta}\right)}{\left(k \dfrac{\pi}{2} \dfrac{\epsilon}{\delta}\right)}\right]^2 \notag{}
\end{align}
$$
得到如下六种PFN电路：

PFN Type A:\
![](./src/PFN_Fig3.png)

PFN Type B:\
![](./src/PFN_Fig4.png)

PFN Type C:\
![](./src/PFN_Fig5.png)

PFN Type D:\
![](./src/PFN_Fig6.png)

PFN Type E:\
![](./src/PFN_Fig7.png)

PFN Type F:\
![](./src/PFN_Fig8.png)

这六种电路要数Type C的参数计算最简单，Type D参数计算最复杂，当然Type D从电路结构上最容易制造，结构也非常简单，详细计算方法见$^{[1]}$。

这里给出Matlab计算代码，有兴趣研究的朋友可以拿去参考$^{[3]}$。

## 设计举例
输入PFN网络最高阶数$n=13$，并且给出上升时间$\epsilon=0.08s$，总时间是$\delta=1s$，则可以得到各种不同网络的参数：
![](./src/PFN_Fig9.png)
设计的脉冲波形图如下：
![](./src/PFN_Fig10.png)

## 参考

<font size=2>[1] :  Ernst A. Guillemin, US2,461,321, PRODUCTION OF ELECTRIC PULSES, 1943.\
[2] : https://en.wikipedia.org/wiki/Pulse-forming_network \
[3] : https://github.com/etools361/PFNDesign\
</font>



