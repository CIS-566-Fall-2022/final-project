# Fantasy Map Generator

**University of Pennsylvania CIS 566 Fall 2022, Final Project**
* Megan Reddy, Nick Moon, and Sakshi Rathore

## About

Many fantasy books, movies, and games include a hand-drawn map describing the features of the fictional world. The art style is often influenced by historic medieval cartographic practices and the author's own vision. Our tool is inspired by such maps. For this project our main goal was to develop a tool for visualizing and creating these maps procedurally. Our tool allows users to envision their own world by defining key landmarks and autogenerating the rest of the world automatically in a way that is stylistically and artistically cohesive and similar to these much beloved fantasy maps.

This tool is implemented in Unity 3D. You can try our tool [here](https://play.unity.com/mg/other/webglbuild2-12)!

Additionally, you can view our presentation slide deck [here](https://docs.google.com/presentation/d/17e4OC9rP3iqA-bK-BJn6z4du41TK7l12LN6roV2ZG8c/edit?usp=sharing).

## Results

<img src="/img/project_gif.gif">
<img width="839" height="418" src="/img/hatching.PNG">
<img width="839" height="418" src="/img/djtyjdty.PNG">

## Design Document

<details>
  <summary>Introduction</summary>
Many fantasy books, movies, and games include a hand-drawn map describing the features of the fictional world. The art style is often influenced by historic medieval cartographic practices and the author's own vision. We would like to develop a tool for visualizing and creating these maps procedurally. We want to allow users to be able to envision their own world by defining key landmarks and autogenerating the rest of the world automatically in a way that is stylistically and artistically cohesive and similar to these much beloved fantasy maps.
</details>

<details>
  <summary>Goals</summary>
We intend to produce a 2D hexagonal fantasy map generator using Wave Function Collapse in the Unity game engine. We plan to render our procedurally generated map data in the style of the references below.
</details>

<details>
  <summary>Inspiration/Reference</summary>
<br>
<details>
  <summary>Fantasy Map Reference Images</summary>
  
  ![mistborn_greyscale](https://user-images.githubusercontent.com/43520504/200185466-631fa337-4e37-46a8-90e8-587224125730.jpg)

  [Mistborn Map](https://www.deviantart.com/mapeffects/art/Mistborn-The-Final-Empire-Map-Brandon-Sanderson-907741466)

  ![lotr_map](https://user-images.githubusercontent.com/43520504/200185526-67683e39-83b9-4daa-bfd2-70f2a17cb18e.jpg)

  [Lord of the Rings Map](https://i.ebayimg.com/images/g/05MAAOSws9dfjJnE/s-l1600.jpg) 

  ![narniamap](https://user-images.githubusercontent.com/43520504/200185636-b325b0bd-319d-4acb-a030-ee172c081eef.jpg)

  [Narnia Map](https://m.media-amazon.com/images/I/91F8R4qQHML.jpg)

  ![landandsea](https://user-images.githubusercontent.com/43520504/200185530-1856d75e-7f1a-4d29-b72a-c06fbbf1adf4.jpg)

  [Land and Sea Board Game](https://www.theboardgamefamily.com/wp-content/uploads/2021/09/20210923_172855.jpg)
</details>

<details>
  <summary>Fantasy Map Generators</summary>
  
  <img width="775" alt="inkarnate" src="https://user-images.githubusercontent.com/43520504/200187904-54a2d224-854f-4b9d-ac64-374e3461be02.PNG">

  [Inkarnate Fantasy Map Creator](https://inkarnate.com/)

  <img width="1280" alt="azgaar" src="https://user-images.githubusercontent.com/43520504/200187977-09de9537-ee70-48bf-bfeb-5bf88cb301ae.PNG">

  [Azgaar's Fantasy Map Generator](https://azgaar.github.io/Fantasy-Map-Generator/)

  <img width="1170" alt="rollforfantasy" src="https://user-images.githubusercontent.com/43520504/200188159-2223faca-f2ce-4088-9382-e23b5abe791c.PNG">

  [Roll For Fantasy Randomized Tile-based Map Generator](https://rollforfantasy.com/tools/map-creator.php)
</details>
</details>


<details>
  <summary>Specification</summary>
  <ul>
    <li>2D Wave Function Collapse: Implementation of the Wave Function Collapse algorithm</li>
    <li>Hexagonal Tiles: Use hexagonal tiles for the WFC map generation</li>
    <li>Non-photorealistic Rendering: Rendering of assets using shaders that provide features like cross-hatching, paint splotches, and outline generation</li>
    <li>Interactivity: Manual seed placement or autoregeneration of map</li>
  </ul>
</details>

<details>
  <summary>Techniques</summary>
    <ul>
      <li>2D Hexagonal Grid made up of 6-sided tiles with a map terrain feature type on each edge of a tile. Each tile has a color mask that defines the feature types that can occupy the tile over its domain.</li>
      <li>Wave Function Collapse to place tiles in the grid based on rules that define what tiles edges can be placed together (i.e. we will only connect two tiles if the neighboring edge is the same feature type like water).</li>
      <li>For rendering, we plan to use common NPR concepts such as cross-hatching, paint splotches, and outline generation. We will most likely write these as Unity shaders. Additionally, we may add post-process render passes for adding rivers, roads, labels, compass, torn edges, and sea monsters.</li>
      <li>Unity built-in modules for cursor-based selection and GUI rendering</li>
  </ul>
</details>

<details>
  <summary>Design</summary>
<img width="482" alt="PG Project Flow Diagram" src="https://user-images.githubusercontent.com/90112787/200188201-6eef1f37-ee3b-49e3-89b8-66b1a7b93501.png">
</details>

<details>
  <summary>Timeline</summary>
<h4>Milestone 1:</h4>
<ul>
  <li>Everyone</li>
    <ul>
      <li>Learn Unity scripting and shading</li>
      <li>Understand and design approach to Wave Function Collapse Algorithm</li>
    </ul>
  <li>Nick & Sakshi</li>
    <ul>
      <li>Basic Asset Creation (i.e. basic combination of sea, shore, and land tiles)</li>
      <li>Creation of hexagonal grid and tiles</li>
      <li>2D Hexagonal Wave Function Collapse development</li>
    </ul>
  <li>Megan</li>
    <ul>
      <li>Shade based on color map from 2D hexagonal tiles in Unity</li>
      <li>Initial prototype of NPR post-process techniques in Unity</li>
      <li>Research and prototype how to represent advanced features on tiles (mountains, forests, etc.)</li>
    </ul>
</ul>

<h4>Milestone 2:</h4>
<ul>
  <li>Everyone</li>
    <ul>
      <li>Polish leftover features from the previous milestone</li>
      <li>Asset creation and polish (more advanced terrain and sea features such as mountain ranges, forests, lakes, castles, etc.)</li>
    </ul>
  <li>Nick</li>
    <ul>
      <li>More post-processing filters (roads, rivers, labels, compass, etc.)</li>
    </ul>
  <li>Sakshi</li>
    <ul>
      <li>UI features and tooling - clear canvas, regeneration of map, and inventory to select tiles</li>
    </ul>
  <li>Megan</li>
    <ul>
      <li>Continue working on shaders for extra features (mountains, forests, lakes, antique painterly look, etc.)</li>
    </ul>
  <li>If time permits</li>
    <ul>
      <li>Inifinite map generation :O</li>
      <li>Extra shader types (e.g. Lord of the Rings or Narnia style)</li>
    </ul>
</ul>

<h4>Final Submission:</h4>
<ul>
  <li>Everyone</li>
    <ul>
      <li>Polish leftover features from the previous milestones</li>
      <li>Polish assets and add any extra visual features</li>
      <li>Finish UI</li>
      <li>Look into ways to publish project online (live demo)</li>
      <li>Finalize README and presentation</li>
    </ul>
</ul>
</details>

## Milestone 1

#### Progress & Outputs

<details>
  <summary><b>Basic assets</b></summary>
  <p>We started the project with basic assets that are hexagonal textures. Any edge of a tile may be associated with just one feature. Each feature on a tile is identifiable by a color. The idea is that these textures define the space that any feature encompasses on a tile, and not the end look( which would be achieved in post-processing).
  <br>Initially we had just 2 features - land & water. There are tiles for each feature with all edges belonging to that same feature, and there are 5 tiles for any 2 features that interface with eachother. Later on we added mountains (as you will see below). We ended up with 13 tiles in all. <br>
  3 features - land(green), water(blue), mountains(brown)</p>
  <img src="/img/basic_assets.png">
</details>

<details>
  <summary><b>Hexagonal Grid and Tiles</b></summary>
  
  <p><b>Tile</b><br>
  A Tile is a pointed hexagon prefab that has a texture applied to it. Every Tile stores the edge map specific to that tile. An edge map stores which feature each edge maps to and is generated procedurally at run time using texture lookup.</p>
  
  <p><b>Cell</b><br>
  A Cell is a placeholder for a Tile in the grid. A Cell also stores information to aid the Wave Function Collapse algorithm such as, whether the cell collasped, list of compatible tiles that could fill the cell, index of the cell in the grid, etc.</p>
  
  <p><b>Grid</b><br>
  We setup a grid in Unity composed of Cells. Every other row of Cells is offset in order to properly tesselate the hexagon grid pattern. The grid also holds values used in the Wave Function Collapse algorithm like, number of cells collapsed and functions that access or modify multiple cells.</p>
  
  <p>Creating a grid and filling it with random tiles</p>
  <img src="/img/step1.PNG">
  
  <p>
    Some references we used: 
    <a href="https://catlikecoding.com/unity/tutorials/hex-map/part-1/">Catlike Coding Hex Grid</a>, 
    <a href="https://www.redblobgames.com/grids/hexagons/">Red Blob Games Hexagonal Grid</a>
  </p>
</details>

<details>
  <summary><b>Wave Function Collapse</b></summary>
  
  <p><h3>Some terminology</h3>
  <b>Entropy</b>: Entropy of a cell is the total number of tiles that could be placed in the cell, while maintaining the neighboring cells' constraints. The available tiles start as all the tiles. As cells collapse, the entropy starts to decrease and incompatible tiles are removed from the available tiles list.
  <br><br><b>Collapse</b>: A cell is collapsed if it contains an instance of a tile. The goal is to collapse all cells. Thus, once a cell is collapsed, its entropy is set to a very large value so that it does not impact the search for cells with minimum entropy.
  <br><br><b>Propagate Entropy</b>: This happens after a cell collapses. As part of propagate, we update the avaiable tiles list for each neighboring cell of the collapsed cell. Once the tile list is updated, the cell's entropy is updated to the size of the tile list.
  </p>
  
  <p><h3>Wave Function Collapse Steps</h3>
  <b>Generate Seeds</b><br>
  We start with placing random seeds on the grid, i.e. collapse some random cells with random tiles. Then we propogate the entropy from the seeds.</p>
  <p><b>Main loop</b>
  <br>- Get cells with minimun entropy.
  <br>- For each of those cells, pick a random tile from the list of available compatible tiles.
  <br>- Collpase the cell with the picked tile.
  <br>- Propagate entropy accross the grid.
  <br>- Break if all cells are collapsed.
  </p>
  
  <p>This is a grid filled with the inital 7 tiles using the Wave Function Collapse Algorithm. Number of seeds = 5</p>
  <img src="/img/step2.PNG">
  
  <br><p>This output is after we added procedural rotation to the 7 inital tiles (resulting in 42 total tiles). Number of seeds = 10</p>
  <img src="/img/step3.PNG">
  
  <br><p>We wanted to extend the implementation to more features, so we introduced mountain tiles. For this we just added 7 new textures and prefabs, and a new feature color value in the lookup.</p>
  <img src="/img/step4.PNG">
  
  <p><h3>Observations & Next steps</h3></p>
  <p>During this process we noticed some holes appearing in our output. Upon analysis we noticed the following 2 possible enhacements to get rid of these artifacts:
  <br>- Added more assets for special cases like rivers, etc.
  <br>- Adding backtracking to our WFC implementation to avoid a case where a cell has no possible tile it could pick.
  </p>
  
  <p>Another feature step we would like to implement is adding probability to our features & tiles. We noticed the output right now is more or less a uniform distribution of each feature. As this is undesireable for the look we want, adding varied probability should help us get larger landmasses and oceans.</p>
</details>

<details>
  <summary><b>Rendering Prototype</b></summary>
  <br><p>The rendering work for this milestone can be found in the "Milestone_1_Rendering" branch. The basic rendering process consists of three passes to get the desired output. Although the order of these passes may change, the current sequence is:
  <br>
  <br>1. Color pass
  <br>2. Asset pass
  <br>3. Edge/Outline pass
  <br>
  <br>The Wave Function Collapse algorithm will output a grid with colored hexagonal tiles. Each color serves as an ID representing distinct terrain features such as land, water, mountains, forests, etc. The color pass will take these ID colors and map them to the desired output color for that feature. The asset pass will scatter assets in designated areas according to color (e.g. a brown area indicates mountains in which several mountains will be scattered). The outline pass will draw outlines around each feature. </p>
  <details>
    <summary><b>Unity Setup</b></summary>
    <br>
    <p><b>Step 1.</b> Create basic grid setup and camera for rendering</p>
    <p>I started by creating a new Unity project so that I could test out rendering techniques without affecting the main Wave Function Collapse project. Using the basic assets (tiles) we created, I manually placed and constructed a hexagon grid for testing the post-process effects. Since the post-process effects would operate on a camera, I created a new Orthographic camera called "Top Down Camera" so that I could attach any scripts and shaders I made to it.</p>
    <img src="/img/unity_camera_setup.PNG">
    <br>
    <br>
    <p><b>Step 2.</b> Create post-process script and setup color pass shader</p>
    <p>In order to apply a post-process effect to the camera image, I needed a script that would tell the camera to pass the output image through a shader before rendering the result to the screen. To do this, I made a very simple script that sends the camera output to a shader, and then sends the result to the screen. To see if this worked, I created a new shader that would take the base color of the tiles and apply FBM to it.</p>
    <img src="/img/unity_color_pass_only.PNG">
    <br>
    <br>
    <p><b>Step 3.</b> Create edge/outline shader</p>
    <p>Now that one shader was setup, I added another shader to test outlines. I created a basic Sobel filter that would create outlines based on color differences within an image.</p>
    <img src="/img/unity_edge_pass_only.PNG">
    <br>
    <br>
    <p><b>Step 4.</b> Execute both shaders at the same time</p>
    <p>After I got each individual shader working, I tested them together. Each shader is executed sequentially and uses the output of the previous shader as its input. In this case, the output of the color pass will be used as the input to the edge pass. This was a critical step because our pipeline depends on the ability to execute multiple passes at once. The look of the Unity shaders will be refined more in the following milestone, but the infrastructure is in place to handle multiple effects at once.</p>
    <img src="/img/unity_prototype.PNG">
  </details>
  <details>
    <summary><b>Shadertoy Prototype</b></summary>
    <br><p>I made a Shadertoy prototype to further experiment with different looks and algorithms without worrying about the Unity shader interface. I mimicked the shader pipeline that I had setup by using different Buffers. The shader can be viewed <a href="https://www.shadertoy.com/view/ddj3Wd">here</a>.</p>
    <br>
    <br>
    <p><b>Step 1.</b> Color output from Wave Function Collapse</p>
    <p>Buffer A outputs a possible result from the Wave Function Collapse algorithm. In our setup, green areas are land, blue areas are sea, and brown areas are mountains. The brown areas are not meant to show up in the final rendering; they are simply a mask to indicate where we should scatter mountain assets.</p>
    <img src="/img/wfc_color_map.PNG">
    <br>
    <br>
    <p><b>Step 2.</b> Grid pass</p>
    <p>In order to randomly place assets within an area, I first split the screen into a uniform grid using fract(GRID_SIZE * uv). I used an approach similar to stratified sampling in path tracing and to the grid layout described in <a href="https://www.youtube.com/watch?v=rvDo9LvfoVE">this Art of Code tutorial</a>. Modifying the grid size will control the density of assets placed in the masked areas.</p>
    <img src="/img/uniform_grid.PNG">
    <br>
    <br>
    <p><b>Step 3.</b> Uniformly sample grid</p>
    <p>To start, I placed one sample in the center of each grid cell. Each of the circles is an SDF, which I am planning to use to procedurally draw the assets for the next milestone.</p>
    <img src="/img/uniform_sampling.PNG">   
    <br>
    <br>
    <p><b>Step 4.</b> Stratified sampling of grid</p>
    <p>Instead of placing the sample in the cell center, I jittered the position using a 1D noise function to create a more organic look.</p>
    <img src="/img/stratified_sampling.PNG"> 
    <br><p>Here is the same result without the grid lines:</p>
    <img src="/img/sample_placement_no_grid.PNG">
    <br>
    <br>
    <p><b>Step 5.</b> Constrain to masked areas</p>
    <p>Now that the samples were randomly placed, I needed to constrain them to the desired areas. I have implemented the naive way of doing this, which simply looks at the base color, decides whether or not it matches the mask color, and places a circle SDF there if it does. I am trying to figure out a more advanced way of doing this, since it cuts off portions of the SDF that lie outside of the mask. The desired output would finish drawing those pieces, even if they are out of bounds. My first solution was to iterate through each cell's neighbors and add the SDF contribution from the neighboring cells. This worked, but when I added the mask back in, the cutoff problem persisted.</p>
    <img src="/img/constrained_asset_placement.PNG">
    <br>
    <br>
    <p><b>Step 6.</b> Coloring and outlines</p>
    <p>Here are some example outputs with more interesting coloring and outlines. The color and outline passes are the same as the ones in Unity. The main difference is that this outline pass operates on a greyscale version of the image, to create black outlines instead of colored outlines. 

In the next milestone, these circles will be replaced with more advanced assets and shapes that represent actual terrain features.</p>
    <img src="/img/color_map_asset_mask.PNG">
    <img src="/img/colored_map_no_mask.PNG">
  </details>
  
  <p><b>Observations & Next steps</b></p>
  <p>For the next milestone, I will first focus on porting the Shadertoy prototype to my Unity setup. Then, I will work on refining each of the post-process effects and asset drawings. This includes creating SDFs for mountains, forests, and a compass, as well as refining the color and edge passes to include more effects from our reference images. Some effects I hope to incorporate are the burnt-edge look, the hatching next to coastlines, and an erosion effect to create a smudged/painterly paper look. 
  </p>
</details>



## Milestone 2

#### Progress & Outputs

<details>
  <summary><b>Assets</b></summary>
  <br><p>In this milestone we added another feature for forests, which interfaces with the land feature only (much like the mountain feature).
  <br>We also changed the colors we used for our textures to use colors that were as distinct from each other as possible, to avoid artifacts in the post-process rendering steps.
  <br>4 features - land(green), water(blue), mountains(red), forests(yellow)
  <br>(Sakshi)</p>
  <br><img src="/img/basic_assets_2.png">
</details>

<details>
  <summary><b>Wave Function Collapse</b></summary>
  <details>
    <summary>Backtracking (Nick & Sakshi)</summary>
    <br><p>As mentioned in the observations and outputs of Milestone 1, we were seeing some scenarios where we end up with holes. To avoid this, we implemented a simple backtracking method that checks ahead for one level of propagation before making a decision. This method seems to works for majority of the scenarios.</p>

  <p><b>WFC logic with backtracking:</b>
  <br>- Get cells with minimun entropy.
  <br>- For each of those cells, pick a random tile from the list of available compatible tiles.
  <br>- <b>Before collapsing the cell, check if using the picked tile will make any of the neighboring cells' entropy 0</b>.
  <br>- If yes, pick a different random tile from the list of available compatible tiles.
  <br>- If no, collpase the cell with the picked tile.
  <br>- Propagate entropy accross the grid.
  <br>- Break if all cells are collapsed or if we've retried picking a random tile a certain number of times.
  </p>

  <p>Output with backtracking, 4 features and randomly generated seeds. Number of seeds = 5</p>
  <img src="/img/step7.png">

  <p><h3>Observations & Next steps</h3></p>
  <p>Our current backtracking solution still doesn't solve all problems and we do sometimes end up with an uncollapsable grid. This happens in situations where there is a need for a tile that does not exist (e.g., a tile with both mountain and forest edges). We do not intend to fix this by adding the "missing" tile assets, as we do not want to such interfacing between features to exist on the map.
    <br>We plan to use a brute force solution to get by this issue, for example - placing a tile (that may not match the constraints) to update the entropy of the grid so that the WFC can resume to collapse the whole grid.
  </p> 
  </details>
  <details>
    <summary>Tile Weighting (Nick & Sakshi)</summary>
    <br><p>One big addition to the Wave Function Collapse made for this milestone was a tile weighting system. Now, each tile is assigned a weight, integer value greater that 0, and that weight is used when determing which tile to pick of the available tiles while collapsing a cell. For example, if all tiles default to weight 1, and the 6 sided land tile is given weight 100, then that will be 100x more likely to be picked as a tile to collapse into during the WFC loop. The way a tile is picked now utilizes an algorithm to the lottery scheduling algorithm taught in OS classes, where a total weight of all available tiles is computed, an rng number is generated in the range 0 to the total weight, and the tiles are looped over, adding their weight to the accumulated sum. If the addition for a tile causes the accumulated sum to go over or equal the random number, then the tile is picked. This ensures that tiles with more weights will have appropriately a higher chance of being picked.
    </p>
    
  Coastline tiles have a much higher weight that the rest of the tiles:
  <img src="/img/weight_3.PNG">

  A large river or sea is generated with high weighting for 6-sided land and ocean tiles: 
  <img src="/img/weight_0.PNG">

  Island map is generated giving really high weighting to 6-sided land and ocean tiles:
  <img src="/img/weight_1.PNG">

  Plausible looking coastline is generated giving really high weighting to 6-sided land, ocean, mountain, forest tiles:
  <img src="/img/weight_2.PNG">
    
  </details>
</details>

<details>
  <summary><b>User Interface</b></summary>
  <details>
    <summary>Placing seeds (Sakshi)</summary>
  <br><p>To add some interactivity, we let the user place tiles as seeds for the WFC. The user can use the mouse by <b>clicking & draging</b> to populate the grid cells with tiles of any of the 4 features. The user can cycle through the tiles by clicking on the active seed tile preview on the upper right corner or by pressing <b>tab</b> on the keyboard.
  <br>Once the user is satisfied with the seed placements, they can start the WFC by pressing <b>enter</b> on the keyboard.</p>
  
https://user-images.githubusercontent.com/90112787/204433411-c4f9f59a-9365-4ccc-abc7-859f3f20c5d6.mov

  </details> 
  <details>
    <summary>Restart and Clear Buttons (Nick)</summary>
    
  <br><p>Buttons were added in this milestone as GUI elements for the tool. These are made using the UIDocument Unity feature, and expose two functions to the user: Restart and Clear. Clear empties the wave function collapse and grid, and thus results in a blank screen that the user can then paint different seeds onto. The Restart button restarts the wave function collapse algorithm with the same seeds, but due to the RNG nature of the algorithm and the possible tiles to place, generates a new board. Alternatively, if no seeds have been manually placed by the user, the button instead also regenerates the seeds randomly each button press.</p>
    
    
  The "Restart" and "Clear" buttons used in the Game mode:
  <img src="/img/buttons.PNG">

  The UI Document viewer and editor inside Unity:
  <img src="/img/uidocument.PNG">
    
  </details> 
</details>

<details>
  <summary><b>Rendering Updates</b></summary>
  <br><p>This milestone, we worked on porting the first milestone's Shadertoy work to Unity, polishing the color and edge post-processes, and working on asset placement and rendering.
  <p><h4>Porting to Unity (Megan)</h4>
  During the first milestone, I made a Shadertoy protoype to test how each post-process pass would interact with each other. The shader can be viewed <a href="https://www.shadertoy.com/view/ddj3Wd">here</a>. Once this was finished, I integrated it into the basic Unity shader setup I had created for Milestone 1. After integration, the initial result looked like this: </p>
  <img src="/img/step6.PNG">
  <br><p>The color matching was quite off in the initial run. In order to assign a color to a fragment, I checked to see how similar the fragment color was (by using a distance metric) to each feature color (light green, light blue, brown, and dark green). If it matched, then I would assign the appropriate map color to that fragment. Since I was using a distance metric, some fragments matched to multiple colors since the mathematical distance could be close even if they were visually different. To fix this, we made the Wave Function Collapse tile colors drastically different (red, yellow, green, blue) so that they would not overlap much when using the distance metric. This made the result a lot cleaner: </p>
  <img src="/img/after_color_id.PNG">
  <br><p>Another minor detail I fixed was the screen-space coordinate calculation in the shaders. Beforehand, the uv calculation was causing the objects to look "stretched" onscreen.</p>
  <img src="/img/uv_stretching.PNG">
  <p>Here is the result after the fix:</p>
  <img src="/img/uv_no_stretching.PNG">
  <p><h4>Color and Edge Post-Process Polish (Megan)</h4>
  Most of the core functionality of these shaders was in place during Milestone 1, however, there are a couple of key updates that I made to the look. The largest update was the tile color and ID matching described above, which helped make the render much cleaner. The second is that the edge post-process skips any areas that are designated as "mountain" or "forest" since we do not want these areas to be demarcated. Unfortunately, there is still a thin outline at the boundaries of these areas since it is hard to properly detect the fragment's color ID at transition zones. </p>
  <p><h4>Asset Placement and Mountain Rendering (Megan)</h4>
  The last area I worked on was updates to the asset placement and mountain rendering. The main issue I saw from Milestone 1 was that assets were being cut off when they went outside of the masked area. There were two solutions I thought of to this problem: cull the mountains that were too close to the edges or continue drawing outside of the boundaries. For the first approach, I did another edge pass to determine the boundaries of the masked areas, then culled all the assets that were within some distance from the boundary. Unfortunately, this still led to some assets being cut off. For the second solution, I attempted to take each local random grid cell point I was drawing at and convert it to a global coordinate relative to the bounds of the screen. If the point fell within the mask, I would draw an asset at that global point. This worked to some extent, but there are still some bugs I have to resolve. Therefore, I left the current scheme as is (with the cut offs) until I work out a better solution. </p>
  For the mountain asset, I created a new Shadertoy to test out the look and placement. The body of the mountain is an equilateral triangle centered at a point p. The center point p will be the global coordinate described above. Once we know p, we can calculate the distance to each vertex, which we can use to find vertices A, B, and C of the triangle. All fragments that lie to the left of p.x are in shadow, whereas fragments that are to the right of p.x are illuminated. To create the central ridge, I added a slight sine-wave jitter to p.x. I noticed that points closer to the ridge are more in shadow than points farther away, so I added a gradient from right to left on the shadowed part of the ridge. The outlines on the top two edges of the triangle are created with line segment SDFs from Inigo Quilez. The Shadertoy can be viewed <a href="https://www.shadertoy.com/view/dsfSzB">here</a>.</p>
  Shadertoy prototype:
  <br><img src="/img/mountain_prototype.PNG">
    
  Unity render:
    <img src="/img/mountains_unity.PNG">
  <p><h4>Forest Rendering (Nick)</h4>
  <p>Forest assets were prototyped in ShaderToy, based off the mountain asset creation file. The trees are made using the egg sdf and the uneven capsule sdf from Inigo Quilez. The outline of the trees is generated based on the value of the sdf within the negative value space of the function: if a position has a negative value above a threshold, it is made a dark grey color. Otherwise, if the SDF value is negative and not an outline case, the trees have a hard-coded shading based on the x value of the position. Positions on the right relative to the center position of the SDF inherit the background color, while positions on the left gradually fade to dark grey based on distance from the center.</p>
  ShaderToy prototype of the tree assets:
  <img src="/img/forest.PNG">

  The tree assets used in Unity on the map where the forest tiles are.
  <img src="/img/trees.PNG">

</details>

## Final Submission

<details>
  <summary><b>Bug Fixes</b></summary>
  Some of the bugs we fixed in this milestone are:
  <ul>
    <li><b>Asset cutoff issue:</b> <br>Previously, assets were being cutoff at mark boundaries. To fix this issue, we changed the calculation of the asset position and added an extra check to ensure that the center point of the asset is contained within the mask. With these additions, the assets that go beyond the boundary edge are fully drawn.</li>
    <li><b>Seed generation accounts for tile weights:</b> <br>Earlier, the seeds were being picked randomly from the processed list of tile prefabs. This did not account for the weights associated with the tile. The weighting system affected only the tile selection in the WFC logic. Now, we account of the weights of the tile when picking input seeds for WFC as well. </li>
    <li><b>Issues with Clear button:</b> <br>We fixed a bug that did not clear all the seed tiles placed by the user manually (using the clear button) after the restart button was used.</li>
  </ul>
</details>

<details>
  <summary><b>Asset Updates</b></summary>
  We cleaned up the basic assets to make the lines more organic and continuous. This changed the look of the output to be more smooth. In addition, we included tiles for <b>rivers</b>, i.e., tiles with 2 water edges not adjacent to each other. We included a way to enable & disable the river tiles in the output using the UI.
  <br>
  <img width="500" src="/img/assets_3.png">

</details>

<details>
  <summary><b>Rendering Updates</b></summary>
  For this milestone we worked on polishing the basic shaders as well as adding some more post-process effects.
  <br>
  <details>
    <summary><b>Coastline Hatching</b></summary>
    In our reference images, we noticed that the coastline contours have a horizontal hatched line effect. In order to create this effect in the shader, we used the mod operation to create horizontal lines across the entire screen, and then masked out the areas that we did not want to be affected by the contours. We used the sobel filter with a thick radius to create this mask and perturbed it using FBM so that the contours would be of varying lengths. Any area that was not within this mask and not above water, would not receive contouring. Additionally, we mixed the contour color with worley noise to create a more hand-drawn look.
    <br><img src="/img/hatching.PNG">
  </details>
  
  <details>
    <summary><b>Animated Water</b></summary>
    <br><img src="/img/wetywrtyw.gif">
    The water feature of the map was animated using a post-process. Before the addition of animation, the procedural water texture simply looked like this static image:
    <br><img width="391" height="200" src="/img/old_Water.PNG">
    <br>The water is animated using a sine function based on time, as well as fractal brownian motion and multiple time, amplitude and phase offsets to get the motion.
    To have the white water waves repeating, the result of the fract function using this animated sine function is compared with line width and repeat variables. Then,
    a series of worley noise and FBM layer on top of each other to get a more heterogeneous look to the coloring and fading of the water texture.
  </details>
  
  <details>
    <summary><b>Compass</b></summary>
    The compass was created with 2D SDFs. Specifically, we used isosceles triangles to represent the directions and circles for the center & other larger shapes. We also used a 2D rotation matrix to correctly orient and place the SDFs around the center circles. The compass is positioned relative to the right edge of the map frame to ensure it does not go out of view.
    <br><img src="/img/compass.PNG">
  </details>
  
  <details>
    <summary><b>Map Frame</b></summary>
    Every reference map we saw had a frame that adds to the look of the map. To bring that same aesthetic to our tool, we wanted to add a frame. Our frame is made using 2D SDFs for the outlines and FBM for the rough edges. We included some layered FBM to give the borders a weathered look based on the distance from the center of the screen as well as the distance from the screen edges. The placement of the frame is relative to screen size.
 <table>
  <tr>
    <td><img src="/img/frame_1.png"></td>
    <td><img src="/img/frame_2.png"></td> 
  </tr>
  <tr>
    <td><img src="/img/frame_3.png"></td>
    <td><img src="/img/frame_5.png"></td> 
  </tr>
</table>
  </details>
  
  
</details>

<details>
  <summary><b>UI Updates</b></summary>
  Some UI additions are as follows:
  <ul>
    <li><b>Number of seeds</b> input</li>
    <li>Sliders to control the <b>weights</b> of land, water, coastline, mountain, forest and river tiles. All slider values range from 1 - 200 (except river, which ranges from 0 - 50, so you can choose to have no rivers in your scene).</li>
    <li>Press Space bar to <b>toggle UI</b></li>
    <li>Press C key to <b>enable free camera</b> movement</li>
    <li>Press and hold Middle mouse button to <b>pan the camera</b> while in free camera mode</li>
    <li>Scroll the Middle mouse button to <b>zoom the camera in and out</b> while in free camera mode</li>
  </ul>
</details>


<details>
  <summary><b>Camera</b></summary>
  The camera is able to be controlled when the "free camera" toggle is enabled (i.e. by hitting "C" key). This allows for panning and zooming the camera. This level
  of control is especially appreciated when the grid size of the map is enlarged to enable traversal of a procedurally generated large-scale land mass.
  <br><br>Zoomed out image of a large map:
  <br><img src="/img/zoom_out.PNG">
  <br>Zoomed in image of a large map:
  <br><img src="/img/zoom_in.PNG">
</details>

<details>
  <summary><b>Publishing to Unity Play</b></summary>
  We built and published our project to Unity Play as a WebGL app, which can be viewed live and played in-browser <a href="https://play.unity.com/mg/other/webglbuild2-12">here</a>. This WebGL version runs a bit slower than our local Unity build, but still includes the full functionality of our tool. The deployment process was simple; we installed the WebGL Publisher package in Unity and then used this to build and run our application. Once this step was completed, we published to Unity Play using the "Publish" tab in the Unity editor.   
</details>

## Post Mortem
Overall, we really enjoyed working on this project. In the end, we accomplished all the main goals we set out from the beginning including 
- hexagonal Wave Function Collapse, 
- non-photorealistically rendered map, and 
- basic user interactivity

We planned out our tasks and goals for each milestone, which helped the project progress smoothly. Additionally, each person was given clear tasks which allowed us to make good progress in both the WFC and the Rendering parts of the project simultaneously. We maintained a task board throughout which made project management easy and kept everyone up to speed with the progress.
For the most part, we did not pivot from the development plan we set out with. Though there are still a lot of ideas, features and feedback we would have liked to implement, we are still happy with what we have accomplished within the time frame of the project.

Some of the features we would like to implement as we continue to work on this project are:
- Options to select from various artistic map styles.
- Better backtracking for the WFC.
- More assets and features such as - castles, villages, roads, sea monsters, etc.
- More geographically accurate feature/biome placement.
- Advanced interactivity, e.g. infinite map generation based on the camera movement.

## Resources

[Catlike Coding Hex Grid Tutorials](https://catlikecoding.com/unity/tutorials/hex-map/)

[Red Blob Games Hexagonal Grid Tutorial](https://www.redblobgames.com/grids/hexagons/)

[Wave Function Collapse by Robert Heaton](https://robertheaton.com/2018/12/17/wavefunction-collapse-algorithm/)

[Wave Function Collapse by Maxim Gumin](https://github.com/mxgmn/WaveFunctionCollapse)

[Unity Camera Tutorial](https://faramira.com/implement-camera-pan-and-zoom-controls-in-unity2d/)

[Unity Camera Shaders](https://lindenreidblog.com/2018/02/05/camera-shaders-unity/)

[Publishing Unity Build for WebGL](https://learn.unity.com/tutorial/how-to-publish-for-webgl#5d92519bedbc2a130fa21789)

[Inigo Quilez 2D SDFs](https://iquilezles.org/articles/distfunctions2d/)
