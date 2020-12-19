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


//创建二叉树
char words[] = "ABDH#K###E##CFI###G#J##";//"AB#D##C##";
int index0 = 0;
void Chapter6::createBinaryTree(Chapter6:: BinaryTreeNode *treeNode, int index) {
    char value = words[index0];
    ++index0;
    
    if (value == '#' || value == '\0') {
        *treeNode = nullptr;
        return;
    }else {
        //节点初始化
        *treeNode = (Chapter6:: BinaryTree *)malloc(sizeof(Chapter6:: BinaryTree));
        (*treeNode)->leftChild = nullptr;
        (*treeNode)->rightChild = nullptr;
        (*treeNode)->value = value;
    }
    
    
    createBinaryTree(&(*treeNode)->leftChild);
    createBinaryTree(&(*treeNode)->rightChild);
    
    return ;
}




//前序遍历树
void Chapter6::prologueTraverseTree(Chapter6::BinaryTree *root) {
    if (root == nullptr) {
        return;
    }
    
    printf("%c", root->value);
    prologueTraverseTree(root->leftChild);
    prologueTraverseTree(root->rightChild);
}

//中序遍历
void Chapter6::middleOrderTraverseTree(Chapter6::BinaryTree *root) {
    
    if (root == nullptr) {
        return;
    }
    
    middleOrderTraverseTree(root->leftChild);
    printf("%c", root->value);
    middleOrderTraverseTree(root->rightChild);
    
}


//后续遍历
void Chapter6::postSequenceTraverseTree(Chapter6:: BinaryTree *root) {
    if (root == nullptr) {
        return;
    }
    
    postSequenceTraverseTree(root->leftChild);
    postSequenceTraverseTree(root->rightChild);
    printf("%c", root->value);
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




