import {mat4, vec4} from 'gl-matrix';
import Drawable from './Drawable';
import Camera from '../../Camera';
import {gl} from '../../globals';
import ShaderProgram from './ShaderProgram';

// In this file, `gl` is accessible because it is imported above
class OpenGLRenderer {
  constructor(public canvas: HTMLCanvasElement) {
  }

  setClearColor(r: number, g: number, b: number, a: number) {
    gl.clearColor(r, g, b, a);
  }

  setSize(width: number, height: number) {
    this.canvas.width = width;
    this.canvas.height = height;
  }

  clear() {
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  }

  render(camera: Camera, time: vec4, color: vec4, noiseColor:vec4, prog: ShaderProgram, drawables: Array<Drawable>, mode: boolean) {
    let model = mat4.create();
    let viewProj = mat4.create();
    // color = vec4.fromValues(1,0,0,1);
    mat4.identity(model);
    mat4.multiply(viewProj, camera.projectionMatrix, camera.viewMatrix);
    prog.setModelMatrix(model);
    prog.setViewProjMatrix(viewProj);
    prog.setGeometryColor(color);
    prog.setNoiseColor(noiseColor);
    prog.setTime(time);
    // prog.setColor(color);
    // gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT );
    gl.clearColor(0.0, 0.0 / 255.0, 0.0 / 255.0, 0.9);
    for (let drawable of drawables) {
      if(!mode){
        prog.draw(drawable);

      }else{
        prog.drawLine(drawable);

      }
    }
  }
};

export default OpenGLRenderer;
