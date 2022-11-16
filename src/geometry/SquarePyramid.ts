import {vec3, vec4} from 'gl-matrix';
import Drawable from '../rendering/gl/Drawable';
import {gl} from '../globals';

class SquarePyramid extends Drawable {
  indices: Uint32Array;
  positions: Float32Array;
  normals: Float32Array;
  center: vec4;

  constructor(center: vec3) {
    super(); // Call the constructor of the super class. This is required.
    this.center = vec4.fromValues(center[0], center[1], center[2], 1);
  }

  createTriangulate() {
    this.create();
    let idxCount: number = this.indices.length;
    

  }

  create() {
    this.indices = new Uint32Array([
      // front
      0, 1, 2,
      // right
      3, 4, 5,
      // back
      6, 7, 8,
      // left
      9, 10, 11,
      // bottom
      12, 13, 14,
      12, 14, 15
    ]);

this.normals = new Float32Array([
        // front
        0, 0, 1, 0,
        0, 0, 1, 0,
        0, 0, 1, 0,        
        // right
         1, 0, 0, 0,
         1, 0, 0, 0,
         1, 0, 0, 0,        
        // back
         0, 0, -1, 0,
         0, 0, -1, 0,
         0, 0, -1, 0,         
        // left
         -1, 0, 0, 0,
         -1, 0, 0, 0,
         -1, 0, 0, 0,         
        
        // bottom
         0, -1, 0, 0,
         0, -1, 0, 0,
         0, -1, 0, 0,
         0, -1, 0, 0
      ]);
this.positions = new Float32Array([
    // front
    this.center[0] - 1, this.center[1] - 1, this.center[2] + 1, 1,
    this.center[0] + 1, this.center[1] - 1, this.center[2] + 1, 1,
    this.center[0], this.center[1] + 1, this.center[2], 1,
    
    // right
    this.center[0] + 1, this.center[1] - 1, this.center[2] + 1, 1,
    this.center[0] + 1, this.center[1] - 1, this.center[2] - 1, 1,
    this.center[0], this.center[1] + 1, this.center[2], 1,
    
    // back
    this.center[0] - 1, this.center[1] - 1, this.center[2] - 1, 1,
    this.center[0] + 1, this.center[1] - 1, this.center[2] - 1, 1,
    this.center[0], this.center[1] + 1, this.center[2], 1,
    
    // left
    this.center[0] - 1, this.center[1] - 1, this.center[2] + 1, 1,
    this.center[0] - 1, this.center[1] - 1, this.center[2] - 1, 1,
    this.center[0], this.center[1] + 1, this.center[2], 1,
        
    // bottom
    this.center[0] + 1, this.center[1] - 1, this.center[2] + 1, 1,
    this.center[0] - 1, this.center[1] - 1, this.center[2] + 1, 1,
    this.center[0] - 1, this.center[1] - 1, this.center[2] - 1, 1,
    this.center[0] + 1, this.center[1] - 1, this.center[2] - 1, 1]);

    this.generateIdx();
    this.generatePos();
    this.generateNor();

    this.count = this.indices.length;
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.bufIdx);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, this.indices, gl.STATIC_DRAW);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.bufNor);
    gl.bufferData(gl.ARRAY_BUFFER, this.normals, gl.STATIC_DRAW);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.bufPos);
    gl.bufferData(gl.ARRAY_BUFFER, this.positions, gl.STATIC_DRAW);

    //console.log(`Created Cube`);
  }
};

export default SquarePyramid;
