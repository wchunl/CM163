// Code references Phong shader from provided class file
// https://creativecoding.soe.ucsc.edu/courses/cmpm163_s19/schedule.php

Shader "Custom/Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Scale ("Scale", Float) = 1.0 // Outline thickness
        _EmmisiveColor("Emmisive Color", Color) = (1, 1, 1, 1)
        _Emissiveness("Emmissiveness", Range(0,10)) = 0
        _Shininess ("Shininess", Float) = 10 //Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags{ "Queue" = "Transparent"}
       pass {
          Cull Front
          // Make character visible through an object
          Ztest Always
          ZWrite Off
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        float4 _Color;
        float _Scale;

        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal: NORMAL;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 normal: NORMAL;
        };

        v2f vert (appdata v)
        {
                v2f o;
                // Scale the position by its normal values
                v.vertex.xyz += v.normal.xyz * _Scale;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                return o;
        }

        float4 frag(v2f i) :SV_Target
        {
            // Return rainbow color
            return float4((normalize(i.normal) + 1.0)/2.0, 1.0) ;
        }

        ENDCG
       }

       pass {
        //    Ztest Always
        CGPROGRAM   
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        float4 _Color;
        float _Scale;
        sampler2D _MainTex;
        float4 _MainTex_ST;

        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal: NORMAL;
            float2 uv: TEXCOORD0;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 normal: NORMAL;
            float2 uv: TEXCOORD0;
        };

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            // Apply the uv texture onto model
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            o.normal = v.normal;
            return o;
        }

        float4 frag(v2f i) :SV_Target
        {
            return tex2D(_MainTex, i.uv);
        }

        ENDCG
       }

       Pass {  
            Tags { "LightMode" = "ForwardAdd" } //Important! In Unity, point lights are calculated in the the ForwardAdd pass
            Blend One One //Turn on additive blending if you have more than one point light
          
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
           
            uniform float4 _LightColor0; //From UnityCG
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess;
    
            uniform float4 _EmmisiveColor;
            uniform float _Emissiveness;   
            sampler _MainTex;       
          
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float3 vertexInWorldCoords : TEXCOORD1;
                    float2 uv: TEXCOORD0;
            };

 
           v2f vert(appdata v)
           { 
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.normal = v.normal; //Normal 
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex); 
                return o;
           }

           fixed4 frag(v2f i) : SV_Target
           {
                
                float3 P = i.vertexInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 H = normalize(L + V);
                
                float3 Kd = _Color.rgb; //Color of object
                float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                //float3 Ka = float3(0,0,0); //UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                float3 Ks = _SpecColor.rgb; //Color of specular highlighting
                float3 Kl = _LightColor0.rgb; //Color of light
                
                //AMBIENT LIGHT 
                float3 ambient = Ka;
                
                //DIFFUSE LIGHT
                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;
                
                //SPECULAR LIGHT
                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                
                if (diffuseVal <= 0) {
                    specularVal = 0;
                }
                
                float3 specular = Ks * Kl * specularVal;
                
                // float4 texColor = tex2D(_MainTex, i.uv);
                float4 texColor = (1.0, 0.0, 0.0 , 1.0);
                //FINAL COLOR OF FRAGMENT
              
                return float4(_EmmisiveColor *  _Emissiveness + ambient+ diffuse + specular, 1.0)*texColor;
 
            }
            
            ENDCG
 
            
        }

    }
    FallBack "Diffuse"
}
