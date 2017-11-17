cbuffer cbData
{
	float4x4 World; 
	float4x4 View; 
	float4x4 Projection;

	float4 gDiffuseMtrl; 
	float4 gDiffuseLight; 
	float3 gLightVecW;

	float4 gAmbientLight;
	float4 gAmbientMtrl;

	float4 gSpecularMtrl;
	float4 gSpecularLight;
	float gSpecularPower;
	float3 gEyePosW;
};

struct VS_IN
{
	float4 posL   : POSITION;
	float3 normalL : NORMAL;
};

struct VS_OUT
{
	float4 Pos  : SV_POSITION;
	float3 Norm : NORMAL;
	float3 PosW : POSITION;
};

VS_OUT VS(VS_IN vIn)
{
	VS_OUT output = (VS_OUT)0;

	output.Pos = mul( vIn.posL, World );
	output.PosW = output.Pos;

	// Compute the vector from the vertex to the eye position.
	// output.Pos is currently the position in world space
	//float3 toEye = normalize(gEyePosW - output.Pos.xyz);
	output.Pos = mul( output.Pos, View );
	output.Pos = mul( output.Pos, Projection );

	// Convert from local to world normal
	float3 normalW = mul(float4(vIn.normalL, 0.0f), World).xyz;
	normalW = normalize(normalW);

	output.Norm = normalW;

	// Compute Colour
	// Compute the reflection vector.
	float3 r = reflect(-gLightVecW, normalW);

	// Determine how much (if any) specular light makes it
	// into the eye.
	float t = pow(max(dot(r, toEye), 0.0f), gSpecularPower);

	// Determine the diffuse light intensity that strikes the vertex.
	float s = max(dot(gLightVecW, normalW), 0.0f);

	// Compute the ambient, diffuse, and specular terms separately.
	float3 spec = t*(gSpecularMtrl*gSpecularLight).rgb;
	float3 diffuse = s*(gDiffuseMtrl*gDiffuseLight).rgb;
	float3 ambient = gAmbientMtrl * gAmbientLight;

	// Sum all the terms together and copy over the diffuse alpha.
	output.Col.rgb = ambient + diffuse + spec;
	output.Col.a = gDiffuseMtrl.a;

	return output;
}

/*float4 PS(VS_OUT pIn) : SV_Target
{
	float3 toEye = normalize(gEyePosW - pIn.PosW.xyz);

	// Compute Colour
	// Compute the reflection vector.
	float3 r = reflect(-gLightVecW, pIn.Norm);

	// Determine how much (if any) specular light makes it
	// into the eye.
	float t = pow(max(dot(r, toEye), 0.0f), gSpecularPower);

	// Determine the diffuse light intensity that strikes the vertex.
	float s = max(dot(gLightVecW, pIn.Norm), 0.0f);

	// Compute the ambient, diffuse, and specular terms separately.
	float3 spec = t*(gSpecularMtrl * gSpecularLight).rgb;
	float3 diffuse = s*(gDiffuseMtrl * gDiffuseLight).rgb;
	float3 ambient = gAmbientMtrl * gAmbientLight;

	float4 col;

	// Sum all the terms together and copy over the diffuse alpha.
	col.rgb = ambient + diffuse + spec;
	col.a = gDiffuseMtrl.a;

	return col;

	return pIn.Col;
}*/

float4 PS(VS_OUT pIn) : SV_Target
{
	return pIn.Col;
}

technique11 Render
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) ); SetGeometryShader( NULL );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	}
}
