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
            12, 14, 15,
            // extra
            16, 17, 18,
            19, 20, 21, 19, 20, 22
        ]);
        const dataLen = ((3*4+4)*4) + (3*4);
        this.positions = new Float32Array(dataLen);
        let positionsOrig = new Float32Array([

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

        this.positions.set(positionsOrig, 0);

        this.normals = new Float32Array(dataLen);
        let i_norm = 0;
        for(let i = 0; i < 4*3*4; i+=(3*4)){
            const p1 = vec3.fromValues(this.positions[i], this.positions[i+1], this.positions[i+2]);
            const p2 = vec3.fromValues(this.positions[i+4], this.positions[i+5], this.positions[i+6]);
            const p3 = vec3.fromValues(this.positions[i+8], this.positions[i+9], this.positions[i+10]);

            let e1 = vec3.sub(vec3.create(), p2, p1);
            let e2 = vec3.sub(vec3.create(), p3, p2);
            let norm = vec3.cross(vec3.create(), e1, e2);
            norm = vec3.normalize(vec3.create(), norm);
            for(let j=0; j<3; j++){
                this.normals[i_norm] = norm[0];
                this.normals[i_norm+1] = norm[1];
                this.normals[i_norm+2] = norm[2];
                this.normals[i_norm+3] = 0;
                i_norm += 4;
            }

        }
        for(let j=0; j<4 ; j++){
            this.normals[i_norm] = 0;
            this.normals[i_norm+1] = -1;
            this.normals[i_norm+2] = 0;
            this.normals[i_norm+3] = 0;
            i_norm += 4;
        }


        // new extruded point
        let oi_idx = i_norm;
        for(let j=0; j<3 ; j++){


            this.positions[i_norm] = this.positions[j*4] + (this.normals[j*4] * 1) ;
            this.positions[i_norm+1] = this.positions[j*4+1] + (this.normals[j*4+1] * 1);
            this.positions[i_norm+2] = this.positions[j*4+2] + (this.normals[j*4+2] * 1);
            this.positions[i_norm+3] = 1;
            i_norm += 4;
        }
        i_norm = oi_idx;
        for(let j=0; j<3 ; j++){
            this.normals[i_norm] = this.normals[j*4];
            this.normals[i_norm+1] = this.normals[j*4+1];
            this.normals[i_norm+2] = this.normals[j*4+2];
            this.normals[i_norm+3] = 0;
            i_norm += 4;
        }
        oi_idx = i_norm;
        for(let j=0; j<3 ; j++){

            this.positions[i_norm] = this.positions[j*4] + (this.normals[j*4] * 1) ;
            this.positions[i_norm+1] = this.positions[j*4+1] + (this.normals[j*4+1] * 1);
            this.positions[i_norm+2] = this.positions[j*4+2] + (this.normals[j*4+2] * 1);
            this.positions[i_norm+3] = 1;
            i_norm += 4;
        }
        console.log(this.positions)


//
// this.normals = new Float32Array([
//         // front
//         0, 0, 1, 0,
//         0, 0, 1, 0,
//         0, 0, 1, 0,
//         // right
//          1, 0, 0, 0,
//          1, 0, 0, 0,
//          1, 0, 0, 0,
//         // back
//          0, 0, -1, 0,
//          0, 0, -1, 0,
//          0, 0, -1, 0,
//         // left
//          -1, 0, 0, 0,
//          -1, 0, 0, 0,
//          -1, 0, 0, 0,
//
//         // bottom
//          0, -1, 0, 0,
//          0, -1, 0, 0,
//          0, -1, 0, 0,
//          0, -1, 0, 0
//       ]);
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
