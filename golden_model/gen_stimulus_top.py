rows=[]

#reset for 1 cycle
rows.append([1,0, 0,0,0,0, 0,0,0,0])
rows.append([1,0, 0,0,0,0, 0,0,0,0])

#release reset
rows.append([0,0, 0,0,0,0, 0,0,0,0])

#start pulse
rows.append([0,1, 0,0,0,0, 0,0,0,0])

#gap cycle
rows.append([0,0, 0,0,0,0, 0,0,0,0])

#Phase 1 data
rows.append([0,0, 1,0,0,0, 1,0,0,0])
rows.append([0,0, 2,5,0,0, 0,0,0,0])
rows.append([0,0, 3,6,1,0, 0,1,0,0])
rows.append([0,0, 4,7,1,2, 0,0,0,0])
rows.append([0,0, 0,8,1,2, 0,0,1,0])
rows.append([0,0, 0,0,1,2, 0,0,0,0])
rows.append([0,0, 0,0,0,2, 0,0,0,1])

for _ in range(20):
    rows.append([0, 0, 0,0,0,0, 0,0,0,0])

with open("stimulus_top.txt", "w") as f:
    for row in rows:
        f.write(" ".join(str(x) for x in row) + "\n")

print(f"wrote {len(rows)} stimulus rows to stimulus_top.txt")