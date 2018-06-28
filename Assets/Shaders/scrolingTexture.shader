Shader "Custom/ScrollingTextures" {
  Properties {
    _MainTint ("Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _ScrollingXSpeed ("X Scrolling Speed", Range(0, 10)) = 2
    _ScrollingYSpeed ("Y Scrolling Speed", Range(0, 10)) = 2
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0

    struct Input {
      float2 uv_MainTex;
    };

    fixed4 _MainTint;
    fixed _ScrollingYSpeed;
    fixed _ScrollingXSpeed;
    sampler2D _MainTex;

    //float4 _Time - встроенная переменная. Время, начиная с загрузки уровня  (t / 20, t, t * 2, t * 3)
    //Используется для анимации внутри шейдеров.  
    //https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html

    void surf (Input IN, inout SurfaceOutputStandard o) {
      fixed2 scrolledUV = IN.uv_MainTex;

      fixed xScrollValue = _ScrollingXSpeed * _Time;
      fixed yScrollValue = _ScrollingYSpeed * _Time;

      scrolledUV += fixed2(xScrollValue, yScrollValue);

      half4 c = tex2D (_MainTex, scrolledUV);
      o.Albedo = c.rgb * _MainTint;
      o.Alpha = c.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
