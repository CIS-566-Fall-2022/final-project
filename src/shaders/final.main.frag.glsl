#version 300 es
precision highp float;

uniform vec3 u_Eye, u_Ref, u_Up;
uniform vec2 u_Dimensions;
uniform float u_Time;
uniform vec3 u_Pos;
uniform float u_Stripe;
uniform vec3 u_BaseCol;
uniform float u_NumStripes;
uniform float u_WhiteFront;

in vec2 fs_Pos;
out vec4 out_Col;

#define MAX_RAY_STEPS 256
#define EPSILON 1e-2

// Want sunlight to be brighter than 100% to emulate High Dynamic Range
#define SUN_KEY_LIGHT vec3(0.6, 0.7, 0.5) * 1.5
// #define SUN_KEY_LIGHT vec3(0.5 * sin(u_Time * 0.003) + 0.4, 0.5 * sin(u_Time * 0.003) + 0.4, 0.5 * sin(u_Time * 0.003) + 0.4) * 1.5

// Fill light is sky color, fills in shadows to not be black
#define SKY_FILL_LIGHT vec3(0.5, 0.2, 0.7) * 0.2

// Faking global illumination by having sunlight bounce horizontally only, at a lower intensity
#define SUN_AMBIENT_LIGHT vec3(0.6, 1.0, 0.4) * 0.2

struct Ray 
{
    vec3 origin;
    vec3 direction;
};

struct Intersection 
{
    vec3 position;
    vec3 normal;
    float distance;
    int material_id;
};

struct DirectionalLight
{
    vec3 dir;
    vec3 color;
};

float noise1D( vec2 p ) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) *
                 43758.5453);
}

float interpNoise2D(float x, float y) {
    float intX = float(floor(x));
    float fractX = fract(x);
    float intY = float(floor(y));
    float fractY = fract(y);

    float v1 = noise1D(vec2(intX, intY));
    float v2 = noise1D(vec2(intX + 1.0, intY));
    float v3 = noise1D(vec2(intX, intY + 1.0));
    float v4 = noise1D(vec2(intX + 1.0, intY + 1.0));

    float i1 = mix(v1, v2, fractX);
    float i2 = mix(v3, v4, fractX);
    return mix(i1, i2, fractY);
}

float fbm(float x, float y) {
    float total = 0.0f;
    float persistence = 0.5f;
    int octaves = 8;
    float freq = 2.f;
    float amp = 0.5f;
    for(int i = 1; i <= octaves; i++) {
        total += interpNoise2D(x * freq,
                               y * freq) * amp;

        freq *= 2.f;
        amp *= persistence;
    }
    return total;
}

float bias(float t, float b) {
    return (t / ((((1.0/b) - 2.0)*(1.0 - t))+1.0));
}

float gain(float t, float g) {
    if (t < 0.5f) {
		return bias(1.0f - g, 2.0f * t) / 2.0f;
	}
	else {
		return 1.0 - bias(1.0f - g, 2.0 - 2.0 * t) / 2.0f;
	}
}

float tri_wave(float x, float freq, float amp) {
    return abs(mod(x * freq, amp) - (0.5 * amp));
}

// sphereSDF
float sphereSDF(vec3 query_position, vec3 position, float radius)
{
  return length(query_position - position) - radius;
}

float planeSDF(vec3 queryPos, float height)
{
  return queryPos.y - height;
    
}

float sdCone( vec3 p, vec2 c, float h )
{
  float q = length(p.xz);
  return max(dot(c.xy,vec2(q,p.y)),-h-p.y);
}

float sdCapsule( vec3 p, vec3 a, vec3 b, float r )
{
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}

