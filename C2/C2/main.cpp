//
//  main.cpp
//  C2
//
//  Created by Harely Huang on 2020/10/23.
//

#include <iostream>


/// 返回指定值的第一次的索引
/// @param array 传递的数组
/// @param num 指定的值
/// @param endIndex 数组终止索引
/// @param startIndex 数组起始索引，默认值为0，放在最后规定
int getSpecifyNumCount(int *array, int num, int endIndex, int startIndex = 0) {
    
    //数组违法，不存在
    if (endIndex < startIndex) {
        return  -1;
    }
    //sizeof() 获取数组元素个数
    int middle = (endIndex + startIndex)/2;
    
    //指针获取数组的值
    if (*(array+middle) > num) {
        endIndex = middle;
    }else if(*(array+middle) < num) {
        startIndex = middle;
    }else {
        return  1;
    }
    
    return  getSpecifyNumCount(array, num, endIndex, startIndex);
}

int main(int argc, const char * argv[]) {
    
    
    
    
    
    std::cout << "<<<<<<<<<<<<<<<<<<    Start\n\n\n";
    
    /**/
    int val = 5;
    int *prt3 = (int *)0x1000;
    prt3 = &val;
    std::cout<<"prt3值为："<<*prt3<<"地址为："<<&prt3<<std::endl;
    std::cout<<"val值为："<<val<<"地址为："<<&val<<std::endl;
    
    
    /*
     
     char str[30];
     std::cout<<"数组长度：30， 可接受输入长度： 10"<<std::endl;
     std::cout<<"请输入任意字符串"<<std::endl;
     
     //getline()函数进行输入，它会读取用户所输入的每个字符（包含空格符），直到用户按下【Enter】键为止。
     //getline(字符串变量， 输入长度， 字符串结束符)
     std::cin.getline(str, 10, '\n');
     
     std::cout<<"str字符串变量为："<<str<<std::endl;
     */
    
    
    
    /* 指针变量运算
     int iVal = 10;
     int *piVal = &iVal;
     
     std::cout<<"piVal指针地址原始值为："<<piVal<<std::endl;
     piVal++;
     std::cout<<"piVal++ 右移地址为："<<piVal<<std::endl;
     piVal--;
     std::cout<<"piVal-- 左移地址为："<<piVal<<std::endl;
     piVal=piVal+3;
     std::cout<<"piVal+3 向右移3个整数基本内存单元偏移量基本地址为："<<piVal<<std::endl;
     */
    
    
    /*指针变量及打印
     int num1 = 10;
     char ch1[2] = "A";
     
     std::cout<<"变量名称    变量值 内存地址"<<std::endl;
     std::cout<<"-----------------------"<<std::endl;
     
     std::cout<<"num1"<<"\t"<<num1<<"\t"<<&num1 <<std::endl;
     std::cout<<"ch1"<<"\t""\t"<<ch1<<"\t"<<&ch1 <<std::endl;
     */
    
    
    std::cout << "\n\n>>>>>>>>>>>>>>>>>>    End!\n";
    system("pause");
    
    return 0;
}



