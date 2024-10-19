from PIL import Image, ImageEnhance

# Load the image
image = Image.open(r'barrier_up.png')

image = image.resize((26,148))

# Ensure the image is in the correct mode (8-bit pixels, 256 colors)
image = image.convert('P')

# Get the pixel data
pixels = list(image.getdata())

# Get the palette data
palette = image.getpalette()

# Get image dimensions
width, height = image.size

# Convert pixel data to a format suitable for assembly
pixel_data = []
for y in range(height):
    for x in range(width):
        pixel_data.append(pixels[y * width + x])


# Write the pixel data and palette to a file
with open('kiki.asm', 'w') as file:
    file.write('barrier: db ')
    for i in range(len(pixel_data)):
        file.write(f'0x{pixel_data[i]:02X}')
        if i != len(pixel_data) - 1:
            file.write(', ')

    file.write('\n\npalette_data: db ')
    for i in range(0, len(palette), 3):
        file.write(f'0x{palette[i]//4:02X}, 0x{palette[i+1]//4:02X}, 0x{palette[i+2]//4:02X}')
        if i != len(palette) - 3:
            file.write(', ')

print("Pixel data and palette have been written to pixel_data.asm")