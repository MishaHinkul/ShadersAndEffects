Shader "Custom/ScreenEffects/BlendMode/Additive" {

  Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _VignetteTex ("Vignette Texture", 2D) = "white"{}
    _ScratchesTex ("Scartches Texture", 2D) = "white"{}
    _DustTex ("Dust Texture", 2D) = "white"{}
    _SepiaColor ("Sepia Color", Color) = (1,1,1,1)
    _EffectAmount ("Old Film Effect Amount", Range(0,1)) = 1.0
    _VignetteAmount ("Vignette Opacity", Range(0,1)) = 1.0
    _ScratchesYSpeed ("Scratches Y Speed", Float) = 10.0
    _ScratchesXSpeed ("Scratches X Speed", Float) = 10.0
    _dustXSpeed ("Dust X Speed", Float) = 10.0
    _dustYSpeed ("Dust Y Speed", Float) = 10.0
    _RandomValue ("Random Value", Float) = 1.0
    _Contrast ("Contrast", Float) = 3.0
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
      
      uniform sampler2D _MainTex;
      uniform sampler2D _VignetteTex;
      uniform sampler2D _ScratchesTex;
      uniform sampler2D _DustTex;
      fixed4 _SepiaColor;
      fixed _VignetteAmount;
      fixed _ScratchesYSpeed;
      fixed _ScratchesXSpeed;
      fixed _dustXSpeed;
      fixed _dustYSpeed;
      fixed _EffectAmount;
      fixed _RandomValue;
      fixed _Contrast;

      fixed4 frag (v2f i) : COLOR {
        //Get the colors from the RenderTexture and the uv's
        //from the v2f_img struct
        half2 distortedUV = half2(i.uv.x, i.uv.y + (_RandomValue * _SinTime.z * 0.005));
        fixed4 renderTex = tex2D(_MainTex, i.uv);
        //Get the pixels from the Vignette Texture
        fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

        //Process the Scratches UV and pixels
        half2 scratchesUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed), i.uv.y + (_Time.x * _ScratchesYSpeed));
        fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);

        //Process the Dust UV and pixels
        half2 dustUV = half2(i.uv.x + (_RandomValue * (_SinTime.z * _dustXSpeed)), i.uv.y + (_RandomValue * (_SinTime.z * _dustYSpeed)));
        fixed4 dustTex = tex2D(_DustTex, dustUV);

        // get the luminosity values from the render texture using the YIQ values.
        fixed lum = dot (fixed3(0.299, 0.587, 0.114), renderTex.rgb);
        //Add the constant color to the lum values
        fixed4 finalColor = lum + lerp(_SepiaColor, _SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 1.0f), _RandomValue);
        finalColor = pow(finalColor, _Contrast);

        //Create a constant white color we can use to adjust opacity of effects
        fixed3 constantWhite = fixed3(1,1,1);
        //Composite together the different layers to create finsl Screen Effect
        finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
        finalColor.rgb *= lerp(scratchesTex, constantWhite, (_RandomValue));
        finalColor.rgb *= lerp(dustTex.rgb, constantWhite, (_RandomValue * _SinTime.z));
        finalColor = lerp(renderTex, finalColor, _EffectAmount);

        return finalColor;
      }
      ENDCG
    }
  }
}