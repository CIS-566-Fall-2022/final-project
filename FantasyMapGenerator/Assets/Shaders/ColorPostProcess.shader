Shader "Hidden/ColorPostProcess"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_CameraPos ("camera_position", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
			uniform float4 _CameraPos;
			uniform float4x4 _InvCamProjMatrix;

            #define PI                3.1415926535897932384626433832795
            #define EPSILON           0.001
            #define LAND_COLOR        float4(0.f, 1.f, 0.f, 1.f)
            #define WATER_COLOR       float4(0.f, 0.f, 1.f, 1.f)
            #define MOUNTAIN_COLOR    float4(1.f, 0.f, 0.f, 1.f)
            #define FOREST_COLOR      float4(1.f, 1.f, 0.f, 1.f)
            #define SCATTER_GRID_SIZE 2.0
            #define ASSETS_PER_CELL   3

            float4 frag (v2f_img input) : COLOR
            {
                // Get uv coordinates
                float2 texUV = input.uv;

                float2 fragCoord = input.uv * _ScreenParams.xy;
                float2 gridUV = (2.0 * fragCoord.xy - _ScreenParams.xy) / _ScreenParams.y;
                
                // Sample color texture and map color ID to final color
                float4 base = tex2D(_MainTex, texUV);
                float4 color = base;

                if (distance(base, LAND_COLOR) <= 0.5) {
                    color = float4(1.0, 0.9, 0.7, 1.0);
                }
                else if (distance(base, WATER_COLOR) <= 0.55) {
                    color = float4(0.74, 0.76, 0.89, 1.0);
                }
                else if (distance(base, MOUNTAIN_COLOR) <= 0.55) {
                    //color = float4(0.71, 0.54, 0.39, 1.0);
                }
                else if (distance(base, FOREST_COLOR) <= 0.55) {
                    //color = float4(0.54, 0.76, 0.49, 1.0);
                }
                else {
                    color = float4(0.0, 0.0, 0.0, 0.0);
                }
                
                return color;
            }
            ENDCG
        }
    }
}