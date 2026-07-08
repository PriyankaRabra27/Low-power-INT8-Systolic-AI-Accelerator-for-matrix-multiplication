import csv
with open("golden_top_output.csv") as f:
    golden_rows=list(csv.DictReader(f))


with open("rtl_top_output.csv") as f:
    rtl_rows=list(csv.DictReader(f))

print(f"Golden rows: {len(golden_rows)} RTL rows: {len(rtl_rows)}")

if len(golden_rows) != len(rtl_rows):
    print(f"WARNING: row counts differ! Comparing up to the shorter length")


n= min(len(golden_rows), len(rtl_rows))
mismatches=0

for i in range(n):
    g=golden_rows[i]
    r=rtl_rows[i]
    if g!=r:
        mismatches+=1
        print(f"[MISMATCH] cycle{i}")
        print(f" golden: {g}")
        print(f" rtl: {r}")

print("-" + 60)
if mismatches==0:
    print(f"all {n} cycles match-golden model and rtl agree exactly")
else:
    print(f"mismatch/{n} cycles mismatched")