using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexMetrics : MonoBehaviour
{
	public const float outer_radius = 1f;
	public const float inner_radius = outer_radius * 0.866025404f;
	public enum NeighborDirections { Left, Right, Upper_Left, Upper_Right, Lower_Left, Lower_Right };

    public static Dictionary<NeighborDirections, Vector2> neighbor_directions = new Dictionary<NeighborDirections, Vector2>
    {
        //{ NeighborDirections.Left, new Vector2(-1, 0) },
        //{ NeighborDirections.Right, new Vector2(1, 0) },
        //{ NeighborDirections.Upper_Left, new Vector2(0, 1) },
        //{ NeighborDirections.Upper_Right, new Vector2(1, 1) },
        //{ NeighborDirections.Lower_Left, new Vector2(0, -1) },
        //{ NeighborDirections.Lower_Right, new Vector2(1, -1) },

        { NeighborDirections.Left, new Vector2(-1, 0) },
        { NeighborDirections.Right, new Vector2(1, 0) },
        { NeighborDirections.Upper_Left, new Vector2(-1, 1) },
        { NeighborDirections.Upper_Right, new Vector2(0, 1) },
        { NeighborDirections.Lower_Left, new Vector2(-1, -1) },
        { NeighborDirections.Lower_Right, new Vector2(0, -1) },
    };

    public static Dictionary<NeighborDirections, NeighborDirections> inverse_neighbor_dir = new Dictionary<NeighborDirections, NeighborDirections>
    {
        { NeighborDirections.Left, NeighborDirections.Right },
        { NeighborDirections.Right, NeighborDirections.Left },
        { NeighborDirections.Upper_Left, NeighborDirections.Lower_Right },
        { NeighborDirections.Upper_Right, NeighborDirections.Lower_Left },
        { NeighborDirections.Lower_Left, NeighborDirections.Upper_Right },
        { NeighborDirections.Lower_Right, NeighborDirections.Upper_Left },
    };


    public enum TerrainFeature { Water, Land, Mountain, Forest };

    public static Dictionary<Color, TerrainFeature> color_to_feature = new Dictionary<Color, TerrainFeature>
    {
        // { new Color(0.807843137254902f, 0.909803921568627f, 0.513725490196078f, 1f), TerrainFeature.Land },
        // { new Color(0.541176470588235f, 0.894117647058824f, 0.972549019607843f, 1f), TerrainFeature.Water },
        // { new Color(0.537254901960784f, 0.894117647058824f, 0.968627450980392f, 1f), TerrainFeature.Water },
        // { new Color(0.470588235294118f, 0.313725490196078f, 0.156862745098039f, 1f), TerrainFeature.Mountain },
        // { new Color(0.470588235294118f, 0.317647058823529f, 0.156862745098039f, 1f), TerrainFeature.Mountain },
        // { new Color(0.156862745098039f, 0.470588235294118f, 0.223529411764706f, 1f), TerrainFeature.Forest },

        { new Color(0.0f, 1.0f, 0.0f, 1.0f), TerrainFeature.Land },
        { new Color(0.0f, 0.0f, 1.0f, 1.0f), TerrainFeature.Water },
        { new Color(1.0f, 0.0f, 0.0f, 1.0f), TerrainFeature.Mountain },
        { new Color(1.0f, 1.0f, 0.0f, 1.0f), TerrainFeature.Forest },
    };

    public static Dictionary<NeighborDirections, Vector2> direction_to_textureUV = new Dictionary<NeighborDirections, Vector2>
    {
        { NeighborDirections.Left, new Vector2(51, 256) },
        { NeighborDirections.Right, new Vector2(460, 256) },
        { NeighborDirections.Upper_Left, new Vector2(153, 410) },
        { NeighborDirections.Upper_Right, new Vector2(384, 410) },
        { NeighborDirections.Lower_Left, new Vector2(153, 102) },
        { NeighborDirections.Lower_Right, new Vector2(384, 102) }
    };

    public static Vector2 getNeighborOffset(NeighborDirections dir, int z)
    {
        if(z%2 == 0)
        {
            return neighbor_directions[dir];
        }
        else
        {
            if (dir == NeighborDirections.Upper_Left || dir == NeighborDirections.Upper_Right
                || dir == NeighborDirections.Lower_Left || dir == NeighborDirections.Lower_Right)
            {
                return neighbor_directions[dir] + new Vector2(1, 0);
            }
            else
            {
                return neighbor_directions[dir];
            }
        }
    }

    public static NeighborDirections remapDirectionWithAngle(NeighborDirections dir, int angle)
    {
        NeighborDirections remapped_dir = NeighborDirections.Left;
        switch(dir)
        {
            case NeighborDirections.Left:
                switch(angle)
                {
                    case 0:
                        remapped_dir = dir;
                        break;
                    case 300:
                        remapped_dir = NeighborDirections.Upper_Left;
                        break;
                    case 240:
                        remapped_dir = NeighborDirections.Upper_Right;
                        break;
                    case 180:
                        remapped_dir = NeighborDirections.Right;
                        break;
                    case 120:
                        remapped_dir = NeighborDirections.Lower_Right;
                        break;
                    case 60:
                        remapped_dir = NeighborDirections.Lower_Left;
                        break;
                }
                break;
            case NeighborDirections.Upper_Left:
                switch (angle)
                {
                    case 0:
                        remapped_dir = dir;
                        break;
                    case 300:
                        remapped_dir = NeighborDirections.Upper_Right;
                        break;
                    case 240:
                        remapped_dir = NeighborDirections.Right;
                        break;
                    case 180:
                        remapped_dir = NeighborDirections.Lower_Right;
                        break;
                    case 120:
                        remapped_dir = NeighborDirections.Lower_Left;
                        break;
                    case 60:
                        remapped_dir = NeighborDirections.Left;
                        break;
                }
                break;
            case NeighborDirections.Upper_Right:
                switch (angle)
                {
                    case 0:
                        remapped_dir = dir;
                        break;
                    case 300:
                        remapped_dir = NeighborDirections.Right;
                        break;
                    case 240:
                        remapped_dir = NeighborDirections.Lower_Right;
                        break;
                    case 180:
                        remapped_dir = NeighborDirections.Lower_Left;
                        break;
                    case 120:
                        remapped_dir = NeighborDirections.Left;
                        break;
                    case 60:
                        remapped_dir = NeighborDirections.Upper_Left;
                        break;
                }
                break;
            case NeighborDirections.Right:
                switch (angle)
                {
                    case 0:
                        remapped_dir = dir;
                        break;
                    case 300:
                        remapped_dir = NeighborDirections.Lower_Right;
                        break;
                    case 240:
                        remapped_dir = NeighborDirections.Lower_Left;
                        break;
                    case 180:
                        remapped_dir = NeighborDirections.Left;
                        break;
                    case 120:
                        remapped_dir = NeighborDirections.Upper_Left;
                        break;
                    case 60:
                        remapped_dir = NeighborDirections.Upper_Right;
                        break;
                }
                break;
            case NeighborDirections.Lower_Right:
                switch (angle)
                {
                    case 0:
                        remapped_dir = dir;
                        break;
                    case 300:
                        remapped_dir = NeighborDirections.Lower_Left;
                        break;
                    case 240:
                        remapped_dir = NeighborDirections.Left;
                        break;
                    case 180:
                        remapped_dir = NeighborDirections.Upper_Left;
                        break;
                    case 120:
                        remapped_dir = NeighborDirections.Upper_Right;
                        break;
                    case 60:
                        remapped_dir = NeighborDirections.Right;
                        break;
                }
                break;
            case NeighborDirections.Lower_Left:
                switch (angle)
                {
                    case 0:
                        remapped_dir = dir;
                        break;
                    case 300:
                        remapped_dir = NeighborDirections.Left;
                        break;
                    case 240:
                        remapped_dir = NeighborDirections.Upper_Left;
                        break;
                    case 180:
                        remapped_dir = NeighborDirections.Upper_Right;
                        break;
                    case 120:
                        remapped_dir = NeighborDirections.Right;
                        break;
                    case 60:
                        remapped_dir = NeighborDirections.Lower_Right;
                        break;
                }
                break;
            default:
                break;
        }

        return remapped_dir;
    }
}
