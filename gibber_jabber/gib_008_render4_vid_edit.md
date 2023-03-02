
gif

![alt text](media/gib_008.gif)


[![Image from Gyazo](https://i.gyazo.com/3cc11c27df7b70339186534a35db6aa0.gif)](https://gyazo.com/3cc11c27df7b70339186534a35db6aa0)

code

```

src(o0).diff(o1,0.01)
  .mask(shape(4,0.4,0.4))
.scale(1.002)
.modulate(noise(2,0.1))
  .out(o0)

osc(2,0.5,1)
.blend(noise(),0.5)
  .out(o1)

osc(2, 4, 6).blend(voronoi(1, 0.2, 0.9), 0.2)
	.layer(
  			osc(10, 2, 5)
  			.pixelate(20,200)
  			.colorama([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99], 0.1)
  			)
	.mult(osc(100,22,33))
  .out(o2)

s3.initVideo("https://cdn.glitch.global/e764fb49-9460-4375-9503-543e60b9dfd4/5b97993b0327636dfabac77adbc97cd8.mp4?v=1669843575186")
src(s3).modulate(noise(3)).colorama(.9).diff(osc(() => -mouse.x * 0.05/ width,
  () => -mouse.y.ease('easeInOutCubic') / height,5))
  .layer(src(o3).mask(shape(2*Math.sin(time), 0.4, 0))).kaleid(()=>6+Math.sin(time)*2)
          .scrollX([0.005, -0.005])
          .scrollY(0.005)
  .out(o3)

render()
```