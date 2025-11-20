# [file name]: Heatmap.py
# [file content begin]
# -*- coding:utf-8 -*-
"""
Copyright (C) 2025 SXMU

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap


class HeatmapPainter:
    def __init__(self, corr_matrix, p_matrix, significance_levels=[0.05, 0.01, 0.001]):
        """
        绘制带显著性标记的相关性热力图
        :param corr_matrix: r x c 的相关性矩阵（DataFrame或numpy array）
        :param p_matrix: r x c 的对应p值矩阵（DataFrame）
        :param significance_levels: 显著性水平，默认为[0.05, 0.01, 0.001]
        :return:
        """
        self.corr_matrix = corr_matrix
        self.p_matrix = p_matrix
        self.significance_levels = significance_levels
        self._param_check()
        self._create_annotations()

    def _param_check(self):
        # 确保输入是DataFrame或ndarray
        if not isinstance(self.corr_matrix, pd.DataFrame):
            if isinstance(self.corr_matrix, np.ndarray):
                self.corr_matrix = pd.DataFrame(self.corr_matrix)
            else:
                raise ValueError('corr_matrix必须为DataFrame或ndarray')
        if not isinstance(self.p_matrix, pd.DataFrame):
            if isinstance(self.p_matrix, np.ndarray):
                self.p_matrix = pd.DataFrame(self.p_matrix)
            else:
                raise ValueError('p_matrix必须为DataFrame或ndarray')

        # 输入参数预处理
        if len(self.significance_levels) != 3:
            raise ValueError('显著性水平需要输入三个浮点型阈值')
        for item in self.significance_levels:
            if not isinstance(item, float):
                raise ValueError('显著性水平需要输入浮点型阈值')

        # 计算实际比较阈值，并重新生成比较阈值集合
        num_compared = self.p_matrix.shape[0] * self.p_matrix.shape[1]
        alpha = self.significance_levels[0]
        alpha_mod = alpha / num_compared
        self.significance_levels.append(alpha_mod)
        self.significance_levels.sort(reverse=True)
        del_end_ind = self.significance_levels.index(alpha_mod)
        del self.significance_levels[: del_end_ind]

        print(
            f'总比较次数为：{num_compared}',
            f'Bonferroni法：校正前后Alpha分别为 {alpha}  {alpha_mod}',
            f'最后确定的浮点阈值为：{self.significance_levels}',
            sep='\n'
        )

    def _create_annotations(self):
        annotations = pd.DataFrame('',
                                   index=self.corr_matrix.index,
                                   columns=self.corr_matrix.columns,
                                   dtype=str)
        for i in range(self.p_matrix.shape[0]):
            for j in range(self.p_matrix.shape[1]):
                p = self.p_matrix.iloc[i, j]
                if len(self.significance_levels) == 3:
                    if p < self.significance_levels[2]:
                        annotations.iloc[i, j] = format(self.corr_matrix.iloc[i, j], '.3f') + '***'
                    elif p < self.significance_levels[1]:
                        annotations.iloc[i, j] = format(self.corr_matrix.iloc[i, j], '.3f') + '**'
                    elif p < self.significance_levels[0]:
                        annotations.iloc[i, j] = format(self.corr_matrix.iloc[i, j], '.3f') + '*'
                    else:
                        annotations.iloc[i, j] = ''
                elif len(self.significance_levels) == 2:
                    if p < self.significance_levels[1]:
                        annotations.iloc[i, j] = format(self.corr_matrix.iloc[i, j], '.3f') + '**'
                    elif p < self.significance_levels[0]:
                        annotations.iloc[i, j] = format(self.corr_matrix.iloc[i, j], '.3f') + '*'
                    else:
                        annotations.iloc[i, j] = ''
                else:
                    if p < self.significance_levels[0]:
                        annotations.iloc[i, j] = format(self.corr_matrix.iloc[i, j], '.3f')
                    else:
                        annotations.iloc[i, j] = ''
        self.annotations = annotations

    def plot_correlation_heatmap(self):
        # 设置画布大小
        plt.figure(figsize=(1.1 * self.corr_matrix.shape[1], 1.1 * self.corr_matrix.shape[0]))
        plt.subplots_adjust(left=0.11, right=1.0, bottom=0.2, top=1.0)      # 可根据客观情况，自行调整

        # 设置热力图色带cmap
        custom_cmap = LinearSegmentedColormap.from_list(
            "custom_cmap",
            # ["#005461", "#25b1bf", "#ffffff", "#ff6366", "#de283b"],  # 绿白红颜色
            ["#104e8b", "#5f89b1", "#ffffff", "#e5b5b5", "#b22222"],  # 蓝白红颜色
            N=1024  # 分成256个颜色渐变层次
        )

        # 绘制热力图
        ax = sns.heatmap(
            self.corr_matrix,
            annot=self.annotations,
            fmt='',
            # cmap='coolwarm',
            cmap=custom_cmap,
            center=0,
            cbar_kws={
                'label': 'Correlation Coefficient',  # 色条标题
                'shrink': 1,  # 色条缩放比例
                'aspect': 15,  # 色条宽窄比例
                'pad': 0.02,  # 色条与主图间距
                # 'orientation': 'horizontal'  # 色条方向
            },  # colorbar相关属性
            annot_kws={
                "size": 13,  # 字号大小
                # "color": "black",  # 文字颜色
                # "weight": "bold",  # 字体加粗
            },  # annotation相关属性
            linewidths=0.5,
            linecolor='white',
        )

        # 修改 colorbar label 的字体大小
        colorbar = ax.collections[0].colorbar
        colorbar.set_label('Correlation Coefficient', fontsize=13)  # 设置label和字号

        # 设置坐标轴字体
        plt.xticks(
            rotation=30, ha='right',
            fontsize=13,
            # fontweight='bold',
        )
        plt.yticks(
            fontsize=13,
            # fontweight='bold',
        )

        # plt.title('Correlation Heatmap with Significance')
        plt.show()


if __name__ == '__main__':
    df_corr = pd.read_csv('data_heatmap_demo/cor_matrix_demo.csv', index_col=0).T
    df_p = pd.read_csv('data_heatmap_demo/p_matrix_demo.csv', index_col=0).T
    hp = HeatmapPainter(df_corr, df_p)
    hp.plot_correlation_heatmap()

# [file content end]