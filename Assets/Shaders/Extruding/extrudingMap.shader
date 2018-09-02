/*В шейдерах цветные каналы идут от 0 до 1, хотя иногда вам нужно представлять
  отрицательные значения (например, внутренняя экструзия). В этом случае обработайте 0,5 как ноль, 
  имея меньшие значения, которые считаются отрицательными и более высокими значениями как положительные. 
  Это именно то, что происходит с нормалями, которые обычно кодируются в текстурах RGB. Функция UnpackNormal() 
  используется для отображения значения в диапазоне (0,1) в диапазоне (-1, + 1). Математически это эквивалентно tex.r * 2 -1.*/

Shader "Custom/Extruding/extrudingMap" {
  Properties{
    _MainTex("Texture", 2D) = "white" {}
    _ExtrusionTex("Extrusion map", 2D) = "white" {}
    _NormalTex ("Normal Map", 2D) = "bump" {}
    _Amount("Extrusion Amount", Range(-0.0001,0.0001)) = 0
  }
  SubShader {
    Tags{ "RenderType" = "Opaque" }
    CGPROGRAM
    #pragma surface surf Standard vertex:vert

    struct Input {
      float2 uv_MainTex;
    };
    float _Amount;
    sampler2D _ExtrusionTex;
    sampler2D _MainTex;
    sampler2D _NormalTex;

    void vert(inout appdata_full v) {
      float4 tex = tex2Dlod (_ExtrusionTex, float4(v.texcoord.xy, 0, 0));
      float extrusion = tex.r * 2 - 1;
      v.vertex.xyz += v.normal * _Amount * extrusion;
    }

    void surf(Input IN, inout SurfaceOutputStandard o) {
      float4 tex = tex2D(_ExtrusionTex, IN.uv_MainTex);
      float extrusion = abs(tex.r * 2 - 1);
      float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));

      o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
      o.Albedo = lerp(o.Albedo.rgb, float3(0, 0,0), extrusion * _Amount / 0.0001 * 1.1);
      o.Normal = normalMap.rgb;
    }
    ENDCG
  }
  Fallback "Diffuse"
}