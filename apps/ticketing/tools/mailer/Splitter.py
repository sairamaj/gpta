import os
import sys

if(len(sys.argv) < 4):
    print('FileName Count OutDir')
    sys.exit(1)
file = sys.argv[1]
batch_count = int(sys.argv[2])
outdir = sys.argv[3]

print(f"Processing {file} with count:{batch_count}")


# Using readlines()
file1 = open(file, 'r')
lines = file1.readlines()

header = lines[0:2]
print(header[0])
print(header[1])

# clean the outdir

batch = 1
out_filename = os.path.join(outdir,f"batch_{batch}.txt")
current = open(out_filename, 'w')

count = 0
for line in lines[2:]:
    if count == batch_count:
        count = 0
        current.close()
        print(f"{out_filename} is done.")
        batch = batch+1
        out_filename = os.path.join(outdir,f"batch_{batch}.txt")
        current = open(out_filename, 'w')        
    else:
        current.writelines(line)
    count = count+1

print(f"{out_filename} is done.")
current.close()