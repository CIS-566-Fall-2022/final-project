code

```

/* fractal fun
 * this demo maps glitch sounds from the freesound database
 * to control geometric parameters (including the folding
 * of a Mandelbulb fractal) and two post-processing effects.
 * use ctrl+h to hide / unhide the code for better viewing.
*/ 

// create blur and inversion post-processing fx.
blur = Blur(0)
inv = Invert(0)
 
// create the intersection of a sphere and
// a repeated mandelbulb, and round the points of 
// intersection. render using the 'fractal.low'
// preset... try changing to fractal.med or fractal.high
// if you have a good graphics card.
ri = RoundIntersection(
  Sphere(3).material('blackhole'),
  Repeat( 
    s = Mandelbulb().material('pink').scale(.25), 
    .5 
  ), .05
).render('fractal.low') 
 
verb = Reverb('space').bus()
 
// see the freesound tutorial! 
glitch = Freesound[6]({ query:'guitar', max:.5 })
  .connect( verb, .05 )
  .spread(.9) // pan voices full stereo
 
// pick and play a random sample
// nine times distributed over sixteen slots,
// where each slot is a 1/16th note.
glitch.pickplay.seq(
  Rndi(0,2)
  Euclid(5,8)
)
  
kick = Freesound[3]({query:'stevie', max: 0.5})
  .connect( verb, .5 )
  .trigger.seq( [1,2,0], [1/2,1/8] )
 
 
  
// start FFT
FFT.start()
// use short windows to capture transients. default
// window is 512 samples, which is converted to 128 below. 
FFT.windowSize *= .25
 
use( 'hydra' ).then( init => init() )
c1 = osc(.9, 100, 3)
console.log(typeof(c1))
 
/////
use( 'p5' )
 
// it might take a second or two to download
// p5, but once that's done we can run
// p5 commands.
 
// set the background color to black
background(0)
 
// set the fill color to red
fill(255,0,0)
 
// draw a rectangle at the screen center
rect( width/2-50, height/2-50, 100,100 )
 
// draw a bunch of rectangles
for( let i = 0; i < 10; i++ ) {
  rect( 200 + i * 20, 200 + i * 20, 100,100 )
}
 
 
onframe = t => {
  fill(255*c1[0], 0, 0)
  rect(width*FFT.low, height*FFT.low, width*FFT.high, 200)
  fill(0, 255, 0)
  rect(width*FFT.mid, height*FFT.mid, 100, width*FFT.high)
  fill(0, 0, 255)
  rect(width*FFT.high, height*FFT.high, 100, 200)
}

```