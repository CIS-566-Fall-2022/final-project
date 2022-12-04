import {vec4, mat4, vec3} from 'gl-matrix';
import Drawable from './Drawable';
import {gl} from '../../globals';
import jsonsdfs from './sdfs.json';

var activeProgram: WebGLProgram = null;


type flatArr = {
  name: string,
  data: Float32Array,
  x: number,
  y: number,
  z: number
}

function toFlatArr(name: string){

  // @ts-ignore
  const arr: number[][][] = jsonsdfs[name];
  const flat2d = arr.reduce((accumulator, value) => accumulator.concat(value), [])
  const flat1d = flat2d.reduce((accumulator, value) => accumulator.concat(value), [])
  const obj: flatArr = {
    name: name,
    data: new Float32Array(flat1d),
    x: arr.length, y:arr[0].length , z: arr[0][0].length
  }
  return obj;
}

export class Shader {
  shader: WebGLShader;
  fields: Array<flatArr>;

  constructor(type: number, sources: Array<string>, fields: Array<string>) {
    this.shader = gl.createShader(type);
    this.fields = [];
    let fullSource = '#version 300 es\n' +
        'precision highp float;\n';
    for (let field of fields){
      // @ts-ignore
      const fieldObj = toFlatArr(field);
      console.log('data size', fieldObj.data.length)
      fullSource += `uniform float u_${field}Field[${fieldObj.x * fieldObj.y * fieldObj.z}];\n` +
                    `uniform vec3 u_${field}FieldDims;\n`
      // @ts-ignore
      this.fields.push(fieldObj);
    }
    for (let partialSource of sources){
      fullSource += partialSource;
    }
    //console.log(fullSource);
    gl.shaderSource(this.shader, fullSource);
    gl.compileShader(this.shader);

    if (!gl.getShaderParameter(this.shader, gl.COMPILE_STATUS)) {
      throw gl.getShaderInfoLog(this.shader);
    }
  }
};

class ShaderProgram {
  prog: WebGLProgram;

  attrPos: number;
  attrNor: number;
  attrCol: number;

  unifModel: WebGLUniformLocation;
  unifModelInvTr: WebGLUniformLocation;
  unifViewProj: WebGLUniformLocation;
  unifColor: WebGLUniformLocation;
  unifNoiseColor: WebGLUniformLocation;
  unifTime: WebGLUniformLocation;
  unifNoiseHeight: WebGLUniformLocation;

  unifCenter: WebGLUniformLocation;

  unifRef: WebGLUniformLocation;
  unifEye: WebGLUniformLocation;
  unifUp: WebGLUniformLocation;
  unifDimensions: WebGLUniformLocation;

  unifRows: WebGLUniformLocation;
  unifTriScale: WebGLUniformLocation;
  unifLowTriRange: WebGLUniformLocation;
  unifHighTriRange: WebGLUniformLocation;
  unifHightT: WebGLUniformLocation;
  unifSymbolScaleT: WebGLUniformLocation;
  unifSymbolPositionT: WebGLUniformLocation;

  constructor(shaders: Array<Shader>) {
    this.prog = gl.createProgram();



    for (let shader of shaders) {
      gl.attachShader(this.prog, shader.shader);
    }
    gl.linkProgram(this.prog);
    if (!gl.getProgramParameter(this.prog, gl.LINK_STATUS)) {
      throw gl.getProgramInfoLog(this.prog);
    }

    this.attrPos = gl.getAttribLocation(this.prog, "vs_Pos");
    this.attrNor = gl.getAttribLocation(this.prog, "vs_Nor");
    this.attrCol = gl.getAttribLocation(this.prog, "vs_Col");
    this.unifModel      = gl.getUniformLocation(this.prog, "u_Model");
    this.unifModelInvTr = gl.getUniformLocation(this.prog, "u_ModelInvTr");
    this.unifViewProj   = gl.getUniformLocation(this.prog, "u_ViewProj");
    this.unifColor      = gl.getUniformLocation(this.prog, "u_Color");
    this.unifNoiseColor = gl.getUniformLocation(this.prog, "u_NoiseColor");
    this.unifTime       = gl.getUniformLocation(this.prog, "u_Time");
    this.unifNoiseHeight = gl.getUniformLocation(this.prog, "u_NoiseHeight");
    this.unifCenter     = gl.getUniformLocation(this.prog, "u_Center");
    this.unifEye   = gl.getUniformLocation(this.prog, "u_Eye");
    this.unifRef   = gl.getUniformLocation(this.prog, "u_Ref");
    this.unifUp   = gl.getUniformLocation(this.prog, "u_Up");
    this.unifDimensions   = gl.getUniformLocation(this.prog, "u_Dimensions");

    this.unifRows  = gl.getUniformLocation(this.prog, "u_Rows");
    this.unifTriScale = gl.getUniformLocation(this.prog, "u_TriScale");
    this.unifLowTriRange = gl.getUniformLocation(this.prog, "u_LowTriRange");
    this.unifHighTriRange = gl.getUniformLocation(this.prog, "u_HighTriRange");
    this.unifHightT = gl.getUniformLocation(this.prog, "u_HeightT");
    this.unifSymbolScaleT = gl.getUniformLocation(this.prog, "u_SymbolScaleT");
    this.unifSymbolPositionT = gl.getUniformLocation(this.prog, "u_SymbolPositionT");




    this.use();
    for (let shader of shaders) {
      console.log(shader);
      for(let field of shader.fields){

        const shaderF = gl.getUniformLocation(this.prog, `u_${field.name}Field`);
        const shaderFDims   = gl.getUniformLocation(this.prog, `u_${field.name}FieldDims`);

        gl.uniform1fv(shaderF, field.data);
        gl.uniform3f(shaderFDims, field.x, field.y, field.z);
      }
    }



  }

