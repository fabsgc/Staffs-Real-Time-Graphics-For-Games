#pragma once

#include <windows.h>
#include <d3d11_1.h>
#include <d3dcompiler.h>
#include <directxmath.h>
#include <directxcolors.h>
#include "resource.h"

using namespace DirectX;

struct ConstantBuffer
{
	XMMATRIX mWorld;
	XMMATRIX mView;
	XMMATRIX mProjection;
};

class Object
{
public:
	Object(ID3D11DeviceContext& immediateContext, ID3D11Buffer& constantBuffer);
	~Object();
	void Init();
	void Draw(ConstantBuffer& cb);
	XMFLOAT4X4& GetWorld();

private:
	XMFLOAT4X4 _world;
	ID3D11DeviceContext& _immediateContext;
	ID3D11Buffer& _constantBuffer;
};

