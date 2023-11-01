import {vec2, vec3} from 'gl-matrix';
// import * as Stats from 'stats-js';
import * as DAT from 'dat-gui';
import Square from './geometry/Square';
import OpenGLRenderer from './rendering/gl/OpenGLRenderer';
import Camera from './Camera';
import {setGL} from './globals';
import ShaderProgram, {Shader} from './rendering/gl/ShaderProgram';

// Define an object with application parameters and button callbacks
// This will be referred to by dat.GUI's functions that add GUI elements.
const controls = {
  'Load Scene': loadScene, // A function pointer, essentially
  posX: 0.0,
  posY: 0.0,
  posZ: 0.0,
  'Stripe Noise': 5.0,
  'Base Color': [127.5, 25.5, 0.0],
  'Number of Stripes': 7.0,
  'White Front?': 1.0,
  'Generate New Cat': generate,
};

let square: Square;
let time: number = 0;

function loadScene() {
  square = new Square(vec3.fromValues(0, 0, 0));
  square.create();
  // time = 0;
}

function generate() {
  controls['Stripe Noise'] = Math.random() * 10.0;
  controls['Base Color'] = [Math.random() * 255.0, 25.5, 0.0];
  controls['Number of Stripes'] = Math.random() * 10.0;
  controls['White Front?'] = Math.round(Math.random());
}

function main() {
  window.addEventListener('keypress', function (e) {
    // console.log(e.key);
    switch(e.key) {
      // Use this if you wish
    }
  }, false);

  window.addEventListener('keyup', function (e) {
    switch(e.key) {
      // Use this if you wish
    }
  }, false);

  // Initial display for framerate
  // const stats = Stats();
  // stats.setMode(0);
  // stats.domElement.style.position = 'absolute';
  // stats.domElement.style.left = '0px';
  // stats.domElement.style.top = '0px';
  // document.body.appendChild(stats.domElement);

  // Add controls to the gui
  const gui = new DAT.GUI()
  gui.add(controls, 'posX', -10.0, 10.0).step(1.0);
  gui.add(controls, 'posY', -10.0, 10.0).step(1.0);
  gui.add(controls, 'posZ', -10.0, 10.0).step(1.0);
  gui.add(controls, 'Stripe Noise', 0.1, 10.0).step(0.1);
  gui.addColor(controls, 'Base Color');
  gui.add(controls, 'Number of Stripes', 0.0, 10.0).step(0.1);
  gui.add(controls, 'White Front?', 0.0, 1.0).step(1.0);
  gui.add(controls, 'Generate New Cat');

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

  const camera = new Camera(vec3.fromValues(7, 15, 20), vec3.fromValues(0, 0, 0));

  const renderer = new OpenGLRenderer(canvas);
  renderer.setClearColor(164.0 / 255.0, 233.0 / 255.0, 1.0, 1);
  gl.enable(gl.DEPTH_TEST);

  const flat = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, require('./shaders/flat-vert.glsl')),
    new Shader(gl.FRAGMENT_SHADER, require('./shaders/flat-frag.glsl')),
  ]);

  const custom = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, require('./shaders/final.vert.glsl')),
    new Shader(gl.FRAGMENT_SHADER, require('./shaders/final.main.frag.glsl')),
  ]);

  function processKeyPresses() {
    // Use this if you wish
  }

  function processGUI() {
    // Use this if you wish
    custom.setPos(controls.posX, controls.posY, controls.posZ);
    custom.setStripe(controls['Stripe Noise']);
    custom.setBaseCol(controls['Base Color']);
    custom.setNumStripes(controls['Number of Stripes']);
    custom.setWhiteFront(controls['White Front?']);
  }

  // This function will be called every frame
  function tick() {
    camera.update();
    // stats.begin();
    gl.viewport(0, 0, window.innerWidth, window.innerHeight);
    renderer.clear();
    processKeyPresses();
    // renderer.render(camera, flat, [
    //   square,
    // ], time);

    // process GUI inputs
    processGUI();

    renderer.render(camera, custom, [
      square,
    ], time);
    time++;
    // stats.end();

    // Tell the browser to call `tick` again whenever it renders a new frame
    requestAnimationFrame(tick);
  }

  window.addEventListener('resize', function() {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.setAspectRatio(window.innerWidth / window.innerHeight);
    camera.updateProjectionMatrix();
    custom.setDimensions(window.innerWidth, window.innerHeight);
    flat.setDimensions(window.innerWidth, window.innerHeight);
  }, false);

  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.setAspectRatio(window.innerWidth / window.innerHeight);
  camera.updateProjectionMatrix();
  custom.setDimensions(window.innerWidth, window.innerHeight);
  flat.setDimensions(window.innerWidth, window.innerHeight);

  // Start the render loop
  tick();
}

main();
