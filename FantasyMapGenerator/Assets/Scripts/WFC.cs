using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WFC : MonoBehaviour
{

    public HexGrid grid;
    public Tile[] tile_prefabs;
    public int num_seeds = 0;



    // Start is called before the first frame update
    void Start()
    {
        num_seeds = Random.Range(1, 5);
        generateSeeds();
        performWFC();
        //grid = gameObject.GetComponent(typeof(HexGrid)) as HexGrid;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void generateSeeds()
    {

        for (int i = 0; i < num_seeds; ++i)
        {
            this.grid.cells[i].collapseCell(tile_prefabs[Random.Range(0, tile_prefabs.Length)]);
            // propogate entropy
        }
    }

    void performWFC()
    {
        while (!this.grid.is_grid_collapsed)
        {
            for (int i = 0; i < this.grid.height * this.grid.width; ++i)
            {
                // get cells with the minimum entropy this iteration
                List<HexCell> cells_to_collapse = this.grid.getCellsWithMinEntropy();

                foreach (HexCell cell in cells_to_collapse)
                {
                    // pick tile based on rules and neighbors
                    Tile tile_to_instantiate = this.grid.pickTileToInstantiate(cell);



                    // collapse each cell
                    this.grid.cells[i].collapseCell(tile_to_instantiate);
                }

                // propogate entropy decrease to neighbors


            }
            this.grid.is_grid_collapsed = true;
        }
    }
}
