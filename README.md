# Learning from Video and Text via Large-Scale Discriminative Clustering


### Introduction

This is the code for the paper :

Antoine Miech, Jean-Baptiste Alayrac, Piotr Bojanowski, Ivan Laptev, Josef Sivic, Learning from Video and Text via Large-Scale Discriminative Clustering, ICCV17.

The webpage for this project is available [here](http://www.di.ens.fr/willow/research/learningvideotext/). 

It only contains the code for the optimization part of the action recognition model given pre-extracted track features.

### Contents

  1. [Dependencies](#dependencies)
  2. [Data](#data)
  3. [Demo](#demo)
  4. [Running on new images](#running-on-new-images)

### Dependencies

To run this code, you need to install : 
1. [MOSEK](https://www.mosek.com/downloads/) : version 7 
2. [CVX](http://cvxr.com/cvx/download/) : version 2.1 

Once installed, setup the paths in startup file :
```Matlab
main.m
```


### Data

First you will need to download the pre-extracted person track features:

```Shell
wget https://www.rocq.inria.fr/cluster-willow/amiech/iccv17/X.mat
```

### Optimization

Now you can run our optimization code that will take X as input and output the label matrix Z given the bags formation and weak-supervision: 
```Matlab
   main.m
```

This code is optimized for running everything on a computer with enough memory. If you are looking for a way to solve the Discriminative Clustering in a totally online manner (ie with very limited memory usage) please contact us. We only provided this version as the fully online version is much slower to run because of the slow disk speed access.

### Cite

If you find this code useful in your research, please, consider citing our paper:

> @InProceedings{miech17learningvideotext,
>   author      = "Miech, Antoine and Alayrac, Jean-Baptiste and Bojanowski, Piotr and Laptev, Ivan and Sivic, Josef",
>   title       = "Learning from Video and Text via Large-Scale Discriminative Clustering",
>   booktitle   = "ICCV",
>   year        = "2017"
>}


