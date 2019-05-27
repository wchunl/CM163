Shader "CM163/TreeShader"
{
    Properties
    {   
        _Color ("Color", Color) = (1, 1, 1, 1) 
        _Shininess ("Shininess", Float) = 10 
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) 
        _MainTex ("Texture", 2D) = "white" {}
        
        // Define property for bend
        _Bend ("Bend", Float) = 0
       
    }
    
    SubShader
    {
        Pass {
            Tags { "LightMode" = "ForwardAdd" }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
           
            uniform float4 _LightColor0; 
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform float _Bend;
 
           

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

                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
                o.normal = v.normal; 
                o.uv = v.uv;
                
                // Do vertex displacement based on _Bend
                v.vertex.xz = v.vertex.xz * _Bend * 1.8;

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
                
                float4 texColor = tex2D(_MainTex, i.uv);
                //FINAL COLOR OF FRAGMENT
              
                return float4(ambient+ diffuse + specular, 1.0)*texColor;
 
            }
            
            ENDCG
 
            
        }
            
    }
}
