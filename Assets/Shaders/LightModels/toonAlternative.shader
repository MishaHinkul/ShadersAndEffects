Shader "Custom/LightModels/ToonAlternative" {
  Properties {
    _MainTex("Texture", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    CGPROGRAM
    #pragma surface surf Toon

    sampler2D _MainTex;
    half _CelShadingLevels;

    struct Input {
      float2 uv_MainTex;
    };

    fixed4 LightingToon (SurfaceOutput s, fixed3 lightDir, fixed atten) {
      half NdotL = dot(s.Normal, lightDir);

      //Альтернативой рамп-текстурам является привязка интенсивности света NdotL, чтобы она могла принять определенное количество значений, равноудаленных от 0 до 1.
      half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels -0.5);

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