float sdCappedCone(vec3 p, vec3 a, vec3 b, float ra, float rb)
{
  float rba  = rb-ra;
  float baba = dot(b-a,b-a);
  float papa = dot(p-a,p-a);
  float paba = dot(p-a,b-a)/baba;
  float x = sqrt( papa - paba*paba*baba );
  float cax = max(0.0,x-((paba<0.5)?ra:rb));
  float cay = abs(paba-0.5)-0.5;
  float k = rba*rba + baba;
  float f = clamp( (rba*(x-ra)+paba*baba)/k, 0.0, 1.0 );
  float cbx = x-ra - f*rba;
  float cby = paba - f;
  float s = (cbx<0.0 && cay<0.0) ? -1.0 : 1.0;
  return s*sqrt( min(cax*cax + cay*cay*baba,
                     cbx*cbx + cby*cby*baba) );
}

float dot2(in vec3 v ) { return dot(v,v); }

float sdRoundCone(vec3 p, vec3 a, vec3 b, float r1, float r2)
{
  // sampling independent computations (only depend on shape)
  vec3  ba = b - a;
  float l2 = dot(ba,ba);
  float rr = r1 - r2;
  float a2 = l2 - rr*rr;
  float il2 = 1.0/l2;
    
  // sampling dependant computations
  vec3 pa = p - a;
  float y = dot(pa,ba);
  float z = y - l2;
  float x2 = dot2( pa*l2 - ba*y );
  float y2 = y*y*l2;
  float z2 = z*z*l2;

  // single square root!
  float k = sign(rr)*rr*rr*x2;
  if( sign(z)*a2*z2>k ) return  sqrt(x2 + z2)        *il2 - r2;
  if( sign(y)*a2*y2<k ) return  sqrt(x2 + y2)        *il2 - r1;
                        return (sqrt(x2*a2*il2)+y*rr)*il2 - r1;
}

float smoothUnion( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h); }


float smoothSubtraction( float d1, float d2, float k ) 
{
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return mix( d2, -d1, h ) + k*h*(1.0-h); 
}

float smoothIntersection( float d1, float d2, float k )
{
    float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) + k*h*(1.0-h);
}

