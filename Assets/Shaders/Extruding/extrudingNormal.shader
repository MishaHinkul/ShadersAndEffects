Shader "Custom/Extruding/extrudingNormal" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _NormalTex ("Normal Map", 2D) = "bump" {}
    _Color ("Main Tint", Color) = (1, 1, 1, 1)
    _Amount ("Extrudi amount", Range(-0.0001,0.0001)) = 0
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

      CGPROGRAM
      #pragma surface surf Lambert vertex:vert

      sampler2D _MainTex;
      sampler2D _NormalTex;
      fixed4 _Color;
      float _Amount;

    struct Input {
      float2 uv_MainTex;
    };

    void vert (inout appdata_full v) {
      v.vertex.xyz += v.normal *_Amount;
    }

    void surf (Input IN, inout SurfaceOutput o) {
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));

      o.Albedo = c.rgb;
      o.Normal = normalMap.rgb;
    }
    ENDCG
  }
}