  setRows(t: number){this.use();gl.uniform1f(this.unifRows, t)}
  setTriScale(t: number){this.use();gl.uniform1f(this.unifTriScale, t)}
  setLowTriRange(t: number){this.use();gl.uniform1f(this.unifLowTriRange, t)}
  setHighTriRange(t: number){this.use();gl.uniform1f(this.unifHighTriRange, t)}
  setHightT(t: number){this.use();gl.uniform1f(this.unifHightT, t)}
  setSymbolScaleT(t: number){this.use();gl.uniform1f(this.unifSymbolScaleT, t)}
  setSymbolPositionT(t: number){this.use();gl.uniform1f(this.unifSymbolPositionT, t)}

  use() {
    if (activeProgram !== this.prog) {
      gl.useProgram(this.prog);
      activeProgram = this.prog;
    }
  }
  setTime(t: number){
    this.use();
    if(this.unifTime !== -1){
      gl.uniform1f(this.unifTime, t);
    }
  }
  setNoiseHeight(h: number){
    this.use();
    if(this.unifNoiseHeight !== -1){
      gl.uniform1f(this.unifNoiseHeight, h);
    }
  }
  setEyeRefUp(eye: vec3, ref: vec3, up: vec3) {
    this.use();
    if(this.unifEye !== -1) {
      gl.uniform3f(this.unifEye, eye[0], eye[1], eye[2]);
    }
    if(this.unifRef !== -1) {
      gl.uniform3f(this.unifRef, ref[0], ref[1], ref[2]);
    }
    if(this.unifUp !== -1) {
      gl.uniform3f(this.unifUp, up[0], up[1], up[2]);
    }
  }

  setDimensions(width: number, height: number) {
    this.use();
    if(this.unifDimensions !== -1) {
      gl.uniform2f(this.unifDimensions, width, height);
    }
  }

  setModelMatrix(model: mat4) {
    this.use();
    if (this.unifModel !== -1) {
      gl.uniformMatrix4fv(this.unifModel, false, model);
    }

    if (this.unifModelInvTr !== -1) {
      let modelinvtr: mat4 = mat4.create();
      mat4.transpose(modelinvtr, model);
      mat4.invert(modelinvtr, modelinvtr);
      gl.uniformMatrix4fv(this.unifModelInvTr, false, modelinvtr);
    }
  }

  setViewProjMatrix(vp: mat4) {
    this.use();
    if (this.unifViewProj !== -1) {
      gl.uniformMatrix4fv(this.unifViewProj, false, vp);
    }
  }

  setGeometryColor(color: vec4) {
    this.use();
    if (this.unifColor !== -1) {
      gl.uniform4fv(this.unifColor, color);
    }
  }

  setNoiseColor(color: vec4) {
    this.use();
    if (this.unifNoiseColor !== -1) {
      gl.uniform4fv(this.unifNoiseColor, color);
    }
  }
  draw(d: Drawable) {
    this.use();

    if (this.attrPos != -1 && d.bindPos()) {
      gl.enableVertexAttribArray(this.attrPos);
      gl.vertexAttribPointer(this.attrPos, 4, gl.FLOAT, false, 0, 0);
    }

    if (this.attrNor != -1 && d.bindNor()) {
      gl.enableVertexAttribArray(this.attrNor);
      gl.vertexAttribPointer(this.attrNor, 4, gl.FLOAT, false, 0, 0);
    }

    d.bindIdx();
    gl.drawElements(d.drawMode(), d.elemCount(), gl.UNSIGNED_INT, 0);

    if (this.attrPos != -1) gl.disableVertexAttribArray(this.attrPos);
    if (this.attrNor != -1) gl.disableVertexAttribArray(this.attrNor);
  }
  drawLine(d: Drawable) {
    this.use();

    if (this.attrPos != -1 && d.bindPos()) {
      gl.enableVertexAttribArray(this.attrPos);
      gl.vertexAttribPointer(this.attrPos, 4, gl.FLOAT, false, 0, 0);
    }

    if (this.attrNor != -1 && d.bindNor()) {
      gl.enableVertexAttribArray(this.attrNor);
      gl.vertexAttribPointer(this.attrNor, 4, gl.FLOAT, false, 0, 0);
    }

    d.bindIdx();
    gl.drawElements(gl.LINE_LOOP, d.elemCount(), gl.UNSIGNED_INT, 0);

    if (this.attrPos != -1) gl.disableVertexAttribArray(this.attrPos);
    if (this.attrNor != -1) gl.disableVertexAttribArray(this.attrNor);
  }
};

export default ShaderProgram;
