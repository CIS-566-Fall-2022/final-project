using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tile : MonoBehaviour
{
    public int id;
    public int weighting = 1;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public List<TileInterface> GenerateRotatedTiles(TileInterface tile_interface)
    {
        List<TileInterface> tile_list = new List<TileInterface>();
        for (int i = 0; i < 6; ++i)
        {
            TileInterface new_tile = Instantiate<TileInterface>(tile_interface);
            new_tile.prefab = this;
            new_tile.rotateAngle = i * 60;
            new_tile.id = i + this.id * 6;
            tile_list.Add(new_tile);
        }
        return tile_list;
    }
}
