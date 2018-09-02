Shader "Custom/Vertex/snow" {
  Properties{
    _MainTex("Main Texture", 2D) = "white" {}
    _MainColor ("Main Tint", Color) = (1, 1, 1, 1)
    _BumpTex("Bump Texture", 2D) = "bump" {}
    _Snow("Level of snow", Range(1, -1)) = 1
    _SnowColor("Color of snow", Color) = (1, 1, 1, 1)
    _SnowDirection ("Direction of snow", Vector) = (0, 1, 0)
    _SnowDepth ("Deph of snow", Range(0, 0.5)) = 0
  }
  SubShader {
    Tags{ "RenderType" = "Opaque" }
    CGPROGRAM
    #pragma surface surf Standard vertex:vert

    struct Input {
      float2 uv_MainTex;
      float2 uv_BumpTex;
      float3 worldNormal;
      INTERNAL_DATA
    };

    sampler2D _MainTex;
    float4 _MainColor;
    sampler2D _BumpTex;
    float _Snow;
    float4 _SnowColor;
    float4 _SnowDirection;
    float _SnowDepth;

    void vert(inout appdata_full v) {
      //Convert _SnowDirection from world space to object space.
      //Так как WorldNormalVector недоступна в вершинной ф-ции
      float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);

      if (dot(v.normal, sn.xyz) >= _Snow) {
        v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
      }
    }

    //В то время как _SnowDirection  представляет собой направление, выраженное в мировых координатах,
    //нормали обычно выражаются в координатах объекта. 
    //Мы не можем сравнивать эти две величины напрямую, потому что они отображаются в разные системы координат. 
    //Unity3D предоставляет функцию WorldNormalVector,  которая может использоваться для отображения нормалей в мировые координаты.
    void surf(Input IN, inout SurfaceOutputStandard o) {
      half4 c = tex2D(_MainTex, IN.uv_MainTex);
      o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
      if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow)
        o.Albedo = _SnowColor.rgb;
      else
        o.Albedo = c.rgb * _MainColor;

        o.Alpha = 1;
    }
    ENDCG
  }
  Fallback "Diffuse"
}