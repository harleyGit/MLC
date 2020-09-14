//
//  main.cpp
//  C++LanguageDemo
//
//  Created by Harely Huang on 2020/9/14.
//  Copyright © 2020 Harely Huang. All rights reserved.
//

//包含iostream头文件，C++中有关输入/输出的函数都在这个头文件中定义
#include <iostream>
//cstdlib是标准函数库的缩写，有许多实用的函数，包括使用的system()函数。
#include <cstdlib>

int main(int argc, const char * argv[]) {

    std::cout << "Hello, World!\n";
    std::cout<<"sss"<<"qqq"<<"eee";
    
    //cout是C++语言的输出指令，其中endl代表换行
//    cout<<"我的第一个C++程序"<<endl;
    //目的是让程序输出结果暂停，等用户按下任意键后才会退出程序的输出窗口。
    system("pause");
    return 0;
}
