# Final Project!

This is it! The culmination of your procedural graphics experience this semester. For your final project, we'd like to give you the time and space to explore a topic of your choosing. You may choose any topic you please, so long as you vet the topic and scope with an instructor or TA. We've provided some suggestions below. The scope of your project should be roughly 1.5 homework assignments). To help structure your time, we're breaking down the project into 4 milestones:

## Project planning: Design Doc (due 11/9)
Before submitting your first milestone, _you must get your project idea and scope approved by Rachel, Adam or a TA._

### Design Doc
Start off by forking this repository. In your README, write a design doc to outline your project goals and implementation plan. It must include the following sections:

#### Introduction
- What motivates your project?

The motivation behind my project is a greater exploration in the use of SDFs and experimenting with intuitive ways to set up a ui so that user inputs help to create cool variations of a basic cat structure.

#### Goal
- What do you intend to achieve with this project?

I did not feel like I learned enough about how to make SDFs work in the HW so I would like another chance to work with SDFs and understand them better. I would also like to try to implement the proccedural textures we saw on the spore creatures in class. My goal and end result is a proccedural cat generator with changable values to customize the cat. Through this final project my goal is to learn more about the engine built to make this creator work and the learn more about the most intuitive ways to create an interaction between the user and the user inputs to have an end result that looks good.

#### Inspiration/reference:
- You must have some form of reference material for your final project. Your reference may be a research paper, a blog post, some artwork, a video, another class at Penn, etc.  
- Include in your design doc links to and images of your reference material.

My inspiration was the spore character creator and the student work we viewed in class with the bird editor. 

