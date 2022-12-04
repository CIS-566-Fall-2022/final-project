from mesh_to_sdf import mesh_to_voxels

import trimesh
import skimage

mesh = trimesh.load('pyramid.obj')

voxels = mesh_to_voxels(mesh, 8, pad=True)

import json

sdfs = {'pyramid': voxels.tolist()}

with open('src/rendering/gl/sdfs.json', 'w') as f:
    json.dump(sdfs, f)


# vertices, faces, normals, _ = skimage.measure.marching_cubes(voxels, level=0)
# mesh = trimesh.Trimesh(vertices=vertices, faces=faces, vertex_normals=normals)
# mesh.show()