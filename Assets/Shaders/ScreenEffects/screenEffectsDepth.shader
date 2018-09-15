﻿Shader "Custom/ScreenEffects/Depth" {

  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _DepthPower ("DepthPower", Range(1, 5)) = 1.0
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
      sampler2D _CameraDepthTexture; //UnityCG.cginc
      fixed _DepthPower;

      fixed4 frag (v2f i) : COLOR {
        float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv.xy));
        d = pow(Linear01Depth(d), _DepthPower);

        return d;
      }
      ENDCG
    }
  }
}
