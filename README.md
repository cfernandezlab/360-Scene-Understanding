# Lines and Vanishing Points directly on Panoramas
Matlab implementation for lines and vanishing points extraction directly with panoramic images. [paper](https://arxiv.org/pdf/1806.08294.pdf): "Layouts from Panoramic Images with Geometry and Deep Learning"

<img src='img/pano_vp_lines.png' width=400>

## How it works
In panoramas, a straight line in the world is projected as an arc segment on a great circle onto the sphere and thus it appears as a curved line segment in the image. For this reason, we represent each line by the normal vector ni of the 3D projective plane that includes the line itself and the camera center. 
We adopt the Manhattan World assumption whereby there exist three dominant orthogonal directions. Another particularity of this type of projection is that parallel lines in the world intersect in two antipodal VP whereas in conventional images they do in one single VP.
We detect lines and VP by a RANSAC-based algorithm that works directly with panoramas showing entire and unique line segments.

- To run the code:
```
main_linesVPs.m
```
Running time: ~ 4 seg/im with Matlab on Linux machine with an Intel Core 3.6 GHz (4 cores)

## Citation
Please cite our paper for any purpose of usage.
```
@article{fernandez2018layouts,
  title={Layouts from Panoramic Images with Geometry and Deep Learning},
  author={Fernandez-Labrador, Clara and Perez-Yus, Alejandro and Lopez-Nicolas, Gonzalo and Guerrero, Jose J},
  journal={arXiv preprint arXiv:1806.08294},
  year={2018}
}
```
