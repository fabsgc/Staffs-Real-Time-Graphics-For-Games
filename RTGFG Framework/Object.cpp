#include "Object.h"

Object::Object(ID3D11DeviceContext& immediateContext, ID3D11Buffer& constantBuffer)
	: _immediateContext(immediateContext)
	, _constantBuffer(constantBuffer)
{

}

Object::~Object()
{

}

void Object::Init()
{
	XMStoreFloat4x4(&_world, XMMatrixIdentity());
}

void Object::Draw(ConstantBuffer& cb)
{
	XMMATRIX world = XMLoadFloat4x4(&_world);
	cb.mWorld = XMMatrixTranspose(world);

	_immediateContext.UpdateSubresource(&_constantBuffer, 0, nullptr, &cb, 0, 0);
	_immediateContext.DrawIndexed(36, 0, 0);
}

XMFLOAT4X4& Object::GetWorld()
{
	return _world;
}