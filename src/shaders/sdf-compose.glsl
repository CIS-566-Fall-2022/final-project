


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

// non smooth combinations https://www.ronja-tutorials.com/post/035-2d-sdf-combination/

float flatUnion(float shape1, float shape2){
    return min(shape1, shape2);
}

float flatIntersection(float shape1, float shape2){
    return max(shape1, shape2);
}

float flatSubtraction(float base, float subtraction){
    return flatIntersection(base, -subtraction);
}

//float flatInterpolatation(float shape1, float shape2, float amount){
//  return lerp(shape1, shape2, amount);
//}

vec3 transform(vec3 q, vec3 rot, vec3 trans){
    mat4 S = mat4(
        vec4(1, 0, 0, 0),
        vec4(0, 1, 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1));

    // Rotation in XY
    mat4 Rx = mat4(
        vec4(1, 0, 0, 0),        
        vec4(0, cos(rot.x), -sin(rot.x), 0),
        vec4(0, sin(rot.x), cos(rot.x), 0),
        vec4(0, 0, 0, 1));        
    mat4 Ry = mat4(
        vec4(cos(rot.y), 0, sin(rot.y), 0),
        vec4(0, 1, 0, 0),
        vec4(-sin(rot.y), 0, cos(rot.y), 0),
        vec4(0, 0, 0, 1));
    mat4 Rz = mat4(
        vec4(cos(rot.z), -sin(rot.z), 0, 0),
        vec4(sin(rot.z), cos(rot.z), 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1));
    
    // Translate to (3, 3, 3)
    mat4 T = mat4(
        vec4(1, 0, 0, trans.x),
        vec4(0, 1, 0, trans.y),
        vec4(0, 0, 1, trans.z),
        vec4(0, 0, 0, 1));
    return (vec4(q, 1) * inverse(S  * Rz * Ry * Rx * T)).xyz;
}

vec3 transform(vec3 q, vec3 rot, vec3 trans, vec3 scale){
    mat4 S = mat4(
        vec4(1.0*scale.x, 0, 0, 0),
        vec4(0, 1.0*scale.y, 0, 0),
        vec4(0, 0, 1.0*scale.z, 0),
        vec4(0, 0, 0, 1));

    // Rotation in XY
    mat4 Rx = mat4(
        vec4(1, 0, 0, 0),
        vec4(0, cos(rot.x), -sin(rot.x), 0),
        vec4(0, sin(rot.x), cos(rot.x), 0),
        vec4(0, 0, 0, 1));
    mat4 Ry = mat4(
        vec4(cos(rot.y), 0, sin(rot.y), 0),
        vec4(0, 1, 0, 0),
        vec4(-sin(rot.y), 0, cos(rot.y), 0),
        vec4(0, 0, 0, 1));
    mat4 Rz = mat4(
        vec4(cos(rot.z), -sin(rot.z), 0, 0),
        vec4(sin(rot.z), cos(rot.z), 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1));

    // Translate to (3, 3, 3)
    mat4 T = mat4(
        vec4(1, 0, 0, trans.x),
        vec4(0, 1, 0, trans.y),
        vec4(0, 0, 1, trans.z),
        vec4(0, 0, 0, 1));
    return (vec4(q, 1) * inverse(S  * Rz * Ry * Rx * T)).xyz;
}