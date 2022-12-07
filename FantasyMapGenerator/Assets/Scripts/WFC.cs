using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class WFC : MonoBehaviour
{

    public HexGrid grid;
    public SelectionManager seedManager;
    public TileInterface tile_interface;
    public Tile[] original_tile_prefabs;
    public TileInterface[] tile_prefabs;
    public int num_seeds = 0;
    public int cur_iter = 0;
    public bool restart_button = false;
    public bool clear_button = false;
    public bool done = false;

    // Start is called before the first frame update
    void Start()
    {

        
        generateTilesWithRotation();
        resetTileWeights();
        generateTileEdgeData();
        this.grid.SetupGrid(tile_prefabs);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyUp(KeyCode.Return))
        {
            if (seedManager.getSeeds().Count == 0)
            {
              generateSeeds();
              // generateTestSeeds();
            }
            else {
              propagateSeeds();
            }

            InvokeRepeating("performWFC2", 1.0f, 0.0005f);
        }

        if (restart_button)
        {
            CancelInvoke();
            resetWFC();

            if (seedManager.getSeeds().Count == 0)
            {
              generateSeeds();
            }
            else {
              setSeeds();
              propagateSeeds();
            }

            InvokeRepeating("performWFC2", 1.0f, 0.0005f);

            restart_button = false;
        }
        else if (clear_button)
        {
            CancelInvoke();
            seedManager.clearSeeds();
            resetWFC();
            clear_button = false;
        }
        else
        {
            List<HexCell> cells_to_collapse = this.grid.getCellsWithMinEntropy();

            if (cells_to_collapse.Count == 0)
            {
                CancelInvoke();

                //if (!done)
                //{
                //    Debug.Log("Coverage:");
                //    for (int i = 0; i < this.grid.feature_coverage.Length; ++i)
                //    {
                //        Debug.Log(i + ": " + this.grid.feature_coverage[i]);
                //    }
                //    done = true;
                //}
            }
        }
    }

    public void setSeedNumber(int new_numSeeds)
    {
        this.num_seeds = new_numSeeds;
    }

    public void resetTileWeights()
    {
        foreach (Tile ta in original_tile_prefabs)
        {
            ta.weighting = 1;
        }

        // land
        setTileWeight(0, 147);

        // water
        setTileWeight(6, 134);

        // coast
        setTileWeight(12, 2);
        setTileWeight(18, 2);
        setTileWeight(24, 2);
        setTileWeight(30, 2);
        setTileWeight(36, 2);

        // mountain
        setTileWeight(42, 15);

        // forest
        setTileWeight(78, 15);

        // rivers
        setTileWeight(114, 1);
        setTileWeight(120, 1);
    }


    public void setTileWeight(int tile_ID, int tile_weight)
    {
        for (int i = 0; i < 6; ++i)
        {
            this.tile_prefabs[tile_ID + i].prefab.weighting = tile_weight;
        }
    }

    void resetWFC()
    {
        this.cur_iter = 0;
        this.grid.resetGrid(this.tile_prefabs);
    }

    public void initiateRestart()
    {
        if (!restart_button)
        {
            restart_button = true;
        }
    }

    public void initiateClear()
    {
        if (!clear_button)
        {
            clear_button = true;
        }
    }

    void generateTilesWithRotation()
    {
        for (int i = 0; i < original_tile_prefabs.Length; ++i)
        {
            List<TileInterface> new_tiles;
            new_tiles = original_tile_prefabs[i].GenerateRotatedTiles(tile_interface);
            tile_prefabs = tile_prefabs.Concat(new_tiles.ToArray()).ToArray();
        }
    }

    void generateTileEdgeData()
    {
        
        for (int i = 0; i < tile_prefabs.Length; ++i)
        {
            tile_prefabs[i].GenerateTileEdgeFeatures();
            
        }
    }

    void generateTestSeeds()
    {
      HexCell seed1 = this.grid.cells[0 + 2 * this.grid.width];
      TileInterface t1 = this.grid.tile_prefabs[84];
      seed1.collapseCell(t1);

      HexCell seed2 = this.grid.cells[1 + 2 * this.grid.width];
      TileInterface t2 = this.grid.tile_prefabs[14];
      seed2.collapseCell(t2);

      HexCell seed3 = this.grid.cells[1 + 1 * this.grid.width];
      TileInterface t3 = this.grid.tile_prefabs[23];
      seed3.collapseCell(t3);

      HexCell seed4 = this.grid.cells[1 + 0 * this.grid.width];
      TileInterface t4 = this.grid.tile_prefabs[93];
      seed4.collapseCell(t4);

      this.grid.propagate(t1, seed1.getPosition());
      this.grid.propagate(t2, seed2.getPosition());
      this.grid.propagate(t3, seed3.getPosition());
      this.grid.propagate(t4, seed4.getPosition());

    }

    void generateSeeds()
    {
        for (int i = 0; i < num_seeds; ++i)
        {
            bool can_use_seed = true;

            Vector2 this_cell_pos = new Vector2(Random.Range(0, this.grid.width - 1), Random.Range(0, this.grid.height - 1));
            //Vector2 this_cell_pos = new Vector2(2, 2);
            //Debug.Log("Seed Position: " + this_cell_pos.x + " " + this_cell_pos.y);
            HexCell seedCell = this.grid.cells[(int)this_cell_pos.x + (int)this_cell_pos.y * this.grid.width];

            int retries = 10;
            while (!seedCell.is_cell_collapsed)
            {
                //int rand_index = Random.Range(0, seedCell.available_tiles.Count - 1);
                //int rand_index = 13;
                //TileInterface t = seedCell.available_tiles[rand_index];

                TileInterface t = this.grid.getRandomTileBasedOnWeight_2(seedCell);
                //Debug.Log("Tile Selected as Seed: " + rand_index);

                can_use_seed = this.grid.checkPropagate(t, this_cell_pos);
                // Debug.Log("can use tile : " + t.prefab.name + " at (" + this_cell_pos.x + ", " + this_cell_pos.y + ") ? " + can_use_seed);

                if(can_use_seed)
                {
                    
                  // collapse cell
                  seedCell.collapseCell(t);
                  this.grid.updateCoverage(t);
                  this.grid.collapsedCellCount++;

                  // propogate entropy
                  this.grid.propagate(t, this_cell_pos);
                }

                retries--;
                if (retries == 0)
                {
                  break;
                }
            }
        }
    }

    void setSeeds()
    {
      TileInterface t = tile_prefabs[0];
      foreach(SeedCell seedCell in seedManager.getSeeds())
      {
          this.grid.collapsedCellCount++;

          if(seedCell.feature == HexMetrics.TerrainFeature.Water)
              t = tile_prefabs[0];
          else if(seedCell.feature == HexMetrics.TerrainFeature.Land)
              t = tile_prefabs[6];
          else if(seedCell.feature == HexMetrics.TerrainFeature.Mountain)
              t = tile_prefabs[42];
          else if(seedCell.feature == HexMetrics.TerrainFeature.Forest)
              t = tile_prefabs[78];

          seedCell.cell.collapseCell(t);
      }
    }

    void propagateSeeds()
    {
      TileInterface t = tile_prefabs[0];
      foreach(SeedCell seedCell in seedManager.getSeeds())
      {
          this.grid.collapsedCellCount++;

          if(seedCell.feature == HexMetrics.TerrainFeature.Water)
              t = tile_prefabs[0];
          else if(seedCell.feature == HexMetrics.TerrainFeature.Land)
              t = tile_prefabs[6];
          else if(seedCell.feature == HexMetrics.TerrainFeature.Mountain)
              t = tile_prefabs[42];
          else if(seedCell.feature == HexMetrics.TerrainFeature.Forest)
              t = tile_prefabs[78];

          this.grid.propagate(t, seedCell.cell.getPosition());
      }
    }

    void performWFC()
    {
        //while (!this.grid.is_grid_collapsed)
        //for(int i = 0; i < (int)(this.grid.height * this.grid.width); i++)
        //{
            //Debug.Log("============== LOOP " + i + " =============");
            // get cells with the minimum entropy this iteration

        List<HexCell> cells_to_collapse = this.grid.getCellsWithMinEntropy();
        //Debug.Log("Cells to collapse: " + cells_to_collapse.Count);

        if (cells_to_collapse.Count == 0)
            return;

        
        foreach (HexCell cell in cells_to_collapse)
        {
            // pick tile based on rules and neighbors
            TileInterface tile_to_instantiate = this.grid.pickTileToInstantiate(cell);

            if (tile_to_instantiate == null)
            {
                cell.collapseCell(this.grid.tile_prefabs[0]);
            }
            else
            {
                // collapse each cell
                cell.collapseCell(tile_to_instantiate);
            }

            this.grid.collapsedCellCount++;

            // propogate entropy decrease to neighbors
            this.grid.propagate(tile_to_instantiate, cell.getPosition());
        }
        this.grid.checkIfGridIsCollapsed();
        cur_iter++;
        //}
    }

    void performWFC2()
    {
        //while (!this.grid.is_grid_collapsed)
        //for(int i = 0; i < (int)(this.grid.height * this.grid.width); i++)
        //{
        //Debug.Log("============== LOOP " + i + " =============");
        // get cells with the minimum entropy this iteration


        List<HexCell> cells_to_collapse = this.grid.getCellsWithMinEntropy();
        //Debug.Log("Cells to collapse: " + cells_to_collapse.Count);

        if (cells_to_collapse.Count == 0)
        {
            return;
        }

        foreach (HexCell cell in cells_to_collapse)
        {
            int retries = 100;
            // while (!cell.is_cell_collapsed)
            while (!cell.is_cell_collapsed && retries > 0)
            {
                // pick tile based on rules and neighbors
                TileInterface tile_to_instantiate = this.grid.pickTileToInstantiate(cell);

                if (tile_to_instantiate == null)
                    break;

                bool can_propagate = this.grid.checkPropagate(tile_to_instantiate, cell.getPosition());
                // Debug.Log("can use tile : " + tile_to_instantiate.prefab.name + " with angle " + tile_to_instantiate.rotateAngle + " at (" + cell.getPosition().x + ", " + cell.getPosition().y + ") ? " + can_propagate);

                if (can_propagate)
                {
                    // collapse each cell
                    cell.collapseCell(tile_to_instantiate);
                    this.grid.updateCoverage(tile_to_instantiate);
                    this.grid.collapsedCellCount++;

                    // propogate entropy decrease to neighbors
                    this.grid.propagate(tile_to_instantiate, cell.getPosition());
                }

                retries--;
                if(retries == 0)
                {
                  cell.entropy = 99999;
                  break;
                }
            }
        }
        this.grid.checkIfGridIsCollapsed();
        cur_iter++;
        //}
    }

    void testFillGrid()
    {
        while (!this.grid.is_grid_collapsed)
        {
            foreach(HexCell cell in this.grid.cells)
            {
                if(!cell.is_cell_collapsed)
                    cell.collapseCell(tile_prefabs[4]);
                    //cell.collapseCell(tile_prefabs[Random.Range(0, tile_prefabs.Length - 1)]);
            }
            this.grid.is_grid_collapsed = true;
        }
    }

    void testAllTiles()
    {
        for (int i = 0; i < tile_prefabs.Length; ++i)
        {
            this.grid.cells[i].collapseCell(tile_prefabs[i]);
        }
    }
}
