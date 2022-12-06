
precision highp float;

uniform vec3 u_Eye, u_Ref, u_Up;
uniform vec2 u_Dimensions;

uniform float u_NoiseHeight;

in vec2 fs_Pos;
out vec4 out_Col;

const int MAX_RAY_STEPS = 200;
const float DIST_MAX = 30.0;
const float FOV = 45.0;
const float EPSILON = 1E-2;
const float EPSILON_N = 1E-2;

// const vec3 EYE = vec3(2.0, 1.5, 5.0);
// const vec3 REF = vec3(1.2, 1.0, 0.0);
const vec3 WORLD_UP = vec3(0.0, 1.0, 0.0);
const vec3 WORLD_RIGHT = vec3(-1.0, 0.0, 0.0);
const vec3 WORLD_FORWARD = vec3(0.0, 0.0, 1.0);
const vec3 LIGHT_DIR = vec3(0.6, 1.0, 0.4) * 1.5;

const vec3 BACKGROUND_COLOR = vec3(0.5, 0.7, 0.9);



struct Ray
{
  vec3 origin;
  vec3 direction;
};
struct DirectionalLight
{
    vec3 dir;
    vec3 color;
};
Ray getRay(vec2 uv) {
  Ray ray;

  float len = tan(3.14159 * 0.125) * distance(u_Eye, u_Ref);
  vec3 H = normalize(cross(vec3(0.0, 1.0, 0.0), u_Ref - u_Eye));
  vec3 V = normalize(cross(H, u_Eye - u_Ref));
  V *= len;
  H *= len * u_Dimensions.x / u_Dimensions.y;
  vec3 p = u_Ref + uv.x * H + uv.y * V;
  vec3 dir = normalize(p - u_Eye);

  ray.origin = u_Eye;
  ray.direction = dir;
  return ray;
}

const float NUM_HILLS = 10.0;
const float HILL_X_WIDTH = 20.0;
const float HILL_Z_WIDTH = 14.0;

float bumpyPlane(vec3 queryPos){
  float plane = planeSDF(queryPos, -0.6);

  for(float i = 0.0; i < NUM_HILLS; i++){
    plane = smoothUnion(plane, sphereSDF(queryPos, vec3(-HILL_X_WIDTH + (random1d_1(i-0.1) * HILL_X_WIDTH * 2.0), -1.2, - (random1d_1(i+0.1) * HILL_Z_WIDTH * 2.0)), 0.5 + (2.0*random1d_1(i+0.2))), 1.0 + (0.5*random1d_1(i+0.3)));
  }
  return plane;

}

float skyPyramids(vec3 queryPos){
  return 0.0;
}

//float weirdPyramid(vec3 queryPos){
//  float final;
//  float mainPart = pyramidSDF(queryPos, vec3(0.0, -0.5, -5.0), 4.0, 4.0, 2.4);
//  mainPart = flatSubtraction(mainPart, cubeSDF(queryPos, vec3(0.0, 1.8, -5.0), vec3(0.5, 0.5, 0.5)));
//  float pyramideon = pyramidSDF(queryPos, vec3(0.0, 1.7, -5.0), 0.4, 0.4, 0.25);
//  pyramideon = flatSubtraction(pyramideon, flatSubtraction(pyramidSDF(queryPos, vec3(0.0, 1.71, -5.0), 0.4*0.9, 0.4*1.1, 0.25*0.88), cubeSDF(queryPos, vec3(0.0, 2.2, -5.0), vec3(0.5, 0.5, 0.5))));
//  pyramideon = flatSubtraction(pyramideon, flatSubtraction(pyramidSDF(queryPos, vec3(0.0, 1.71, -5.0), 0.4*1.1, 0.4*0.9, 0.25*0.88), cubeSDF(queryPos, vec3(0.0, 2.2, -5.0), vec3(0.5, 0.5, 0.5))));
//  float skyPyramid = pyramidSDF(queryPos, vec3(0.0, 4.5, -5.0), 4.0, 4.0, -2.4);
//  final = flatUnion(flatUnion(mainPart, pyramideon), skyPyramid);
//  return final;
//}


