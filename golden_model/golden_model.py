class PEMacGolden:
    def __init__(self):
        self.a_out=0
        self.b_out=0
        self.acc_out=0
        self.valid_out=0
        
    def wrap32(self,x):
        x=x&0xFFFFFFFF
        if x>=2**31:
            x=x-2**32
        return x
    
    def step(self,clear,rst,enable,valid_in,a_in,b_in):
        if(rst):
            self.a_out=0
            self.b_out=0
            self.acc_out=0
            self.valid_out=0
        elif(clear):
            self.a_out=0
            self.b_out=0
            self.acc_out=0
            self.valid_out=0
        elif(enable):
            self.a_out=a_in
            self.b_out=b_in
            self.valid_out=valid_in

            active_mac=valid_in and (a_in!=0) and (b_in!=0)
            product=a_in*b_in
            if(active_mac):
                self.acc_out=self.wrap32(self.acc_out + product)
        return self.a_out, self.b_out, self.acc_out, self.valid_out          

class SystolicArray4x4Golden:
    def __init__(self):
        self.pe = [[PEMacGolden() for _ in range(4)] for _ in range(4)]
        self.prev_a_out = [[0 for _ in range(4)] for _ in range(4)]
        self.prev_b_out = [[0 for _ in range(4)] for _ in range(4)]
        self.prev_valid_out = [[0 for _ in range(4)] for _ in range(4)]


    def step(self,clear,rst,enable,valid_in,a_ext,b_ext):
        new_a_out = [[0 for _ in range(4)] for _ in range(4)]
        new_b_out = [[0 for _ in range(4)] for _ in range(4)]
        new_valid_out = [[0 for _ in range(4)] for _ in range(4)]
        c = [[0 for _ in range(4)] for _ in range(4)]
        new_a_out = [[0 for _ in range(4)] for _ in range(4)]
        new_b_out = [[0 for _ in range(4)] for _ in range(4)]
        new_valid_out = [[0 for _ in range(4)] for _ in range(4)]
        c = [[0 for _ in range(4)] for _ in range(4)]
        for i in range(4):
            for j in range(4):
                if j == 0:
                    a_in = a_ext[i]
                else:
                    a_in = self.prev_a_out[i][j-1]

                if i==0:
                    b_in = b_ext[j]
                else:
                    b_in = self.prev_b_out[i-1][j]
                
                if j>0:
                    pe_valid_in = self.prev_valid_out[i][j-1]
                elif i>0:
                    pe_valid_in = self.prev_valid_out[i-1][j]
                else:
                    pe_valid_in = valid_in

                a_o, b_o, acc_o, v_o = self.pe[i][j].step(clear, rst, enable, pe_valid_in, a_in, b_in)
                new_a_out[i][j] = a_o
                new_b_out[i][j] = b_o
                new_valid_out[i][j] = v_o
                c[i][j] = acc_o
        self.prev_a_out = new_a_out
        self.prev_b_out = new_b_out
        self.prev_valid_out = new_valid_out

        return c
    
class ControllerGolden:
    def __init__(self):
        self.current_state="IDLE"
        self.cycle_count=0

    def step(self,rst,start):
        if rst:
            self.current_state="IDLE"
            self.cycle_count=0
            return 0,0,0,0 #clear,enable,valid_in,done

        if self.current_state == "IDLE":
            clear = 0
            enable = 0
            valid_in = 0
            done = 0
            if start:
                self.current_state = "CLEAR"
            else:
                self.current_state="IDLE"
        
        elif self.current_state == "CLEAR":
            clear=1
            enable=0
            valid_in=0
            done=0
            self.current_state="RUN"
        
        elif self.current_state == "RUN":
            clear=0
            enable=1
            done=0
            if self.cycle_count <= 6:
                valid_in = 1
            else:
                valid_in=0
            if self.cycle_count == 12:
                self.current_state="DONE"
            else:
                self.current_state = "RUN"

            self.cycle_count=self.cycle_count+1

        elif self.current_state == "DONE":
            clear = 0
            enable = 0
            valid_in = 0
            done = 1
            self.current_state = "IDLE"

        
        return clear, enable, valid_in, done
    
class TopAcceleratorGolden:
    def __init__(self):
        self.ctrl=ControllerGolden()
        self.array=SystolicArray4x4Golden()
        self.skew=InputSkewGolden()

    def step(self,rst, start, a_ext, b_ext):
        clear, enable, valid_in, done=self.ctrl.step(rst,start)
        a_skewed, b_skewed = self.skew.step(a_ext,b_ext)
        c=self.array.step(clear,rst,enable,valid_in, a_skewed, b_skewed)
        return c, done


class SkewDelayGolden:
    def __init__(self, delay):
        self.delay=delay
        self.queue=[0]*delay

    def step(self,value):
        self.queue.append(value)
        oldest_value = self.queue.pop(0)
        return oldest_value

class InputSkewGolden:
    def __init__(self):
        self.skew_a0=SkewDelayGolden(0)
        self.skew_a1=SkewDelayGolden(1)
        self.skew_a2=SkewDelayGolden(2)
        self.skew_a3=SkewDelayGolden(3)
        self.skew_b0=SkewDelayGolden(0)
        self.skew_b1=SkewDelayGolden(1)
        self.skew_b2=SkewDelayGolden(2)
        self.skew_b3=SkewDelayGolden(3)

    def step(self, a_ext, b_ext):
        a0_out = self.skew_a0.step(a_ext[0])
        a1_out = self.skew_a1.step(a_ext[1])
        a2_out = self.skew_a2.step(a_ext[2])
        a3_out = self.skew_a3.step(a_ext[3])

        b0_out = self.skew_b0.step(b_ext[0])
        b1_out = self.skew_b1.step(b_ext[1])
        b2_out = self.skew_b2.step(b_ext[2])
        b3_out = self.skew_b3.step(b_ext[3])

        a_skewed = [a0_out, a1_out, a2_out, a3_out]
        b_skewed = [b0_out, b1_out, b2_out, b3_out]
        return a_skewed, b_skewed



        
        
        


     
        



             