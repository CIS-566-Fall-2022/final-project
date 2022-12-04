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
  'CameraX': 1,
  'CameraY': 1,
  'CameraZ': 1,

  'Camera Animation': 'On',
  'Camera Animation Speed': 1,

  'Noise Color': [ 255, 255, 0 ],
  'Depth': 0.1,
};

let icosphere: Icosphere;

let square: Square;
let cube: Cube;
let squarePyramid: SquarePyramid;
let time: number = 0;
let timeCamera: number = 0;
let cameraSpeed: number = 0.002;
let height: number = 0;
let color: vec4; 
let noiseColor: vec4; 

let prevTesselations: number = 5;

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
  var f1 = gui.addFolder('Greeble Control');

  f1.add(controls, 'Depth', 0, 0.5).step(0.02);
  
  var f2 = gui.addFolder('Animation');

  f2.add(controls, 'Camera Animation', [ 'On', 'Off' ]);
  f2.add(controls, 'Camera Animation Speed', 1, 10).step(1);
  f2.add(controls, 'CameraX', -10, 10).step(0.02);
  f2.add(controls, 'CameraY', -10, 10).step(0.02);
  f2.add(controls, 'CameraZ', -10, 10).step(0.02);
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
  const camera = new Camera(vec3.fromValues(2, 2, 1.5), vec3.fromValues(0, 0, 0));

  // const camera = new Camera(vec3.fromValues(2, 3, 0), vec3.fromValues(0, 0, 0));

  const renderer = new OpenGLRenderer(canvas);
  renderer.setClearColor(0.2, 0.2, 0.2, 1);
  gl.enable(gl.DEPTH_TEST);

  const sdf = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, [require('./shaders/sdf1-vert.glsl')], []),
    new Shader(gl.FRAGMENT_SHADER, [
      require('./shaders/toolbox.glsl'),
      require('./shaders/noise.glsl'),
      require('./shaders/sdf-compose.glsl'),
      require('./shaders/sdf-objects.glsl'),      
      require('./shaders/sdf1-frag.glsl')
    ], [
    ]),
  ]);
  sdf.setDimensions(window.innerWidth, window.innerHeight);

  time = 0;
  // This function will be called every frame
  function tick() {
    time +=1;
    color = vec4.fromValues(controls.Color[0] /255, controls.Color[1] / 255, controls.Color[2] / 255, 1);
    noiseColor = vec4.fromValues(controls['Noise Color'][0] /255, controls['Noise Color'][1] / 255, controls['Noise Color'][2] / 255, 1);
    height = controls['Depth'];

    if(controls['Camera Animation'] == 'On'){
      // camera.setPosition(vec3.fromValues(
      //   controls['CameraX'] + Math.sin(timeCamera) * 4, 
      //   controls['CameraY'] + Math.sin(timeCamera) * 2, 
      //   controls['CameraZ'] + Math.sin(timeCamera) * 10));
      camera.setPosition(vec3.fromValues(
        2 + Math.sin(timeCamera) * controls['CameraX'], 
        2 + Math.sin(timeCamera) * controls['CameraY'], 
        1.5 + Math.sin(timeCamera) * controls['CameraZ']));
    }
    // const camera = new Camera(vec3.fromValues(controls.CameraX, 3, 0), vec3.fromValues(0, 0, 0));

    // camera.update();
    stats.begin();
    gl.viewport(0, 0, window.innerWidth, window.innerHeight);
    renderer.clear();
    if(controls.tesselations != prevTesselations)
    {
      prevTesselations = controls.tesselations;
      icosphere = new Icosphere(vec3.fromValues(3, 0, 0), 1, prevTesselations);
      icosphere.create();
    }

    renderer.render(camera, time, height, color, noiseColor, sdf, [
      square,
    ], false);

    stats.end();

    // Tell the browser to call `tick` again whenever it renders a new frame
    requestAnimationFrame(tick);


    timeCamera+=0.002 * controls['Camera Animation Speed'];
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
