// CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message) {
    if (lValue == MISMATCH || rValue == MISMATCH)
        return;

    if (lValue != rValue) {
        // Check for illegal narrowing
        if (lValue == INT_TYPE && rValue == REAL_TYPE) {
            appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
            return;
        }
        // Other type mismatches
        appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
    }
}

Types checkWhen(Types true_, Types false_) {
	if (true_ == MISMATCH || false_ == MISMATCH)
		return MISMATCH;
	if (true_ != false_)
		appendError(GENERAL_SEMANTIC, "When Types Mismatch ");
	return true_;
}

Types checkSwitch(Types case_, Types when, Types other) {
	if (case_ != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Switch Expression Not Integer");
	return checkCases(when, other);
}

Types checkCases(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == NONE || left == right)
		return right;
	appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
	return MISMATCH;
}

Types checkArithmetic(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	if (left == REAL_TYPE || right == REAL_TYPE) 
		return REAL_TYPE;
	appendError(GENERAL_SEMANTIC, "Integer Type Required");
	return MISMATCH;
}

Types checkList(Types index1, Types index2) {
	if (index1 == MISMATCH || index2 == MISMATCH)
		return MISMATCH;
	if (index1 == NONE || index1 == index2)
		return index2;
	appendError(GENERAL_SEMANTIC, "List Element Types Do Not Match");
	return MISMATCH;
}

void checkListAssignment(Types declaredType, Types elementType) {
    if (declaredType != MISMATCH && elementType != MISMATCH && declaredType != elementType)
        appendError(GENERAL_SEMANTIC, "List Type Does Not Match Element Types");
}

Types checkListSubscript(Types index) {
	if (index != INT_TYPE) {
		appendError(GENERAL_SEMANTIC, "List Subscript Must Be Integer");
		return MISMATCH; 
	}
	return index;
}

Types checkRelationAssignment(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH)
        return MISMATCH;
	if (left != MISMATCH && right != MISMATCH && left != right) {
        appendError(GENERAL_SEMANTIC, "Character Literals Cannot be Compared to Numeric Expressions");
		return MISMATCH; }
	return INT_TYPE;
}

Types checkNegopAssignment(Types value) { 
	if (value == INT_TYPE || value == REAL_TYPE) return value;
    appendError(GENERAL_SEMANTIC, "Arithmetic Operator Requires Numeric Types");
    return MISMATCH;
}

Types checkExpopAssignment(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH) return MISMATCH;
    if ((left == INT_TYPE || left == REAL_TYPE) && (right == INT_TYPE || right == REAL_TYPE)) {
        if (left == REAL_TYPE || right == REAL_TYPE)
            return REAL_TYPE;
        return INT_TYPE;
    }
    appendError(GENERAL_SEMANTIC, "Arithmetic Operator Requires Numeric Types");
    return MISMATCH;
}

Types checkRemopAssignment(Types left, Types right) {
	if (left == INT_TYPE && right == INT_TYPE) 
		return INT_TYPE; 
	appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands"); 
	return MISMATCH; 
}

Types checkIf(Types then, Types elif, Types els) {
	if (elif == NONE)
		return checkElses(then, els);
	if (then != elif) 
		appendError(GENERAL_SEMANTIC, "If-Elsif-Else Type Mismatch");
	return checkElses(elif, els);
}

Types checkElses(Types left, Types right) {
	if (left != NONE && left != MISMATCH && right != MISMATCH && left != right) {
        appendError(GENERAL_SEMANTIC, "If-Elsif-Else Type Mismatch");
        return MISMATCH;
    }
    return right;
}

Types checkFold(Types index) {
	if (index == MISMATCH)
    	return MISMATCH;
	if (index != INT_TYPE || index != REAL_TYPE) {
		appendError(GENERAL_SEMANTIC, "Fold Requires A Numeric List");
		return MISMATCH; 
	}
	return index;
}