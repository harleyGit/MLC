//
//  Chapter6.cpp
//  C2
//
//  Created by Harely Huang on 2020/10/28.
//

#include "Chapter6.hpp"
#include <stdio.h>
#include <stdlib.h>
#include "math.h"
#include "string.h"



Chapter6::BinaryTree *KthNodeCore(Chapter6::BinaryTree *pRoot, unsigned int& k);

/**测试方法 start
 *------------------------------------------------------------------------------------
 */

void  setTest(Chapter6::BinaryTreeNode *node);
void  infixOrderTraverse(Chapter6::BinaryTreeNode *binaryTree);
char  binaryTreeNodeSearch1(int index, Chapter6::BinaryTree *rootNode);


char  binaryTreeNodeSearch1(int index, Chapter6::BinaryTree *rootNode) {
    
    char value = '0';
    
    if (rootNode == NULL) {
        return '0';
    }
    
    if (rootNode->leftChild != NULL) {
        value = binaryTreeNodeSearch1(index, rootNode->leftChild);
    }
    
    if (index == 1) {
        value = rootNode->value;
        //    printf("---->> %c\n", rootNode->value);
    }
    index --;
    
    
    if (rootNode->rightChild != NULL) {
        value = binaryTreeNodeSearch1(index, rootNode->rightChild);
    }
    
    return value;
}

//中序遍历
void infixOrderTraverse(Chapter6::BinaryTreeNode *binaryTree){
    if (*binaryTree == NULL) {
        return;
    }
    
    infixOrderTraverse(&(*binaryTree)->leftChild);
    printf("--->>>%c\n",(*binaryTree)->value);
    infixOrderTraverse(&(*binaryTree)->rightChild);
    
    return;
}

void  setTest(Chapter6::BinaryTreeNode *node){
    *node = (Chapter6::BinaryTreeNode )malloc(sizeof(Chapter6::BinaryTreeNode));
    printf("\n*node:%p, node:%p", *node, node);
    (*node)->value = 'S';
}

/**测试方法 end
 *------------------------------------------------------------------------------------
 */




void Chapter6:: chapter6Run() {
    
    /*
    int result1, result2;
    int data[8] = {2, 4, 3, 6, 3, 2, 5, 5};
    this->findNumsAppearOnce("面试题56：数组中数字出现次数", data, sizeof(data)/sizeof(int), &result1, &result2);
    PrintFormat2("result1: %d, result2: %d", result1, result2);
    */
    
    /**
     *二叉树的深度
     */
    /*
    BinaryTree *binaryTree = nullptr;
    this->createBinaryTree(&binaryTree);
    int depth = this->getBinaryTreeDepth(binaryTree);
    PrintFormat2("二叉树的深度为： %d", depth);
    */
    
    /*
     int array[7] = {1, 1, 2, 3, 4, 4, 4};
     int index = this->getSpecifyNumCount( array, 1, 6);
     PrintFormat1("%d", index);
     */
    
    
    //    BinaryTreeNode treeNode = NULL;
    //    //BinaryTreeNode 为指针结构体相当于 BinaryTree*
    //    PrintFormat2("treeNode 地址为：%p, &treeNode 地址为：%p", treeNode, &treeNode);
    //    setTest(&treeNode);
    //    PrintFormat2("data:%c, binaryTree:%p, &binaryTree:%p", treeNode->value, treeNode, &treeNode);
    
    
    /* 二叉搜索树的第 K 大节点
    //结构体指针需要申请内存空间才可以使用
    BinaryTree *binaryTree = NULL;//(BinaryTree *)malloc(sizeof(BinaryTree));
    //    PrintFormat2("BinaryTree 字节数为：%lu", sizeof(binaryTree));
    //    binaryTree->value = '0';
    //    PrintFormat2("赋值前：value: %c, leftNode:%p, rightNode: %p", binaryTree->value, binaryTree->leftChild, binaryTree->rightChild);
    
    this->createBinaryTree(&binaryTree);
    PrintFormat2("赋值后：value: %c, leftNode:%p, rightNode: %p", binaryTree->value, binaryTree->leftChild, binaryTree->rightChild);
    
    BinaryTree *searchNode = this->kthNode(binaryTree, 4);
    PrintFormat2("%c", searchNode->value);
    //    infixOrderTraverse(&binaryTree);
    //    int nodeValue = this->
    //    char nodeValue = binaryTreeNodeSearch1(4, binaryTree);
    //    PrintFormat2("第 4 大节点value = %c", nodeValue);
    
    */
    
    
}



