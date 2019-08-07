# Recoding simulation analyses

### Background
Models of protein evolution or amino acid replacement models are used to score amino acid substitutions in sequence alignments or phylogenetic analyses. The Dayhoff and JTT matrices are examples of 20-state amino acid replacement models. Recently, recoding techniques have been employed to address difficulties that these models have dealing with compositional heterogeneity and substitution saturation (Susko & Roger 2007). Dayhoff recoding (i.e., Dayhoff 6-state recoding) specifically recodes amino acids from Dayhoff matrices according to 6 groups of chemically related amino acids that frequently replace one another (Hrdy et al. 2005), while JTT recoding (i.e., S&R 6-state recoding) is based on binning experiments using the JTT model by Susko & Roger (2007). 

### Rationale
The principle of using recoding to address compositional heterogeneity and substitution saturation has never been extensively tested. Evidence from our analysis presented at the SICB 2018 Conference showed that under all saturation simulations in the study, Dayhoff 6-state recoding performed worse than the PAM250 (Dayhoff) model. These preliminary results raise doubts about the benefits of using recoding approaches. 

### Objectives
The objective of this study is to test the effectiveness of 6-state recoding by comparing the performance of analyses on recoded and non-recoded datasets that have been simulated under gradients of compositional heterogeneity or saturation. In addition, we evaluate alternative recoding strategies using 9, 12, 15, and 18 states. 

### 00-PHYLOTOCOL
directory in which we have layed out all planned analyses

### 01-MODULES
perl modules used by multiple scripts in this repo

### 02-COMPOSITIONAL_HETEROGENEITY
all scripts and data employed in our compositional heterogeneity analysis

### 03-SATURATION
all scripts and data employed in our saturation analysis

### LICENSE
    Copyright (C) 2018, Hernandez and Ryan

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

