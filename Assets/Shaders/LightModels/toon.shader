//Тоновое затенение (также известное как cel shading ). Это не фотореалистичный стиль рендеринга, который меняет способ отражения света на модели, 
//чтобы дать иллюзию, будто он нарисован. Чтобы реализовать этот стиль, нам нужно заменить стандартную модель освещения.
//Наиболее распространенным методом достижения этого стиля является использование дополнительной текстуры, называемой _RampTex

Shader "Custom/LightModels/Toon" {
  Properties {
    _MainTex("Texture", 2D) = "white" {}
    _RampTex ("Ramp", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    CGPROGRAM
    #pragma surface surf Toon

    sampler2D _MainTex;
    sampler2D _RampTex;

    struct Input {
      float2 uv_MainTex;
    };

    fixed4 LightingToon (SurfaceOutput s, fixed3 lightDir, fixed atten) {
      half NdotL = dot(s.Normal, lightDir); //коэффициент интенсивности 
      NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5)); //используем текстуру рампы для повторной привязки ее к другому набору значений. Все зависит от Ramp-текстуры.

      fixed4 c;
      c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;
      c.a = s.Alpha;

      return c;
    }

    void surf (Input IN, inout SurfaceOutput o) {
      o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}