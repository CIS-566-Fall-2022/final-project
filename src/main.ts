import {vec3} from 'gl-matrix';
import {vec4} from 'gl-matrix';

const Stats = require('stats-js');
import * as DAT from 'dat.gui';
import Icosphere from './geometry/Icosphere';
import Square from './geometry/Square';
import Cube from './geometry/Cube';
import SquarePyramid from './geometry/SquarePyramid';

import OpenGLRenderer from './rendering/gl/OpenGLRenderer';
import Camera from './Camera';
import {setGL} from './globals';
import ShaderProgram, {Shader} from './rendering/gl/ShaderProgram';

// Define an object with application parameters and button callbacks
// This will be referred to by dat.GUI's functions that add GUI elements.
const controls = {
  tesselations: 5,
  'Load Scene': loadScene, // A function pointer, essentially
  'Shader': 0,
  'Color': [ 255, 12, 25 ],
  'Shaders': 'Fireball',
  'Noise Color': [ 255, 255, 0 ],
  'Depth': 0.1,
};

let icosphere: Icosphere;
let icosphereLine: Icosphere;
let icosphereLine2: Icosphere;
let icosphereLine3: Icosphere;
let icosphereLine4: Icosphere;

let square: Square;
let cube: Cube;
let squarePyramid: SquarePyramid;
let time: number = 0;
let height: number = 0;
let color: vec4; 
let noiseColor: vec4; 

let prevTesselations: number = 5;

import jsonsdfs from './sdfs.json';

type flatArr = {
  data: Float32Array,
  x: number,
  y: number,
  z: number
}

function toFlatArr(arr: number[][][]){
  const flat2d = arr.reduce((accumulator, value) => accumulator.concat(value), [])
  const flat1d = flat2d.reduce((accumulator, value) => accumulator.concat(value), [])
  const obj: flatArr = {
    data: new Float32Array(flat1d),
      x: arr.length, y:arr[0].length , z: arr[0][0].length
  }
  return obj;
}

function loadScene() {
  icosphere = new Icosphere(vec3.fromValues(3, 0, 0), 1, controls.tesselations);
  icosphere.create();
  
  square = new Square(vec3.fromValues(0, 0, 0), vec3.fromValues(1, 1, 1));
  square.create();

  cube = new Cube(vec3.fromValues(0, 0, 0));
  cube.create();

  squarePyramid = new SquarePyramid(vec3.fromValues(0, 0, 0))
  squarePyramid.create();
}

