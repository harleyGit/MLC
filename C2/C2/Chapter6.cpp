//
//  Chapter6.cpp
//  C2
//
//  Created by Harely Huang on 2020/10/28.
//

#include "Chapter6.hpp"




void Chapter6:: chapter6Run() {
    
    int array[7] = {1, 1, 2, 3, 4, 4, 4};
    int index = this->getSpecifyNumCount( array, 1, 6);
    PrintFormat1("%d", index);
    PrintFormat2("%d", index);
    
    
}

//实现处把默认值省略
int Chapter6:: getSpecifyNumCount(int *array, int num, int endIndex, int startIndex) {
    
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
    
    return  getSpecifyNumCount(array, num, endIndex, startIndex);
}


typedef struct BinaryTree {
    int value;
    struct BinaryTree *leftChild;
    struct BinaryTree *rightChild;
}BinaryTree;

int  binaryTreeNodeSearch(int index, BinaryTree *rootNode) {
    
    if ( rootNode == NULL) {
        return  0;
    }
    
    binaryTreeNodeSearch((index-1), rootNode->leftChild);
    
    PrintFormat2("%d", rootNode->value);
    if ((index-1) < 0) {
        PrintFormat2("第 K 大节点值是：%d", rootNode->value);
        return  rootNode->value;
    }
    
    binaryTreeNodeSearch((index-1), rootNode->rightChild);
    
    
    return  0;
}

