Shader "Custom/ScreenEffects/BlendMode/ScreenBlend" {

  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _BlendText ("Blend Texture", 2D) = "white" {}
    _Opacity ("Blend Opacity", Range (0, 1)) = 1
  }

  SubShader {
    // No culling or depth
    Cull Off ZWrite Off ZTest Always

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma fragmentoption ARB_precision_hint_fastest
      
      #include "UnityCG.cginc"

      struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      struct v2f {
        float2 uv : TEXCOORD0;
        float4 vertex : SV_POSITION;
      };

      v2f vert (appdata v) {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = v.uv;
        return o;
      }
      
      sampler2D _MainTex;
      sampler2D _BlendText;
      fixed _Opacity;

      fixed4 frag (v2f i) : COLOR {
        fixed4 main = tex2D(_MainTex, i.uv);
        fixed4 blend = tex2D(_BlendText, i.uv);

        fixed4 blendScreen = (1.0 - ((1.0 - main) * (1.0 - blend)));

        main = lerp(main, blendScreen, _Opacity);

        return main;
      }
      ENDCG
    }
  }
}