//float sceneSDField(vec3 queryPos)
//{
//  vec3 t = transform(queryPos, vec3(0, 0, 0), vec3(-20.0, -20.0, -20.0), vec3(2, 2, 2));
//  float final;
//
//  if(t.x < 0.0 || t.x > u_pyramidFieldDims.x - 1.0 || t.y < 0.0 || t.y > u_pyramidFieldDims.y - 1.0 || t.z < 0.0 || t.z > u_pyramidFieldDims.z - 1.0){
//    return 1.0;
//  }
//
//  float qp_idx = round(t.x) + round(t.y) * u_pyramidFieldDims.x + round(t.z) * u_pyramidFieldDims.x * u_pyramidFieldDims.y;
//  return u_pyramidField[int(qp_idx)];
//
//}

//float sceneSDFunction(vec3 queryPos)
//{
//  return 1000000000.0;
//}
//
//float sceneSDF(vec3 queryPos){
//  return min(sceneSDFunction(queryPos), sceneSDField(queryPos));
//}

float culledSceneSDF(vec3 queryPos)
{
  return planeSDF(queryPos, -1.6);
}

float sceneSDF(vec3 queryPos)
{

  float final;
  vec3 main_t = transform(queryPos, vec3(0, 0, 0), vec3(0.0, -1.5, 0), vec3(4.0, 4.0, 4.0));

  final = pyramidNormalSDF(main_t,  0.5,
                           u_NoiseHeight,
                           0.5,
                           u_Rows,
                           u_TriScale);

  //final = symbol3SDF(queryPos);


  final = flatUnion(final, planeSDF(queryPos, -1.6));

  return final;
}

struct Intersection
{
  vec3 position;
  vec3 normal;
  float distance;
  int material_id;
};

vec3 estimateNormal2(vec3 p) {
  return normalize(vec3(
  sceneSDF(vec3(p.x + EPSILON_N, p.y, p.z)) - sceneSDF(vec3(p.x - EPSILON_N, p.y, p.z)),
  sceneSDF(vec3(p.x, p.y + EPSILON_N, p.z)) - sceneSDF(vec3(p.x, p.y - EPSILON_N, p.z)),
  sceneSDF(vec3(p.x, p.y, p.z  + EPSILON_N)) - sceneSDF(vec3(p.x, p.y, p.z - EPSILON_N))
  ));
}

// https://iquilezles.org/articles/normalsSDF/
vec3 estimateNormal( in vec3 p ) // for function f(p)
{
  const float h = EPSILON_N; // replace by an appropriate value
  const vec2 k = vec2(1,-1);
  return normalize( k.xyy*sceneSDF( p + k.xyy*h ) +
  k.yyx*sceneSDF( p + k.yyx*h ) +
  k.yxy*sceneSDF( p + k.yxy*h ) +
  k.xxx*sceneSDF( p + k.xxx*h ) );
}

