//
//  NSString+CharacterToNumberSubstitution.m
//  CharacterToNumberSubstitution
//
//  Created by Xcode Developer on 7/27/21.
//

#import "NSString+CharacterToNumberSubstitution.h"

@implementation NSString (CharacterToNumberSubstitution)

// Add more as encountered
// Do not restrict returned values to numerics-only
//  until all possible substitutions are added to the
//  conversion table
//

/**
 // Key-value pairs for character-to-numeric substitutions
 // (Key: character  --> value: numeric equivalent)
 //
 conversionTable = [
     "s": "5",
     "S": "5",
     "o": "0",
     "Q": "0",
     "O": "0",
     "i": "1",
     "I": "1",
     "l": "1",
     "B": "8"
 ]
 */

// TO-DO:
// Create a method that searches for a match between between the assigned value of the string
// and a character in the conversion table if the assigned value is not between 0 and 9.
// If found, replace the assigned value with numeric equivalent

// CFDictionary

@end
