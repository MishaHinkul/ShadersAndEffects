Shader "Custom/LightModels/Phong" {
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
    #pragma surface surf CustomPhong

    sampler2D _MainTex;
    float4 _MainTint;
    float4 _SpecularColor;
    float _SpecularPower;

    struct Input {
      float2 uv_MainTex;
    };

    //Модель Фонга предполагает, что конечная интенсивность света отражающей поверхности определяется двумя компонентами: 
    //ее диффузным цветом и зеркальным значением, следующим образом:
    fixed4 LightingCustomPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
      //Reflection
      float NdotL = dot(s.Normal, lightDir);
      float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);

      //Specular
      float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecularPower);
      float3 finalSpec = _SpecularColor.rgb * spec;

      //Final effect
      fixed4 c;
      c.rgb = (s.Albedo * _LightColor0.rgb * max(0, NdotL) * atten) + (_LightColor0.rgb * finalSpec);
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