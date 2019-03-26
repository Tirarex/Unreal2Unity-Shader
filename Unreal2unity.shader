Shader "UNREAL"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {} 
		_Mask("Mask", 2D) = "white" {} 
	    _BumpScale("", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM 
        #pragma surface surf Standard fullforwardshadows
			 
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Normal;
		sampler2D _Mask;

        struct Input
        {
            float2 uv_MainTex;
        };
		 
        fixed4 _Color;

		half _BumpScale;
    
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			//Getting Albedo
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
           
			//Big mask
			fixed4 Mask = tex2D(_Mask, IN.uv_MainTex) ;

			o.Metallic = Mask.b;
			//Invert Roug map
			o.Smoothness = 1-Mask.g;

			o.Occlusion = Mask.r;
			
			fixed4 NormalMap = tex2D(_Normal, IN.uv_MainTex);
			//Invert G channel
			NormalMap.g = 1 - NormalMap.g;
			o.Normal = UnpackScaleNormal(NormalMap, _BumpScale);


			o.Albedo = c.rgb ;
		
        }
        ENDCG
    }
    FallBack "Diffuse"
}
