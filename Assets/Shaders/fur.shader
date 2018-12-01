/*
Техника, представленная в этом рецепте, известна как концентрическая меховая оболочка Ленгьеля/Lengyel’s
техникой или просто оболочкой. Она работает, создавая постепенно большие копии
геометрию, которую нужно визуализировать. При правильной прозрачности это дает иллюзию
непрерывной нити волос.
*/
Shader "Custom/Fur" {
  Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _Glossiness ("Smoothness", Range(0,1)) = 0.5
    _Metallic ("Metallic", Range(0,1)) = 0.0

    _FurLenght ("Fur Lenght", Range(0.0002, 1)) = 0.25
    _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    _CutoffEnd ("Alpha cutoff end", Range(0, 1)) = 0.5
    _EdgeFade ("Edge Fade", Range(0, 1)) = 0.4
    _Gravity ("Gravity direction", Vector) = (0, 0, 1, 0)
    _GravityStrenght ("G strenght", Range(0, 1)) = 0.25
  }
  SubShader {
    Tags {
      "Queue"="Transparent" 
      "IgnoreProjector"="True" 
      "RenderType"="Transparent"
    }
    ZWrite On
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0

    fixed4 _Color;
    sampler2D _MainTex;
    half _Glossiness;
    half _Metallic;

    struct Input {
      float2 uv_MainTex;
    };

    void surf (Input IN, inout SurfaceOutputStandard o) {
      fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;
      o.Metallic = _Metallic;
      o.Smoothness = _Glossiness;
      o.Alpha = c.a;
    }
    ENDCG

    
    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.05
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.1
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.15
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.20
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.25
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.30
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.35
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.40
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.45
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.50
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.55
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.60
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.65
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.70
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.75
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.80
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.85
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.90
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
    #define FUR_MULTIPLIER 0.95
    #include "Assets/CGIncludes/FurPass.cginc"
    ENDCG
  }
  Fallback "Diffuse"
}