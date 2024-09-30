import time

# Define the Initial Vector (IV)
IV = [0x34, 0x55, 0x0F, 0x14, 0xCC, 0xAA, 0xF0, 0xE3]

def SA(m):
    """
    State Array (SA) function
    Transforms the 64-bit input data block m into an array of 8 elements, each of 1 byte.
    """
    H = bytearray(8)
    for i in range(8):
        H[i] = (m >> (8 * (7 - i))) & 0xFF  # Extract each byte from the 64-bit message
        H[i] ^= IV[i]  # XOR with the corresponding IV element
    return H

def Theta(H):
    # reverse the array
    for i in range(len(H) // 2):
        H[i], H[len(H) - 1 - i] = H[len(H) - 1 - i], H[i]
    return H  # Reverse the array

def Rho(H):
    """
    Rho function
    Adds 0x85 to each element in the array, mod 0xFD.
    """
    for i in range(8):
        H[i] = (H[i] + 0x85) % 0xFD
    return H

def FPX(H):
    """
    Final Permutation and Xoring (FPX) function
    """
    d = [0] * 8
    for i in range(8):
        d[i] = H[7 - i] ^ IV[i]  # XOR with IV in reverse order
    return d

def light_hash_v5(m):
    """
    Light Hash Algorithm v5
    Generates a 64-bit digest for a 64-bit input data block.
    """
    H = []

    # Perform 36 rounds of the hashing process
    for r in range(36):
        H = SA(m)
        H = Theta(H)
        H = Rho(H)

    # Final Permutation and Xoring
    digest = FPX(H)

    # Combine the 8 bytes into a single 64-bit digest
    final_digest = 0
    for i in range(8):
        final_digest = (final_digest << 8) | digest[i]

    return final_digest

user_provided_in = input("provide a message: ")
print(user_provided_in);

start = time.time()
# convert the provided input to bytes
user_provided_in = user_provided_in.encode('utf-8')

# define the block size of 64 bits
block_size = 8 #64 bits in bytes

# check if the input data is a multiple of the block size
if len(user_provided_in) % block_size != 0:
    # add padding to the input data
    padding = block_size - (len(user_provided_in) % block_size)
    user_provided_in += b'\x00' * padding # adding null bytes to the message
    print(f"Padding added: {padding} bytes")

# convert the provided input to a 64-bit integer
for i in range(0, len(user_provided_in), block_size):
    block = user_provided_in[i:i + block_size]
    block_data = int.from_bytes(block, byteorder='big', signed=False) # convert the block to a 64-bit integer
    print(f"Block {i // block_size + 1}: 0x{block_data:016X}")
    # calculate the digest of the block
    digest = light_hash_v5(block_data) # calculate the digest of the block
    print(f"Digest of block {i // block_size + 1}: 0x{digest:016X}")

end = time.time()
print(f"Execution time: {end - start} seconds")






