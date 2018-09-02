Shader "Custom/Vertex/volumetricExplosion" {
  Properties {
    _RampTex("Color Ramp", 2D) = "white" {}
    _RampOffset("Ramp offset", Range(-0.5, 0.5)) = 0

    _NoeseTex("Noese Tex", 2D) = "gray" {}
    _Period("Period", Range(0, 1)) = 0.5

    _Amount("_Amount", Range(0, 1.0)) = 0.1
    _ClimpRange("ClimpRange", Range(0, 1.0)) = 1
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    #pragma target 2.0

    sampler2D _RampTex;
    half _RampOffset;

    sampler2D _NoeseTex;
    half _Period;

    half _Amount;
    half _ClimpRange;

    #pragma surface surf Lambert vertex:vert nolightmap

    struct Input {
      float2 uv_NoeseTex;
    };

    void vert(inout appdata_full v) {
      //В шейдере нет ф-ции для получения случайного числа. Воспользуемся шумом. 
      float3 disp = tex2Dlod(_NoeseTex, float4(v.texcoord.xy, 0, 0));

      /*Встроенная переменная _Time [3] используется для получения текущего времени из шейдера, 
      а красный канал шумовой текстуры disp.r используется для обеспечения независимого перемещения каждой вершины. 
      Функция sin () двигает вершины вверх и вниз, имитируя хаотическое поведение взрыва.
      Затем происходит нормальная экструзия:*/
      float time = sin(_Time[3] * _Period + disp.r * 10);

      v.vertex.xyz += v.normal * disp.r * _Amount * time;
    }

    void surf (Input IN, inout SurfaceOutput o) {
      //Здесь текстура шума используется для выбора случайного цвета из текстуры ramp
      float3 noise = tex2D(_NoeseTex, IN.uv_NoeseTex);

      /* С положительные значения, поверхность взрыва имеет тенденцию проявлять больше серых тонов; 
      точно, что происходит, когда оно растворяется. 
      Вы можете использовать _RampOffset, чтобы определить, сколько огня или дыма должно быть в вашем взрыве.*/
      float n = saturate(noise.r + _RampOffset);

      /*При вызове с отрицательным значением текущий пиксель не рисуется.
      Этот эффект контролируется _ClipRange, который определяет, какие пиксели объемного взрыво будут прозрачными.*/
      clip(_ClimpRange - n);
      
      half4 c = tex2D(_RampTex, float2(n, 0.5));
      o.Albedo = c.rgb;
      o.Emission = c.rgb * c.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
