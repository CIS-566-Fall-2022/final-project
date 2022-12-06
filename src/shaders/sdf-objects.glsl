

float sphereSDF(vec3 query_position, vec3 position, float radius)
{
    return length(query_position - position) - radius;
}

float planeSDF(vec3 queryPos, float height)
{
    return queryPos.y - height;
}

float bumpyPlaneSDF(vec3 queryPos, float height, float u_Time)
{
    return queryPos.y - height + (0.3*(sin(queryPos.x + 5.4) * cos(queryPos.z)));
}

float rand_3(vec2 p)
{
    return fract(sin(dot(p.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float boxSDF( vec3 p, vec3 b)
{
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);

}

float symbol1SDF( vec3 p){
    // cross thing
    return flatUnion(
        boxSDF(p, vec3(0.1, 0.1, 1.0)),
        boxSDF(p, vec3(1.0, 0.1, 0.1))
    );
}

float symbol2SDF( vec3 p){
    // star thing
    float final;
    final = boxSDF(p, vec3(0.1, 0.1, 1.0));
    final = flatUnion(final, boxSDF(p, vec3(1.0, 0.1, 0.1)));
    final = flatUnion(final, boxSDF(rotate(p, vec3(0, PI/4.0, 0)), vec3(1.0, 0.1, 0.1)));
    final = flatUnion(final, boxSDF(rotate(p, vec3(0, -PI/4.0, 0)), vec3(1.0, 0.1, 0.1)));

    return final;
}

float symbol3SDF( vec3 p){
    // flat twist thing
    float final;
    final = boxSDF(p, vec3(0.1, 0.1, 1.0));
    final = flatUnion(final, boxSDF(translate(p, vec3(-1.0, 0, 0)), vec3(0.1, 0.1, 1.0)));
    final = flatUnion(final, boxSDF(translate(p, vec3(1.0, 0, 0)), vec3(0.1, 0.1, 1.0)));
    final = flatUnion(final, boxSDF(translate(p, vec3(0.5, 0, 0.9)), vec3(0.5, 0.1, 0.1)));
    final = flatUnion(final, boxSDF(translate(p, vec3(-0.5, 0, -0.9)), vec3(0.5, 0.1, 0.1)));

    return final;
}


float value_noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 s = smoothstep(0.0, 1.0, f);
    float nx0 = mix(rand_3(i + vec2(0.0, 0.0)), rand_3(i + vec2(1.0, 0.0)), s.x);
    float nx1 = mix(rand_3(i + vec2(0.0, 1.0)), rand_3(i + vec2(1.0, 1.0)), s.x);
    return mix(nx0, nx1, s.y);
}


float bumpyPlaneSDF2(vec3 p)
{
    const int no = 3;
    float tot = 0.0;
    vec2 q = p.xz * 0.35;
    float a = 0.5;
    float f = 1.0;
    for (int i = 0; i < no; ++i)
    {
        tot += value_noise(q * f) * a;
        a *= 0.5;
        f *= 2.5;
        q = q * mat2(0.5, -0.866, 0.866, 0.5) * 0.65;
        q += vec2(2.5, 4.8);
    }

    float d1 = p.y - tot * 2.0;

    return d1;
}

float cubeSDF(vec3 query_position, vec3 dims )
{
    vec3 d = abs(query_position) - dims;
    return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float capsuleSDF( vec3 queryPos, vec3 a, vec3 b, float r )
{
    vec3 pa = queryPos - a, ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h ) - r;
}

// based on https://www.shadertoy.com/view/Ntd3DX
float pyramidSDF(vec3 q_position, vec3 position, float halfWidth, float halfDepth, float halfHeight) {
    q_position -= position;
    q_position.xz = abs(q_position.xz);

    // bottom
    float s1 = abs(q_position.y) - halfHeight;
    vec3 base = vec3(max(q_position.x - halfWidth, 0.0), abs(q_position.y + halfHeight), max(q_position.z - halfDepth, 0.0));
    float d1 = dot(base, base);

    vec3 q = q_position - vec3(halfWidth, -halfHeight, halfDepth);
    vec3 end = vec3(-halfWidth, 2.0 * halfHeight, -halfDepth);
    vec3 segment = q - end * clamp(dot(q, end) / dot(end, end), 0.0, 1.0);
    float d = dot(segment, segment);

    // side
    vec3 normal1 = vec3(end.y, -end.x, 0.0);
    float s2 = dot(q.xy, normal1.xy);
    float d2 = d;
    if (dot(q.xy, -end.xy) < 0.0 && dot(q, cross(normal1, end)) < 0.0) {
        d2 = s2 * s2 / dot(normal1.xy, normal1.xy);
    }
    // front/back
    vec3 normal2 = vec3(0.0, -end.z, end.y);
    float s3 = dot(q.yz, normal2.yz);
    float d3 = d;
    if (dot(q.yz, -end.yz) < 0.0 && dot(q, cross(normal2, -end)) < 0.0) {
        d3 = s3 * s3 / dot(normal2.yz, normal2.yz);
    }
    return sqrt(min(min(d1, d2), d3)) * sign(max(max(s1, s2), s3));
}

float triprism(vec3 q_position, float halfWidth, float halfHeight, float halfDepth) {
    
    q_position.x = abs(q_position.x);
    q_position.xy -= vec2(halfWidth, -halfHeight);
    vec2 end = vec2(-halfWidth, halfHeight * 2.0);
    vec2 segment = q_position.xy - end * clamp(dot(q_position.xy, end) / dot(end, end), 0.0, 1.0);
    float d1 = length(segment);
    if (max(segment.x, segment.y) < 0.0) {
        d1 = -min(d1, q_position.y);
    }
    float d2 = abs(q_position.z) - halfDepth;
    return length(max(vec2(d1, d2), 0.0)) + min(max(d1, d2), 0.0);
}

// https://math.stackexchange.com/questions/1641859/distance-function-for-n-prism
float nGon(in int n, in vec2 p, in float r) {
    // these 2 lines can be precomputed
    float an = 6.2831853 / float(n);
    float he = r * tan(0.5 * an);

    // rotate to first sector
    p = -p.yx; // if you want the corner to be up
    float bn = an * floor((atan(p.y, p.x) + 0.5 * an) / an);
    vec2 cs = vec2(cos(bn), sin(bn));
    p = mat2(cs.x, -cs.y, cs.y, cs.x) * p;

    // side of polygon
    return length(p - vec2(r, clamp(p.y, -he, he))) * sign(p.x-r);
}

float toPrism(in float d2d, in float v, in float size) {
    vec2 d = vec2(d2d, abs(v) - 0.5 * size);
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float nPrism(in vec3 p, in int n, in float r, in float depth) {
    float d = nGon(n, p.xy, r);
    return toPrism(d, p.z, depth);
}

float sdTorus( vec3 p, vec2 t )
{
    vec2 q = vec2(length(p.xz)-t.x,p.y);
    return length(q)-t.y;
}

float sdCappedTorus(in vec3 p, in vec2 sc, in float ra, in float rb)
{
    p.x = abs(p.x);
    float k = (sc.y*p.x>sc.x*p.y) ? dot(p.xy,sc) : length(p.xy);
    return sqrt( dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
}

float hourglass(vec3 p){
    return sdTorus(p, vec2(0.15, 0.03));
}

float randomSymbol(vec3 p, float r){
    float tot = 4.0;
    if(r < 1.0/tot){
        return symbol1SDF(p);
    }else if(r < 2.0/tot){
        return symbol2SDF(p);
    }else if(r < 3.0/tot){
        return symbol3SDF(p);
    }else{
        return sdTorus(p, vec2(0.40, 0.10));
    }
}

float pyramidNormalSDF(vec3 p, float h, float depth, float depth_scale, float num_splits, float split_height_scale) {
    //q_position -= position;
    vec3 q_position = p;

    float m2 = h*h + 0.25;

    p.xz = abs(p.xz);
    p.xz = (p.z>p.x) ? p.zx : p.xz;
    p.xz -= 0.5;

    vec3 q = vec3( p.z, h*p.y - 0.5*p.x, h*p.x + 0.5*p.y);

    float s = max(-q.x,0.0);
    float t = clamp( (q.y-0.5*p.z)/(m2+0.25), 0.0, 1.0 );

    float a = m2*(q.x+s)*(q.x+s) + q.y*q.y;
    float b = m2*(q.x+0.5*t)*(q.x+0.5*t) + (q.y-m2*t)*(q.y-m2*t);

    float d2 = min(q.y,-q.x*m2-q.y*0.5) > 0.0 ? 0.0 : min(a,b);

    float mainPyramid = sqrt( (d2+q.z*q.z)/m2 ) * sign(max(q.z,-p.y));

    float slant = atan(0.5/h); // 1/2 base , height
    float prisim1 = nPrism(transform(q_position, vec3(slant, 0, 0), vec3(0, 0, 0)), 3, 0.1, 1.0);

    float final = mainPyramid;

    //float num_splits = 15.0;
    
    float slant_height = sqrt(h*h + 0.25);
    float greeble_height = (slant_height / num_splits) * split_height_scale * 0.5;
    float greeble_width = (1.0/slant_height) * greeble_height;




    for(float g_i=0.0; g_i<4.0; g_i++){
        float g_rot = g_i * (PI/2.0);
//
//        for(float b_i=0.0; b_i<10.0; b_i++){
//            //bars
//
//            float y_min = 0.0;
//            float y_max = h;
//            float _y1 = y_min + random(vec2(b_i+1.0, b_i)) * (y_max - y_min);
//
//            float z_min = -0.5 * (h - _y1);
//            float z_max = 0.5 * (h - _y1);
//            float _z1 = z_min + random(vec2(b_i+1.0, b_i+1.0)) * (z_max - z_min);
////            _z = 0.05;
////            _y = u_NumSymbolsPerTri;
//            float _x1 = 0.5 - (tan(slant) * _y1);
//            vec3 prisim_transform = transform(q_position, vec3(0, g_rot, 0), vec3(0, 0, 0)); // rotate to a different pyramid face (of four)
//            prisim_transform = transform(prisim_transform, vec3(0, PI/2.0, 0), vec3(_x1, _y1, _z1)); // translate to the position on the face and rotate so prism "points outward
//            prisim_transform = transform(prisim_transform, vec3(-slant, 0, 0), vec3(0, 0, 0));
//            prisim_transform = transform(prisim_transform, vec3(0, random(vec2(b_i+1.0, b_i+1.0))*PI/16.0, 0), vec3(0, 0, 0));
//            float prisim = triprism(prisim_transform, 0.01, 0.01, 0.1);
//            final = flatUnion(final, prisim);
//
//        }

        // the main triangles that get shifted in/out
        for(float i=0.0; i<num_splits; i++){

            float _zinc = (tan(slant) * (h / num_splits));
            float _zstart = -_zinc * (num_splits-i-1.0);
            for(float j=0.0; j<((num_splits-i)*2.0)-1.0; j++){
                float _y = (h/num_splits * (i+1.0)) - (h/ (num_splits * 2.0));
                //_y += -(greeble_height/4.0) + ((2.0*greeble_height/4.0)*mod(j,2.0));
                float _x = 0.5 - (tan(slant) * _y);
                float _z = _zstart;
                _zstart += _zinc;

                // these transforms could probably be optimized...
                vec3 prisim_transform = transform(q_position, vec3(0, g_rot, 0), vec3(0, 0, 0)); // rotate to a different pyramid face (of four)
                prisim_transform = transform(prisim_transform, vec3(0, PI/2.0, 0), vec3(_x, _y, _z)); // translate to the position on the face and rotate so prism "points outward"
                vec3 shape_transform = transform(prisim_transform, vec3(-slant+PI/2.0, 0.0, 0), vec3(0,0,0));

                // low = -1.0  high = 2.0
                float noiseHeight = depth*(u_LowTriRange + (u_HighTriRange - u_LowTriRange) * random3d(vec3(_x+j, _y+i, _z+g_rot)));
                float noiseTransform = depth_scale*noiseHeight;
                float zshift = noiseTransform;
                prisim_transform = transform(prisim_transform, vec3(-slant, 0, PI*mod(j,2.0)), vec3(0, 0, 0));
                if(noiseHeight < 0.0){
                    zshift += 0.02;  // prevent z-fighting during subtraction
                }
                prisim_transform = transform(prisim_transform, vec3(0, 0, 0), vec3(0, 0, zshift));
                float prisim = triprism(prisim_transform, greeble_width, greeble_height, abs(noiseTransform));

                float scale = 0.02 + 0.04 * random(vec2(_x+i, _z+g_rot));
                shape_transform = transform(shape_transform, vec3(0, 0, 0), vec3(-0.01+0.02*random(vec2(_x+i+_y, _z+g_rot)), -0.01+0.02*random(vec2(_x+i, _z+g_rot)), 0.0), vec3(1.0 * scale, 1000.0 * scale, 1.0 * scale));
                prisim = flatSubtraction(prisim, randomSymbol(shape_transform, random(vec2(_x+j+i, _z+g_rot))));

                //                for(float k=0.0; k<u_NumSymbolsPerTri; k++){
                //                    float scale = 0.02 + 0.04 * random(vec2(_x+i, _z+g_rot+k));
                //                    vec3 shape_transform2 = transform(shape_transform, vec3(0, 0, 0), vec3(-0.1+0.2*random(vec2(_x+i+_y+u_SymbolPositionT, _z+g_rot+k)), -0.1+0.2*random(vec2(_x+i+k+u_SymbolPositionT, _z+g_rot)), -0.02+0.04*random(vec2(k+u_SymbolPositionT, k))), vec3(1.0 * scale, 1000.0 * scale, 1.0 * scale));
                //                    prisim = flatSubtraction(prisim, randomSymbol(shape_transform2, random(vec2(_x+j+i, _z+g_rot+k))));
                //                }

                if(noiseHeight > 0.0){
                    final = flatUnion(final, prisim);
                }else{
                    final = flatSubtraction(final, prisim);
                }

            }

        }

        // spread symbols randomly
//        for(float i=0.0; i<5.0; i++){
//            float _y = random1d(i+g_i) * h;
//            float _x = 0.5 - (tan(slant) * _y);
//            float _z = -0.5 * (1.0-_y) + random1d(_y);
//            //_z = 0.0;
//
//
//            vec3 shape_transform = transform(q_position, vec3(0, g_rot, 0), vec3(0, 0, 0));
//            shape_transform = transform(shape_transform, vec3(0, PI/2.0, 0), vec3(_x, _y, _z));
//            shape_transform = transform(shape_transform, vec3(-slant+PI/2.0, 0, 0), vec3(0, 0, 0));
//            float scale = 0.05;
//            shape_transform = transform(shape_transform, vec3(0, 0, 0), vec3(0, 0.02, 0), vec3(1.0 * scale, 7.0 * scale, 1.0 * scale));
//
//            float shape = randomSymbol(shape_transform, random1d(_x));
//            final = flatSubtraction(final, shape);
//
//        }

        break;
    }
    



    return final;
}