https://hydra.ojack.xyz/?sketch_id=5gDCyIgVkO3KCPgN

gif

![alttext](media/wallacekaleid.gif)


code 

```
// hydra sit scan
// upload video to glitch asset for public cdn url post
// this was a slit scan attempt, but it got weird
s0.initVideo("https://cdn.glitch.global/c3b47f2f-df51-44d8-88fa-3d80edae5b75/e6a0e4cb397bed9735c4efad157e87ac.mp4?v=1670291308631")
src(s0)
	.modulateScrollX(noise(), 0.01, 0.1)
	.pixelate(200, 500)
	.diff(osc(5,-0.04,0.9).kaleid(50))
	.modulateScrollY(voronoi(0.75, 0.2, 0.3), -1.9, 0.9)
	.scrollX(0, ({time}) => Math.tan(time*0.05)*0.0005 )
  .scrollY(0, ({time}) => Math.cos(time*0.0001)*-0.0007 )
  .out(o0)

```