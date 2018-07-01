Shader "Custom/Transparent" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
  }
  SubShader {
    //Теги используются для добавления информации о том как объекты будут отображаться. 
    //Unity по умолчанию будет сортировать ваши объекты для вас на основе расстояния от камеры. 
    //Поэтому, когда объект приближается к камере, он будет нарисован поверх всех объектов, 
    //которые находятся дальше от камеры. В большинстве случаев это отлично подходит для игр.

    Tags { 
      "RenderType" = "Transparent"
      "IgnoreProjector" = "True"
      "Queue" = "Transparent" //порядок отрисовки
    }
    LOD 200
    
    CGPROGRAM
    // это означает, что все пиксели из этого
    //материала должен смешиваться с тем, что было на экране раньше, в соответствии с их альфа-значениями. 
    //Без этой директивы пиксели будут рисоваться в правильном порядке, но они не будут имеют никакой прозрачности.

    #pragma surface surf Standard alpha:fade
    #pragma target 3.0

    sampler2D _MainTex;
    fixed4 _Color;

    struct Input {
      float2 uv_MainTex;
    };

    void surf (Input IN, inout SurfaceOutputStandard o) {
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;
      o.Alpha = c.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}