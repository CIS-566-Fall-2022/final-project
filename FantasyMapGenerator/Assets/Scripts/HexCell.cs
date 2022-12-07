using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class HexCell : MonoBehaviour
{

    public bool is_cell_collapsed = false;
    public int entropy;
    public Tile tile;
    public int x;
    public int z;
    public List<bool> neighboring_features;
    public int num_unique_neighboring_features;

    public List<TileInterface> available_tiles; // tiles available to be placed in this cell

    public Vector2 getPosition()
    {
        return new Vector2(x, z);
    }

    // Start is called before the first frame update
    void Start()
    {
		    this.gameObject.layer = LayerMask.NameToLayer("Cell");
    }

    void Awake()
    {
        initializeNeighboringFeatures();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void initializeNeighboringFeatures()
    {
        neighboring_features = new List<bool>();
        foreach (HexMetrics.TerrainFeature feat in System.Enum.GetValues(typeof(HexMetrics.TerrainFeature)))
        {
            neighboring_features.Add(false);
        }
        num_unique_neighboring_features = 0;
    }

    public void setTilePrefabs(List<TileInterface> t_prefabs)
    {
        this.available_tiles = new List<TileInterface>();
        foreach (TileInterface t in t_prefabs)
        {
            this.available_tiles.Add(t);
        }
    }

    public void resetCell(List<TileInterface> tile_prefabs)
    {
        this.setTilePrefabs(tile_prefabs);
        this.entropy = this.available_tiles.Count;
        if (this.tile != null)
        {
          Destroy(this.tile.gameObject);
        }
        this.tile = null;
        this.initializeNeighboringFeatures();
        this.is_cell_collapsed = false;
    }

    public void collapseCell(TileInterface t)
    {
        /*if (this.tile != null)
        {
          resetCell();
        }*/

        this.tile = Instantiate<Tile>(t.prefab);
        this.tile.transform.SetParent(transform, false);
        this.tile.transform.rotation = Quaternion.AngleAxis(-90 + t.rotateAngle, Vector3.up);
        this.is_cell_collapsed = true;
        this.entropy = 1000000;
    }
    
    public bool fillCell(Tile t)
    {
        if (this.tile != null) return false;

        this.tile = Instantiate<Tile>(t);
        this.tile.transform.SetParent(transform, false);
        this.tile.transform.rotation = Quaternion.AngleAxis(-90, Vector3.up);
        this.is_cell_collapsed = true;
        this.entropy = 1000000;

        return true;
    }

    public void removeCell()
    {
      Destroy(this.tile.gameObject);
      this.tile = null;
      this.is_cell_collapsed = false;
      this.entropy = this.available_tiles.Count;
    }

    public void updateEntropy(TileInterface t, HexMetrics.NeighborDirections dir)
    {
        if (this.is_cell_collapsed)
            return;

        HexMetrics.TerrainFeature this_edge_feature_constraint = t.edge_map[dir];

        if (!neighboring_features[(int)this_edge_feature_constraint])
        {
            neighboring_features[(int)this_edge_feature_constraint] = true;
            num_unique_neighboring_features++;
        }

        this.available_tiles.RemoveAll(tile => tile.edge_map[HexMetrics.inverse_neighbor_dir[dir]] != this_edge_feature_constraint);
        this.entropy = this.available_tiles.Count;
    }

    public int checkIfCanUpdateEntropy(TileInterface t, HexMetrics.NeighborDirections dir)
    {
        if (this.is_cell_collapsed)
        {
            // Debug.Log("this neighbor is collapsed!");
            return -1;
        }

        HexMetrics.TerrainFeature this_edge_feature_constraint = t.edge_map[dir];
        // Debug.Log("Checking for : " + this_edge_feature_constraint + ", in seed's direction : " + dir);

        // List<TileInterface> copy_list = new List<TileInterface>(this.available_tiles);

        int tiles_left = this.available_tiles.Count(tile => tile.edge_map[HexMetrics.inverse_neighbor_dir[dir]] == this_edge_feature_constraint);
        // Debug.Log("Old entropy for cell (" + this.x + ", " + this.z + ") = " + this.available_tiles.Count);
        // Debug.Log("New entropy for cell (" + this.x + ", " + this.z + ") = " + tiles_left);

        if (tiles_left == 0)
        {
          foreach(TileInterface tile in this.available_tiles)
          {
            // Debug.Log("From AT list: " + tile.prefab.name +", " + tile.rotateAngle);
          }
        }

        
        return tiles_left;
    }
}
