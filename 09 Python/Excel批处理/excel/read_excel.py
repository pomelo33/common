import re
import sys
import os
import shutil
import pandas as pd
import numpy as np

class Batchfile():

    def __init__(self,filename,ExcelName,SHEETName,TargetDir):
        self.filename = filename
        self.ExcelName = ExcelName
        self.SHEETName = SHEETName
        self.TargetDir = TargetDir

    # 读取excel表格
    def readExcel(self):
        df = pd.read_excel(io=self.ExcelName,sheet_name=self.SHEETName)
        count = df.shape[0]
        num = 0
        while num < count:
            data1 = df.loc[num,"文件名"]
            data2 = (df.loc[num,"检查细节要点"]).split(",")
            data3 = df.loc[num,"检查方法"]
            print(data2)
            for i in range(0,len(data2)):
                # num = len(data2)
                counts = 0
                value = data2[counts]
                print(value)
                counts += 1
                

            # data4 = df.loc[num,"服务名称"]
            # 复制模板    
            # self.copyFile(data1,data2,data3,data4)
            num += 1


    # 复制模板   
    def copyFile(self,data1,data2,data3,data4):
        source = self.filename
        target = self.TargetDir + data1
        try:
            shutil.copy(source,target)
        except IOError as e:
            print("Unable to copy file. %s" % e)
        except:
            print("Unexpected error:",sys.exc_info())
        else:
            self.modifyValue(target,data1,data2,data3,data4)

    # 批量修改内容
    def modifyValue(self,target,data1,data2,data3,data4):
        filename = target
        data = ""

        value1 = data2[0]
        value2 = data2[1]
        value3 = data2[2]
        value4 = data2[3]


        with open(filename,"r+") as f_obj:
            for line in f_obj.readlines():
                if re.search('@key@',line):
                    line = re.sub("@key@",data3,line)
                    data += line
                elif re.search('@@keys@@',line):
                    line = re.sub("@@keys@@",data2,line)
                    data += line
                elif re.search("@@value@@",line):
                    line = re.sub("@@value@@",data2,line)
                    data += line
                elif re.search("@keys@",line):
                    line = re.sub("@keys@",data4,line)
                    data += line
                else:
                    data += line
        with open(filename,"w") as f:
            f.write(data)


if __name__ == '__main__':
    sheets = ['nginx']
    for sheet in sheets:
        mytest = Batchfile("/root/demo/01.sh","/root/demo/test2.xlsx",sheet,"/root/demo/test/")
        mytest.readExcel()