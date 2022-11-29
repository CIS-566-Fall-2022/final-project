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
- Placed tiles on the tower tops! Really happy with how "wonky" and imperfect but still organized they look :) 
- Added bevels to smooth out features like windows and doors
- Applied noise to pillar shapes to make them a little less "CG" looking, which also helps the wood panels because those get projected onto the pillars
- Added noise and remeshing for a "chipped" look on the turrets and pillars

## Example Outputs
<img height="400" alt="TowerExample1_M2" src="https://user-images.githubusercontent.com/25019996/204440005-2c754a03-5a43-47cc-84fe-ec577603c07e.png"><img height="400" alt="TowerExample2_M2" src="https://user-images.githubusercontent.com/25019996/204440008-862cb0ad-5fd5-4a10-ada6-6d364f4009fb.png">

