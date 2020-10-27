//
//  main.cpp
//  C2
//
//  Created by Harely Huang on 2020/10/23.
//

#include <iostream>


///算法： 数字在排序数组中出现的次数
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
    
    if (*(array + middle) == num) {//指针获取数组的值
        //array 表示是数组的首位地址
        //*(array+middle - 1) 取第 middle - 1 位元素
        //(*(array+middle - 1) < num && middle > 0) 表示当数组元素为中间时我们要取到最开始的元素，所以要进行判断
        //middle == 0 当数组是第 0 位时，那它就是第一位
        if ((*(array+middle - 1) < num && middle > 0) || middle == 0) {
            return  middle;
        }else {
            //当索引是中间或者最后相同的元素时
            endIndex = middle - 1;
        }
    }else if (*(array+middle) > num) {
        //取上限的下一位，因为middle已经比过了
        endIndex = middle - 1;
    }else if(*(array+middle) < num) {
        //取下限的上一位，因为middle已经比过了
        startIndex = middle + 1;
    }
    printf("sss %d\n", 111);
    
    return  getSpecifyNumCount(array, num, endIndex, startIndex);
}

int main(int argc, const char * argv[]) {
    
    int array[7] = {1, 1, 2, 3, 4, 4, 4};
    int index = getSpecifyNumCount( array, 1, 6);
    std::cout << "🍎 🍎 🍎 索引为："<<index<<std::endl;
    
    
    
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



