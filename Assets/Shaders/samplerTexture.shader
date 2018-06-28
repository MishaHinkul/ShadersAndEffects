Shader "Custom/SamplerTexture" {
  Properties {
    _Color ("Color", Color) = (1, 1, 1, 1)
    _MainTex ("Texture", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0

    //Специальная структура c зарезервированным именем. 
    //Ее содержимое также предопределено
    //http://wiki.unity3d.com/index.php/Shader_Code#Surface_Shader_input_structure_.28Input.29
    struct Input {
      float2 uv_MainTex; //всегда начинать с uv или uv2 + имя текстуры
    };

    sampler2D _MainTex;
    fixed4 _Color;

    void surf (Input IN, inout SurfaceOutputStandard o) {
      // tex2D - выполнить текстурную выборку
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}