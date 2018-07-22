//Согласно освещенности Ламберта, количество света, отражаемого поверхностью, зависит от угла между падающим светом и нормалью поверхности.

Shader "Custom/LightModels/Lambert" {
  Properties {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200
    
    CGPROGRAM
    //это говорит какую функцию затемнения мы используем. Если это наша собственная модель, а не готовая
    //начинайть нужно с слова Lighting
    #pragma surface surf SimpleLambert 

    //вызывается после ф-ции surf
    //attenuation - затухание
    half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
      //NdotL  представляет коэффициент интенсивности, который затем умножается на цвет света.
      half NdotL = dot(s.Normal, lightDir);
      half4 c;
      //Параметры atten  используются для модуляции интенсивности света. Причина, по которой он умножается на два, - это трюк,
      //первоначально используемый Unity3D для имитации определенных эффектов. Как объяснил  Арас Пранкявичюс, 
      //он был сохранен в Unity4 для обратной совместимости. Это окончательно было зафиксировано в Unity5, поэтому,
      //если вы переопределяете модель Lambertian для Unity5, просто умножьте ее на единицу.
      c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 1);
      c.a = s.Alpha;

      return c;
    }

    sampler2D _MainTex;

    struct Input {
      float2 uv_MainTex;
    };

    void surf (Input IN, inout SurfaceOutput o) {
      o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
