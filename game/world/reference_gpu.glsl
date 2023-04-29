#[compute]
#version 450

/*
Godot
https://docs.godotengine.org/en/latest/tutorials/shaders/compute_shaders.html

GLSL
https://registry.khronos.org/OpenGL-Refpages/gl4/index.php
https://www.khronos.org/opengl/wiki/GLSL_Optimizations

GPUgems
https://developer.nvidia.com/gpugems/gpugems/contributors
https://developer.nvidia.com/gpugems/gpugems2/copyright
https://developer.nvidia.com/gpugems/gpugems3/contributors
https://developer.nvidia.com/gpugems/gpugems3/part-v-physics-simulation/chapter-30-real-time-simulation-and-rendering-3d-fluids

Fluid rendering (may not be suited for Mali GPUs, due to excessive post processing usage)
https://developer.download.nvidia.com/presentations/2010/gdc/Direct3D_Effects.pdf

Compute
in uvec3 gl_GlobalInvocationID = gl_WorkGroupID * gl_WorkGroupSize + gl_LocalInvocationID
in uvec3 gl_LocalInvocationID
in uint gl_LocalInvocationIndex
in uvec3 gl_WorkGroupID
in uvec3 gl_WorkGroupSize
in uvec3 gl_NumWorkGroups
*/

//Invocations
layout(
	local_size_x = 1,
	local_size_y = 1,
	local_size_z = 1) in;
	
// binding to the buffer we create in our script
layout(set = 0, binding = 0, std430) restrict buffer SharedBuffer {
	int data[];
} shared_data;

void main() {
	//shared_data.data[] *= 2.0;
}