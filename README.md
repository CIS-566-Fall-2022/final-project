# Final Project!
I'll work with Yuqi Zhang and Dongying Liu for this final project. 

Here's the link of our design doc: https://docs.google.com/document/d/1Fy-YzTWK_csSgQDFjBJPMhLtHKCemdKlwvjb63kiVcI/edit?usp=sharing

# Milestone 2

## Weather
### Yuqi Zhang
For milestone 2, I finished most part of different weathers, I still getting bugs on thunders and lightning part. 
| Cloud | Cloud with sample scene|
|--|--|
|<img height = "300" alt="cloud1" src="img/cloud1.png">|<img height = "300" alt="cloud2" src="img/cloud2.png">|

I did not find a good way to transit different weather smoothly, I may work on that before the final. If I cannot find a good way to transit, I may use keyframe to present different weathers. 

## Fluid Landscape and Growth

<p align="center">
<img width="600" src="/img/fluid_landscape_with_growth_2.gif">
</p>

### Dongying Liu - Fluid Landscape
After figuring out how to transfer the motion of flip particles to heightfield, I tried to create a better looked terrain and drive it with a spiral particle motion.

#### Pyro Smoke and Flip Particle Simulation
I want to create a spiral particle simulation. Inspired by [this tutorial](https://lesterbanks.com/2018/10/create-mix-colors-houdini-fluids/)
, I tried to create a smoke and use the motion of the smoke to drive the paritcles' movement. The smoke is created with pyro solver. The particle is simulated with flip solver. I use the velocity of the smoke as wind direction, and use wind to affect the particles' movement.
| Smoke Simulation | Flip Particle Simulation Drive By Smoke |
|--|--|
|<img width="400" src="/img/smoke.gif">|<img width="400" src="/img/particle_smoke.gif">|

#### HeightField Terrain
Inspired by [this tutorial](https://www.youtube.com/watch?v=X0Bgl-HjW8k). I simply created the terrain with heightfield.

<p align="center">
<img width="600" src="/img/height_field.jpg">
</p>

#### Transfer Flip Particle Motion To HeightField
Although I've spend a lot of time and tried a lot of ways to transfer the flip particle motion to heightfield. When I finally figured this out, it turns out that it was really not that difficult... Flip simulation is created base on volume, it will output a velocity field itself. So, I can use the velocity field of the flip particle simuation to drive the heightfield. After convert the heightfield to polygon, I sample the velocity field with point position and use the solver to do p+=vt to create the movement of the terrain.

<p align="center">
<img width="600" src="/img/particle_smoke_terrain.gif">
</p>


# Milestone 1

### Wenqing Wang
| Dense surface packing | Pine tree model |
|--|--|
|<img height = "300" alt="growth" src="img/growth.gif">|<img height = "300" alt="pine_tree" src="img/pine_tree.png">|

In milestone 1, I learned the principle of Dense surface packing to complete a simple tree growth animation. I also modelled a pine tree based on our reference image. The current problem is that Houdini always crashes when I try to replace the low-poly tree shown in the gif result with my high resolution pine tree (I already pack and instance all the leaves when generating the pine tree). I considered that maybe the dense surface packing method is too computationally intensive for complex terrain or complex models, so in milestone 2 I plan to create a scatter number vs. time function to animate the growth of trees on the heightfield.

### Yuqi Zhang
Yuqi’s Milestone 1: <br>
<img width="500" src="/img/rain.png"> <img width="500" src="/img/rain.gif">

I finished the rain and snow particle generation, for the rain effect, I also worked with the interaction with the particle to geometry. (Rain drops stick on the geometry surface, accumulate to and drops) <br>
I started working with lightning and got basic shapes. I am still working on the color/light of the lightning. <br>
I also need more knowledge of rendering in houdini. I assigned the material to the geometry and rain drops, but I did not render the effect I wanted. I may also need to spend some time learning that.  <br>
In milestone 2, I need to keep working on the weathers and maybe also need to think about how to represent them. For example, I want to exhibit the wind by moving plants. I may need to observe how they move. What is more, I also need to keep working with the sound, the thunder and lightning always happen together, also I need to add some rain sound to make sure they combine perfectly. 



### Dongying Liu

| Terrian Motion With Random Vel | Flip Tank Particle | Terrian Motion With Particle Vel |
|--|--|--|
|<img height="300" src="/img/moving_terrian.gif">|<img height="300" src="/img/flip_tank.gif">|<img height="300" src="/img/wrong_land.jpg">|

For milestone 1, my goal is to create a fluid terrain. My first thought was to create a terrain and give every point of the terrain velocity. So, with the Solver node, I can do p+=vt to every point to make the terrain move. 

As the picture shows above, I create a velocity field with Volume Node, and the velocity is generated by noise. And then I sample the velocity field with the position of every point of the terrain to give the point a velocity. As the picture shows, the terrain moved. 

According to the reference, the author said he transfered the flip tank particle motion to heightfield. So, I created a simple flip tank particle effect and then used the particle velocity to create a velocity field volume. However, the reulst seems not correct, it might be the problem that the velocity field has more y direction's velocity. So, the terrian move upward rather than moved on xz plane. 
