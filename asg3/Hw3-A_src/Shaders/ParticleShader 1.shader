Shader "Custom/ParticleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StartColor ("Start Color", Color) = (0,0,0,0)
        _EndColor ("End Color", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Opaque" }
        LOD 100
        
        Blend One One
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"    

            struct appdata
            {
                float4 vertex : POSITION;
                //Define UV data
                float3 uv : TEXCOORD0;
            };

            struct v2f
            {   
                float4 vertex : SV_POSITION;
                float3 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _StartColor;
            float4 _EndColor;
          

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.uv.z = v.uv.z;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                
                
                //Get particle age percentage
                float particleAgePercent = i.uv.z;

                //Sample color from particle texture
                fixed4 col = tex2D(_MainTex, i.uv);

                //Find "start color"
                float4 start = _StartColor;
                
                //Find "end color"
                float4 end = _EndColor;
                
                //Do a linear interpolation of start color and end color based on particle age percentage
                col = lerp(start,end, particleAgePercent )*(col.a)*0.15;

                


                return col;
            }
            ENDCG
        }
    }
}
