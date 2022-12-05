# Final Project!
I'll work with Yuqi Zhang and Dongying Liu for this final project. 

Here's the link of our design doc: https://docs.google.com/document/d/1Fy-YzTWK_csSgQDFjBJPMhLtHKCemdKlwvjb63kiVcI/edit?usp=sharing

# Final Submission

## Final Result

## Post Mortem

### How did your project go overall? 
### Did you accomplish your goal? 
### Do you have pivot?

# Milestone 2

## Weather
### Yuqi Zhang
For milestone 2, I finished most part of different weathers, I still getting bugs on thunders and lightning part. 
The Cloud will be used in sunny weather and raining/snowy weather. The color(shadow) of the cloud will change based on the timeframe. 
There are also be different layers of cloud, I finished two layers, the cloud on the top layer will be lighter and move fast. But rendering one frame of cloud takes about 40 minutes, so I didn't include the gif of the cloud. 
| Cloud | Cloud with sample scene|
|--|--|
|<img height = "300" alt="cloud1" src="img/cloud1.png">|<img height = "300" alt="cloud2" src="img/cloud2.png">|


For the interaction part, I finished the accumulated snow on the simple tree. The interaction between objects and snow only has the relationship of accumulation. The interaction between rain and objects may be more complicated. The rain drops may accumulate, sliding, sticking on the surface of the objects. 

| Snow interactions | 
|--|
|<img height = "300" alt="snowy" src="img/snow.png">|


In the next week, I will work with my teammate to merge this part. I will work with the interaction of snow and rain on the terrain and plants that my teammates implemented. I did not find a good way to transit weathers for now, I will work on that before the final. If I cannot find a good way to transit, I may use keyframe to present different weathers.  The transit between different seasons and weather may also be a challenge for me. I will also work on the weather cycle to make the change of weather as smooth as possible. 

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

### Wenqing Wang - Growth simulation on heightfield
<p align="center">
<img height = "400" alt="screenshot" src="img/2.png">
</p>

Since the method, I used for simulation growth on the surface is somehow computationally heavy and would crash my laptop if using more complicated geometries, I tried another way to implement growth simulation in milestone 2. I first tested it on a 10 x 10 grid with a simple noised applied to it, and it looks good with my pine tree growing on it. In order to merge my simulation with Dongying's terrain motion, I then started working on heightfield. 
The basic settings for my growth are simple. First, I selected a start area with the scattered point on the heightfield for the growth simulation. Then I paint the attribute on the converted heightfield to create the growth path.
| Start point | growth path |
|--|--|
|<img height = "300" alt="start point" src="img/start_pt.png">|<img height = "300" alt="growth path" src="img/pat.png">|

In this phase, I use the color attribute to visualize the expansion of the growth area. I also add a wave at the outer edge to add some motion to the simulation.

| growth area | growth wave |
|--|--|
|<img height = "300" alt="growth_along_path" src="img/growth_along_path.gif">|<img height = "300" alt="growth_wave_along_path" src="img/growth_wave_along_path.gif">|

And below is the final result:
| Pine tree growth simulation on heightfield |
|-|
|<img height = "600" alt="tree gowth simulation" src="img/tree_growth_along_path.gif">|

During this milestone, I also started to merge with Dongying's work. Before merging our code, one of my concerns was whether the positions of the trees growing based on the height field would move with them when the terrain started to have some motion. Fortunately, I found that this could be solved by simply replacing the original scatter node with the heightfield scatter node.

The biggest problem we faced so far was the hardware and software limitations. Although we have a GTX 3060 graphics card, we can only use the free version of Houdini and its own CPU-based renderer, so our simulation and rendering in Houdini are super slow. The situation seems to get even worse considering Dongying wants to create more complex terrain and I plan to add other high-resolution assets from Quixel Bridge (i.e. grass, flowers, etc) and create unique growth paths and animations for each (we haven't even merged Yuqi's work yet).

Maybe buying Houdini's commercial version + subscription to Redshift would be a solution, but for now, we are still considering if there is a more affordable solution.

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
