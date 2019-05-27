Shader "Custom/ParticleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //Define properties for Start and End Color
        _StartColor ("Start Color", Color) = (0,0,0,1)
        _EndColor ("End Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Opaque" }
        LOD 100
        
        Blend One One
        ZWrite off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct appdata
            {
                float4 vertex : POSITION;
                //Define UV data
                float4 normal : NORMAL;
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {   
                float4 vertex : SV_POSITION;
                //Define UV data
                float4 normal : NORMAL;
                float4 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _StartColor;
            float4 _EndColor;
          

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; // Correct this for particle shader
                // o.uv.w *= v.uv.w;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {   
                //Get particle age percentage
                float2 noise = i.uv.w;
                float age = i.uv.z;
                
                //Sample color from particle texture
                float4 texColor = tex2D(_MainTex,i.uv.xy);
                
                //Find "start color"
                float4 start = _StartColor;
                
                //Find "end color"
                float4 end = _EndColor;
                
                //Do a linear interpolation of start color and end color based on particle age percentage
                float4 findCol = lerp(_StartColor, _EndColor, age)*(texColor.a);
               
                return findCol;
            }
            ENDCG
        }
    }
}
