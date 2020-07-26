import sys
import numpy as np
import csv

#期待値データ作成
# def create_expected_value():
#     expected_value = create_expected_value5()
#     return expected_value
    
#10進→16進変換
# def convert_dec2hex(data):
#     data = np.array(data,dtype='object')
#     for i in range(data.shape[0]):
#         for j in range(data.shape[1]):
#             data[i,j]=format(data[i,j],'02x')
#     return data

#csv出力
def write_csv(data,filename):
    f = open(filename, 'w')
    writer = csv.writer(f,lineterminator='\n')
    writer.writerows(data)
    return None

def add_nrsr(data):
    PIXEL_WIDTH = 100 # 2008 ?
    up_data = np.zeros((2 * PIXEL_WIDTH,1),dtype='object')
    down_data = np.zeros((2 * PIXEL_WIDTH,1),dtype='object')

    up_data = data[:2 * PIXEL_WIDTH]
    down_data = data[-2 * PIXEL_WIDTH:]

    up_data = np.tile(up_data,(4,1))
    down_data = np.tile(down_data,(4,1))

    nrsr_data = np.concatenate([up_data,data,down_data])
    
    return nrsr_data
    
def main():
    #1.csv入力 
    #read_csv
    data = np.zeros((10000,1),dtype='uint16')
    data[:100] = 1
    data[100:200] = 2
    data[-200:-100] = 99
    data[-100:] = 100
    data = np.array(data,dtype='object')
    print(data)
    print(data.dtype)
    
    #2.期待値データ作成
    nrsr_data = add_nrsr(data)

    print(nrsr_data)
    print(nrsr_data.dtype)
    print(nrsr_data.shape)
    
    #3.csv出力
    filename = "testcase.csv"
    write_csv(nrsr_data,filename)
    return None

if __name__ == "__main__":
    # #0.引数取得
    # try:
    #     testcase = sys.argv[1]
    # except:
    #     print("Error:argv Num")
    #     quit()
    
    #1.期待値データ作成
    main()
