﻿//Adapted code from Professor Forbes
Shader "Custom/Procedural"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed("Speed", Float) = 1.0
        _Amplitude("Amplitude", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Speed;
            float _Amplitude;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.y += sin(_Time.y * _Speed + v.vertex.x * _Amplitude);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float s = i.uv.x;
                float t = i.uv.y;

                float sum = floor(s * 1) + floor(t * 1);
                bool isEven = fmod(sum,2.0)==0.0;
                float percent = (isEven) ? 1.0 : 0.0;

                float4 col = float4(1.0, 1.0, 1.0, 1.0);

                return col * percent;
            }
            ENDCG
        }
    }
}