// build scene
float sceneSDF(vec3 queryPos, out int obj) 
{
  float fb;

  // head
  float nose = sphereSDF(queryPos, u_Pos + vec3(4.5, 5.8, 0.0), 0.8);
  float uH = sphereSDF(queryPos, u_Pos + vec3(3.2, 6.2, 0.0), 1.4);
  float head = smoothUnion(nose, uH, 0.4);

// body
  float neck = sdCapsule(queryPos, u_Pos + vec3(1.0, 4.8, 0.0), u_Pos + vec3(3.0, 6.4, 0.0), 0.8 );
  float uRS = sphereSDF(queryPos, u_Pos + vec3(0.9, 4.4, -0.6), 1.1);
  float uLS = sphereSDF(queryPos, u_Pos + vec3(0.9, 4.4, 0.6), 1.1);
  float uLL = sdRoundCone(queryPos, u_Pos + vec3(0.9, 4.4, -0.9), u_Pos + vec3(0.9, 0.0, -0.9), 0.8, 0.4);
  float uRL = sdRoundCone(queryPos, u_Pos + vec3(0.9, 4.4, 0.9), u_Pos + vec3(0.9, 0.0, 0.9), 0.8, 0.4);
  float frontL = smoothUnion(uLL, uRL, 0.5);

  float bURS = sphereSDF(queryPos, u_Pos + vec3(-5.0, 4.4, -0.6), 1.1);
  float bULS = sphereSDF(queryPos, u_Pos + vec3(-5.0, 4.4, 0.6), 1.1);
  float bULL = sdRoundCone(queryPos, u_Pos + vec3(-5.0, 4.4, -0.9), u_Pos + vec3(-5.0, 0.0, -0.9), 0.8, 0.4);
  float bURL = sdRoundCone(queryPos, u_Pos + vec3(-5.0, 4.4, 0.9), u_Pos + vec3(-5.0, 0.0, 0.9), 0.8, 0.4);
  float backL = smoothUnion(smoothUnion(smoothUnion(bURS, bULS, 0.1), bULL, 0.5), bURL, 0.5);

  float legs = smoothUnion(frontL, backL, 0.5);
  float nL = smoothUnion(legs, neck, 0.5);

  float skele = sdCapsule(queryPos, u_Pos + vec3(0.5, 4.8, 0.0), u_Pos + vec3(-5.0, 5.0, 0.0), 1.5 );

  float nLS = smoothUnion(nL, skele, 0.5);
  float body = smoothUnion(smoothUnion(uRS, uLS, 0.5), nLS, 0.5);

  // float t1 = sphereSDF(queryPos, u_Pos + vec)

  // tail
  float s1 = sdCappedCone(queryPos, u_Pos + vec3(-5.2, 5.9, 0.0), u_Pos + vec3(-6.7, 5.9, 0.0), 0.5, 0.42);
  float s2 = sdCappedCone(queryPos, u_Pos + vec3(-6.7, 5.9, 0.0), u_Pos + vec3(-8.2, 5.2, 0.0), 0.4, 0.3);
  float s3 = sdCappedCone(queryPos, u_Pos + vec3(-8.2, 5.2, 0.0), u_Pos + vec3(-8.8, 4.0, 0.0), 0.3, 0.25);
  float s4 = sdCappedCone(queryPos, u_Pos + vec3(-8.8, 4.0, 0.0), u_Pos + vec3(-9.8, 1.8, 0.0), 0.25, 0.2);
  float s5 = sdCapsule(queryPos, u_Pos + vec3(-9.8, 1.8, 0.0), u_Pos + vec3(-10.2, 0.3, 0.0), 0.2 );

  float m1 = smoothUnion(s5, s4, 0.2);
  float tail = smoothUnion(smoothUnion(smoothUnion(s1, s2, 0.3), s3, 0.3), m1, 0.2);

  // ears
  float outLE = sdRoundCone(queryPos, u_Pos + vec3(3.5, 6.2, -0.6), u_Pos + vec3(3.2, 7.7, -1.2), 0.5, 0.3);
  float outRE = sdRoundCone(queryPos, u_Pos + vec3(3.5, 6.2, 0.6), u_Pos + vec3(3.2, 7.7, 1.2), 0.5, 0.3);
  float inLE = sdRoundCone(queryPos, u_Pos + vec3(4.0, 6.2, -0.6), u_Pos + vec3(3.7, 7.7, -1.2), 0.5, 0.3);
  float inRE = sdRoundCone(queryPos, u_Pos + vec3(4.0, 6.2, 0.6), u_Pos + vec3(3.7, 7.7, 1.2), 0.5, 0.3);

  float bothLE = smoothSubtraction(inLE, outLE, 0.3);
  float bothRE = smoothSubtraction(inRE, outRE, 0.3);

  float outE = smoothUnion(bothLE, bothRE, 0.5);

  float noseP = sphereSDF(queryPos, u_Pos + vec3(5.2, 5.8, 0.0), 0.2);

  float eye1 = sphereSDF(queryPos, u_Pos + vec3(4.2, 6.5, 0.3), 0.5);
  float eye2 = sphereSDF(queryPos, u_Pos + vec3(4.2, 6.5, -0.3), 0.5);
  float eyelids = smoothUnion(eye1, eye2, 0.3);

  float eye3 = sphereSDF(queryPos, u_Pos + vec3(4.3, 6.4, 0.45), 0.05);
  float eye4 = sphereSDF(queryPos, u_Pos + vec3(4.3, 6.4, -0.45), 0.05);
  float eyeballs = smoothUnion(eye3, eye4, 0.3);

  float eye5 = sphereSDF(queryPos, u_Pos + vec3(4.7, 6.6, 0.4), 0.1);
  float eye6 = sphereSDF(queryPos, u_Pos + vec3(4.7, 6.6, -0.4), 0.1);
  float pupils = smoothUnion(eye5, eye6, 0.3);

  float eyes = smoothUnion(smoothUnion(smoothUnion(eyelids, eyeballs, 0.4), pupils, 0.4), noseP, 0.4);
  
  float whisker1 = sdCappedCone(queryPos, u_Pos + vec3(5.3, 6.7, 1.5), u_Pos + vec3(5.3, 5.0, -1.5), 0.05, 0.05);
  float whisker2 = sdCappedCone(queryPos, u_Pos + vec3(5.3, 5.0, 1.5), u_Pos + vec3(5.3, 6.7, -1.5), 0.05, 0.05);
  float whisker3 = sdCappedCone(queryPos, u_Pos + vec3(5.3, 5.85, 1.5), u_Pos + vec3(5.3, 5.85, -1.5), 0.05, 0.05);

  float whiskers = smoothUnion(smoothUnion(whisker1, whisker2, 0.1), whisker3, 0.1);

  fb = fb * gain(fb, 10.0);
  obj = 0;

  float fullbody = smoothUnion(smoothUnion(smoothUnion(head, body, 0.4), tail, 0.4), outE, 0.4);
  if ((min(eyelids, fullbody) == eyelids) || (min(eyeballs, fullbody) == eyeballs) || (min(pupils, fullbody) == pupils)) {
    if ((min(eyelids, eyeballs) == eyeballs) || (min(eyelids, pupils) == eyelids)) {
      obj = 2;
    } else if (min(eyeballs, pupils) == eyeballs) {
      obj = 1;
    } else {
      obj = 3;
    }
  } else if (min(fullbody, noseP) == noseP) {
    obj = 4;
  }

  float full = smoothUnion(smoothUnion(fullbody, eyes, 0.4), whiskers, 0.1);
  return full;
}


