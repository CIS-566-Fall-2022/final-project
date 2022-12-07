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

addding a painting of mine
https://hydra.ojack.xyz/?code=JTJGJTJGJTIwbGljZW5zZWQlMjB3aXRoJTIwQ0MlMjBCWS1OQy1TQSUyMDQuMCUyMGh0dHBzJTNBJTJGJTJGY3JlYXRpdmVjb21tb25zLm9yZyUyRmxpY2Vuc2VzJTJGYnktbmMtc2ElMkY0LjAlMkYlMEElMkYlMkYlMjBoeWRyYSUyMHNpdCUyMHNjYW4lMEElMkYlMkYlMjB1cGxvYWQlMjB2aWRlbyUyMHRvJTIwZ2xpdGNoJTIwYXNzZXQlMjBmb3IlMjBwdWJsaWMlMjBjZG4lMjB1cmwlMjBwb3N0JTBBJTJGJTJGJTIwdGhpcyUyMHdhcyUyMGElMjBzbGl0JTIwc2NhbiUyMGF0dGVtcHQlMkMlMjBidXQlMjBpdCUyMGdvdCUyMHdlaXJkJTBBJTJGJTJGJTIwdXBsb2FkZWQlMjBvbmUlMjBvZiUyMG15JTIwcGFpbnRpbmdzJTBBJTJGJTJGJTIwY2xpY2slMjB0aGUlMjBjZG4lMjBsaW5rJTIwYmVsb3clMjB0byUyMHNlZSUyMG9yaWdpbmFsJTIwdmlkJTBBcSUyMCUzRCUyMDAuMDA1JTBBciUyMCUzRCUyMC0wLjAwNyUwQSUwQXMwLmluaXRWaWRlbyglMjJodHRwcyUzQSUyRiUyRmNkbi5nbGl0Y2guZ2xvYmFsJTJGYzNiNDdmMmYtZGY1MS00NGQ4LTg4ZmEtM2Q4MGVkYWU1Yjc1JTJGcGFpbnRpbmcuTU9WJTNGdiUzRDE2NzAzMzcwNTY5NTglMjIpJTBBc3JjKHMwKSUwQSUwOS5tb2R1bGF0ZVNjcm9sbFgobm9pc2UoKSUyQyUyMDAuMDElMkMlMjAwLjEpJTBBJTA5LmRpZmYob3NjKDUlMkMtMC4wNCUyQzAuOSkua2FsZWlkKDUwKSklMEElMDkubW9kdWxhdGVTY3JvbGxZKHZvcm9ub2koMC4wNSUyQyUyMDAuMiUyQyUyMDAuMyklMkMlMjAtMS45JTJDJTIwMC45KSUwQSUwOS5zY3JvbGxYKDAlMkMlMjAoJTdCdGltZSU3RCklMjAlM0QlM0UlMjBNYXRoLnRhbih0aW1lKjAuNSkqcSUyMCklMEElMjAlMjAuc2Nyb2xsWSgwJTJDJTIwKCU3QnRpbWUlN0QpJTIwJTNEJTNFJTIwTWF0aC5jb3ModGltZSowLjEpKnIlMjApJTBBJTIwJTIwLm91dChvMCklMEE%3D

![alt text](media/hydra_painting_code_overlay.mp4)

![alt text](media/fastpainting.gif)