//
//  mySurfaceShader.metal
//  custom-material
//  
//  Created by fuziki on 2022/08/15
//  
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>

using namespace metal;

constexpr sampler textureSampler(coord::normalized, address::repeat, filter::linear, mip_filter::linear);
constant float pi = 3.1415926535897932384626433832795;

[[visible]]
void mySurfaceShader(realitykit::surface_parameters params)
{
    // Retrieve the base color tint from the entity's material.
    half3 baseColorTint = (half3)params.material_constants().base_color_tint();

    // Retrieve the entity's texture coordinates.
    float2 uv = params.geometry().uv0();

    // Flip the texture coordinates y-axis. This is only needed for entities
    // loaded from USDZ or .reality files.
    uv.y = 1.0 - uv.y;

    // Sample a value from the material's base color texture based on the
    // flipped UV coordinates.
    auto tex = params.textures().custom();
    half3 color = (half3)tex.sample(textureSampler, uv).rgb;

    // Multiply the tint by the sampled value from the texture, and
    // assign the result to the shader's base color property.
    color *= baseColorTint;

    // Modify color using time.
    auto t = params.uniforms().time();
    auto i = (int)t % 3;
    auto v = (t - floor(t)) * pi;
    auto mx = max(color[i], (half)sin(v));
    color[i] = min(mx, (half)1);
    params.surface().set_base_color(color);
    params.surface().set_opacity(1.0);
    // if use CustomMaterial.LightingModel.unlit
//    params.surface().set_emissive_color(color);
}

[[visible]]
void emptyGeometryModifier(realitykit::geometry_parameters params)
{
}
