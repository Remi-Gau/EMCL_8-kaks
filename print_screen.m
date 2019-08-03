function frame = print_screen(win, filename, frame)

image_array=Screen('GetImage', win);

imagesc(image_array)
box  off
axis off
set(gca, 'position', [0 0 1 1], 'units', 'normalized')

print(gcf, [filename sprintf('%04.0f', frame) '.tif'], '-dtiffnocompression');

frame = frame+1;

end