![image](https://user-images.githubusercontent.com/65415823/200924126-3b15fe7e-182e-46b1-b2fd-42beabf21c29.png)
![image](https://user-images.githubusercontent.com/65415823/200924485-fb3785ba-28e3-4040-894d-dfccb4da55cc.png)
![image](https://user-images.githubusercontent.com/65415823/200924599-29b04d14-4832-4cbd-b47b-6020d6630cdf.png)
![image](https://user-images.githubusercontent.com/65415823/200924748-d05e4f6d-cc13-404f-909e-50b4d2708cf5.png)
<img width="728" alt="image" src="https://user-images.githubusercontent.com/65415823/201000111-8361f66f-bf05-4f9c-91c5-518c71603d28.png">

#### Specification:
- Outline the main features of your project.

1) SDF cat creation
2) UI features for manipulation/changing of cat
3) proccedural texture on cat

Extra time features:
skeleton/joint based movement of cat
more proccedural textures including different breeds

#### Techniques:
- What are the main technical/algorithmic tools you’ll be using? Give an overview, citing specific papers/articles.

SDFs and raycasting, proccedural texture using normals and noise like what happens in spore, polishing UI interface 

#### Design:
- How will your program fit together? Make a simple free-body diagram illustrating the pieces.

![Blank diagram](https://user-images.githubusercontent.com/65415823/200922817-34dc0fd0-91b5-4551-971f-a440147ee6fc.png)

#### Timeline:
- Create a week-by-week set of milestones for each person in your group. Make sure you explicitly outline what each group member's duties will be.

Milestone 1: Implement engine for SDFs appearing on the screen. Create a scenegraph type node structure and design the basic cat.

Milestone 2: Convert the cat to SDFs. Add UI options for changing the SDFs that manipulate the form of the cat.

Milestone 3: Add texture and (if time proccedural textures). Catch up on previous milestones. Polish UI and background to make it look nice. (If time add skeleton rigging structure for rigging movement of cat.)

Submit your Design doc as usual via pull request against this repository.
## Milestone 1: Implementation part 1 (due 11/16)
Begin implementing your engine! Don't worry too much about polish or parameter tuning -- this week is about getting together the bulk of your generator implemented. By the end of the week, even if your visuals are crude, the majority of your generator's functionality should be done.

Put all your code in your forked repository.

Submission: Add a new section to your README titled: Milestone #1, which should include
- written description of progress on your project goals. If you haven't hit all your goals, what's giving you trouble?
- Examples of your generators output so far
We'll check your repository for updates. No need to create a new pull request.

Progress: I have created the SDF engine and designed the basic cat SDF using a lot of IQ's SDFs from his website. I decided that I do not think I want to create necessarily a scene graph structure I just want to implement specific ways to change the cat. I also realize that I did not factor in design the basic cat and then figuring out how to change the shape of the SDFs to best work with the sliders for different features so I will probably spend most of milestone 2 doing that.

<img width="536" alt="image" src="https://user-images.githubusercontent.com/65415823/202383928-3086c5f2-d523-44cc-b4cc-fb14a2463eea.png">

![image](https://user-images.githubusercontent.com/65415823/202382209-c93fa4ab-560a-48e8-8458-6c48f9ec5328.png)

## Milestone 3: Implementation part 2 (due 11/28)
We're over halfway there! This week should be about fixing bugs and extending the core of your generator. Make sure by the end of this week _your generator works and is feature complete._ Any core engine features that don't make it in this week should be cut! Don't worry if you haven't managed to exactly hit your goals. We're more interested in seeing proof of your development effort than knowing your planned everything perfectly. 

Put all your code in your forked repository.

Submission: Add a new section to your README titled: Milestone #3, which should include
- written description of progress on your project goals. If you haven't hit all your goals, what did you have to cut and why? 
- Detailed output from your generator, images, video, etc.
We'll check your repository for updates. No need to create a new pull request.

Progress: I implemented one procedural texture that can be expanded upon and implemented the GUI features, that can also be expanded upon, to make the cat editable. Ran into trouble figuringout that the way I implemented it will make it hard to scale anything as a whole so I have to scale individul features. Figured out how to use intersections as a way to mathamatically manipulate the colors to create stripes using positions and patches of color with normals.

<img width="728" alt="image" src="https://user-images.githubusercontent.com/65415823/204440908-f0b7ba7b-7401-4f3a-aa54-c142dde4ef9f.png">

Come to class on the due date with a WORKING COPY of your project. We'll be spending time in class critiquing and reviewing your work so far.

## Final submission (due 12/5)
Time to polish! Spend this last week of your project using your generator to produce beautiful output. Add textures, tune parameters, play with colors, play with camera animation. Take the feedback from class critques and use it to take your project to the next level.

Submission:
- Push all your code / files to your repository
- Come to class ready to present your finished project
- Update your README with two sections 
  - final results with images and a live demo if possible
  - post mortem: how did your project go overall? Did you accomplish your goals? Did you have to pivot?

Final Results:
<img width="329" alt="image" src="https://user-images.githubusercontent.com/65415823/205598033-55168fa3-521c-4bcb-a457-1fb0ea285525.png">
<img width="313" alt="image" src="https://user-images.githubusercontent.com/65415823/205598241-69872ab8-7e3a-4999-ad7c-9138c080749d.png">
<img width="295" alt="image" src="https://user-images.githubusercontent.com/65415823/205598381-3fe11faa-cec9-426e-a008-fdfe67bb84fa.png">
<img width="322" alt="image" src="https://user-images.githubusercontent.com/65415823/205598457-bf7e6f6f-7dff-4934-aa5d-19b954410752.png">
<img width="339" alt="image" src="https://user-images.githubusercontent.com/65415823/205608619-c598b504-ef2c-4835-8d31-0a6b3de924b0.png">

Post Mortem:
Overall, I think my project went ok. Unfortunately, I couldn't do everything I wanted to because I ran into a lot of troubles and bugs. I had to pivot away from size changes and a more realistic model because I was having trouble with the SDFs and time constraints. I ended up with something not as realistic but I did get to play around alot with proccedural texturing. I ended up creating a texture generator for the cat and it worked out pretty well. I would also like to give credit to all the SDF equations I used from IQ's website.

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
