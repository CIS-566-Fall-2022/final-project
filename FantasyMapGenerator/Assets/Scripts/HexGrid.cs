using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public class HexGrid : MonoBehaviour
{

    public int width = 10;
    public int height = 10;
	public bool is_grid_collapsed = false;
	public int collapsedCellCount = 0;
	public int max_retries = 0;

	public HexCell cellPrefab;

    public HexCell[] cells;
	public List<TileInterface> tile_prefabs;

	public System.Random rng_engine = new System.Random();

	public int[] feature_coverage;

	void Awake()
	{
		// create new hecx prefabs spanning the grid
		cells = new HexCell[height * width];
		feature_coverage = new int[4]{ 0, 0, 0, 0 };
	}

	public void updateCoverage(TileInterface tile)
    {	
		HexMetrics.TerrainFeature feature = tile.edge_map.Values
												.GroupBy(i => i)
												.GroupBy(g => g.Count())
												.OrderByDescending(g => g.Key)
												.First()
												.Select(g => g.Key)
												.ToArray()[0];

		feature_coverage[(int)feature] = feature_coverage[(int)feature] + 1;
	}

	public void resetGrid(TileInterface[] t_prefabs)
    {
		this.collapsedCellCount = 0;
		this.is_grid_collapsed = false;

		this.tile_prefabs = new List<TileInterface>();
		foreach (TileInterface t in t_prefabs)
		{
			this.tile_prefabs.Add(t);
		}

		for (int z = 0, i = 0; z < height; z++)
		{
			for (int x = 0; x < width; x++)
			{
				// create cell and set the position of this instance
				ResetCell(x, z, i++);
			}
		}
	}

	public void SetupGrid(TileInterface[] t_prefabs)
	{
		this.tile_prefabs = new List<TileInterface>();
		foreach (TileInterface t in t_prefabs)
		{
			this.tile_prefabs.Add(t);
        }
        //Debug.Log("Grid Tile Prefabs Length: " + this.tile_prefabs.Count);

    for (int z = 0, i = 0; z < height; z++)
		{
			for (int x = 0; x < width; x++)
			{
				// create cell and set the position of this instance
				CreateCell(x, z, i++);
			}
		}
    }

	public void ResetCell(int x, int z, int i)
	{
		// cells[i].setTilePrefabs(this.tile_prefabs);
		cells[i].resetCell(tile_prefabs);
	}

	public void CreateCell(int x, int z, int i)
	{
		Vector3 position;
		
		position.y = 0f;
		position.z = z * (HexMetrics.outer_radius * 1.5f);
		position.x = (x + z * 0.5f - z / 2) * (HexMetrics.inner_radius * 2f);
        //position.z = z * 2f;
        //position.x = x * 2f;

        HexCell cell = cells[i] = Instantiate<HexCell>(cellPrefab);
        //cell.x = x - z / 2;
        //cell.x = x - (z - (z & 1)) / 2;
        cell.x = x;
        cell.z = z;
		cell.transform.SetParent(transform, false);
		cell.transform.localPosition = position;
    cell.transform.rotation = Quaternion.AngleAxis(90, Vector3.right);
		cells[i].setTilePrefabs(this.tile_prefabs);
		cell.entropy = this.tile_prefabs.Count;
		
	}

	public List<HexCell> getCellsWithMinEntropy()
	{
		List<HexCell> cells_with_min_entropy = new List<HexCell>();
		int min_entropy = 100000000;
		for (int i = 0; i < this.height * this.width; i++)
		{
			if (cells[i].entropy < min_entropy && !cells[i].is_cell_collapsed)
			{
				min_entropy = cells[i].entropy;
			}
		}
		//Debug.Log("Min entropy: " + min_entropy);
		for (int i = 0; i < this.height * this.width; i++)
		{
			if (cells[i].entropy == min_entropy && !cells[i].is_cell_collapsed)
			{
				//Debug.Log("Cell to Collapse: (" + cells[i].x + ", " + cells[i].z + ")");
				cells_with_min_entropy.Add(cells[i]);
			}
		}
		return cells_with_min_entropy;
	}
	
	public TileInterface pickTileToInstantiate(HexCell cell)
  {
		if (cell.available_tiles.Count == 0)
		{
			// Debug.Log("=================== No Tiles for Cell + (" + cell.x + ", " + cell.z + ")  :( ==================");
			this.collapsedCellCount++;
			cell.is_cell_collapsed = true;
			return null;
		}

		// Debug.Log("=================== Picking Tile for Cell + (" + cell.x + ", " + cell.z + ") ==================");

		Vector2 cell_pos = new Vector2(cell.x, cell.z);

		TileInterface potential_tile = null;
		bool can_place_tile = true;

		this.max_retries = cell.available_tiles.Count;
		// Debug.Log("Cell + (" + cell.x + ", " + cell.z + ") : " + "Available tile count = " + this.max_retries );
		int num_cur_retry = 0;

		do
		{
      potential_tile = getRandomTileBasedOnWeight_2(cell);
      
			//Random.seed = System.DateTime.Now.Millisecond;
			//potential_tile = cell.available_tiles[Random.Range(0, cell.available_tiles.Count)];
			//potential_tile = cell.available_tiles[];

			foreach (HexMetrics.NeighborDirections dir in HexMetrics.neighbor_directions.Keys)
			{
				Vector2 neighbor_coord = HexMetrics.getNeighborOffset(dir, (int)cell_pos.y);
				neighbor_coord += cell_pos;

				if (neighbor_coord.x >= 0 && neighbor_coord.x < this.width && neighbor_coord.y >= 0 && neighbor_coord.y < this.height)
				{
					//Debug.Log("Cell Position Neighbor: " + hex_coord.x + " " + hex_coord.y);
					HexCell neighbor = this.cells[(int)neighbor_coord.x + (int)neighbor_coord.y * this.width];

					if (!neighbor.is_cell_collapsed)
					{
						if (!neighbor.neighboring_features[(int)potential_tile.edge_map[dir]] && neighbor.num_unique_neighboring_features == 2)
						{
							// Debug.Log(potential_tile.prefab.name + ", " + potential_tile.rotateAngle + " Rejected for Cell + (" + cell.x + ", " + cell.z + ")  :( ");
							can_place_tile = false;
							break;
						}
					}
				}
			}
			num_cur_retry++;
			//break ;
		}
		while (!can_place_tile && num_cur_retry < this.max_retries);

		if (num_cur_retry >= this.max_retries && !can_place_tile)
    {
			// Debug.Log("Couldn't find Tile to place for Cell + (" + cell.x + ", " + cell.z + ")  :( ");
			potential_tile = null;
      return null;
    }

		// Debug.Log("Picked Tile for Cell + (" + cell.x + ", " + cell.z + ") : " + potential_tile.prefab.name + ", " + potential_tile.rotateAngle);
		return potential_tile;
  }

  public TileInterface getRandomTileBasedOnWeight(HexCell cell)
  {
		TileInterface picked_tile = null;

    int total_weight = 0;
		foreach (TileInterface tile in cell.available_tiles)
    {
      total_weight += tile.prefab.weighting;
    }
  
    int rand_number = rng_engine.Next(1, total_weight + 1);
    int rand_accum = 0;
    foreach (TileInterface tile in cell.available_tiles)
    {
      if (tile.prefab.weighting + rand_accum < rand_number)
      {
        rand_accum += tile.prefab.weighting;
      }
      else
      {
        picked_tile = tile;
        break;
      }
    }

    if (rand_accum >= total_weight)
    {
      // Debug.Log("force picking last tile");
      picked_tile = cell.available_tiles.Last();
    }

    return picked_tile;
  }

	public TileInterface getRandomTileBasedOnWeight_2(HexCell cell)
	{

		int total_weight = 0;
		foreach (TileInterface tile in cell.available_tiles)
		{
			total_weight += tile.prefab.weighting;
		}

		int rand_number = rng_engine.Next(0, total_weight);
		foreach (TileInterface tile in cell.available_tiles)
		{
			if (rand_number < tile.prefab.weighting)
			{
				return tile;
			}
			else
			{
				rand_number -= tile.prefab.weighting;
			}
		}

		return null;
	}

	public void propagate(TileInterface t, Vector2 cell_pos)
    {
		foreach (HexMetrics.NeighborDirections dir in HexMetrics.neighbor_directions.Keys)
		{
			Vector2 hex_coord = HexMetrics.getNeighborOffset(dir, (int)cell_pos.y);
			hex_coord += cell_pos;

			if (hex_coord.x >= 0 && hex_coord.x < this.width && hex_coord.y >= 0 && hex_coord.y < this.height)
			{
				//Debug.Log("Cell Position Neighbor: " + hex_coord.x + " " + hex_coord.y);
				this.cells[(int)hex_coord.x + (int)hex_coord.y * this.width].updateEntropy(t, dir);
			}
		}
	}
  public bool checkPropagate(TileInterface t, Vector2 cell_pos)
  {
    bool can_propagate = true;
    List<HexCell> neighbors = new List<HexCell>();

		foreach (HexMetrics.NeighborDirections dir in HexMetrics.neighbor_directions.Keys)
		{
			Vector2 hex_coord = HexMetrics.getNeighborOffset(dir, (int)cell_pos.y);
			hex_coord += cell_pos;

			if (hex_coord.x >= 0 && hex_coord.x < this.width && hex_coord.y >= 0 && hex_coord.y < this.height)
			{
        int new_entropy = this.cells[(int)hex_coord.x + (int)hex_coord.y * this.width].checkIfCanUpdateEntropy(t, dir);

        if(new_entropy == 0)
        {
          can_propagate = false;
          break;
        }
			}
		}

    // foreach(HexCell neighbor in neighbors)
    // {
    //   HexMetrics.NeighborDirections dir = (HexMetrics.NeighborDirections)neighbors.IndexOf(neighbor);
    //   Debug.Log("Checking entropy for neighbor (" + neighbor.x + ", " + neighbor.y + ") in direction " + dir);
    //   int new_entropy = neighbor.checkIfCanUpdateEntropy(t, dir);

    //     if(new_entropy == 0)
    //     {
    //       can_propagate = false;
    //       break;
    //     }
    // }
    
    return can_propagate;
	}

	public bool checkIfGridIsCollapsed()
    {
		return collapsedCellCount == height * width;

	}
}
