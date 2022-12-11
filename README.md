# Crystal Machine

# Final

![all](https://user-images.githubusercontent.com/3106877/204704575-9249d318-00d1-4dd9-9f2f-883576432abb.png)

I didn't have much time to spend on this milestone (mostly due to upcoming projects in other classes) so this just includes some finshing touches. The two main improvements are procedural bump mapping and coloring on the wood and post-processing on the renders to fix overexposure. Apparently there's a setting in Redshift called "Photographic Exposure" which more or less fixed all the problems with colors burning to white.

I was considering doing some kind of animation but given that each frame took anywhere from around 10 to 20 minutes to render, I decided that would take too long for the amount of time I had.

<details>
  <summary>More pictures</summary>
  <img src="https://user-images.githubusercontent.com/3106877/204704668-0d3536f1-964a-43d1-bf77-2b9d190c05ed.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204704669-5529aa9a-dd4c-4caf-9679-3b8ad11d28cc.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204704671-6580b7ba-a296-4911-b338-74b952b54dab.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204704673-2e4960c9-531f-4770-bff4-1f4e2144063a.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204704675-2b009d4f-6443-4414-be24-e5a479bec73c.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204704676-816db710-31d5-4b40-9e4c-6cfc7fbae47e.png" />
</details>

# Milestone 2

![all](https://user-images.githubusercontent.com/3106877/204164407-87f98304-dd95-4bee-9328-6cfa161a46f5.png)

For this milestone, I mostly focused on making a simple environment to place the crystals in. I used the actual Astro Gallery as reference for the colors and layout of the room, and I added some procedurally oriented lights at the top to give some variation to the lighting and shadows. I also cached some interesting variations of each crystal type to show the project's procedural nature.

I was originally going to add more crystal types in this section of the project but I decided against it due to time constraints. In the final milestone, I may attempt some more variations, but I'm not sure I'll have time for that given some other projects I have going on.

<details>
  <summary>More pictures</summary>
  <img src="https://user-images.githubusercontent.com/3106877/204164447-ca097c64-bc68-42b9-adc7-c4bc26d1e4a5.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204164449-d03b09f0-602b-4c72-94a3-08c41cb31cb2.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204164450-0c4f7cd3-627e-4658-917f-2acf7cde506c.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204164451-c12f424f-40d9-48f7-99fd-04d6edc845dc.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204164454-574c6689-83f8-44dc-8ad0-8bb35fa851da.png" />
  <img src="https://user-images.githubusercontent.com/3106877/204164455-69625011-c52b-421d-a9a2-2f474d3b8564.png" />
</details>

# Milestone 1

I managed to complete 3 different crsytals which I'm pretty happy with. I didn't have time to do the lighting setup, so I'll move that to milestone 2. I think I needed to scale back the project a bit overall, and I definitely will not have time to do the animation. So my end goal now is to add one or two more crystal types and create the museum environment for one or possibly multiple good static renders.

## Deep Sea Quartz

![deep sea quartz](https://user-images.githubusercontent.com/3106877/200666476-0aba34d9-9276-45d1-a872-fb28e6f15834.png)

This isn't necessarily a form of quartz that exists in the real world, but I really like the depth offered by the blue/green colors.

### References

[Entagma tutorial](https://www.youtube.com/watch?v=pq2bYZGurzc)

<details>
  <summary>Pictures</summary>
  <img src="https://user-images.githubusercontent.com/3106877/199603517-bb059dec-a708-46d8-a36b-ad62bf60cc2d.jpg" width="30%" /><br>
  <p>Source: Astro Gallery</p>
  <img src="https://user-images.githubusercontent.com/3106877/200919528-fd448747-ee94-40a3-b240-f21c2621cf8f.png" width="30%" />
  <p>Source: https://kawaiikandi.com/products/clear-quartz-raw-crystal-cluster</p>
</details>

## Vanadinite Cluster

![vanadinite](https://user-images.githubusercontent.com/3106877/201255107-879be63b-8cec-4406-be61-66e291d75a73.png)

### References

<details>
  <summary>Pictures</summary>
  <img src="https://cdn.discordapp.com/attachments/890997576462139412/1039982520059560006/IMG_6075.jpg" width="30%" /><br>
  <p>Source: Astro Gallery</p>
  <img src="https://user-images.githubusercontent.com/3106877/200921338-de4df944-9663-4698-9da7-72314137c5e1.png" width="30%" /><br>
  <p>Source: https://en.wikipedia.org/wiki/Vanadinite#/media/File:Mibladene_Vanadinite.jpg</p>
</details>

## Red Garnet

![red garnet](https://user-images.githubusercontent.com/3106877/201504048-4e441e5a-a9db-464b-9115-88e3daf91d22.png)

### References

[Tutorial](https://www.youtube.com/watch?v=5WSUW7L5Pxo) (which I only somewhat followed)

# Design

## Introduction

Over the fall break, I visited the [Astro Gallery of Gems](https://astrogallery.com/) in New York and was inspired by their extensive collection of gems, minerals, fossils, and more. I knew right then that I wanted to make this my final project - that is, I want to recreate some of my favorite crystals and gems in Houdini. I've already done something like this once for a [daily render](https://www.instagram.com/p/CXhI0pLpYv-/), but this project would be more extensive and more based on real-world crystals.

## Goal

This project's goal is to recreate real-world crystal and rock formations in Houdini, and then to display them in a simple museum-like scene. If I have time, I also want to add a cool animation that pans slowly across a crystal before zooming into the next room with a different crystal (for example, something like [this](https://www.instagram.com/reel/Ce0ypFSpHd9/)).

## Inspiration

My main inspiration is the Astro Gallery's [website](https://astrogallery.com/) as well as some pictures I took when I visited. Some of my favorites include:

<details>
  <summary>Cool pics</summary>
  <img src="https://user-images.githubusercontent.com/3106877/199603517-bb059dec-a708-46d8-a36b-ad62bf60cc2d.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603530-aec18171-aebc-4947-a31b-8ce03b402567.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603532-4c88a704-8cb0-4088-bc75-d8f0b33b0554.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603533-1f28e131-b94f-4d87-a1bb-2e34fe0492ce.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603535-1ff39c1c-d6a1-4fd9-ba4f-3358e195358d.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603537-02ff7607-79ae-41ee-a968-a8229f5229ae.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603540-1454f596-b436-4331-bf1f-472b09f13a4e.jpg" />
  <img src="https://user-images.githubusercontent.com/3106877/199603542-757a40f9-88c7-4dcc-9211-94a09f1391d8.jpg" />
</details>

I haven't yet decided which ones I want to recreate. I'd like to do all of them if I have time but more realistically, I'll have to pick some favorites. I might also pick some from the gallery's website that I didn't see in person.

Additionally, the tutorial I used for the daily render is [here](https://www.youtube.com/watch?v=fVZL1RrGB_A). I'll probably be using some similar techniques to what I learned there, especially the idea of using a pyro simulation to organically "grow" smaller crystals on the main structure.

## Specification

The main features of this project will include:

- A procedural generator for each type of crystal I want to create, with a global seed that can be used to quickly generate new variations
- A museum-like scene that displays hand-picked specimens from each generator
- Possibly an animation to show off all the specimens in one video

## Techniques

Given my experience with making that one daily render with the red crystals, I'm anticipating heavy usage of Houdini's scattering, noise displacement, and mesh/VDB conversion features. For the shaders, Redshift has helpful built-in features like dispersion and caustics that I will use to add realism and artistic flair to the final renders.

For more specifics, I've watched online tutorials by Entagma for previous daily renders, so I'll probably use [this one](https://www.youtube.com/watch?v=pq2bYZGurzc) to help with the structure of the more jagged crystals. There are plenty of other online tutorials as well, such as [this one](https://www.youtube.com/watch?v=f_koHS7Gcnc) and [this one](https://www.youtube.com/watch?v=5WSUW7L5Pxo). I will probably use a couple of these to get the basics down and then branch off on my own for some of the other crystals.

Other useful links:
- https://www.katexagoraris.com/rock-and-minerals-procedural-modeli
- https://80.lv/articles/breakdown-procedural-crystals-in-houdini

## Design

Each crystal will likely be encapsulated on its own, with its own special generation methods and materials. There may be some nodes reused, like basic stone materials and some intersection analysis ideas, but most of the crystals I want to try will be relatively different from each other.

Then, I'll likely pick some of my favorite specimens from each generator and put them into the museum boxes. The museum scene itself will be relatively simple, with a glass box on a pedestal for each specimen. The lighting will probably be the most important part.

![image](https://user-images.githubusercontent.com/3106877/200186345-28550aad-4532-42e3-b22f-a832fd800930.png)

## Timeline

### Milestone 1 (11/16)

At the bare minimum, I'd like to have two crystals done (mesh and shading), as well as a glass display case and a rudimentary lighting system. After thinking about it, I believe it would be better to finish one crystal before moving on to the next, rather than first finishing the meshes and then moving on to the shading. That way, I can adjust the number of crystals I plan on finishing if I find I have more or less time than I expected.

The first couple of crystals will likely be based on online tutorials, and then I'll branch out if I have more time. For the lighting, I'll probably look for pictures and/or videos of the Astro Gallery or other gemstone galleries to find what might work well for the museum.

### Milestone 2 (11/28)

After milestone 1, I'm hoping to implement more crystal generators and have some other interesting specimens to show off. I'll also update the museum scene with more detailed shading and lighting.

Other than that, I may look into more complex features like animating crystal growth. But rather than spending too much time on that, I think I would prefer to work on new types of crystals to explore more procedural generation techniques.

### Final submission (12/5)

The last week will be spent polishing the lighting and shading, mostly. If I have time, I'll also try to set up an animaton that pans over multiple rooms with different kinds of crystals.
