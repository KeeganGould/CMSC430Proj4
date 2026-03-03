// CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, CHAR_TYPE, REAL_TYPE, NONE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkWhen(Types true_, Types false_);
Types checkSwitch(Types case_, Types when, Types other);
Types checkCases(Types left, Types right);
Types checkArithmetic(Types left, Types right);
Types checkList(Types index1, Types index2);
void checkListAssignment(Types lValue, Types rValue); 
Types checkListSubscript(Types index); 
Types checkRelationAssignment(Types left, Types right); 
Types checkNegopAssignment(Types value); 
Types checkExpopAssignment(Types left, Types right); 
Types checkRemopAssignment(Types left, Types right); 
Types checkIfBranch(Types expected, Types branch); 
Types mergeIfTypes(Types thenType, Types elsifType, Types elseType); 
Types checkIf(Types then, Types elif, Types els); 
Types checkElses(Types left, Types right); 
Types checkFold(Types index); 