function main() {
  // console.log(toFlatArr(jsonsdfs['h-pyramid']));
  // Initial display for framerate
  const stats = Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.left = '0px';
  stats.domElement.style.top = '0px';
  document.body.appendChild(stats.domElement);

  // Add controls to the gui
  const gui = new DAT.GUI();
  // gui.add(controls, 'tesselations', 0, 8).step(1);
  // gui.add(controls, 'Load Scene');
  // gui.addColor(controls, 'Color');
  // gui.addColor(controls, 'Noise Color');
  gui.add(controls, 'Depth', 0, 0.5).step(0.02);

  // gui.add(controls, 'Shader', 0, 1).step(1);
  // gui.add(controls, 'Shaders', [ 'Lambert', 'Perlin Noise', 'Transform', 'Fireball' ] );

  // get canvas and webgl context
  const canvas = <HTMLCanvasElement> document.getElementById('canvas');
  const gl = <WebGL2RenderingContext> canvas.getContext('webgl2');
  if (!gl) {
    alert('WebGL 2 not supported!');
  }
  // `setGL` is a function imported above which sets the value of `gl` in the `globals.ts` module.
  // Later, we can import `gl` from `globals.ts` to access it
  setGL(gl);

  // Initial call to load scene
  loadScene();

  const camera = new Camera(vec3.fromValues(2, 3, 1.5), vec3.fromValues(0, 0, 0));

  const renderer = new OpenGLRenderer(canvas);
  renderer.setClearColor(0.2, 0.2, 0.2, 1);
  gl.enable(gl.DEPTH_TEST);
  // const fireball = new ShaderProgram([
  //   new Shader(gl.VERTEX_SHADER, require('./shaders/fireball-vert.glsl')),
  //   new Shader(gl.FRAGMENT_SHADER, require('./shaders/fireball-frag.glsl')),
  // ]);
  const lambert = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, require('./shaders/lambert-vert.glsl')),
    new Shader(gl.FRAGMENT_SHADER, require('./shaders/lambert-frag.glsl')),
  ]);
  // const perlin = new ShaderProgram([
  //   new Shader(gl.VERTEX_SHADER, require('./shaders/perlin-vert.glsl')),
  //   new Shader(gl.FRAGMENT_SHADER, require('./shaders/perlin-frag.glsl')),
  // ]);
  // const transform = new ShaderProgram([
  //   new Shader(gl.VERTEX_SHADER, require('./shaders/transform-vert.glsl')),
  //   new Shader(gl.FRAGMENT_SHADER, require('./shaders/lambert-frag.glsl')),
  // ]);
  const sdf = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, [require('./shaders/sdf1-vert.glsl')]),
    new Shader(gl.FRAGMENT_SHADER, [
      require('./shaders/toolbox.glsl'),
      require('./shaders/noise.glsl'),
      require('./shaders/sdf-compose.glsl'),
      require('./shaders/sdf-objects.glsl'),      
      require('./shaders/sdf1-frag.glsl')
    ]),
  ]);
  sdf.setDimensions(window.innerWidth, window.innerHeight);


  // This function will be called every frame
  function tick() {
    time = 10000;
    color = vec4.fromValues(controls.Color[0] /255, controls.Color[1] / 255, controls.Color[2] / 255, 1);
    noiseColor = vec4.fromValues(controls['Noise Color'][0] /255, controls['Noise Color'][1] / 255, controls['Noise Color'][2] / 255, 1);
    height = controls['Depth'];
    camera.update();
    stats.begin();
    gl.viewport(0, 0, window.innerWidth, window.innerHeight);
    renderer.clear();
    if(controls.tesselations != prevTesselations)
    {
      prevTesselations = controls.tesselations;
      icosphere = new Icosphere(vec3.fromValues(3, 0, 0), 1, prevTesselations);
      icosphere.create();
    }
    var shader;
    // if(controls.Shaders == 'Lambert'){
    //   renderer.render(camera, time, color, noiseColor, lambert, [
    //     cube,  icosphere,
    //   ], false);
    // }
    // if(controls.Shaders == 'Perlin Noise'){
    //   shader = perlin;
    //   renderer.render(camera, time, color, noiseColor, perlin, [
    //     cube,  icosphere,
    //   ], false);
    // }
    // if(controls.Shaders == 'Transform'){
    //   shader = transform;
    //   renderer.render(camera, time, color, noiseColor, transform, [
    //     cube,  
    //   ],false);
    // }

    renderer.render(camera, time, height, color, noiseColor, sdf, [
      square,
    ], false);

    // renderer.render(camera, time, color, noiseColor, lambert, [
    //     squarePyramid,
    //   ], false);


    // square = new Square(vec3.fromValues(-2, -2, -2), vec3.fromValues(10, 10, 1));
    // square.create();
    // icosphere = new Icosphere(vec3.fromValues(0, 0, 0), 1, prevTesselations);
    // icosphere.create();
    // if(controls.Shaders == 'Fireball'){
    //   square = new Square(vec3.fromValues(-2, -2, -2), vec3.fromValues(10, 10, 1));
    //   square.create();

    //   icosphere = new Icosphere(vec3.fromValues(0, 0, 0), 1, prevTesselations);
    //   icosphere.create();

    //   icosphereLine = new Icosphere(vec3.fromValues(0, 0, 0), 1.5, 2);
    //   icosphereLine.create();
      
    //   icosphereLine2 = new Icosphere(vec3.fromValues(0, 0, 0), 2.0, 1);
    //   icosphereLine2.create();

    //   icosphereLine3 = new Icosphere(vec3.fromValues(0, 0, 0), 4.0, 1);
    //   icosphereLine3.create();


    // }



    stats.end();

    // Tell the browser to call `tick` again whenever it renders a new frame
    requestAnimationFrame(tick);
  }

  window.addEventListener('resize', function() {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.setAspectRatio(window.innerWidth / window.innerHeight);
    camera.updateProjectionMatrix();
  }, false);

  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.setAspectRatio(window.innerWidth / window.innerHeight);
  camera.updateProjectionMatrix();

  // Start the render loop
  tick();
}

main();