Ray getRay(vec2 uv) {
    Ray ray;
    
    float len = tan(3.14159 * 0.125) * distance(u_Eye, u_Ref);
    vec3 H = -normalize(cross(vec3(0.0, 1.0, 0.0), u_Ref - u_Eye));
    vec3 V = -normalize(cross(H, u_Eye - u_Ref));
    V *= len;
    H *= len * u_Dimensions.x / u_Dimensions.y;
    vec3 p = u_Ref + uv.x * H + uv.y * V;
    vec3 dir = normalize(p - u_Eye);
    
    ray.origin = u_Eye;
    ray.direction = dir;
    return ray;
}

Intersection getRaymarchedIntersection(vec2 uv)
{
  Ray ray = getRay(uv);
  Intersection intersection;
  int hitobj;

  vec3 queryPoint = ray.origin;
  for (int i=0; i < MAX_RAY_STEPS; ++i)
    {
    float n = fbm(queryPoint.x * 10.0, queryPoint.y * 10.0) * 0.25;
    float distanceToSurface = sceneSDF(queryPoint + n, hitobj);
    
    intersection.material_id = 0;
    if (hitobj == 1) {
      intersection.material_id = 1; // lids
    } else if (hitobj == 2) {
      intersection.material_id = 2; // eyeballs
    } else if (hitobj == 3) {
      intersection.material_id = 3; // pupils
    } else if (hitobj == 4) {
      intersection.material_id = 4; // nose
    }

    if (distanceToSurface < EPSILON)
    {
      intersection.position = queryPoint;
      intersection.normal = vec3(0.0, 0.0, 1.0);
      intersection.distance = length(queryPoint - ray.origin);
          
      return intersection;
    }
      
    queryPoint = queryPoint + ray.direction * distanceToSurface;
  }
  
  intersection.distance = -1.0;
  return intersection;
}


vec3 estimateNormal(vec3 p) {
  int dummyVar;
  return normalize(vec3(
    sceneSDF(vec3(p.x + EPSILON, p.y, p.z), dummyVar) - sceneSDF(vec3(p.x - EPSILON, p.y, p.z), dummyVar),
    sceneSDF(vec3(p.x, p.y + EPSILON, p.z), dummyVar) - sceneSDF(vec3(p.x, p.y - EPSILON, p.z), dummyVar),
    sceneSDF(vec3(p.x, p.y, p.z  + EPSILON), dummyVar) - sceneSDF(vec3(p.x, p.y, p.z - EPSILON), dummyVar)
  ));
}

