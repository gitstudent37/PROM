# [file name]: ItemResponseCurve.py
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

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

class ItemCharacter:
    def __init__(self, icc_data):
        """
        Plot item characteristic curves
        :param icc_data: Plotting data
        """
        self.df_icc = icc_data

    def icc_painter(self):
        if not isinstance(self.df_icc, pd.DataFrame):
            raise ValueError(
                'Please input icc_data in DataFrame format'
            )
        sns.set(style="darkgrid")

        # Get all item names (e.g., 'Item_1' to 'Item_57')
        items = self.df_icc['Item'].unique()
        num_items = len(items)

        # Set figure parameters: display cols subplots per row
        cols = 10
        rows = (num_items + cols - 1) // cols  # Round up
        fig, axes = plt.subplots(rows, cols, figsize=(cols * 1.5, rows * 1.5), constrained_layout=True)

        # For unified legend colors
        palette = sns.color_palette('tab10', 5)
        category_labels = ['P1', 'P2', 'P3', 'P4', 'P5']

        # Plotting loop
        for idx, item in enumerate(items):
            ax = axes[idx // cols, idx % cols]  # Determine subplot position
            item_df = self.df_icc[self.df_icc['Item'] == item]

            # Reshape P1~P5 to long format suitable for Seaborn plotting
            melted = item_df.melt(id_vars=['Theta'], value_vars=['P1', 'P2', 'P3', 'P4', 'P5'],
                                  var_name='Category', value_name='Probability')

            # Plot multiple probability curves
            sns.lineplot(data=melted, x='Theta', y='Probability', hue='Category', ax=ax, palette='tab10', linewidth=1.5)

            ax.set_title(item, fontsize=10)
            ax.set_xlabel('')
            ax.set_ylabel('')
            ax.set_ylim(0, 1)
            ax.legend().remove()

        # Delete extra subplots (if last row is not full)
        for j in range(idx + 1, rows * cols):
            fig.delaxes(axes[j // cols, j % cols])

        # Add unified legend outside the image
        # Create dummy lines for legend (to get colors)
        legend_elements = [Line2D([0], [0], color=palette[i], lw=2, label=category_labels[i]) for i in range(5)]

        # Add legend to the upper right corner of the entire image
        fig.legend(handles=legend_elements, title='Response Category', loc='lower right')

        # Add overall title
        plt.show()


if __name__ == '__main__':
    df_icc = pd.read_csv('icc_data.csv')
    isc = ItemCharacter(df_icc)
    isc.icc_painter()
# [file content end]
