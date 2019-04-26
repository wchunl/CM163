// Code adapted from Edge.shader file
Shader "Custom/Sharpen"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amount ("Amount", Float) = 3
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize; //special value
            uniform float _Amount;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target {

                 float2 texel = float2(
                    _MainTex_TexelSize.x * _Amount, 
                    _MainTex_TexelSize.y * _Amount
                );
                
                // Sharpen Kernel, from wiki
                const float kernel[9] = { 
                                0, -1,  0, 
                               -1,  5, -1, 
                                0, -1,  0   }; 

                float2 ival[9];
                // fetch the 3x3 neighborhood of a fragment
                ival[0] = i.uv + texel * float2( -1,  1 );
                ival[1] = i.uv + texel * float2(  0,  1 );
                ival[2] = i.uv + texel * float2(  1,  1 );
                ival[3] = i.uv + texel * float2( -1,  0 );
                ival[4] = i.uv + texel * float2(  0,  0 );
                ival[5] = i.uv + texel * float2(  1,  0 );
                ival[6] = i.uv + texel * float2( -1, -1 );
                ival[7] = i.uv + texel * float2(  0, -1 );
                ival[8] = i.uv + texel * float2(  1, -1 );
           
                fixed4 avg = 0;
                for (int z = 0; z < 9; z++ ) {
                    avg += tex2D(_MainTex, ival[z]) * kernel[z];
                }
                return avg;
            }
            ENDCG
        }
    }
}
