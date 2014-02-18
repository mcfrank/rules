rules
=====

This repository contains the code for a model by Frank & Tenenbaum (2011), and corrections, elaborations, and extensions. It is a more dynamic version of the original zip file that was distributed with the paper. 

Correction
----------

Note that this code contains a correction to Equation 4, suggested by Florent Meyniel. The bottom term of this Equation should read \frac{(1-\alpha)}{|S|} instead of \frac{(1-\alpha)}{|S|-|r|}.

When this correction is implemented, there are some small numerical differences in results, but as far as we know, no qualitative differences resulting in modification to any of our claims. 

Original readme is below:
=====
Readme for code accompanying Frank & Tenenbaum, "Three ideal observer models for rule learning in simple languages."

Paper linked here: http://langcog.stanford.edu/papers/FT-cognition2011.pdf

This archive contains matlab code to reproduce the simulations reported in our paper. The main director contains three scripts. Each one can be modified directly by changing the parameters specified at the top of the script; comments in each one describe which options are possible. 

* SCRIPTS

model1.m - single rule, no noise

model2.m - single rule, memory noise

model3.m - multiple rules, memory noise (note that this model uses a gibbs sampler for approximate inference and so runs considerably slower and provides approximate guesses about the posterior over rule clusters rather than giving an exact posterior as the other two do).

* DIRECTORIES

experiments - contains scripts for reproducing our simulations.

helper - contains a variety of helper functions for the base models and the simulations.

mats - contains cached hypothesis space .MAT files. the efficiency of our models relies on much of the computation being cached ahead of time and looked up during inference.

All code was created using Matlab R2010a. Feel free to modify or distribute any of this code but please cite the corresponding paper. 

