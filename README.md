# Analyzing Temporal Factors for Anxiety and Depression Symptoms with the Rashomon Perspective

This repository contains the scripts, results, and plots to reproduce the paper "Analyzing Temporal Factors for Anxiety and Depression Symptoms with the Rashomon Perspective".

## 📂 Repository Structure

The project is organized into the following directory structure to ensure reproducibility:

```
├── scripts/                                     # scripts for Partial Dependence Profiles (.R)
│   ├── age_vs_education_for_GAD2.R
│   ├── age_vs_sex_for_PHQ2.R
│   ├── hour_vs_weekday_for_GAD2.R
│   └── ... (Total of 12 analysis scripts)
|
├── rds/                                         # stored Partial Dependence Profiles (.rds)                      
│   ├── profiles_age_vs_education_for_GAD2.rds
│   ├── profiles_age_vs_education_for_PHQ2.rds
│   ├── profiles_age_vs_sex_for_GAD2.rds
│   ├── profiles_hour_vs_weekday_for_PHQ2.rds
│   └── ... (Total of 12 .rds files)
│
├── plots/                                       # high-resolution PDP plots (GAD-2 and PHQ-2)
│   ├── GAD2.png
│   └── PHQ2.png                             
│
└── README.md                                    # project documentation
```

🛠️ Installation

To reproduce the analysis, you need R (>= 4.0.0) and the following libraries:

```
install.packages(c("tidyverse", "DALEX", "randomForest", "dplyr", "ggplot2", "readr"))
```

🚀 Usage

  1. Reproducing the Analysis
If you wish to re-run the entire model training and profiling process (which uses 100 bootstrap iterations and may be computationally intensive):
Run ```scripts/02_real_data_analysis.R```.

  2. Reproducing Figures and Tables

The repository provides pre-calculated .rds files in raw results/ to allow for immediate reproduction of figures without re-training:

Run scripts/03_tables_figures.R. This script accesses the .rds files to generate the grouped PDP plots seen in the paper.

📊 Key Findings

![](https://github.com/mcavs/RashPy/blob/main/plots/GAD2.png)
**Figure 1.** The Grouped PDPs for GAD-2 Risk Across the Factors. They illustrate the model-predicted relationship between the plotted factors and the estimated probability of the GAD-2 score being greater than 3. The lines represent the predicted probability values, and the surrounding bands indicate the 95% confidence intervals. Non-overlapping confidence intervals between groups suggest differences in predicted risk.

![](https://github.com/mcavs/RashPy/blob/main/plots/PHQ2.png)
**Figure 2.** The Grouped PDPs for the PHQ-2 Risk Across the Factors. They illustrate the model-predicted relationship between the plotted factors and the estimated probability of the PHQ-2 score being greater than 3. The lines represent the predicted probability values, and the surrounding bands indicate the 95% confidence intervals. Non-overlapping confidence intervals between groups suggest differences in predicted risk.

## Citation

```
@article{Cavus2023thestats,
  title   = {Analyzing the Temporal Factors for Anxiety and Depression Symptoms with the Rashomon Perspective},
  author  = {Cavus, Mustafa and Biecek, Przemys\l{}aw and Tejada, Julian and Faro, Andre and Marmolejo-Ramos, Fernando},
  year    = {2026},
  journal = {},
  volume  = {},
  number  = {},
  pages   = {},
  doi     = {}
}
```


## Contact

For any questions and feedback, please don't hesitate to contact us via the following e-mail addresses:
- mustafacavus@eskisehir.edu.tr 
-
-
-
-
