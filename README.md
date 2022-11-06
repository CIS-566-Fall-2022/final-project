# cool crystals thing

## Design

### Introduction

Over the fall break, I visited the [Astro Gallery of Gems](https://astrogallery.com/) in New York and was inspired by their extensive collection of gems, minerals, fossils, and more. I knew right then that I wanted to make this my final project - that is, I want to recreate some of my favorite crystals and gems in Houdini. I've already done something like this once for a [daily render](https://www.instagram.com/p/CXhI0pLpYv-/), but this project would be more extensive and more based on real-world crystals.

### Goal

This project's goal is to recreate real-world crystal and rock formations in Houdini, and then to display them in a simple museum-like scene. If I have time, I also want to add a cool animation that pans slowly across a crystal before zooming into the next room with a different crystal (for example, something like [this](https://www.instagram.com/reel/Ce0ypFSpHd9/)).

### Inspiration

My main inspiration is the Astro Gallery's [website](https://astrogallery.com/) as well as some pictures I took when I visited. Some of my favorites include:

<details>
  <summary>cool pics</summary>
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

### Specification

The main features of this project will include:

- A procedural generator for each type of crystal I want to create, with a global seed that can be used to quickly generate new variations
- A museum-like scene that displays hand-picked specimens from each generator
- Possibly an animation to show off all the specimens in one video

### Techniques

Given my experience with making that one daily render with the red crystals, I'm anticipating heavy usage of Houdini's scattering, noise displacement, and mesh/VDB conversion features. For the shaders, Redshift has helpful built-in features like dispersion and caustics that I will use to add realism and artistic flair to the final renders.

For more specifics, I've watched online tutorials by Entagma for previous daily renders, so I'll probably use [this one](https://www.youtube.com/watch?v=pq2bYZGurzc) to help with the structure of the more jagged crystals. There are plenty of other online tutorials as well, such as [this one](https://www.youtube.com/watch?v=f_koHS7Gcnc) and [this one](https://www.youtube.com/watch?v=5WSUW7L5Pxo). I will probably use a couple of these to get the basics down and then branch off on my own for some of the other crystals.

Other useful links:
- https://www.katexagoraris.com/rock-and-minerals-procedural-modeli
- https://80.lv/articles/breakdown-procedural-crystals-in-houdini

### Design

Each crystal will likely be encapsulated on its own, with its own special generation methods and materials. There may be some nodes reused, like basic stone materials and some intersection analysis ideas, but most of the crystals I want to try will be relatively different from each other.

Then, I'll likely pick some of my favorite specimens from each generator and put them into the museum boxes. The museum scene itself will be relatively simple, with a glass box on a pedestal for each specimen. The lighting will probably be the most important part.

![image](https://user-images.githubusercontent.com/3106877/200186345-28550aad-4532-42e3-b22f-a832fd800930.png)

### Timeline

#### Milestone 1 (11/16)

At the bare minimum, I'd like to have two crystals done (mesh and shading), as well as a glass display case and a rudimentary lighting system. After thinking about it, I believe it would be better to finish one crystal before moving on to the next, rather than first finishing the meshes and then moving on to the shading. That way, I can adjust the number of crystals I plan on finishing if I find I have more or less time than I expected.

The first couple of crystals will likely be based on online tutorials, and then I'll branch out if I have more time. For the lighting, I'll probably look for pictures and/or videos of the Astro Gallery or other gemstone galleries to find what might work well for the museum.

#### Milestone 2 (11/28)

After milestone 1, I'm hoping to implement more crystal generators and have some other interesting specimens to show off. I'll also update the museum scene with more detailed shading and lighting.

Other than that, I may look into more complex features like animating crystal growth. But rather than spending too much time on that, I think I would prefer to work on new types of crystals to explore more procedural generation techniques.

#### Final submission (12/5)

The last week will be spent polishing the lighting and shading, mostly. If I have time, I'll also try to set up an animaton that pans over multiple rooms with different kinds of crystals.
