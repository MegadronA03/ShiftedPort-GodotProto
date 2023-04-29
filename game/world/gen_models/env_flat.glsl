#[compute]
#version 450

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) restrict buffer env_flatSBO {
	float data[];
} shared_data;

void main() {
	shared_data.data[gl_GlobalInvocationID.x] *= 2.0;
}