const float PI=3.14159265;
uniform float u_Time;
uniform float u_Rows;
uniform float u_TriScale;
uniform float u_LowTriRange;
uniform float u_HighTriRange;
uniform float u_NumSymbolsPerTri;
uniform float u_HeightT;
uniform float u_SymbolScaleT;
uniform float u_SymbolPositionT;



float bias(float t, float b) {
    return (t / ((((1.0/b) - 2.0)*(1.0 - t))+1.0));
}

float gain(float t, float g) {
    if(t < 0.5){
        return bias(1.0-g, 2.0*t) / 2.0;
    }else{
        return 1.0 - bias(1.0-g, 2.0 - 2.0*t) / 2.0;
    }

}