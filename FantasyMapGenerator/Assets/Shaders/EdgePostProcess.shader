Shader "Hidden/EdgePostProcess"
{
    Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_CameraPos ("camera_position", Vector) = (0,0,0,0)
	}
	
	SubShader {

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
            #define LAND_COLOR        float4(0.f, 1.f, 0.f, 1.f)
            #define WATER_COLOR       float4(0.f, 0.f, 1.f, 1.f)
            #define MOUNTAIN_COLOR    float4(1.f, 0.f, 0.f, 1.f)
            #define FOREST_COLOR      float4(1.f, 1.f, 0.f, 1.f)
            #define LINEGRID          0.95
            #define LINEWIDTH         0.61

            float bias(float t, float b) {
                return (t / ((((1.0 / b) - 2.0) * (1.0 - t)) + 1.0));
            }

            float noise1Df(float x) {
                return sin(2.0 * x) + sin(PI * x);
            }
            
            float noise2Df(float2 p) {
                return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
            }

            float2 noise2Dv(float2 p ) {
                return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5,183.3)))) * 43758.5453);
            }

            float cosineInterpolate(float a, float b, float t)
            {
                float cos_t = (1.f - cos(t * PI)) * 0.5f;
                return lerp(a, b, cos_t);
            }

            float interpolateNoise1D(float x) {
                int intX = int(floor(x));
                float fractX = frac(x);

                float v1 = noise1Df(float(intX));
                float v2 = noise1Df(float(intX + 1));
                return lerp(v1, v2, fractX);
            }

            float fbm1D(float x) 
            {
                float total = 0.f;
                float persistence = 0.5f;
                int octaves = 8;

                for(int i = 1; i <= octaves; i++) {
                    float freq = pow(2.f, float(i));
                    float amp = pow(persistence, float(i));

                    float perlin = interpolateNoise1D(x * freq);
                    total += amp * (0.5 * (perlin + 1.0));
                }

                return total;
            }

            float interpolateNoise2D(float x, float y) 
            {
                // Get integer and fractional components of current position
                int intX = int(floor(x));
                float fractX = frac(x);
                int intY = int(floor(y));
                float fractY = frac(y);

                // Get noise value at each of the 4 vertices
                float v1 = noise2Df(float2(intX, intY));
                float v2 = noise2Df(float2(intX + 1, intY));
                float v3 = noise2Df(float2(intX, intY + 1));
                float v4 = noise2Df(float2(intX + 1, intY + 1));

                // Interpolate in the X, Y directions
                float i1 = cosineInterpolate(v1, v2, fractX);
                float i2 = cosineInterpolate(v3, v4, fractX);
                return cosineInterpolate(i1, i2, fractY);
            }

            float fbm2D(float2 p) 
            {
                float total = 0.f;
                float persistence = 0.5f;
                int octaves = 4;

                for(int i = 1; i <= octaves; i++)
                {
                    float freq = pow(2.f, float(i));
                    float amp = pow(persistence, float(i));

                    float perlin = interpolateNoise2D(p.x * freq, p.y * freq);
                    total += amp * (0.5 * (perlin + 1.0));
                }
                return total;
            }

            float WorleyNoise(float2 uv) {
                uv *= 10.0; // Now the space is 10x10 instead of 1x1. Change this to any number you want.
                float2 uvInt = floor(uv);
                float2 uvFract = frac(uv);
                float minDist = 1.0; // Minimum distance initialized to max.
                for(int y = -1; y <= 1; ++y) {
                    for(int x = -1; x <= 1; ++x) {
                        float2 neighbor = float2(float(x), float(y)); // Direction in which neighbor cell lies
                        float2 p = noise2Dv(uvInt + neighbor); // Get the Voronoi centerpoint for the neighboring cell
                        float2 diff = neighbor + p - uvFract; // Distance between fragment coord and neighbor’s Voronoi point
                        float dist = length(diff);
                        minDist = min(minDist, dist);
                    }
                }
                return minDist;
            }

            float4 convertToGreyscale(float4 col)
            {
                float greyVal = dot(col, float4(0.21, 0.72, 0.07, 0.0));
                return float4(float3(greyVal, greyVal, greyVal), 1.0);
            }
            
            float4 frag (v2f_img input) : COLOR {
                float horizontal[9] = { -1.0, 0.0, 1.0,
                                        -2.0, 0.0, 2.0,
                                        -1.0, 0.0, 1.0 
                                      };  

            
                float vertical[9] = { 1.0, 2.0, 1.0,
                                      0.0, 0.0, 0.0,
                                      -1.0, -2.0, -1.0 
                                    }; 

                float2 texUV = input.uv;

                float2 fragCoord = input.uv * _ScreenParams.xy;
                float2 gridUV = (2.0 * fragCoord.xy - _ScreenParams.xy) / _ScreenParams.y;

                float4 baseColor = tex2D(_MainTex, texUV);
                float4 color = baseColor;

                // If asset mask, we should not apply outlines
                if (distance(baseColor, MOUNTAIN_COLOR) <= 0.75) {
                    return baseColor;
                }
                if (distance(baseColor, FOREST_COLOR) <= 0.75) {
                    return baseColor;
                }
                    
                // Outline thickness
                float2 delta = float2(0.001, 0.001);
                float4 horizontalSum = float4(0.0, 0.0, 0.0, 0.0);
                float4 verticalSum = float4(0.0, 0.0, 0.0, 0.0);

                for (int i = -1; i <= 1; i++) {
                    for (int j = -1; j <= 1; j++) {
                        // Matrix coordinates
                        int kx = i + 1;
                        int ky = j + 1;

                        // Get current UV coordinate
                        float2 offset = float2(i, j);

                        float4 neighborPixelValue = tex2D(_MainTex, (texUV + offset * delta));

                        if (distance(neighborPixelValue, FOREST_COLOR) <= 0.75 || distance(neighborPixelValue, MOUNTAIN_COLOR) <= 0.85) {
                            continue;
                        }

                        // Sample input texture
                        horizontalSum += convertToGreyscale(neighborPixelValue) * horizontal[kx + 3 * ky];
                        verticalSum += convertToGreyscale(neighborPixelValue) * vertical[kx + 3 * ky];
                    }
                }
                
                float sum = 1.0 - sqrt(horizontalSum * horizontalSum + verticalSum * verticalSum);
                float3 sumColor = float3(sum, sum, sum); 

                // Any outline should be black
                if (length(sumColor.xyz) <= 1.5) color = float4(0.0, 0.0, 0.0, 0.0);

                // Animated water
                if (distance(color, float4(0.74, 0.76, 0.89, 1.0)) <= 0.5) {
                    float4 line_col = color;
                    
                    float y_based_grid = texUV.y / LINEGRID;
                    float y_pow = pow(texUV.y + 4.0f, 0.75);
                    float x_fbm = fbm1D(100.0f + texUV.x / 5.0f);
                    float time_movement = (2.97f * (_Time * 25.0f + 300.0f) * y_pow) / (5.0f + 2.25f * x_fbm);
                    float x_amp = texUV.x * 25.0f;
                    float y_amp = 5.0 * texUV.y;
                    float xy_fbm = fbm2D(50.0 * texUV);
                    float sinusoid_val = 1.4 * sin(x_amp + y_amp + time_movement + pow(texUV.x, 5.0));
                    
                    if (frac(sinusoid_val + y_based_grid) * xy_fbm < LINEWIDTH) {
                        line_col = float4(0.45, 0.9, 1.0, 1.0) * 1.25;
                        float fbm_val = fbm2D(5.0 * texUV + 10.0f + _Time * 0.5f);
                        float worley_val_0 = WorleyNoise(0.1 * texUV + 20.0f);
                        float worley_val_1 = WorleyNoise(0.5 * texUV - 17.0f);
                        float worley_val_2 = WorleyNoise(0.25 * texUV - 35.0f);
                        line_col = lerp(line_col, float4(0.41, 0.55, 0.98, 1.0) * 1.2f * fbm_val, bias(fbm_val,0.355));
                        line_col = lerp(line_col, color, bias(worley_val_0, 0.23475));
                        line_col = lerp(line_col, color, bias(worley_val_1, 0.23));
                        line_col = lerp(line_col, color, bias(worley_val_2, 0.134));
                    }

                    color = lerp(color, line_col, 1.0);
                }

                // Coastline hatching
                float deltaOffset = WorleyNoise(50.0 * texUV.xy) * 0.025;
                delta = float2(0.002 + deltaOffset, 0.002); // outline thickness
                horizontalSum = float4(0.0, 0.0, 0.0, 0.0);
                verticalSum = float4(0.0, 0.0, 0.0, 0.0);
                
                for (int m = -1; m <= 1; m++) {
                    for (int n = -1; n <= 1; n++) {
                        // Matrix coordinates
                        int kx = m + 1;
                        int ky = n + 1;

                        // Get current UV coordinate
                        float2 offset = float2(m, n);

                        // Sample input texture
                        horizontalSum += tex2D(_MainTex, (texUV - offset * delta)) * horizontal[kx + 3 * ky];
                        verticalSum += tex2D(_MainTex, (texUV - offset * delta)) * vertical[kx + 3 * ky];
                    }
                }
                
                sum = sqrt(horizontalSum * horizontalSum + verticalSum * verticalSum);
                float3 outlineColor = float3(0.0, 0.0, 0.0);
                if (length(sum) >= 0.5) outlineColor = float3(1.0, 0.0, 0.0);
                
                // Horizontal lines
                float u = fmod(texUV.y, 0.01);
                float fbm = fbm2D(100.0 * texUV.xy);
                if (u < 0.002 && u > 0.0) {
                    if (distance(baseColor, float4(1.0, 0.9, 0.7, 1.0)) <= 0.2 || distance(baseColor, MOUNTAIN_COLOR) <= 0.5 || distance(baseColor, FOREST_COLOR) <= 0.5) {
                        //col = vec3(0.68, 0.54, 0.39);
                    }
                    else {
                        if (distance(outlineColor, float3(1.0, 0.0, 0.0)) <= 0.5) {
                            color = lerp(float4(0.0, 0.0, 0.0, 1.0), float4(0.74, 0.76, 0.89, 1.0), bias(fbm, 0.15)); 
                        }       
                    }
                }
                
                return color;
            }	

			ENDCG
        }	
	} 
}