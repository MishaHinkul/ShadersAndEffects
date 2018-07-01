/*
Показывая только силуэт объекта. Если мы посмотрим на объект под другим углом, его контур изменится. 
Геометрически, ребрами модели являются все те треугольники, нормальное направление которых ортогонально (90 градусов) 
к текущему направлению обзора. Структура ввода объявляет эти параметры, worldNormal и viewDir, соответственно.
*/

Shader "Custom/Holographic" {
  Properties {
    _Color ("Color:", Color) = (1,1,1,1)
    _MainTex ("Main Texture:", 2D) = "white" { }
    _DotProduct ("Rim effect:", Range(-1, 1)) = 0.25
  }
  SubShader {
    Tags {
      "Queue" = "Transparent"
      "IgnoreProjector" = "True" 
      "RenderType"="Transparent" 
    }
    LOD 200
    CGPROGRAM
    #pragma surface surf Lambert alpha:fade nolighting 

    struct Input {
      float2 uv_MainTex;
      float3 worldNormal;
      float3 viewDir; 
    };

    float _DotProduct;
    sampler2D _MainTex;
    fixed4 _Color;

    void surf (Input IN, inout SurfaceOutput o) {
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;

      float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));

      //Это мягкое затухание между краем модели (полностью видимая) и угол, определяемый _DotProduct (невидимый).
      float alpha = (border * (1 - _DotProduct) + _DotProduct);
      o.Alpha = c.a * alpha;
    }
    ENDCG
  }
  FallBack "Diffuse"
}