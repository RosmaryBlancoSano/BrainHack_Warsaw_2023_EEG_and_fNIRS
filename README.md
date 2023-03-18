# BrainHack_Warsaw_2023_EEG_and_fNIRS

The brain has been described as an interconnected neural network modeled as a graph to outline the functional topology and dynamics of brain processes. 
In Graph theory, the classical approach is to model the brain as a single-layer network, where the edges represent the same type of connections between nodes.
However, the complex network representation of the human brain on multiple scales and in multiple dimensions cannot ignore the use of more complex multiscale and multilayer models, which take into account the hierarchical organization of the brain in both spatial and temporal dimensions, as well as the changes in its functional organization over time.
The recent advances in network science led to the development of a powerful mathematical framework for multilayer modeling that consists of several distinct classical networks, each one encoding a specific type of information about the system.
Multilayer modeling takes into account the simultaneous existence of different types of relationships (edges) between system units (nodes), resulting in interconnected multiplex topologies, allowing to build whole-brain models by integrating features of various kinds. 
Moreover, multimodal monitoring is getting increased interest in the last few years. Mostly functional near-infrared spectroscopy (fNIRS) and electroencephalography (EEG) because of their non-invasiveness, low cost, and portability.
Their integration can reveal more comprehensive information associated with brain activity, taking advantage of their strengths (high spatial resolution of fNIRS and high temporal resolution of EEG) and compensating for their shortcomings (highly sensitive to extracerebral physiology for fNIRS and volume conduction for EEG).
The present project aims at combining the two modalities, together with the integrative graph models (multilayer networks), to produce a more reliable approximation of both the topology and dynamics associated with cognitive and motor brain functions.

Dataset: simultaneous EEG and fNIRS recordings of 19 subjects performing a motor imagery task.The signals for both modalities are preprocessed and then ready to use.

To be comparable the signals for both techniques need to be modeled on the same source space (by an atlas-based approach Desikan-Killiany we’ll define the region of interest (ROI)). 
These regional time series will be extracted for EEG for the 5 characteristic frequency bands: δ (0.5–4 Hz); θ (4–8 Hz); α (8–13 Hz); β (13–30 Hz); γ (30–128 Hz), and for fNIRS for the oxy- (HBO) and deoxyhemoglobin (HBR).

The functional connectivities will be calculated (for each subject) using Pearson’s correlation for fNIRS (for each HBO and HBR) and weighted Phase Locked Value for EEG (for all the frequency bands). 


To access my OneDrive data folder, click 
[here](https://sanoscience-my.sharepoint.com/:f:/g/personal/r_blanco_sanoscience_org/Ep8EL0t_EwRKsqVQQ4Cte-oB1tnxwY_gc2MlYf2YD0IUeg?email=c.koba%40sanoscience.org&e=gzVGow).

To download the BCT, click 
[here](https://sites.google.com/site/bctnet/).









