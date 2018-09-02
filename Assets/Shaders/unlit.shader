// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/unlit" {
  Properties {
    _Color ("Color", Color) = (1, 1, 1, 1)
    _MainTex ("Texture", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass {
      CGPROGRAM
      //назначаем ф-ции для обработки вершин и фрагментов
      // термин «фрагмент» часто используется для обозначения сбора данных, необходимых для рисования пикселя. 
      #pragma vertex vert
      #pragma fragment frag

      /*через : пишутся связывающие семантики (binding semantic)
      Это особенность Cg, которая позволяет нам отмечать переменные, 
      чтобы они были инициализированы определенными данными, такими как нормальные векторы и положение вершин и т.д.*/
      struct vertexInput {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };
      /*Хотя Unity будет инициализировать vertInput для нас, мы отвечаем за инициализацию
        vertOutput. Несмотря на это, его поля по-прежнему должны быть украшены связующей семантикой:*/
      struct vertexOutput { 
        float2 uv : TEXCOORD0;
        float4 vertex : SV_POSITION;
      };

      half4 _Color;
      sampler2D _MainTex;
      float4 _MainTex_ST;
      
      vertexOutput vert (vertexInput v) {
        vertexOutput o;
        //UnityObjectToClipPos - Преобразует точку из пространства объекта в пространства камеры
        //в однородных координатах. Это эквивалент mul (UNITY_MATRIX_MVP, float4 (pos, 1.0))
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = v.uv;

        return o;
      }
      
      half4 frag (vertexOutput i) : COLOR {
        half4 mainColor = tex2D(_MainTex, i.uv);
        return mainColor * _Color;
      }
      ENDCG
    }
  }
}