# Interactive Deep House Visualization

## Introduction

Interactive generative art has been a significant source of inspiration for my journey in computer graphics, especially since visiting large scale exhibitions produced by studios like [teamLab](https://www.teamlab.art/) and [Moment Factory](https://momentfactory.com/home). While the main purpose of computer graphics is to generate beautiful images, these visual experiences can be greatly elevated by integrating sensors and input systems to involve the audience in the art form. Recently, I have been playing around with [TouchDesigner](https://derivative.ca/) and the LeapMotion controller to create interactive art using hand motions. However, these experiences are thus far limiting in space. It is now time for me scale it to the next level both in terms of display output and the input system.

The theme of this project focuses on two important interests of mine: **dancing** and **fashion**. A friend of mine recently introduced me to the music genre of **Deep House**, which is both a type of [dance](https://www.youtube.com/watch?v=PbSv9doE9IY&ab_channel=MOVEDanceStudio) as well as the genre heavily used in the fashion industry for fashion runways or stores like ZARA. For example, [check this song out](https://www.youtube.com/watch?v=KD3sOUxKp9g&ab_channel=MelomaniacRDV) to get a sense of the vibe. My plan is to integrate these two elements into my work as I design the overall audience experience and the visuals.

## Goal

The goal of this project is to create an audio-and-motion-reactive visualization of Deep House music. Specifically, there are a few core objectives that I would like to meet:

* The visuals react to a playlist of Deep House music coherently. The overall mood established should follow the beats and pace of the music.
* The project will be rendered in real-time at an interactive rate (minimum 30 fps).
* The audience can interact with the visualizer by moving their bodies and dancing to the music.
* The project can be scaled to a larger environment, ideally displayed using a projector and have multiple people interact with it at the same time.
* The visuals must be polished with fine-tuned color schemes that feel in place with the overall theme of the project.
* BONUS: Install the project somewhere on campus for people to actually interact with, and record a video showing this.

**The above goals are dependent on my ability to source the hardware.*

## Inspiration & References:

- [TouchDesigner Artist: Bileam Tschepe](https://www.instagram.com/elekktronaut/)
- [Universe of Water Particles - teamLab](https://www.teamlab.art/ew/waterparticles-transcending_superblue/superbluemiami/)
- [TouchDesigner: Popping Dance w/ Particles](https://www.youtube.com/watch?v=oSPbZISVjRM)
- [TouchDesigner: Audio-Reactive Voronoi](https://www.youtube.com/watch?v=tQp2osjgfYE&ab_channel=VJHellstoneLiveVisuals)
- [TouchDesigner: Tile Pattern](https://www.youtube.com/watch?v=gXUWcYZ8hqQ&ab_channel=bileamtschepe%28elekktronaut%29)
- [Taipei Fashion Week SS22 - Ultra Combos (Only available in Chinese)](https://ultracombos.com/SS22-Taipei-Fashion-Week-SS22)

## Specification:

This project will be implemented using **TouchDesigner**. The inputs to the system will be a depth sensor camera such as ZED Mini or Kinect, as well as audio signals from the music. These signals will be used to drive the various parameters of the visualization.

The visualizer can be broken down into multiple visual layers which are composited together. These layers will be discussed more in-depth in the design section. Finally, the composited render will be displayed using a projector.

## Techniques:

The project will explore many common procedural techniques, including but not limited to the following:

* **Particles Simulation** - particles will be used to add interactivity to the scene, and/or as an decorative element.
* Procedural shapes and patterns - procedural shapes and 
* Optical Flow: 
* Noise
* Toolbox Functions
* Post-processing Techniques


- What are the main technical/algorithmic tools you’ll be using? Give an overview, citing specific papers/articles.

## Design:
- How will your program fit together? Make a simple free-body diagram illustrating the pieces.

## Timeline:
- Create a week-by-week set of milestones for each person in your group. Make sure you explicitly outline what each group member's duties will be.

Submit your Design doc as usual via pull request against this repository.
## Milestone 1: Implementation part 1 (due 11/16)
Begin implementing your engine! Don't worry too much about polish or parameter tuning -- this week is about getting together the bulk of your generator implemented. By the end of the week, even if your visuals are crude, the majority of your generator's functionality should be done.

Put all your code in your forked repository.

Submission: Add a new section to your README titled: Milestone #1, which should include
- written description of progress on your project goals. If you haven't hit all your goals, what's giving you trouble?
- Examples of your generators output so far
We'll check your repository for updates. No need to create a new pull request.
## Milestone 3: Implementation part 2 (due 11/28)
We're over halfway there! This week should be about fixing bugs and extending the core of your generator. Make sure by the end of this week _your generator works and is feature complete._ Any core engine features that don't make it in this week should be cut! Don't worry if you haven't managed to exactly hit your goals. We're more interested in seeing proof of your development effort than knowing your planned everything perfectly. 

Put all your code in your forked repository.

Submission: Add a new section to your README titled: Milestone #3, which should include
- written description of progress on your project goals. If you haven't hit all your goals, what did you have to cut and why? 
- Detailed output from your generator, images, video, etc.
We'll check your repository for updates. No need to create a new pull request.

Come to class on the due date with a WORKING COPY of your project. We'll be spending time in class critiquing and reviewing your work so far.

## Final submission (due 12/5)
Time to polish! Spen this last week of your project using your generator to produce beautiful output. Add textures, tune parameters, play with colors, play with camera animation. Take the feedback from class critques and use it to take your project to the next level.

Submission:
- Push all your code / files to your repository
- Come to class ready to present your finished project
- Update your README with two sections 
  - final results with images and a live demo if possible
  - post mortem: how did your project go overall? Did you accomplish your goals? Did you have to pivot?

## Topic Suggestions

### Create a generator in Houdini

### A CLASSIC 4K DEMO
- In the spirit of the demo scene, create an animation that fits into a 4k executable that runs in real-time. Feel free to take inspiration from the many existing demos. Focus on efficiency and elegance in your implementation.
- Example: 
  - [cdak by Quite & orange](https://www.youtube.com/watch?v=RCh3Q08HMfs&list=PLA5E2FF8E143DA58C)

### A RE-IMPLEMENTATION
- Take an academic paper or other pre-existing project and implement it, or a portion of it.
- Examples:
  - [2D Wavefunction Collapse Pokémon Town](https://gurtd.github.io/566-final-project/)
  - [3D Wavefunction Collapse Dungeon Generator](https://github.com/whaoran0718/3dDungeonGeneration)
  - [Reaction Diffusion](https://github.com/charlesliwang/Reaction-Diffusion)
  - [WebGL Erosion](https://github.com/LanLou123/Webgl-Erosion)
  - [Particle Waterfall](https://github.com/chloele33/particle-waterfall)
  - [Voxelized Bread](https://github.com/ChiantiYZY/566-final)

### A FORGERY
Taking inspiration from a particular natural phenomenon or distinctive set of visuals, implement a detailed, procedural recreation of that aesthetic. This includes modeling, texturing and object placement within your scene. Does not need to be real-time. Focus on detail and visual accuracy in your implementation.
- Examples:
  - [The Shrines](https://github.com/byumjin/The-Shrines)
  - [Watercolor Shader](https://github.com/gracelgilbert/watercolor-stylization)
  - [Sunset Beach](https://github.com/HanmingZhang/homework-final)
  - [Sky Whales](https://github.com/WanruZhao/CIS566FinalProject)
  - [Snail](https://www.shadertoy.com/view/ld3Gz2)
  - [Journey](https://www.shadertoy.com/view/ldlcRf)
  - [Big Hero 6 Wormhole](https://2.bp.blogspot.com/-R-6AN2cWjwg/VTyIzIQSQfI/AAAAAAAABLA/GC0yzzz4wHw/s1600/big-hero-6-disneyscreencaps.com-10092.jpg)

### A GAME LEVEL
- Like generations of game makers before us, create a game which generates an navigable environment (eg. a roguelike dungeon, platforms) and some sort of goal or conflict (eg. enemy agents to avoid or items to collect). Aim to create an experience that will challenge players and vary noticeably in different playthroughs, whether that means procedural dungeon generation, careful resource management or an interesting AI model. Focus on designing a system that is capable of generating complex challenges and goals.
- Examples:
  - [Rhythm-based Mario Platformer](https://github.com/sgalban/platformer-gen-2D)
  - [Pokémon Ice Puzzle Generator](https://github.com/jwang5675/Ice-Puzzle-Generator)
  - [Abstract Exploratory Game](https://github.com/MauKMu/procedural-final-project)
  - [Tiny Wings](https://github.com/irovira/TinyWings)
  - Spore
  - Dwarf Fortress
  - Minecraft
  - Rogue

### AN ANIMATED ENVIRONMENT / MUSIC VISUALIZER
- Create an environment full of interactive procedural animation. The goal of this project is to create an environment that feels responsive and alive. Whether or not animations are musically-driven, sound should be an important component. Focus on user interactions, motion design and experimental interfaces.
- Examples:
  - [The Darkside](https://github.com/morganherrmann/thedarkside)
  - [Music Visualizer](https://yuruwang.github.io/MusicVisualizer/)
  - [Abstract Mesh Animation](https://github.com/mgriley/cis566_finalproj)
  - [Panoramical](https://www.youtube.com/watch?v=gBTTMNFXHTk)
  - [Bound](https://www.youtube.com/watch?v=aE37l6RvF-c)

### YOUR OWN PROPOSAL
- You are of course welcome to propose your own topic . Regardless of what you choose, you and your team must research your topic and relevant techniques and come up with a detailed plan of execution. You will meet with some subset of the procedural staff before starting implementation for approval.
