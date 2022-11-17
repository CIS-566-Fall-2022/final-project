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

## Week 1 Process
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
