# Variational Approach for Capsule Video Frame Interpolation
## Abstract
Variational Approach for Capsule Video Frame Interpolation Capsule video endoscopy, which uses a wireless camera to visualize the digestive
tract, is emerging as an alternative to traditional colonoscopy. Colonoscopy is considered as gold standard for visualizing the colon and takes 30 frames per
second. Capsule images, on the other hand, are taken with low frame rate (average 5 frames per second), which makes it difficult to find pathology and
results in eye fatigue for viewing. In this paper, we propose a variational algorithm to smooth the video temporally and create a visually pleasant video.
The main objective of the paper is, to increase the frame rate to the gold standard of colonosocopy. We propose variational energy that take into
consideration both motion estimation and intermediate frame intensity interpolation using the surrounding frames. The proposed formulation
incorporates both pixel intensity and texture feature in the optical flow objective function such that the interpolation at the intermediate frame is directly
modeled. 
![alt text](https://github.com/ahme0307/TSR/blob/master/readme/featuremap.png)

## Sample result
![alt text](https://github.com/ahme0307/TSR/blob/master/readme/fig3.png)

## How to run

>makevideo.m

## Reference
>Mohammed, Ahmed, Ivar Farup, Sule Yildirim, Marius Pedersen, and Øistein Hovde. "Variational approach for capsule video frame interpolation." EURASIP Journal on Image and Video Processing 2018, no. 1 (2018): 30.


@article{mohammed2018variational,
  title={Variational approach for capsule video frame interpolation},
  author={Mohammed, Ahmed and Farup, Ivar and Yildirim, Sule and Pedersen, Marius and Hovde, {\O}istein},
  journal={EURASIP Journal on Image and Video Processing},
  volume={2018},
  number={1},
  pages={30},
  year={2018},
  publisher={Nature Publishing Group}
}
