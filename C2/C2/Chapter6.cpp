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
     int array[7] = {1, 1, 2, 3, 4, 4, 4};
     int index = this->getSpecifyNumCount( array, 1, 6);
     PrintFormat1("%d", index);
     */
    
    PrintFormat2("%s 💣 💣 💣 💣 💣 💣 💣 💣 💣 💣 💣 💣", "=============================");
    
    
    
    
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



int leftDepth = 1;
int rightDepth = 1;



int Chapter6:: getBinaryTreeDepth(BinaryTree *rootTree, int depth) {
    
    if (rootTree == nullptr) {
        return 0;
    }
    
    if (rootTree->leftChild != nullptr) {
        leftDepth ++;
        this->getBinaryTreeDepth(rootTree->leftChild, depth);
    }
    
    
    if (rootTree->rightChild != nullptr) {
        depth ++;
        this->getBinaryTreeDepth(rootTree->rightChild, depth);
    }
    
    return  0;
}

//我写的二叉树深度
int  binaryDepth() {
    Chapter6 chap6;
    Chapter6:: BinaryTree *rootTree;
    
    int leftD = chap6.getBinaryTreeDepth(rootTree->leftChild, 0);
    int rightD = chap6.getBinaryTreeDepth(rootTree->rightChild, 0);

    return  leftD > rightD ? leftD : rightD;

}

int Chapter6:: getBinaryTreeDepth(BinaryTree *rootNode) {
    if (rootNode == nullptr) {
        return  0;
    }
    
    int leftDep= this->getBinaryTreeDepth(rootNode->leftChild);
    int rightDep = this->getBinaryTreeDepth(rootNode->rightChild);
    
    
    return (leftDepth>rightDep) ? (leftDepth+1) : (rightDep+1);
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


