# Final Project!
I'll work with Yuqi Zhang and Dongying Liu for this final project. 

Here's the link of our design doc: https://docs.google.com/document/d/1Fy-YzTWK_csSgQDFjBJPMhLtHKCemdKlwvjb63kiVcI/edit?usp=sharing

## Milestone 1

### Wenqing Wang
| Pine tree model | Dense surface packing|
|--|--|
|<img width="500" height = "400" alt="growth" src="img/growth.gif">|<img width="400" alt="pine_tree" src="img/pine_tree.png">|

In milestone 1, I learned the principle of Dense surface packing to complete a simple tree growth animation. I also modelled a pine tree based on our reference image. The current problem is that Houdini always crashes when I try to replace the low-poly tree shown in the gif result with my high resolution pine tree (I already pack and instance all the leaves when generating the pine tree). I considered that maybe the dense surface packing method is too computationally intensive for complex terrain or complex models, so in milestone 2 I plan to create a scatter number vs. time function to animate the growth of trees on the heightfield.

### Yuqi Zhang
Yuqi’s Milestone 1: <br>
I finished the rain and snow particle generation, for the rain effect, I also worked with the interaction with the particle to geometry. (Rain drops stick on the geometry surface, accumulate to and drops) <br>
I started working with lightning and got basic shapes. I am still working on the color/light of the lightning. <br>
I also need more knowledge of rendering in houdini. I assigned the material to the geometry and rain drops, but I did not render the effect I wanted. I may also need to spend some time learning that.  <br>
In milestone 2, I need to keep working on the weathers and maybe also need to think about how to represent them. For example, I want to exhibit the wind by moving plants. I may need to observe how they move. What is more, I also need to keep working with the sound, the thunder and lightning always happen together, also I need to add some rain sound to make sure they combine perfectly. 

![](./img/rain.png)
![](./img/rain.gif)
