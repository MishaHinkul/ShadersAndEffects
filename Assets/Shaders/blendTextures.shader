Shader "Custom/BlendTextures" {
  Properties {
    _MaintTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
    _ColorA ("Terrein Color A", Color) = (1, 1, 1, 1)
    _ColorB ("Terrein Color B", Color) = (1, 1, 1, 1)
    _RTexture ("R Channel Texture", 2D) = "" {}
    _GTexture ("G Channel Texture", 2D) = "" {}
    _BTexture ("B Channel Texture", 2D) = "" {}
    _BlendTex ("Blend Texture", 2D) = "" {}

  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM

    #pragma surface surf Lambert

    float4 _MaintTint;
    float4 _ColorA;
    float4 _ColorB;
    sampler2D _RTexture;
    sampler2D _GTexture;
    sampler2D _BTexture;
    sampler2D _ATexture;
    sampler2D _BlendTex;

    struct Input {
      float2 uv_RTexture;
      float2 uv_GTexture;
      float2 uv_BTexture;
      float2 uv_BlendTex;
    };

    void surf(Input IN, inout SurfaceOutput o) {
      float4 blendData = tex2D (_BlendTex, IN.uv_BlendTex);

      float4 rTextData = tex2D (_RTexture, IN.uv_RTexture);
      float4 gTextData = tex2D (_GTexture, IN.uv_GTexture);
      float4 bTextData = tex2D (_BTexture, IN.uv_BTexture);

      float4 finalColor = 1.0;
      finalColor = lerp(rTextData, gTextData, blendData.g);
      finalColor = lerp(finalColor, bTextData, blendData.b);
      finalColor.a = 1.0;

      float4 terreinLayers = lerp(_ColorA, _ColorB, blendData.r);
      finalColor *= terreinLayers;
      finalColor = saturate(finalColor);
      o.Albedo = finalColor.rgb;
      o.Alpha = finalColor.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
