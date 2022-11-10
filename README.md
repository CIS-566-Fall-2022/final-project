# SEE FULL DESIGN DOC HERE: 

https://elyssac.notion.site/Fantasy-Towers-10d51eabbc1e489194ddc86e53520510

I have my full design doc at the link above (had formatting that only works in notion that I wanted to use for my personal planning) but also pasted the text parts below. If possible use the link above instead though (easier to view and includes things the pure markup can't visualize)

# Partial Design Doc

## Introduction
For this project, I plan to make a tool for creating fantasy towers in Houdini. This project is mainly inspired by the piece on the right by Byzwa Dher (link: https://www.artstation.com/artwork/JlXmJa). His piece was actually created by modeling the buildings and terrain in Blender and then painting over them in Photoshop. Watching his Blender process of putting together different pieces following certain patterns, I thought this kind of structure would lend itself well to proceduralism. 

In my past procedural projects, I’ve had success creating completely organic forms (like plant growth, jellyfish, and fire) and very structured human made objects architecture (like a very boxy city lol). I find it more difficult to create things like these towers, which look clearly human made but still have a cluttered and organic look. I love the handcrafted charm of things like this, so these towers really appeal to me.

## Goal

My main goals for this project, in order of priority, are:

1. Create an intuitive user interface with customer viewer handles and multiparam menus
2. Implement a shape grammar-like system in Houdini (which doesn’t have built in shape grammar tools) to generate procedural towers
3. Experiment with different terrain generation techniques to create floating islands

Goal #1 is very exciting to me because I’m trying to expand the techniques I’m comfortable with for creating good tools in Houdini. I’m hoping that becoming comfortable with these two concepts will help me make better tools in the future.

I anticipate goal #2 being pretty tricky, so I probably won’t purely use shape grammars for the towers and instead will use a combination of different techniques, but I’m excited about how shape grammar logic could be used to form tower details. 

Goals #3 is a lower priority for me, so if the other ones take a lot of time I might not get to it (I think thats pretty likely). I think towers with no floating islands would still be pretty cool, so thats okay. However, it would be super cool if I could incorporate some teleological approaches to generate the islands and mountains. I think it would really bring the whole project to the next level and create an immersive environment.

## Reference

Although the main inspiration for my project is the concept art I showed above, I’ve also collected other reference images so I have more to draw on for the project (link: https://www.pinterest.com/elyssasijia/procedural-towers/).

## Design

I plan to use Houdini’s multiparam menus to allow users of the tool to stack together different tower layers. The first image on the right gives a good visual for what I mean by tower layers. 

Within certain tower elements, I will use shape grammar-like logic to guide detail placement. For example, deciding the placement of windows, wood paneling, and cobblestone. 

If I have extra time, I’d love to also include a way for users to hand dress details after generation (but I think its likely I won’t get to this time-wise). I think this would be a great addition to the tool because I very often find myself frustrated with generators when I have a result thats near perfect and just want to make a small tweak, but all I’m able to do it change random seeds until I get an exactly perfect output.

The reason I’m choosing to structure the tool this way is I think it will give the most power to the artist while still letting the generator handle the tedious work. One issue I have with some procedural tools is they generate the overall structure (ex: city layout and building structures, terrain shape) and then let you fine tune details (ex: size/color/number of details on buildings, roughness or scattered details on terrain). But as an artist, its often more important to be able to have control of the broad strokes overall structure, for example, if you’re trying to hit a specific silhouette thats compositionally pleasing. I think by letting the artist be able to specifically art direct the large scale building blocks (tower layers) I’ll avoid this issue.

[procedural towers code diagram 2.pdf](https://github.com/e-chou/fantasy-towers/files/9977257/procedural.towers.code.diagram.2.pdf)

## Specifications

### Tool Functionality

This is a quick overview of what a user’s workflow with the tool would look like:

1. Create base by choosing layers
    1. ex: stone pillar base, radial pattern, rounded turret
2. Tune layer parameters (tune grammar output by modifying or deleted generated details)
    1. ex: cobblestone size and mix with stone, wooden radial pattern with windows, rounded turret tile type
3. Add dressable layer details
    1. ex: door at bottom of stone base, house to the top of the stone base, balcony at radial patterned layer, extra tiny turret on top of rounded turret
4. Tune dressable layer detail parameters
5. Stretch: add inter tower elements to connect multiple towers (I don’t plan to do this for this class, but I want to set up the tool so in the future I can implement it)

### Asset List

So the main assets in the tool can be broken into layers, details, and inter tower elements. Below I have a database of the different assets along with implementation details about them. The different tabs separate the asset types, and you can click on any card to expand details about the asset. It’s easiest to navigate if you open it as a full page. (sorry this doesn't translate out of notion so i can't link it :/)

### Asset References

In this Figma board, I’ve sorted my reference images based on the layers/details they feature to give a sense of what variants I might include and how the layers/details are usually placed relative to each other to inform my shape grammar rule design. (link: https://www.figma.com/file/iXyEyp702M6ql2ZSHOx6v7/Procedural-Towers?node-id=0%3A1)

## Techniques

### Multiparam Menus

#### Plan

I would like to use multiparam menus so the tool doesn’t limit users to a certain number of layers or details. From my research, it looks like a typical workflow would be to:

- Set up a subnet that has a menu with all the paramaters to create one layer
- Add a multiparam menu that created repeated instances of menus that look like the menu needed to create a layer
- Repeatedly run the subnet in a for loop which references the multiparam menu (identifying which instance to use based on iteration number)

#### Resources

[Written tutorial on multiparams in Houdini](https://www.artstation.com/blogs/arjunaravikumar/WEoY/tutorial-using-multiparms-in-houdini) 

[Multiparam tutorial that also covers for-each loops and HDAs for complete beginners](https://www.youtube.com/watch?v=00gF31TMFsw)

[Multiparam copy objects to points](https://www.youtube.com/watch?v=tKhVfZbI8xQ)

[Indie Pixel multiparam video 1](https://www.youtube.com/watch?v=BF3qumCWhUI)

[Indie Pixel multiparam video 2](https://www.youtube.com/watch?v=ApC9b4bR2S4)

### Custom Viewer Handles

#### Plan

I will be using custom viewer handles and states to make my user interface more friendly. From my research, it seems like this doesn’t change the overall tool structure, it requires some extra steps after HDA creation to make the viewer handles and link them to parameters.

I plan to use custom viewer handles for:

- High priority:
    - Layer sizing (handle at the top of layer to scale it up and down (base stays fixed)
    - Layer placement (mainly rotation)
    - Detail placement (click to place, then use rotation and translation handles to move if needed)
- Low priority
    - Detail scale
    - Making sure when layers rotate details rotate with them
    - Detail/layer type specific parameters

#### Resources

[Houdini Documentation on custom viewer states](https://www.sidefx.com/docs/houdini/hom/python_states.html)

[Houdini Documentation on custom viewer handles](https://www.sidefx.com/docs/houdini/hom/python_handles.html)

[Custom viewer state  tutorial (click to add sourcepoints for cables)](https://www.youtube.com/watch?v=6iOGo_xFymw&ab_channel=SimonHoudini)

[Custom viewer state  tutorial (drag over viewport to change parameter value)](https://www.youtube.com/watch?v=isUySmVBUOQ&ab_channel=HoudiniElement)

[Custom viewer state  tutorial (handle for translation and hotkey to toggle)](https://www.youtube.com/watch?v=94G5gD_XJk8&ab_channel=HoudiniElement)

### Shape Grammars

#### Plan

In addition to being able to manually dress details, each layer type will automatically place details using shape grammar like logic. Artists can then stick with the generated output, or add/delete details to tweak the generated output, or disable the generation altogether and hand dress all the details. 

Each layer type will have its own set of shape grammar rules. I’ve outlined the rules in the table below (click cards to expand).

#### References

[Shape grammar class slides](https://cis700-procedural-graphics.github.io/files/shape_grammar_2_7_17.pdf)

Procedural lake village: [demo](https://www.youtube.com/watch?v=EL4pKdahqbI&ab_channel=AnastasiaOpara), [tutorial part 1](https://app.gumroad.com/d/22f47c6ca8a08b3554dc995fe1d2218c) (my all time favorite procedural demo, uses shape grammar like approach ***and*** aesthetically somewhat similar to my goal)

[Article from creator of procedural lake village, mentions more about her procedural approaches](https://80.lv/articles/realistic-procedural-architecture-for-games/)

[Medieval house tool (seems to have a shape grammar-ish system under the hood)](https://www.youtube.com/watch?v=gmYvA05orbs&ab_channel=BenjaminYde)

[Medieval tower tool (less shape grammar related)](https://www.youtube.com/watch?v=8OfgF6qBQ_s&ab_channel=Pepi)

### Terrain Generation

#### Plan

I probably won’t get to this part, but I’d like to use Houdini’s heightfield features to generate floating islands for the towers to sit on. I would also like to incorporate some other procedural modeling techniques to add rocky features to the terrain. 

#### Resources

********************Heightfield Terrain********************

[20 minute height field tutorial](https://www.youtube.com/watch?v=iogVyO_nK6g&ab_channel=AdrienLambert)

[Terrain series 1/4](https://www.youtube.com/watch?v=2njl4R0oV1M&ab_channel=AdrienLambert)

[Terrain series 2/4](https://www.youtube.com/watch?v=Q9VEvnUruwY&ab_channel=AdrienLambert)

[Terrain series 3/4](https://www.youtube.com/watch?v=vioCnci12FI&ab_channel=AdrienLambert)

[Terrain series 4/4](https://www.youtube.com/watch?v=ZlVPY6lpAs8&ab_channel=AdrienLambert)

********Rocks********

[Procedural cliffs 1](https://www.youtube.com/watch?v=E8WujQ8EPWM&ab_channel=BizarreSelf-Production)

[Procedural cliffs 2](https://www.youtube.com/watch?v=L9YoExpA0Gw&ab_channel=SimonHoudini)

[Layered rocks](https://www.youtube.com/watch?v=dRidiaXGYrk&ab_channel=RenderEverything)

[General rocks](https://www.youtube.com/watch?v=fxOxygaEOFk&ab_channel=SimonHoudini)

## Project Scoping

sorry this section doesn't translate out of notion well :/

## Timeline

![IMG_0973 copy](https://user-images.githubusercontent.com/25019996/200999466-91197468-8062-4dd9-89b4-87ad17ff3d13.jpg)

also an actual timeline in notion that doesn't export out

# Final Project!

This is it! The culmination of your procedural graphics experience this semester. For your final project, we'd like to give you the time and space to explore a topic of your choosing. You may choose any topic you please, so long as you vet the topic and scope with an instructor or TA. We've provided some suggestions below. The scope of your project should be roughly 1.5 homework assignments). To help structure your time, we're breaking down the project into 4 milestones:

## Project planning: Design Doc (due 11/9)
Before submitting your first milestone, _you must get your project idea and scope approved by Rachel, Adam or a TA._

### Design Doc
Start off by forking this repository. In your README, write a design doc to outline your project goals and implementation plan. It must include the following sections:

#### Introduction
- What motivates your project?

#### Goal
- What do you intend to achieve with this project?

#### Inspiration/reference:
- You must have some form of reference material for your final project. Your reference may be a research paper, a blog post, some artwork, a video, another class at Penn, etc.  
- Include in your design doc links to and images of your reference material.

#### Specification:
- Outline the main features of your project.

#### Techniques:
- What are the main technical/algorithmic tools you’ll be using? Give an overview, citing specific papers/articles.

#### Design:
- How will your program fit together? Make a simple free-body diagram illustrating the pieces.

#### Timeline:
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
