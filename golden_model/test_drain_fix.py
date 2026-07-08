from golden_model import TopAcceleratorGolden

top=TopAcceleratorGolden()
top.step(rst=1,start=0,a_ext=[0,0,0,0], b_ext=[0,0,0,0])

cycle=0
done_seen=False
while cycle<30 and not done_seen:
    start=1 if cycle==1 else 0
    a_ext=[1,1,1,1]
    b_ext=[1,1,1,1]
    c,done=top.step(rst=0,start=start,a_ext=a_ext,b_ext=b_ext)
    if done:
        print(f'DONE at cycle {cycle}')
        for row in c:
            print(row)
        done_seen=True
    cycle+=1