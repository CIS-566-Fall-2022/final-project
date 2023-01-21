[video performance](https://drive.google.com/file/d/18BxG7HP8sOYoWghmwB8to4ZEGT92g5sL/view?usp=sharing)


[link to playable gibber site code](https://gibber.cc/alpha/playground/index.html?CnVzZSggJ2h5ZHJhJyApLnRoZW4oIGluaXQgPT4gaW5pdCgpICkKIAovKiAKQnkgZGVmYXVsdCwgdGhlIEZGVCBhc3NpZ25zIGZyZXF1ZW5jaWVzIAo8MTUwIEh6IHRvIEZGVC5sb3csIDE1MC0xNDAwSHogdG8KRkZULm1pZCwgYW5kIGFsbCByZW1haW5pbmcgZnJlcXVlbmNpZXMKdG8gRkZULmhpZ2guIEhvd2V2ZXIsIHlvdSBjYW4gYWxzbwpkZWZpbmUgeW91ciBvd24gYm91bmRhcmllcyBieSBwYXNzaW5nCmFuIGFycmF5IHRvIEZGVC5zdGFydCgpOyBpZiB5b3UgZG8gdGhpcwp0aGUgYXZlcmFnZXMgd2lsbCB0aGVuIGJlIGluIEZGVFswXSwgCkZGVFsxXSwgRkZUWzJdIGV0Yy4gCiovCiAKLy8gMDogMC0xMDBIegovLyAxOiAxMDAtNTAwSHoKLy8gMjogNTAwLTIwMDBIegovLyAzOiAyMDAwLTIyMDUwSHoKRkZULnN0YXJ0KFsxMDAsNTAwLDIwMDAsMjIwNTBdKQogCm9zYyggMTAsMCwoKT0+IEZGVFswXSAqIDE1ICkKICAubW9kdWxhdGUoIG5vaXNlKCAoKT0+IEZGVFsyXSArIEZGVFszXSAqIDUgKSApCiAgLm91dCgpCgoKQ2xvY2suYnBtID0gMjAwCnZlcmIgPSBCdXMyKCdzcGFjZXZlcmInKQogCnN5biA9IFBvbHlTeW50aCgnc3F1YXJlLnBlcmMnKQoKc3luLm5vdGUudGlkYWwoICcyKjIgWzAgMiAyXSozIDw0IDM+KjIgNycgKQpzeW4ucGFuLnRpZGFsKCAnMCAwLjUgMC45OScgKQpzeW4uY3V0b2ZmLnRpZGFsKCAnLjQ1IC45NSAuMzI1IDEuNScgKQoKLy8gY3VycmVudGx5IHVzZXMgI3Mgb25seS4KVGhlb3J5LnJvb3QgPSAyNjEgLy9jNApUaGVvcnkucm9vdCA9IDM0OSAvL2Y0CgovLyBhZW9saWFuLCBkb3JpYW4sIHBocnlnaWFuLCBpb25pYW4sIG1peG9seWRpYW4sIGx5ZGlhbiBldGMuClRoZW9yeS5tb2RlID0gJ2x5ZGlhbicKVGhlb3J5Lm1vZGUgPSAncGhyeWdpYW4nIApUaGVvcnkubW9kZSA9ICAnbWl4b2x5ZGlhbicKCi8vYWRkIHNvbWUgZHJ1bXMKZHJ1bXMgPSBEcnVtcygpCmRydW1zLnRpZGFsKCdba2QqMyA8c2QqMiBjaCo2Pl0qMicpCgovL21vcmUgZHJ1bXMKZDIgPSBEcnVtcygpCmQyLnRpZGFsKCdbb2gqMiA8a2QqMyBvaCoyPl0nKQoKZHJ1bXMuc3RvcCgpCmQyLnN0b3AoKQpzeW4uc3RvcCgp)


code
```

use( 'hydra' ).then( init => init() )
 
/* 
By default, the FFT assigns frequencies 
<150 Hz to FFT.low, 150-1400Hz to
FFT.mid, and all remaining frequencies
to FFT.high. However, you can also
define your own boundaries by passing
an array to FFT.start(); if you do this
the averages will then be in FFT[0], 
FFT[1], FFT[2] etc. 
*/
 
// 0: 0-100Hz
// 1: 100-500Hz
// 2: 500-2000Hz
// 3: 2000-22050Hz
FFT.start([100,500,2000,22050])
 
osc( 10,0,()=> FFT[0] * 15 )
  .modulate( noise( ()=> FFT[2] + FFT[3] * 5 ) )
  .out()


Clock.bpm = 200
verb = Bus2('spaceverb')
 
syn = PolySynth('square.perc')

syn.note.tidal( '2*2 [0 2 2]*3 <4 3>*2 7' )
syn.pan.tidal( '0 0.5 0.99' )
syn.cutoff.tidal( '.45 .95 .325 1.5' )

// currently uses #s only.
Theory.root = 261 //c4
Theory.root = 349 //f4

// aeolian, dorian, phrygian, ionian, mixolydian, lydian etc.
Theory.mode = 'lydian'
Theory.mode = 'phrygian' 
Theory.mode =  'mixolydian'

//add some drums
drums = Drums()
drums.tidal('[kd*3 <sd*2 ch*6>]*2')

//more drums
d2 = Drums()
d2.tidal('[oh*2≥ <kd*3 oh*2>]')

drums.stop()
d2.stop()
syn.stop()
```
