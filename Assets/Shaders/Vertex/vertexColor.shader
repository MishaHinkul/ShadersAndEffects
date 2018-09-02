Shader "Custom/Vertex/vertexColor" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    #pragma surface surf Lambert vertex:vert //используем вершиннуб ф-цию с именем vert

    struct Input {
      float4 vertColor;
    };
    fixed4 _Color;

    void vert(inout appdata_full v, out Input o) {
 //   UNITY_INITIALIZE_OUTPUT(Input, o); добавить строку, если пишем шейдер под DirectX 11
      o.vertColor = v.color;
    }

    void surf (Input IN, inout SurfaceOutput o) {
      o.Albedo = IN.vertColor.rgb * _Color.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}