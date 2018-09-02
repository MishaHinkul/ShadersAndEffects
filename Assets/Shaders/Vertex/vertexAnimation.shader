Shader "Custom/Vertex/vertexAnimation" {
  Properties {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _tintAmount ("Main Tint", Range(0, 1)) = 0.5
    _ColorA ("ColorA", Color) = (1, 1, 1, 1)
    _ColorB ("ColorB", Color) = (1, 1, 1, 1)
    _Speed ("Wave speed", Range(0.1, 80)) = 5
    _Frequency ("Wave frequency", Range(0, 5)) = 2
    _Amplitude ("Wave amplitude", Range(-1, 1)) = 1
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    #pragma surface surf Lambert vertex:vert

    sampler2D _MainTex;
    float _tintAmount;
    float4 _ColorA;
    float4 _ColorB;
    float _Speed;
    float _Frequency;
    float _Amplitude;

    struct Input {
      float3 vertColor;
    };

    void vert(inout appdata_full v, out Input o){
      float time = _Time * _Speed;
      float waveValueA = sin(time + v.vertex.x * _Frequency) *_Amplitude;

      v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);
      v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
      o.vertColor = float3(waveValueA, waveValueA, waveValueA);
    }

    void surf (Input IN, inout SurfaceOutput o) {
      half4 c = 1;
      float3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor).rgb;

      o.Albedo = c.rgb * (tintColor * _tintAmount);
      o.Alpha = c.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
