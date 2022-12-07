Shader "Hidden/AssetPostProcess"
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

            #define PI                 3.1415926535897932384626433832795
            #define LAND_COLOR         float4(0.f, 1.f, 0.f, 1.f)
            #define WATER_COLOR        float4(0.f, 0.f, 1.f, 1.f)
            #define MOUNTAIN_COLOR     float4(1.f, 0.f, 0.f, 1.f)
            #define FOREST_COLOR       float4(1.f, 1.f, 0.f, 1.f)
            #define MOUNTAIN_GRID_SIZE 5.0
            #define MOUNTAINS_PER_CELL 7
            #define FOREST_GRID_SIZE   6.0
            #define TREES_PER_CELL     10

            float noise1Df(float x) {
                return sin(2.0 * x) + sin(PI * x);
            }

            float noise1D(float x) {
                return sin(x);
            }

            float rand(float2 uv)
            {
                return frac(sin(dot(uv.xy, float2(12.9898,78.233))) * 43758.5453123);
            }
                        
            float noise2Df(float2 p) {
                return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
            }

            float2x2 rotate2D(float angle)
            {
                return float2x2(cos(angle), -sin(angle), 
                                sin(angle), cos(angle));
            }

            float2x2 identity()
            {
                return float2x2(1, 0,
                                0, 1);
            }

            float sdCircle(float2 p, float r)
            {
                return length(p) - r;
            }

            float sdCirclePos(float2 queryPos, float2 p, float r)
            {
                return length(queryPos - p) - r;
            }

            float sdSegment(in float2 p, in float2 a, in float2 b)
            {
                float2 pa = p - a;
                float2 ba = b - a;
                float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
                return length(pa - ba * h);
            }

            float sdEgg(in float2 p, in float ra, in float rb)
            {
                const float k = sqrt(3.0);
                p.x = abs(p.x);
                float r = ra - rb;
                return ((p.y<0.0)       ? length(float2(p.x,  p.y    )) - r :
                        (k*(p.x+r)<p.y) ? length(float2(p.x,  p.y-k*r)) :
                                        length(float2(p.x+r,p.y    )) - 2.0*r) - rb;
            }

            float sdSquarePos(float2 queryPos, float2 p, float2 b)
            {
                float2 d = abs(queryPos - p) - b;
                return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
            }

            float sdUnevenCapsule(float2 p, float r1, float r2, float h)
            {
                p.x = abs(p.x);
                float b = (r1-r2)/h;
                float a = sqrt(1.0-b*b);
                float k = dot(p,float2(-b,a));
                if( k < 0.0 ) return length(p) - r1;
                if( k > a*h ) return length(p-float2(0.0,h)) - r2;
                return dot(p, float2(a,b) ) - r1;
            }

            float triangleArea(float2 a, float2 b, float2 c)
            {
                return abs(a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) * 0.5;
            }

            bool pointInTriangle(float2 p, float2 a, float2 b, float2 c)
            {
                float totalArea = triangleArea(a, b, c);
                float sum = 0.0;
                
                sum += triangleArea(p, a, b);
                sum += triangleArea(p, a, c);
                sum += triangleArea(p, b, c);
                
                if (totalArea >= sum - 0.001) return true;
                
                return false;
            }

            float sdTriangleIsosceles(in float2 queryPos, in float2 pos, in float2 q, in float2x2 rot)
            {
                float2 p = mul(queryPos - pos, rot);
                p.x = abs(p.x);
                float2 a = p - q*clamp( dot(p,q)/dot(q,q), 0.0, 1.0 );
                float2 b = p - q*float2( clamp( p.x/q.x, 0.0, 1.0 ), 1.0 );
                float s = -sign( q.y );
                float2 d = min( float2( dot(a,a), s*(p.x*q.y-p.y*q.x) ),
                            float2( dot(b,b), s*(p.y-q.y)  ));
                return -sqrt(d.x)*sign(d.y);
            }

            float mountainOutlineSDF(float2 uv, float2 p, float s, float thickness)
            {    
                // Find distance to vertices and distance to midpoints
                float distToVertex = 0.33 * (s * 1.73);
                float distToMidpoint = 0.04 * (s * 1.73); // change (1.0 / 25.0) to some other number for height
                
                // Find vertices of equilateral triangle
                float2 A = p + float2(0.0, distToVertex);
                float2 B = p + float2(s * 0.5, distToMidpoint);
                float2 C = p + float2(-s * 0.5, distToMidpoint);
                
                // Outline segments
                float f = sdSegment(uv, A, B);
                float g = sdSegment(uv, A, C);
                float dMin = min(f, g);
                
                if (dMin < thickness) return dMin;
                
                return -1.0;
            }

            float4 drawMountain(in float3 baseCol, float2 uv, float2 p, float sideLength, float thickness)
            {                
                // Find distance to vertices and distance to midpoints
                float distToVertex = 0.33 * (sideLength * 1.73);
                float distToMidpoint = 0.04 * (sideLength * 1.73); // change 25.0 to some other number for height
                
                // Find vertices of equilateral triangle
                float2 A = p + float2(0.0, distToVertex);
                float2 B = p + float2(sideLength * 0.5, distToMidpoint);
                float2 C = p + float2(-sideLength * 0.5, distToMidpoint);
                
                // Background color is map "paper" color
                float3 col = baseCol;
                float3 mountainCol = float3(0.93, 0.75, 0.55); // color of mountain region
                float jitter = noise1Df(50.0 * uv.y) * 0.008;
                
                // Do shading within mountain body
                if (pointInTriangle(uv, A, B, C)) {
                    if (uv.x < p.x - jitter && uv.x > C.x) {  
                        float t = (uv.x - C.x) / (p.x - jitter - C.x);                       
                        float3 fadeColor = lerp(mountainCol, float3(0.3, 0.3, 0.3) * mountainCol, t);
                        col = fadeColor;
                    }
                    else {
                        col = mountainCol;
                    }      
                }
                
                return float4(col.xyz, 1.0);
            }

            float4 placeMountains(float4 baseColor, float2 uv, float2 gridId)
            {
                float4 col = baseColor;
                if (distance(baseColor, MOUNTAIN_COLOR) <= 0.5) {
                    col = float4(0.93, 0.75, 0.55, 1.0);
                }
                // Place a mountains randomly within each cell
                for (int n = 0; n < MOUNTAINS_PER_CELL; ++n) {
                    float r = rand(float2(n, n));
                    float jitterScale = 10.0 * noise1Df(float(n)) + 10.0;
                    for (int y = -1; y <= 1; ++y) {
                        for (int x = -1; x <= 1; ++x) {
                            float2 neighborOffset = float2(x, y);
                            float jitter = noise2Df(gridId + neighborOffset + r);
                            float2 uvOffset = float2(jitter, frac(jitterScale * jitter)) - float2(0.5, 0.5);
                            
                            // Skip if center point of mountain is not within mountain region
                            float2 drawPosition = gridId + uvOffset + neighborOffset;
                            float2 localDrawPosition = drawPosition / MOUNTAIN_GRID_SIZE;
                            float2 localFragCoord = 0.5 * ((localDrawPosition * _ScreenParams.y) + _ScreenParams.xy);
                            float2 localUV = localFragCoord / _ScreenParams.xy;
                            if (distance(tex2D(_MainTex, localUV), MOUNTAIN_COLOR) > 0.5) {
                                continue;
                            }
                            
                            // Draw mountain body and outline
                            col = drawMountain(col, MOUNTAIN_GRID_SIZE * uv, drawPosition, 0.5, 0.01);
                            float e = mountainOutlineSDF(MOUNTAIN_GRID_SIZE * uv, drawPosition, 0.5, 0.01);
                            if (e > 0.0) col = lerp(col, float4(0.0, 0.0, 0.0, 0.0), 1.0);
                        }
                    }
                }

                return col;
            }

            float4 drawTree(in float4 baseCol, float2 uv, float2 gridId, float ra, in float rb)
            {
                float4 col = baseCol;

                float leaves_sdf = sdEgg(uv - gridId, 0.09, 0.01 );
                float tree_sdf = sdUnevenCapsule(uv - gridId + float2(0, 0.2), 0.02, 0.02, 0.175 );
                float min_sdf = min(tree_sdf, leaves_sdf);
                
                if (min_sdf <= 0.0) {
                    col = float4(0, 0, 0, 0);
                    if (leaves_sdf < -0.025 || tree_sdf < -0.015) {
                        if (uv.x < gridId.x) {        
                            col = lerp(float4(0.4, 0.4, 0.4, 1.0), baseCol,  1.0 - (gridId.x - uv.x) * 15.0);
                        }
                        else {
                            col = float4(0.9, 0.93, 0.7, 1.0);
                        }
                    }
                }
                
                return col;
            }

            float4 placeTrees(float4 baseColor, float2 uv, float2 gridId)
            {
                float4 col = baseColor;
                if (distance(baseColor, FOREST_COLOR) <= 0.5) {
                    col = float4(0.9, 0.93, 0.7, 1.0);
                }

                // Place a tree randomly within each cell
                for (int n = 0; n < TREES_PER_CELL; ++n) {
                    float r = rand(float2(n, n));
                    float jitterScale = 10.0 * noise1Df(float(n)) + 10.0;
                    for (int y = -1; y <= 1; ++y) {
                        for (int x = -1; x <= 1; ++x) {
                            float2 neighborOffset = float2(x, y);
                            float jitter = noise2Df(gridId + neighborOffset + r);
                            float2 uvOffset = float2(jitter, frac(jitterScale * jitter)) - float2(0.5, 0.5);

                            // Skip if center point of mountain is not within mountain region
                            float2 drawPosition = gridId + uvOffset + neighborOffset;
                            float2 localDrawPosition = drawPosition / FOREST_GRID_SIZE;
                            float2 localFragCoord = 0.5 * ((localDrawPosition * _ScreenParams.y) + _ScreenParams.xy);
                            float2 localUV = localFragCoord / _ScreenParams.xy;
                            if (distance(tex2D(_MainTex, localUV), FOREST_COLOR) > 0.5) {
                                continue;
                            }

                            col = drawTree(col, FOREST_GRID_SIZE * uv, gridId + uvOffset + neighborOffset, 0.0, 0.0);
                        }
                    }
                }

                return col;
            }

            float cosineInterpolate(float a, float b, float t)
            {
                float cos_t = (1.f - cos(t * PI)) * 0.5f;
                return lerp(a, b, cos_t);
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

            float4 drawCompass(float4 baseColor, float2 pos, float2 gridUV)
            {
                float4 color = baseColor;
                float4 outerColor = float4(0.34, 0.26, 0.33, 1.0);
                float4 cardinalColor = float4(0.72, 0.58, 0.55, 1.0);
                float4 diagonalColor = float4(0.44, 0.39, 0.53, 1.0);
                float4 largeCircleColor = float4(0.35, 0.4, 0.2, 1.0);
                float4 smallCircleColor = float4(0.9, 0.93, 0.7, 1.0);

                // Draw compass
                float dMin = 1.0;
                
                // Outer circles
                float innerCircle = sdCirclePos(gridUV, pos + float2(-1.3, -0.5), 0.11);
                float outerCircle = sdCirclePos(gridUV, pos + float2(-1.3, -0.5), 0.15);
                dMin = max(-innerCircle, outerCircle);
                if (dMin < 0.0) {
                    if (dMin < -0.008) {
                        color = outerColor;     
                    }
                    else {
                        color = float4(0.0, 0.0, 0.0, 0.0);   
                    }
                }

                // NE, NW, SE, SW needles
                float southeast = sdTriangleIsosceles(gridUV, pos + float2(-1.18, -0.62), float2(0.015, 0.12), rotate2D(0.785398));
                float southwest = sdTriangleIsosceles(gridUV, pos + float2(-1.42, -0.62), float2(0.015, 0.12), rotate2D(-0.785398));
                float northeast = sdTriangleIsosceles(gridUV, pos + float2(-1.18, -0.38), float2(0.015, 0.12), rotate2D(3.0 * 0.785398));
                float northwest = sdTriangleIsosceles(gridUV, pos + float2(-1.42, -0.38), float2(0.015, 0.12), rotate2D(-3.0 * 0.785398));
                if (southeast < 0.0 || southwest < 0.0 || northeast < 0.0 || northwest < 0.0) {
                    color = diagonalColor;
                }

                // N, S, E, W needles
                float north = sdTriangleIsosceles(gridUV, pos + float2(-1.3, -0.25), float2(0.03, 0.2), rotate2D(2.0 * 1.5708));
                float south = sdTriangleIsosceles(gridUV, pos + float2(-1.3, -0.75), float2(0.03, 0.2), identity()); 
                float east = sdTriangleIsosceles(gridUV, pos + float2(-1.05, -0.5), float2(0.03, 0.2), rotate2D(1.5708));
                float west = sdTriangleIsosceles(gridUV, pos + float2(-1.55, -0.5), float2(0.03, 0.2), rotate2D(-1.5708)); 
                if (north < 0.0 || south < 0.0 || east < 0.0 || west < 0.0) {
                    if (north < -0.008 || south < -0.008 || east < -0.008 || west < -0.008) {
                        color = cardinalColor;    
                    }
                    else {
                        color = float4(0.0, 0.0, 0.0, 0.0);   
                    }      
                }  
                
                // Innermost circles
                float smallCircle1 = sdCirclePos(gridUV, pos + float2(-1.3, -0.5), 0.07);
                if (smallCircle1 < 0.0) {
                    if (smallCircle1 < -0.008) {
                        color = largeCircleColor;
                    }
                    else {
                        color = float4(0.0, 0.0, 0.0, 0.0);
                    }
                }
                float smallCircle2 = sdCirclePos(gridUV, pos + float2(-1.3, -0.5), 0.04);
                if (smallCircle2 < 0.0) {
                    if (smallCircle2 < -0.008) {
                        color = smallCircleColor;
                    }
                    else {
                        color = float4(0.0, 0.0, 0.0, 0.0);
                    }
                }

                return color;
            }

            float4 drawFrame(float4 color, float2 texUV, float2 pos)
            {
                // Frame
                float thickness = 0.01;
                float thickness2 = 0.007;
                float offset = 0.02;
                float offset2 = 0.07;

                float ybound = pos.y;
                float xbound = pos.x;
        
                if (texUV.x < -xbound || texUV.x > xbound || texUV.y < -ybound || texUV.y > ybound)
                {
                    color = float4(1.0, 0.9, 0.7, 1.0);
                }
                
                // Frame 1
                float sdfFrame = sdSquarePos(texUV, float2(0.0, 0.0), float2(xbound + offset, ybound + offset));
                if (sdfFrame < thickness && sdfFrame > 0.0) color = float4(0.0, 0.0, 0.0, 1.0);
                
                // Frame 2
                sdfFrame = sdSquarePos(texUV, float2(0.0, 0.0), float2(xbound + 2.0 * offset, ybound + 2.0 * offset));
                if (sdfFrame < thickness2 && sdfFrame > 0.0) color = float4(0.0, 0.0, 0.0, 1.0);
                
                // Edge
                float noiseoffsetx = fbm1D(texUV.y * 1.79) * 0.07;
                float noiseoffsety = fbm1D(texUV.x * 1.98) * 0.07;
                if (texUV.x < -(xbound + offset2 + noiseoffsetx) || texUV.x > xbound + offset2 + noiseoffsetx || 
                    texUV.y < -(ybound + offset2 + noiseoffsety) || texUV.y > ybound + offset2 + noiseoffsety)
                {
                            color = float4(0.0, 0.0, 0.0, 1.0);
                }
                
                //Edge noise
                float2 uvgrad = texUV / 0.9;
                color = lerp(color, color * fbm2D(8.0 * texUV), smoothstep(0.8, 1.2, length(float2(texUV.x / 2.0, texUV.y / 1.0))));
                color = lerp(color, color * fbm2D(3.0 * texUV), smoothstep(0.5, 0.4, length(sdSquarePos(texUV, float2(0.0, 0.0), 1.1 * float2(2.0, 1.2)))));

                return color;
            }

            float4 frag (v2f_img input) : COLOR
            {
                // Get uv coordinates
                float2 texUV = input.uv;

                float2 fragCoord = input.uv * _ScreenParams.xy;
                float2 gridUV = (2.0 * fragCoord.xy - _ScreenParams.xy) / _ScreenParams.y;
                
                // Sample color texture and map color ID to final color
                float4 base = tex2D(_MainTex, texUV);
                float4 color = base;

                // Scatter assets over the map
                float2 cellCoordMountain = frac(MOUNTAIN_GRID_SIZE * gridUV) - 0.5; // remap so that middle of cell is origin
                float2 gridIdMountain = floor(MOUNTAIN_GRID_SIZE * gridUV);

                float2 cellCoordTree = frac(FOREST_GRID_SIZE * gridUV) - 0.5; // remap so that middle of cell is origin
                float2 gridIdTree = floor(FOREST_GRID_SIZE * gridUV);

                // Draw assets in appropriate areas on the map
                bool screenBlack = distance(base, float4(0.0, 0.0, 0.0, 0.0)) <= 0.5;
                if (!screenBlack) {
                    color = placeMountains(color, gridUV, gridIdMountain);
                    color = placeTrees(color, gridUV, gridIdTree);
                }  

                // Uncomment for visualizing grid values
                //if (cellCoordMountain.x > 0.48 || cellCoordMountain.y > 0.48) color = float4(0.4, 0.3, 1.0, 1.0);

                // Uncomment for test mountain
                // color = float4(1.0, 1.0, 1.0, 1.0);
                // color = drawMountain(color, SCATTER_GRID_SIZE * gridUV, float2(0.0, 0.0), 0.5, 0.01);
                // float e = mountainOutlineSDF(SCATTER_GRID_SIZE * gridUV, float2(0.0, 0.0), 0.5, 0.01);
                // if (e > 0.0) color = lerp(color, float4(0.0, 0.0, 0.0, 0.0), 1.0);
                
                // FBM pass for paper look
                float fbm = pow(fbm2D(5.0 * gridUV), 1.0);

                // Draw map frame
                float2 maxDim = _ScreenParams.xy / _ScreenParams.y;
                float2 frameBounds = maxDim - 0.15;
                color = drawFrame(color, gridUV, frameBounds);

                // Draw compass
                float2 compassPos = float2(frameBounds.x + 1.04, 0.0);
                color = drawCompass(color, compassPos, gridUV);

                return color * fbm;
            }
            ENDCG
        }
    }
}