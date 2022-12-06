# Design Docs

[Design Doc Version 1](https://elyssac.notion.site/Fantasy-Towers-V1-10d51eabbc1e489194ddc86e53520510)

[Design Doc Version 2](https://www.notion.so/elyssac/Fantasy-Towers-V2-cc04456f23a84bb9b8b155841eff1ce6)

# Milestone 1

## Progress Overview
So far I have implemented most of my generator's core functionality, though the visuals are all just rough temporary block ins. The only major functional element I was not able to implement were custom handles, which I am planning to cut from the project (more info below). 

The functions I implemented are:
- Radio buttons to choose between different layer types (currently three stand in layer types)
- Multiparm menu connected to for loop which enables adding arbitrary numbers of layers
- Very basic shape grammar for placing doors and windows
- Procedural placement data can be saved and loaded into a menu
- Menu parameters can then be tweaked by the user to further tune the generated output

## Milestone Process
I thought the radio button/multiparm setup would be the trickiest part of this tool, so I decided to first try and implement that functionality on a different project I'm currently working on (a pagoda generator) as a test run. I thought this would be a good way to get a fuller sense of how it would work in a more completed project (both from an implementation and a user experience side) because making layered pagodas and layered towers follows the same sort of flow. I'm really glad I did that because I found a couple key takeaways that drastically changed my project:

- There is no built in way to duplicate multiparm instances, so any new instance is set to defaults, which is really annoying to deal with as a user. As a solution for the pagoda tool, I built in a way to save a layer as a JSON and load it back in. This works, but wasn't as smooth a user experience as I hoped and gets cumbersome quickly. However, this was still very valuable because it was the first time I used python for Houdini UI scripts. Understanding how custom button functions could be scripted opened many more possibilities for improving the UI.
- I realized that radio buttons aren't as fully built out in Houdini as other parameter types (no way to copy relative references, strange autmatic channel naming, etc.) and it took a while to find a way around those issues so the radio buttoms could still integrate with the multiparm. 
- Realized that nested multiparms would be extremely confusing for user experience and implementation
- Realized that my original plan for having features be generated per layer and then be able to delete/add feature wasn't very intuitive

So I ended up restructuring my plan for the tool structure to improve user experience and code structure:
| Original User Workflow      | New UserWorkflow |
| ----------- | ----------- |
| Step 1: Create base by choosing layers. Shape grammar generates features for each layer.     | Step 1: Create and tune layers with multiparm       |
| Step 2: Tune layer parameters for each layer (which also affect the random features)     | Step 2: Generate features (for whole tower) with shape grammar, which pre-populates multiparm feature menu      |
| Step 3: Edit grammar output for each layer by deleting generated feature (type in ID). Add hand dressed features in seperate menu.    | Step 3: Edit features multiparm to remove/add/edit features by hand      |

By seperating the layer and features into different steps of the process and streamlining the plan for the UI, I created a far better plan for the tool. This also necessitated re-planning the technical structure of the tool, hence the [new design doc](https://www.notion.so/elyssac/Fantasy-Towers-V2-cc04456f23a84bb9b8b155841eff1ce6).

I then set to work implementing the new plan, which was a bit more challenging than expected but ultimately worked out well. The only major unresolved hitch in the plan was that custom function handles are tricky to implement along with mutliparms because they would need to be dynamically updated to match the multiparm. This introduces some technical issues (resources on dynamically creating an arbitary number of handles are hard to find) and also user interface questions (how to toggle between handles for different layers/features in an intuitive way?). Though on their own custom handles and multiparms are both reasonable to tackle, they are confusing to combine. Because I'm also new to both of them, I decided that figuring out at the same time will be a bit too tricky for this project, so I won't be making custom handles unless I have extra time at the end. The good news is custom handles don't change the main structure of the project, so if I have time then adding them on at the end should be possible. I think this choice will also give memore time to work on a nice polished visual output. 

## Demos
In the folder linked below I have a video demoing the current functionality and a walkthrough of the current network/code (files were too big to upload directly).
https://drive.google.com/drive/folders/1H-OctZ7DNY11PtFCktsheuoef5WzoC8c?usp=sharing

# Milestone 2

## Progress Overview
I now have all of the core functionality completed, and I've continued polishing the existing features/layers and added some additional features/layers. 

The main new things I added are:
- Refactored systems I implemented last week to make then extendable 
- New layer type (supports to go under protruding layers)
- New feature type (wood paneling)
- Continued developing shape grammar for feature placement 
- Polished look of existing features

## Milestone Process
I started by refactoring the systems I created last week (primarily the feature saving/loading process). I made the python functions connected to the button callback and the associated nodes more modular so I could easily reuse functionality when adding new types of features/grammars/etc. This took longer than expected, because when I cleaned up my node network and put things into subnets I caused a lot of problems (usually Houdini audomatically updates connections like the ones in parameter channels, but if there are vex/python references those connections get broken, and I didn't know that so I caused some chaos oops). I'm also pretty new to debugging python modules in Houdini (I've always stuck to nodes/vex in the past), which meant figuring everything out took some time. So while I thought this would be a quick one afternoon task it ended up taking a few days :,) On the plus side, I'm much more comforable with python in Houdini now!

After that I added a new layer type ("supports" for going under protruding pillar and balcony layers). This was fairly simple, but a good sanity check that my layer system was easily extendable, especially because they work a bit different from the other layers (sitting on top of an existing layer, but still affecting the scale of the next layer unlike a "feature")

I then added a new wood paneling feature. The procedural pattern is created by taking a grid lattice, procedurally adding vertical, horizontal and diagonal panels connecting various points on the lattice, projecting those lines onto the main tower shape, and then extruding a shape along those connections to create plank shapes. This was surprisingly very time consuming and finicky to create, but I'm happy with the final result and it allowed me to check that the system I set up for details was robust enough to support many kinds of features. 

The shape grammar for the wood paneling feature was the first one to really take in more detailed context about the tower to inform placement (paneling is randomly placed at divides between pillar layers with height based on the pillars, and then wrapped around the pillar geometry). This opened by eyes to ways the shape grammar for other features could be improved, which I'm excited to explore more for milestone 3. I also tweaked the window shape grammar (ex: windows can no longer appear inside of towers on on the edges of layers).

Lastly, I went through and polished the existing features/layers more. They're not done yet, but I think the new updates add a lot! The main changes are listed below:
- Placed tiles on the tower tops! Really happy with how "wonky" and imperfect but still organized they look :) I plan to add more variations on placement types for milestone 3
- Added bevels to smooth out features like windows and doors
- Applied noise to pillar shapes to make them a little less "CG" looking, which also helps the wood panels because those get projected onto the pillars
- Added noise and remeshing for a "chipped" look on the turrets and pillars

## Example Outputs
<img height="340" alt="TowerExample1_M2" src="https://user-images.githubusercontent.com/25019996/204441589-ee933d83-6b08-44e2-97ee-90aab23ba7cc.png"><img height="340" alt="TowerExample2_M2" src="https://user-images.githubusercontent.com/25019996/204441590-1d6186a6-cb05-4e01-898d-e7ccf92b2f92.png"><img height="340" alt="TowerExample3_M2" src="https://user-images.githubusercontent.com/25019996/204441591-75016043-a8b1-49e8-9eb1-847a94570ccd.png">

# Final Submission!

## Showcase!
Here is my final output! A little showcase of 6 different towers :D
![Towers](https://user-images.githubusercontent.com/25019996/205810067-9b2f3e2a-8136-4cbf-b74b-a25c3f1f7f32.png)

## Progress Overview
In the last week I decided to go for adding more features instead of polishing the existing ones/shading/etc because I wanted to focus on creating a robust tool rather than a single nice render. I'm planning to go back to this over break and add more polish and shade it, but for now I'm happy to say I've achieved all my original goals for the project! 

At the milestone 2 crit the main feedback I got were suggestions for additional features to add more variation, and was advised to focus on ones that would vary the silhouette's of my towers the most, so this is what I prioritized. I ended up adding the following features:
- Secondary towers (additional towers "branching" off the main tower)
- Square balconies with two types of legs
- Finished up circular balconies (which were there but were too ugly to include at milestone 2 lol)
- Cobblestone pillar option
- Brick pillar options
- Spiral staircases
- Variation in roof profiles
- Vines

Some of these features aren't 100% polished and smoothly integrated, but it was super fun throwing on fun extras like the vines! 

## Post Mortem
I think this project went quite well! I was able to implement the skeleton of all core features I wanted to include. However, in order to explore a breadth of things (both breadth of tool making approaches and also breadth of tower features) I sacrificed depth. Given more time (aka what I'll be doing over winter break lol) I'd want to add more polish to the structures I established, particularly:
- I spent a long time working out how to integrate a shape grammar with user editing done post grammar generation, but the shape grammar itself could definitely be expanded
- I'd like to add more options to each feature (different window/door shapes, different kinds of supports, balconies with different amounts of sides etc.)
- And also polish some of the features more (make the vines grow in nice shapes more consistently, add bevels lol theres a lot of hard edges)
- Expose more existing parameters in the menu (this is the part I think fell shortest of where I'd originally hoped, because I ended up throwing in so many bonus features at the end instead of working on the menu)

Overall, even though in some areas I didn't reach the depth I'd hoped, I think it was worth it because I got to touch so many new parts of Houdini (even ones I've been scared of because there aren't a lot of tutorials/resources on them). I'm incredibly excited about the fact that I'm more comfortable incorporating Python, that opens a lot of doors in terms of the user interfaces I can create in the future. I'm also definetly going to re-use the "shape grammar -> user art direction" tool structure I developed for this a lot. 

I think a large reason why this project was pretty successful was because I made such a drastic pivot on how I was approaching the underlying structure of my generator in the first week. That allowed me to hit all my later goals because I had a strong foundation to build on. It definetly scared me that at the end of the first week I didn't have any pretty outputs because I'd spent all my time restructuring my approach, but I reaped the benefits later on. Over the summer I got advice to always try and work "rough to fine" and my little perfectionist brain had a lot of trouble doing that, but now I think I'm finally getting it. I'm pleased that not only was this a good Houdini learning experienced in terms of hard skills, but I also feel more confident in my ability to tackle big projects pretty independently and figure out new parts of Houdini, even in areas that are less well documented online.