vec3 proceduralColor(vec3 nor, Intersection i)
{
  vec3 color;
  float n = fbm(i.position.x, i.position.y) * u_Stripe;
  float n2 = fbm(i.position.x * 2.0, i.position.y * 2.0) * 1.0;
  float n3 = fbm(i.position.x * 20.0, i.position.y * 20.0) * 0.3;
  n3 = smoothstep(0.1, 0.17, n3);

  if ((i.position.y + n2 > 3.55 + u_Pos.y) && i.position.x > 1.0) {
    if (u_WhiteFront == 1.0) {
      float stripe = gain(nor.x, 0.95);
      color = mix(abs(sin(i.position.x * u_NumStripes + n)) * u_BaseCol + vec3(0.2 * n3, 0.0, 0.0), vec3(1.0,1.0,1.0), stripe);
    } else {
      color = abs(sin(i.position.x * u_NumStripes + n)) * u_BaseCol + vec3(0.2 * n3, 0.0, 0.0);
    }
  } else if ((i.position.y + n2 > 3.55 + u_Pos.y) && i.position.x < 1.0) {
    color = abs(sin(i.position.x * u_NumStripes + n)) * u_BaseCol + vec3(0.2 * n3, 0.0, 0.0);
  } else {
    color = abs(sin(i.position.y * u_NumStripes + n)) * u_BaseCol + vec3(0.2 * n3, 0.0, 0.0);
  }
  
  return color;
}

vec3 getSceneColor(vec2 uv)
{
    Intersection intersection = getRaymarchedIntersection(uv);
    
    DirectionalLight lights[3];
    vec3 backgroundColor = vec3(0.);
    lights[0] = DirectionalLight(normalize(vec3(1.0, 1.0, 1.0)),
                                 SUN_KEY_LIGHT);
    lights[1] = DirectionalLight(vec3(1., 1., 1.),
                                 SKY_FILL_LIGHT);
    lights[2] = DirectionalLight(normalize(-vec3(1.0, 1.0, 1.0)),
                                 SUN_AMBIENT_LIGHT);
    backgroundColor = SUN_KEY_LIGHT;
    
    vec3 n = estimateNormal(intersection.position);

    // function to determine procedural albedo
    vec3 albedo = proceduralColor(n, intersection);

     if (intersection.material_id == 1) {
      albedo = u_BaseCol;
    } else if (intersection.material_id == 2) {
      albedo = vec3(1.0, 1.0, 1.0);
    } else if (intersection.material_id == 3) {
      albedo = vec3(0.0, 0.0, 0.0);
    } else if (intersection.material_id == 4) {
      albedo = vec3(1.0, 0.5, 0.5);
    }
      
    
        
    vec3 color = albedo *
                 lights[0].color *
                 max(0.0, dot(n, lights[0].dir));
    
    if (intersection.distance > 0.0)
    { 
        for(int i = 1; i < 3; ++i) {
            color += albedo *
                     lights[i].color *
                     max(0.0, dot(n, lights[i].dir));
        }
    }
    else
    {
      color = vec3(0.9, 0.8, 0.7);
      // color = vec3(0.5, 0.7, 0.9);
      
    }
      color = pow(color, vec3(1. / 2.2));
      return color;
}

void main() {

  // Normalized pixel coordinates (from 0 to 1)
  vec2 uv = gl_FragCoord.xy / u_Dimensions.xy;
  
  // Make symmetric [-1, 1]
    uv = uv * 2.0 - 1.0;

  // Time varying pixel color
  vec3 col = getSceneColor(uv);
  
  out_Col = vec4(col,1.0);
}
