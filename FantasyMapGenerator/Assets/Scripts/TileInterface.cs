using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileInterface : MonoBehaviour
{
    public Tile prefab;
    public Dictionary<HexMetrics.NeighborDirections, HexMetrics.TerrainFeature> edge_map = new Dictionary<HexMetrics.NeighborDirections, HexMetrics.TerrainFeature>();
    public int rotateAngle = 0;
    public int id;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void GenerateTileEdgeFeatures()
    {
        
        foreach (HexMetrics.NeighborDirections dir in HexMetrics.direction_to_textureUV.Keys)
        {

            HexMetrics.NeighborDirections remapped_dir = HexMetrics.remapDirectionWithAngle(dir, this.rotateAngle);
            //HexMetrics.NeighborDirections remapped_dir = dir;

            Vector2 uvs = HexMetrics.direction_to_textureUV[remapped_dir];
            Color color = ((Texture2D)prefab.GetComponent<Renderer>().sharedMaterial.mainTexture).GetPixel((int)uvs.x, (int)uvs.y);
            edge_map[dir] = HexMetrics.color_to_feature[color];

            //if (id == 13)
            //{
            //    Debug.Log("Dir: " + dir + " Remapped Dir: " + remapped_dir + " Feature: " + edge_map[dir]);
            //}
        }
    }


}
