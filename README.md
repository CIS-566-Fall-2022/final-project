# Final Project!

## Design Doc

#### Motivation
The motivation behind my project is a greater exploration in the use of SDFs and experimenting with intuitive ways to set up a ui so that user inputs help to create cool variations of a basic cat structure.

#### Goal
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
- The main features of my project:

1) SDF cat creation
2) UI features for manipulation/changing of cat
3) proccedural texture on cat

Extra time features:
skeleton/joint based movement of cat
more proccedural textures including different breeds

#### Techniques:
- The Main technical/algorithmic tools:
SDFs and raycasting, proccedural texture using normals and noise like what happens in spore, polishing UI interface 

#### Design:
![Blank diagram](https://user-images.githubusercontent.com/65415823/200922817-34dc0fd0-91b5-4551-971f-a440147ee6fc.png)

#### Timeline:
Milestone 1: Implement engine for SDFs appearing on the screen. Create a scenegraph type node structure and design the basic cat.

Milestone 2: Convert the cat to SDFs. Add UI options for changing the SDFs that manipulate the form of the cat.

Milestone 3: Add texture and (if time proccedural textures). Catch up on previous milestones. Polish UI and background to make it look nice. (If time add skeleton rigging structure for rigging movement of cat.)

## Milestone 1: Implementation part 1 (due 11/16)
I have created the SDF engine and designed the basic cat SDF using a lot of IQ's SDFs from his website. I decided that I do not think I want to create necessarily a scene graph structure I just want to implement specific ways to change the cat. I also realize that I did not factor in design the basic cat and then figuring out how to change the shape of the SDFs to best work with the sliders for different features so I will probably spend most of milestone 2 doing that.

<img width="536" alt="image" src="https://user-images.githubusercontent.com/65415823/202383928-3086c5f2-d523-44cc-b4cc-fb14a2463eea.png">

![image](https://user-images.githubusercontent.com/65415823/202382209-c93fa4ab-560a-48e8-8458-6c48f9ec5328.png)

## Milestone 3: Implementation part 2 (due 11/28)
I implemented one procedural texture that can be expanded upon and implemented the GUI features, that can also be expanded upon, to make the cat editable. Ran into trouble figuringout that the way I implemented it will make it hard to scale anything as a whole so I have to scale individul features. Figured out how to use intersections as a way to mathamatically manipulate the colors to create stripes using positions and patches of color with normals.

<img width="728" alt="image" src="https://user-images.githubusercontent.com/65415823/204440908-f0b7ba7b-7401-4f3a-aa54-c142dde4ef9f.png">

## Final submission (due 12/5)
Final Results:
<img width="329" alt="image" src="https://user-images.githubusercontent.com/65415823/205598033-55168fa3-521c-4bcb-a457-1fb0ea285525.png">
<img width="313" alt="image" src="https://user-images.githubusercontent.com/65415823/205598241-69872ab8-7e3a-4999-ad7c-9138c080749d.png">
<img width="295" alt="image" src="https://user-images.githubusercontent.com/65415823/205598381-3fe11faa-cec9-426e-a008-fdfe67bb84fa.png">
<img width="322" alt="image" src="https://user-images.githubusercontent.com/65415823/205598457-bf7e6f6f-7dff-4934-aa5d-19b954410752.png">
<img width="339" alt="image" src="https://user-images.githubusercontent.com/65415823/205608619-c598b504-ef2c-4835-8d31-0a6b3de924b0.png">

Post Mortem:
Overall, I think my project went ok. Unfortunately, I couldn't do everything I wanted to because I ran into a lot of troubles and bugs. I had to pivot away from size changes and a more realistic model because I was having trouble with the SDFs and time constraints. I ended up with something not as realistic but I did get to play around alot with proccedural texturing. I ended up creating a texture generator for the cat and it worked out pretty well. I would also like to give credit to all the SDF equations I used from IQ's website.
