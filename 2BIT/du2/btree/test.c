#include "btree.h"
#include "test_util.h"
#include <stdio.h>

const int base_data_count = 15;
const char base_keys[] = {'H', 'D', 'L', 'B', 'F', 'J', 'N', 'A',
                          'C', 'E', 'G', 'I', 'K', 'M', 'O'};
const int base_values[] = {8, 4, 12, 2, 6, 10, 14, 1, 3, 5, 7, 9, 11, 13, 16};

const int additional_data_count = 6;
const char additional_keys[] = {'S', 'R', 'Q', 'P', 'X', 'Y', 'Z'};
const int additional_values[] = {10, 10, 10, 10, 10, 10};

const int traversal_data_count = 5;
const char traversal_keys[] = {'D', 'B', 'A', 'C', 'E'};
const int traversal_values[] = {1, 2, 3, 4, 5};

void init_test() {
  printf("Binary Search Tree - testing script\n");
  printf("-----------------------------------\n");
  printf("\n");
}

TEST(test_tree_init, "Initialize the tree")
bst_init(&test_tree);
ENDTEST

TEST(test_tree_dispose_empty, "Dispose the tree")
bst_init(&test_tree);
bst_dispose(&test_tree);
ENDTEST

TEST(test_tree_search_empty, "Search in an empty tree (A)")
bst_init(&test_tree);
int result;
bst_search(test_tree, 'A', &result);
ENDTEST

TEST(test_tree_insert_root, "Insert an item (H,1)")
bst_init(&test_tree);
bst_insert(&test_tree, 'H', 1);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_search_root, "Search in a single node tree (H)")
bst_init(&test_tree);
bst_insert(&test_tree, 'H', 1);
int result;
bst_search(test_tree, 'H', &result);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_update_root, "Update a node in a single node tree (H,1)->(H,8)")
bst_init(&test_tree);
bst_insert(&test_tree, 'H', 1);
bst_print_tree(test_tree);
bst_insert(&test_tree, 'H', 8);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_insert_many, "Insert many values")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_search, "Search for an item deeper in the tree (A)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
int result;
bst_search(test_tree, 'A', &result);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_search_missing, "Search for a missing key (X)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
int result;
bst_search(test_tree, 'X', &result);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_leaf, "Delete a leaf node (A)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_print_tree(test_tree);
bst_delete(&test_tree, 'A');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_left_subtree, "Delete a node with only left subtree (R)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_insert_many(&test_tree, additional_keys, additional_values,
                additional_data_count);
bst_print_tree(test_tree);
bst_delete(&test_tree, 'R');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_right_subtree,
     "Delete a node with only right subtree (X)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_insert_many(&test_tree, additional_keys, additional_values,
                additional_data_count);

bst_print_tree(test_tree);
bst_delete(&test_tree, 'X');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_both_subtrees, "Delete a node with both subtrees (L)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_insert_many(&test_tree, additional_keys, additional_values,
                additional_data_count);

bst_print_tree(test_tree);
bst_delete(&test_tree, 'L');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_missing, "Delete a node that doesn't exist (U)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_print_tree(test_tree);
bst_delete(&test_tree, 'U');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_root, "Delete the root node (H)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_print_tree(test_tree);
bst_delete(&test_tree, 'H');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_delete_both_subtrees_parent,
     "Delete a node with both subtrees while moving a parent (F, H)")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_insert_many(&test_tree, additional_keys, additional_values,
                additional_data_count);

bst_delete(&test_tree, 'G');
bst_print_tree(test_tree);
bst_delete(&test_tree, 'H');
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_dispose_filled, "Dispose the whole tree")
bst_init(&test_tree);
bst_insert_many(&test_tree, base_keys, base_values, base_data_count);
bst_print_tree(test_tree);
bst_dispose(&test_tree);
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_preorder, "Traverse the tree using preorder")
bst_init(&test_tree);
bst_insert_many(&test_tree, traversal_keys, traversal_values,
                traversal_data_count);
bst_preorder(test_tree);
printf("\n");
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_inorder, "Traverse the tree using inorder")
bst_init(&test_tree);
bst_insert_many(&test_tree, traversal_keys, traversal_values,
                traversal_data_count);
bst_inorder(test_tree);
printf("\n");
bst_print_tree(test_tree);
ENDTEST

TEST(test_tree_postorder, "Traverse the tree using postorder")
bst_init(&test_tree);
bst_insert_many(&test_tree, traversal_keys, traversal_values,
                traversal_data_count);
bst_postorder(test_tree);
printf("\n");
bst_print_tree(test_tree);
ENDTEST

// DELETION TESTS
TEST(test_delete1, "Delete H in H")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete2, "Delete H in HA")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete2a, "Delete A in HA")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'A');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete3, "Delete H in HZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete3a, "Delete Z in HZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'Z');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete4, "Delete H in HAZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete5, "Delete H in HAC")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'C', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete6, "Delete H in HCAB")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'C', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_insert(&test_tree, 'B', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete6a, "Delete A in HCAB")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'C', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_insert(&test_tree, 'B', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'A');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete6b, "Delete B in HCAB")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'C', 20);
    bst_insert(&test_tree, 'A', 20);
    bst_insert(&test_tree, 'B', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'B');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete7, "Delete H in HJT")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'J', 20);
    bst_insert(&test_tree, 'T', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete7a, "Delete J in HJT")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'J', 20);
    bst_insert(&test_tree, 'T', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'J');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete8, "Delete H in HJZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_insert(&test_tree, 'J', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete8a, "Delete J in HJZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_insert(&test_tree, 'J', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'J');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete9, "Delete H in HJTZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'J', 20);
    bst_insert(&test_tree, 'T', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete9a, "Delete J in HJTZ")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'J', 20);
    bst_insert(&test_tree, 'T', 20);
    bst_insert(&test_tree, 'Z', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'J');
    bst_print_tree(test_tree);
ENDTEST

TEST(test_delete10, "Delete H in HCD")
    bst_init(&test_tree);
    bst_insert(&test_tree, 'H', 20);
    bst_insert(&test_tree, 'C', 20);
    bst_insert(&test_tree, 'D', 20);
    bst_print_tree(test_tree);
    bst_delete(&test_tree, 'H');
    bst_print_tree(test_tree);
ENDTEST
int main(int argc, char *argv[]) {
  init_test();

  test_tree_init();
  test_tree_dispose_empty();
  test_tree_search_empty();
  test_tree_insert_root();
  test_tree_search_root();
  test_tree_update_root();
  test_tree_insert_many();
  test_tree_search();
  test_tree_search_missing();
  test_tree_delete_leaf();
  test_tree_delete_left_subtree();
  test_tree_delete_right_subtree();
  test_tree_delete_both_subtrees();
  test_tree_delete_both_subtrees_parent();
  test_tree_delete_missing();
  test_tree_delete_root();
  test_tree_dispose_filled();
  test_tree_preorder();
  test_tree_inorder();
  test_tree_postorder();
  test_delete1();
  test_delete2();
  test_delete2a();
  test_delete3();
  test_delete3a();
  test_delete4();
  test_delete5();
  test_delete6();
  test_delete6a();
  test_delete6b();
  test_delete7();
  test_delete7a();
  test_delete8();
  test_delete8a();
  test_delete9();
  test_delete9a();
  test_delete10();
}
