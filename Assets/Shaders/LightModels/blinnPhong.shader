//BlinnPhong Specular почти точно похож на Phong Specular, за исключением того, что он более эффективен, 
//потому что он использует меньше кода для достижения почти того же эффекта. До внедрения физически-рендеринга
//этот подход был выбором по умолчанию для зеркального отражения в Unity 4.

Shader "Custom/LightModels/BlinnPhong" {
  Properties {
    _MainTint ("Main Tint", Color) = (1, 1, 1, 1)
    _MainTex("Main Tex", 2D) = "white" {}
    _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
    _SpecularPower ("SpecularPower", Range(0, 30)) = 1
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    CGPROGRAM
    #pragma surface surf CustomBlinnPhong

    sampler2D _MainTex;
    float4 _MainTint;
    float4 _SpecularColor;
    float _SpecularPower;

    struct Input {
      float2 uv_MainTex;
    };

    //Вычисление вектора отражения R обычно является дорогостоящим. 
    //BlinnPhong Specular заменяет его половинным вектором H между направлением зрения V и направлением света L
    fixed4 LightingCustomBlinnPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
      float NdotL = max(0, dot(s.Normal, lightDir));
      float3 halfVector = normalize(lightDir + viewDir);
      float NdotH = max(0, dot(s.Normal, halfVector));
      float spec = pow(NdotH, _SpecularPower) * _SpecularColor;

      fixed4 c;
      c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec) * atten;
      c.a = s.Alpha;

      return c;
    }

    void surf (Input IN, inout SurfaceOutput o) {
      o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _MainTint.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}