vec3 lambertColor(Intersection intersection, float daycycle){
  vec3 albedo = vec3(0.99, 0.91, 0.72);
  // vec4 diffuseColor = u_Color;
  
  DirectionalLight lights[3];
  lights[0] = DirectionalLight(normalize(vec3(0.0, 3.0, 0.0)),
                                normalize(vec3(1, 1, 1)));
  lights[1] = DirectionalLight(normalize(vec3(0., 1., 0.)),
                                normalize(vec3(124, 104, 95)));
  lights[2] = DirectionalLight(normalize(-vec3(15.0, 0.0, 10.0)),
                                normalize(vec3(72, 53, 39)));

  vec3 norm = estimateNormal(intersection.position);

  float dayProgression = abs(sin(daycycle * 3.14159));
  vec3 color;
  for(int i = 1; i < 3; ++i) {
      color += albedo *
                lights[i].color *
                max(0.0, dot(norm, lights[i].dir));
  }

  // vec3 color = albedo * 0.1 * vec3(1.0, 1.0, 1.0) * max(0.0, dot(norm, normalize(vec3(4.0, 15.0, -10.0))));

  // color += vec3(0.96, 0.28, 0.74) * 0.1 * max(0.0, dot(norm, normalize(vec3(0.0, 10.0, 0.0))));
  // //color = max(color, albedo*0.2);
  // color += vec3(0.96, 0.88, 0.74) * dayProgression * max(0.0, dot(norm, normalize(vec3((dayProgression-0.5) * 60.0, 10.0, (dayProgression-0.5) * 40.0))));

  return color;
}

bool sphereIntersect(Ray r, vec3 center, float radius)
{
//solve for tc
vec3 L = r.origin - center;
float p = dot(r.direction, L);
float q = dot(L, L) - (radius * radius);

float discriminant = (p * p) - q;
if (discriminant < 0.0f)
{
  return true;
}
return false;
}

Intersection getRaymarchedIntersection(vec2 uv)
{
  Ray ray = getRay(uv);
  Intersection intersection;
  float dist = 0.0;
  vec3 queryPoint = ray.origin;

  bool culled = sphereIntersect(ray, vec3(0, -0.5, 0), 15.0);

  for (int i=0; i < MAX_RAY_STEPS; ++i)
  {
    float distanceToSurface;
    if(culled) {
      distanceToSurface = culledSceneSDF(queryPoint);
    }else {
      distanceToSurface = sceneSDF(queryPoint);
    }

    if (distanceToSurface < EPSILON)
    {

      intersection.position = queryPoint;
      intersection.normal = vec3(0.0, 0.0, 1.0);
      intersection.distance = length(queryPoint - ray.origin);

      return intersection;
    }
    dist += distanceToSurface * 0.5;
    if (dist > DIST_MAX){
      intersection.distance = -1.0;
      return intersection;
    }

    // sphere distance
    queryPoint = queryPoint + ray.direction * distanceToSurface;
  }


  intersection.distance = -1.0;
  return intersection;
}

struct skyGradient{
  vec3 midColLit;
  vec3 midColUnlit;
  vec3 upperCol;
  vec3 lowerCol1;
  vec3 lowerCol2;
};

const skyGradient sunMid = skyGradient(
  vec3(1., 0.341 * 2., 0.09 * 2.2),
  vec3(1., 0.341, 0.09),
  vec3(0.5, 0.156, 0.225),
  vec3(1., 0.6, 0.1),
  vec3(1., 0.7, 0.1)
);

const skyGradient sunDusk = skyGradient(
  vec3(0.21, 0.2, 0.2),
  vec3(0.02, 0.01, 0.01),
  vec3(0.13, 0.1, 0.1),
  vec3(0.05, 0.05, 0.05),
  vec3(0.09, 0.05, 0.05)
);

const skyGradient sunDay = skyGradient(
  vec3(0.2, 0.69, 1.0),
  vec3(0.2, 0.69, 0.96),
  vec3(0.2, 0.69, 0.96),
  vec3(0.92, 0.79, 0.45),
  vec3(0.92, 0.82, 0.45)
);

vec3 getSkyBackground(in vec2 uv, skyGradient colorScheme)
{
  float mid = smoothstep(0.1, 0.2, uv.y/2.0);
  vec3 midCol = mix(colorScheme.midColUnlit, colorScheme.midColLit, 1. - clamp(distance(uv.x, 0.5) * 1.5, 0., 1.));
  vec3 skyColorTop = mix(midCol, colorScheme.upperCol, uv.y/2.0);
  vec3 skyColorBottom = mix(colorScheme.lowerCol1, colorScheme.lowerCol2, 1. - clamp(distance(uv.x, 0.5) * 3., 0., 1.));
  vec3 skyColor = mix(skyColorBottom, skyColorTop, mid);

  return skyColor;
}