/// 判断在num的二进制表示中从右边数起的indexBit位是不是1
/// @param num <#num description#>
/// @param indexBit <#indexBit description#>
bool isBit1(int num, unsigned int indexBit) {
    num = num >> indexBit;
    return (num & 1);
}

void Chapter6:: findNumsAppearOnce(const char *name, int data[], int length, int *num1, int *num2) {
    
    if (name != nullptr) {
        PrintFormat2("%s", name);
    }
    
    if (data == nullptr || length < 2) {
        return;
    }
    
    //异或运算：0 ^ 0 = 0, 0 ^ 1 = 1, 1 ^ 0 = 1, 1 ^ 1 = 0
    int resultExclusiveOR = 0;
    for (int i = 0; i < length; i ++) {
        resultExclusiveOR ^= data[i];
        PrintFormat1("%d", resultExclusiveOR);
    }
    
    unsigned int indexOf1 = findFirstBitIs1(resultExclusiveOR);
    
    *num1 = *num2 = 0;
    for (int j = 0; j < length;  ++j) {
        if (isBit1(data[j], indexOf1)) {
            *num1 ^= data[j];
        }else {
            *num2 ^= data[j];
        }
    }
    
}

unsigned int Chapter6::findFirstBitIs1(int num) {
    
    int indexBit = 0;
    while (((num & 1) == 0) && (indexBit < 8 * sizeof(int))) {
        num = num >> 1;
        ++ indexBit;
    }
    return  indexBit;
}






//二叉树深度
int Chapter6:: getBinaryTreeDepth(BinaryTree *rootNode) {
    if (rootNode == nullptr) {
        return  0;
    }
    
    int leftDep= this->getBinaryTreeDepth(rootNode->leftChild);
    int rightDep = this->getBinaryTreeDepth(rootNode->rightChild);
    
    
    return (leftDep>rightDep) ? (leftDep+1) : (rightDep+1);
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


//创建二叉树
void Chapter6:: createBinaryTree(BinaryTreeNode *binaryTree, int index) {
    char data = characters[number++];
    
    if (data == '#' || data == '\0') {
        //当其设置为NULL时，其右子树的指针容易变为野指针导致错误
        *binaryTree = NULL;
    }else {
        //if (*binaryTree == NULL) {//不要加判断否则程序crash
        //malloc 函数返回的是 void * 类型，如果你写成：p = malloc (sizeof(int)); 则程序无法通过编译，报错：“不能将 void* 赋值给 int * 类型变量”。所以必须通过 (int *) 来将强制转换。
        *binaryTree = (BinaryTree*)malloc(sizeof(BinaryTree));
        //}
        if (!(*binaryTree)) {
            exit(OVERFLOW);
        }
        
        (*binaryTree)->value = data;
        createBinaryTree(&(*binaryTree)->leftChild,++index);
        //当 (*binaryTree)->rightChild 递归设置为NULL，返会再次打印 (*binaryTree)->rightChild 其值时，发现已经有值了，它的指针变为野指针了
        createBinaryTree(&(*binaryTree)->rightChild, ++index);
    }
    
}


Chapter6::BinaryTree *KthNodeCore(Chapter6::BinaryTree *pRoot, unsigned int& k) {
    
    Chapter6::BinaryTree *target = nullptr;
    
    if (pRoot->leftChild != nullptr) {
        target = KthNodeCore((pRoot->leftChild), k);
    }
    
    if(target == nullptr) {
        if (k == 1) {
            target = pRoot;
        }
        k--;
    }
    
    if (target == nullptr && pRoot->rightChild != nullptr) {
        target = KthNodeCore(pRoot->rightChild, k);
    }
    
    return target;
    
}

Chapter6::BinaryTree * Chapter6:: kthNode(Chapter6::BinaryTree *pRoot, unsigned int k) {
    if (pRoot == NULL || k == 0) {
        return nullptr;
    }
    
    return KthNodeCore(pRoot, k);
}


