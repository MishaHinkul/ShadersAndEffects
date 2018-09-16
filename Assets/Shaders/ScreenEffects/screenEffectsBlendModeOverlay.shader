Shader "Custom/ScreenEffects/BlendMode/Overlay" {

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

      fixed4 OverlayBlendMode(fixed basePixel, fixed blendPixel) {
        if (basePixel < 0.5) {
          return (2.0 * basePixel * basePixel);
        }

         return (1.0 - 2.0 * (1.0 - basePixel) * (1.0 - blendPixel));
      }

      fixed4 frag (v2f i) : COLOR {
        fixed4 main = tex2D(_MainTex, i.uv);
        fixed4 blend = tex2D(_BlendText, i.uv);

        fixed4 blendImage = main;
        blendImage.r = OverlayBlendMode(main.r, blend.r);
        blendImage.g = OverlayBlendMode(main.g, blend.g);
        blendImage.b = OverlayBlendMode(main.b, blend.b);

        main = lerp(main, blendImage, _Opacity);

        return main;
      }
      ENDCG
    }
  }
}
