Shader "Custom/NormalMapIntensity" {
  Properties {
    _MainTint ("Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _NormalTex ("Normal Map", 2D) = "bump" {}
    _NormalMapIntensity("Noarmal Map Intensity", Range(0, 5)) = 1
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    #pragma surface surf Lambert
    #pragma target 3.0

    struct Input {
      float2 uv_MainTex;
      float2 uv_NormalTex;
    };

    float4 _MainTint;
    sampler2D _NormalTex;
    sampler2D  _MainTex;
    float _NormalMapIntensity;

    void surf (Input IN, inout SurfaceOutput o) {
      float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
      normalMap.x *= _NormalMapIntensity;
      normalMap.y *= _NormalMapIntensity;

      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;

      o.Albedo = c.rgb;
      o.Normal = normalize(normalMap);
    }
    ENDCG
  }
  FallBack "Diffuse"
}