import time

# Define the Initial Vector (IV)
IV = [0x34, 0x55, 0x0F, 0x14, 0xCC, 0xAA, 0xF0, 0xE3]

def SA(m):
    for i in range(8):
        m[i] ^= IV[i]  # XOR with the corresponding IV element
    #print(f"SA: {[f'0x{x:02X}' for x in m]}")
    return m

def Theta(H):
    H.reverse()
    #print(f"Theta: {[f'0x{x:02X}' for x in H]}")  # print the reversed array
    return H  # return the reversed array
    
def Rho(H):
    for i in range(8):
        H[i] = (H[i] + 0x85) % 0xFD
    #print(f"Rho: {[f'0x{x:02X}' for x in H]}")
    return H

def FPX(H):
    d = [0] * 8
    for i in range(8):
        d[i] = H[7 - i] ^ IV[i]  # XOR with IV in reverse order
    #print(f"FPX: {[f'0x{x:02X}' for x in d]}")
    return d

def light_hash_v5(m):
    H = []
    # Perform 36 rounds of the hashing process
    for r in range(36):
        if(r == 0):
            H = SA(m)
        else:
            H = SA(H)
        H = Theta(H)
        H = Rho(H)

    # Final Permutation and Xoring
    digest = FPX(H)
    return digest

message = bytes.fromhex("A1B2C3D4E5F60788")

# define the block size of 64 bits
block_size = 8

# check if the input data is a multiple of the block size
if len(message) % block_size != 0:
    # adding padding to the input data
    padding = block_size - (len(message) % block_size)
    message += b'\x00' * padding

print("---------------------------------------------------------")
for i in range(0, len(message), block_size):    
    block = bytearray(8)
    print(f"Processing Block n.{i // block_size + 1}")
    for i in range(8):
        block[i] = (int.from_bytes(message, byteorder='big', signed=False) >> (8 * (7 - i))) & 0xFF  # Extract each byte from the 64-bit message
    print("Input: ",' '.join(f'0x{byte:02X}' for byte in block))
    
    # calculate the digest of the block
    start = time.time()
    digest = light_hash_v5(block) # calculate the digest of the block
    end = time.time()
    
    # printing the output digest
    print("Output Digest:", ' '.join(f'0x{byte:02X}' for byte in digest))
    print("---------------------------------------------------------")
print(f"Execution time: {(end - start) * 1e9:.0f} nanoseconds")