vec3 skyColorAtTime(vec2 uv, float daycycle){
  vec3 midColor = getSkyBackground(uv, sunMid);
  vec3 duskColor = getSkyBackground(uv, sunDusk);
  vec3 dayColor = getSkyBackground(uv, sunDay);

  // day night cycle should progress with peak at 0.0 / 1.0 for dusk, 0.3 and 0.7 for mid, and 0.5 for day
  vec3 finalColor;

  finalColor = mix(duskColor, midColor, smoothstep(0.0, 0.2, daycycle));
  finalColor = mix(finalColor, dayColor, smoothstep(0.2, 0.5, daycycle));
  finalColor = mix(finalColor, midColor, smoothstep(0.5, 0.8, daycycle));
  finalColor = mix(finalColor, duskColor, smoothstep(0.8, 1.0, daycycle));
  //finalColor = vec3(daycycle);

  return finalColor;
}

vec3 getSun(in vec2 uv, float opacity, float dayCycle)
{
  // float dayProgression = abs(cos(dayCycle * 3.14159));
  // vec2 st = uv;
  // uv -= .5;
  // uv.x *= u_Dimensions.x / u_Dimensions.y;

  // uv.y += 0.05;
  // uv.y += bias(dayProgression, 0.1);

  // float radius = 0.1;
  // float uvLength = 1. - length(uv);
  // vec3 sun;
  // float sunOpacity = 1.;
  // float time = u_Time * 0.1;

  // for(int i = 0; i < 10; i++)
  // {
  //   sunOpacity *= 0.6;
  //   sun += vec3(smoothstep(0.95 - radius, 0.953 - radius, uvLength) * sunOpacity) * vec3(1., 0.6, 0.);
  //   sun = clamp(sun, 0., 1.);
  //   radius *= 1.3 + sin(time) / 100.;
  // }

  // sun *= opacity;
  // sun.g *= 0.9;

  // vec3 sunGlow = clamp(1. - vec3(length(uv * 2.)), 0., 1.) * opacity;
  // sunGlow *= smoothstep(0.1 - sin(time) / 10., 1. - sin(time) / 10., sunGlow);

  // vec3 flare = 1. - vec3(distance(vec2(st.x * 1.5 - 0.25, st.y * 2. - 0.5), vec2(0.5))) * 2. + sin(time) / 40.;
  // flare = clamp(flare * vec3(1., 0.8, 0.), 0., 1.);

  // return sun + (sunGlow + flare) / 4.;


  Ray ray = getRay(uv);

  // sun
  float sunn = clamp( dot(normalize(vec3(0.0, 2.0, 10.0)), ray.direction), 0.0, 1.0 );
  
  vec3 color = vec3(1.0,0.6,0.3) * pow( sunn, 256.0 ); // sun
  color += 0.5 * vec3(1.0,0.6,0.3) * pow( sunn, 32.0 );

  return color;
}


void main() {
  //out_Col = vec4(0.5 * (fs_Pos + vec2(1.0)), 0.5 * (sin(u_Time * 3.14159 * 0.01) + 1.0), 1.0);
  Intersection intersection = getRaymarchedIntersection(fs_Pos);

  vec3 albedo = vec3(0.5);
  vec3 color;
  float dayCycle = (1.0+cos(u_Time / 90.0))/2.0;
  if (intersection.distance > 0.0){
    color = lambertColor(intersection, dayCycle);
  }else{
    color = skyColorAtTime(fs_Pos, dayCycle);
    color += getSun(fs_Pos, 0.5, dayCycle);
    // color += skyColorAtTime(fs_Pos, 0.9);
    // color = BACKGROUND_COLOR * rnd;
  }


  out_Col = vec4(color, 1.0);
}
