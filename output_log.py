def output_log(file_name,log_data,option='w'):
    with open(file_name, option) as f:
        for index,log in enumerate (log_data):
            print(log, file=f)

def main():
    file_name = 'test.txt'
    s1 = 'data1'
    s2 = 'data2'
    a = True
    b= True
    c = False
    data1 = [s1,a,b,c]
    data2 = [s2,a,b,c]
    for i in range(3):
        if (i == 0):
            output_log(file_name,data1,option='w')
        else:
            output_log(file_name,data2,option='a')
            
if __name__ == '__main__':
    main()

