Shader "Custom/NormalMap" {
  Properties {
    _MainTint ("Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _NormalTex ("Normal Map", 2D) = "bump" {}
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

    void surf (Input IN, inout SurfaceOutput o) {
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;

      //При выборке текстуры вы получаете значения RGB от 0 до 1; 
      //Однако направления вектора нормали  варьируются от -1 до 1.
      //UnpackNormal () выводит эти компоненты в правильном диапазоне.

      float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
      o.Albedo = c.rgb;
      o.Normal = normalMap.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}