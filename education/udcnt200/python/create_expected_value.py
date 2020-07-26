import sys
import numpy as np
import csv

#期待値データ1作成 カウントアップ用テストデータ
def create_expected_value1():
    expected_value = np.arange(200,dtype='uint16').reshape(200,1)
    expected_value = np.tile(expected_value,(2,1))
    return expected_value

#期待値データ2作成　カウントダウン用テストデータ
def create_expected_value2():
    expected_value = np.zeros((400,1),dtype='uint16')
    expected_value[1:201,:] = np.flip(np.arange(200,dtype='uint16').reshape(200,1))
    expected_value[201:,:] = np.flip(np.arange(1,200,dtype='uint16').reshape(199,1))
    return expected_value

#期待値データ3作成　リセット用テストデータ
def create_expected_value3():
    expected_value = np.zeros((300,1),dtype='uint16')
    expected_value[:101,:] = np.arange(101,dtype='uint16').reshape(101,1)
    expected_value[201:300,:] = np.arange(1,100,dtype='uint16').reshape(99,1)
    return expected_value

#期待値データ4作成　アップダウン切替用テストデータ
def create_expected_value4():
    expected_value = np.zeros((300,1),dtype='uint16')
    expected_value[:101,:] = np.arange(101,dtype='uint16').reshape(101,1)
    expected_value[101:201,:] = np.flip(np.arange(100,dtype='uint16').reshape(100,1))
    expected_value[201:300,:] = np.arange(1,100,dtype='uint16').reshape(99,1)
    return expected_value

#期待値データ5作成　イネーブル用テストデータ
def create_expected_value5():
    expected_value = np.full((300,1),100,dtype='uint16')
    expected_value[:101,:] = np.arange(101,dtype='uint16').reshape(101,1)
    expected_value[201:300,:] = np.arange(101,200,dtype='uint16').reshape(99,1)
    return expected_value

#期待値データ作成
def create_expected_value(testcase):
    if(testcase == "testcase1"):
        expected_value = create_expected_value1()
    elif(testcase == "testcase2"):
        expected_value = create_expected_value2()
    elif(testcase == "testcase3"):
        expected_value = create_expected_value3()
    elif(testcase == "testcase4"):
        expected_value = create_expected_value4()
    elif(testcase == "testcase5"):
        expected_value = create_expected_value5()
    else:
        print("Error:argv Name")
        quit()
    return expected_value
    
#10進→16進変換
def convert_dec2hex(data):
    data = np.array(data,dtype='object')
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            data[i,j]=format(data[i,j],'02x')
    return data

#csv出力
def write_csv(data,filename):
    f = open(filename, 'w')
    writer = csv.writer(f,lineterminator='\n')
    writer.writerows(data)
    return None

def main(testcase):
    #1.期待値データ作成
    expected_value = create_expected_value(testcase)
    data = convert_dec2hex(expected_value)

    #2.csv出力
    filename = testcase+".csv"
    write_csv(data,filename)
    return None

if __name__ == "__main__":
    #0.引数取得
    try:
        testcase = sys.argv[1]
    except:
        print("Error:argv Num")
        quit()
    
    #1.期待値データ作成
    main(testcase)