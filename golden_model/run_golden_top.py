from golden_model import TopAcceleratorGolden

top= TopAcceleratorGolden()

results=[]

with open("stimulus_top.txt") as f:
    for line in f:
        vals=[int(x) for x in line.split()]
        rst,start,a0,a1,a2,a3,b0,b1,b2,b3=vals
        c,done=top.step(rst=rst,start=start,a_ext=[a0,a1,a2,a3], b_ext=[b0,b1,b2,b3])
        flat=[c[i][j] for i in range(4) for j in range(4)]
        results.append(flat+[done])

with open("golden_top_output.csv", "w") as f:
    f.write("c00,c01,c01,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33,done\n")
    for row in results:
        f.write(",".join(str(x) for x in row) +"\n")

print(f"Wrote {len(results)} golden output rows to golden_top_output.csv")