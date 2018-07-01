Shader "Custom/CircleRadius" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Center ("Center", Vector) = (0, 0, 0, 0)
    _Radius ("Radius:", Float) = 0.5
    _RadiusColor ("Radius Color", Color) = (1, 0, 0, 1)
    _RadiusWith ("Radius With", Float) = 2
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows

    #pragma target 3.0

    sampler2D _MainTex;
    float3 _Center;
    float _Radius;
    float4 _RadiusColor;
    float _RadiusWith;

    struct Input {
      float2 uv_MainTex;
      // мы просим Unity предоставить нам позицию пикселя, который мы рисуем, выраженный в мировых координатах. 
      //Это фактическое положение объекта в редакторе.
      float3 worldPos; 
    };

    void surf (Input IN, inout SurfaceOutputStandard o) {
      float d = distance(_Center, IN.worldPos);
      if (d > _Radius && d < _Radius + _RadiusWith) {
        o.Albedo = _RadiusColor;
      }
      else {
        o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
      }
    }
    ENDCG
  }
  FallBack "Diffuse"
}