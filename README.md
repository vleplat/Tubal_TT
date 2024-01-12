# Software for tubal tensor train (TTT) decomposition:
This repository contains the software for a novel tensor model called the tubal tensor train (TTT) decomposition
This MATLAB software reproduces the results from the following paper:

```
@misc{anonymousXXX,
      title={A New Tensor Network: Tubal Tensor Train Network and its Applications}, 
      author={XXX,XXY,XYX and XYY},
      year={2023},
}
```

## Minimal requirements

In order to run the demos, you will need to add to your MATLAB path:
- Tensorlab 3.0: https://www.tensorlab.net
- Tensor-Tensor Product Toolbox 2.0: https://github.com/canyilu/Tensor-tensor-product-toolbox/tree/master

Additionnally, you will need:

- Download the Tensorbox from https://drive.google.com/file/d/1FJ-cHl54Dxxx1VqGX8-ezX1KoHURqhKO/view?usp=sharing
- The tensor_toolbox-v3.4 toolbox: https://rb.gy/nlq3w 

Please copy and paste these toolboxes within the /Libraries directory, see Content section below.

## Content
 
 - /Libraries : contains helpful libaries 
 
 - /DataSets : contains data sets considered in the numerical simulations, see Section 5 of the preprint.

 - /Utils : contains helpful files and MatLab routines to run the demos.

 - test_tt_tubal_image_demo.m : test file to reproduce results for image compression task, see Example 1 in section 5.

 - Video_demo.m : test file to reproduce results for video compression task, see Example 2 in section 5.

 - completion_demo.m : test file to reproduce results for tensor completion task, see Example 3 in section 5.

 - test_file_HSI.m :  test file for HSI tests, see Example 4 in section 5.
 
 



 
 
