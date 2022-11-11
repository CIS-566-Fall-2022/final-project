using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexGrid : MonoBehaviour
{

    public int width = 10;
    public int height = 10;
	public bool is_grid_collapsed = false;

	public HexCell cellPrefab;

    public HexCell[] cells;

	void Awake()
	{
		// create new hecx prefabs spanning the grid
		cells = new HexCell[height * width];

		for (int z = 0, i = 0; z < height; z++)
		{
			for (int x = 0; x < width; x++)
			{

				// create cell and set the position of this instance
				CreateCell(x, z, i++);
			}
		}
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
		cell.x = x;
		cell.z = z;
		cell.transform.SetParent(transform, false);
		cell.transform.localPosition = position;
		//cell.entropy = cellPrefab.Length;
		
	}

	public List<HexCell> getCellsWithMinEntropy()
	{
		List<HexCell> cells_with_min_entropy = new List<HexCell>();
		int min_entropy = 100000000;
		for (int i = 0; i < this.height * this.width; ++i)
		{
			if (cells[i].entropy < min_entropy)
			{
				min_entropy = cells[i].entropy;
			}
		}
		for (int i = 0; i < this.height * this.width; ++i)
		{
			if (cells[i].entropy == min_entropy)
			{
				cells_with_min_entropy.Add(cells[i]);
			}
		}
		return cells_with_min_entropy;
	}

	public Tile pickTileToInstantiate(HexCell cell)
    {
		return new Tile();
    }
}
