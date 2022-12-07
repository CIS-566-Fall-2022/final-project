code

```
// licensed with CC BY-NC-SA 4.0 https://creativecommons.org/licenses/by-nc-sa/4.0/
// hydra sit scan
// upload video to glitch asset for public cdn url post
// this was a slit scan attempt, but it got weird
// uploaded one of my paintings
// click the cdn link below to see original vid

// coefficeints
q = 0.0005
r = -0.00007

// audio analysis
// set bins for fft (microphone input fft)

s0.initVideo("https://cdn.glitch.global/c3b47f2f-df51-44d8-88fa-3d80edae5b75/painting.MOV?v=1670337056958")
src(s0)
	.modulateScrollX(noise(), 0.01, 0.1)
	.diff(osc(5,-0.04,0.9).kaleid(50))
	.modulateScrollY(voronoi(0.05, 0.2, 0.3), -1.9, 0.9)
	.scrollX(0, ({time}) => Math.sin(time*0.5)*q ) //movement
  	.scrollY(0, ({time}) => Math.cos(time*0.1)*r ) //movement
	.diff(noise(0.8,0.2).luma(0.5,0.1).invert()) //vibrant oil drops
  .out(o0)

```


another rip

https://hydra.ojack.xyz/?sketch_id=UKv7XyXbDynTuz6Q


//i started using am array to alternate between the different luma coefficients and fast to modualte the time

https://hydra.ojack.xyz/?sketch_id=0XFAiHUr5GHFL3HL

![alt text](media/lumafast.gif)

<video src='media/lumafast.mp4'/>


