//
// Copyright 2011 ESCOZ Inc  - http://escoz.com
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

NSDictionary * QRootElementJSONBuilderConversionDict;

@interface QRootBuilder ()
- (void)initializeMappings;

@end

@implementation QRootBuilder

+ (void)trySetProperty:(NSString *)propertyName onObject:(id)target withValue:(id)value {
    if ([value isKindOfClass:[NSString class]] && [target respondsToSelector:NSSelectorFromString(propertyName)]) {
        [target setValue:value forKey:propertyName];
        if ([QRootElementJSONBuilderConversionDict objectForKey:propertyName]!=nil) {
            [target setValue:[[QRootElementJSONBuilderConversionDict objectForKey:propertyName] objectForKey:value] forKey:propertyName];
        }
    } else if ([value isKindOfClass:[NSNumber class]]){
        [target setValue:value forKey:propertyName];
    } else if ([value isKindOfClass:[NSArray class]]) {
        [target setValue:value forKey:propertyName];
    } else if ([value isKindOfClass:[NSDictionary class]]){
        [target setValue:value forKey:propertyName];
    }
}

- (void)updateObject:(id)element withPropertiesFrom:(NSDictionary *)dict {
    for (NSString *key in dict.allKeys){
        if ([key isEqualToString:@"type"] || [key isEqualToString:@"sections"]|| [key isEqualToString:@"elements"])
            continue;

        id value = [dict valueForKey:key];
        [QRootBuilder trySetProperty:key onObject:element withValue:value];
    }
}

- (QElement *)buildElementWithObject:(id)obj {
    QElement *element = [[NSClassFromString([obj valueForKey:[NSString stringWithFormat:@"type"]]) alloc] init];
    if (element==nil)
            return nil;
    [self updateObject:element withPropertiesFrom:obj];
    return element;
}

- (void)buildSectionWithObject:(id)obj forRoot:(QRootElement *)root {
    QSection *sect = [[QSection alloc] init];
    [self updateObject:sect withPropertiesFrom:obj];
    [root addSection:sect];
    for (id element in (NSArray *)[obj valueForKey:[NSString stringWithFormat:@"elements"]]){
       [sect addElement:[self buildElementWithObject:element] ];
    }
}

- (QRootElement *)buildSectionsWithObject:(id)obj {
    if (QRootElementJSONBuilderConversionDict==nil)
        [self initializeMappings];
    
    QRootElement *root = [QRootElement new];
    [self updateObject:root withPropertiesFrom:obj];
    for (id section in (NSArray *)[obj valueForKey:[NSString stringWithFormat:@"sections"]]){
        [self buildSectionWithObject:section forRoot:root];
    }
    
    return root;
}

- (void)initializeMappings {
    QRootElementJSONBuilderConversionDict = [[NSDictionary alloc] initWithObjectsAndKeys:

                    [[NSDictionary alloc] initWithObjectsAndKeys:
                        [NSNumber numberWithInt:UITextAutocapitalizationTypeNone], @"None",
                                [NSNumber numberWithInt:UITextAutocapitalizationTypeWords], @"Words",
                                [NSNumber numberWithInt:UITextAutocapitalizationTypeSentences], @"Sentences",
                                [NSNumber numberWithInt:UITextAutocapitalizationTypeAllCharacters], @"AllCharacters",
                                nil], @"autocapitalizationType",

                    [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInt:UITextAutocorrectionTypeDefault], @"Default",
                                    [NSNumber numberWithInt:UITextAutocorrectionTypeNo], @"No",
                                    [NSNumber numberWithInt:UITextAutocorrectionTypeYes], @"Yes",
                                    nil], @"autocorrectionType",

                    [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:UIKeyboardTypeDefault], @"Default",
                                    [NSNumber numberWithInt:UIKeyboardTypeASCIICapable], @"ASCIICapable",
                                    [NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation], @"NumbersAndPunctuation",
                                    [NSNumber numberWithInt:UIKeyboardTypeURL], @"URL",
                                    [NSNumber numberWithInt:UIKeyboardTypeNumberPad], @"NumberPad",
                                    [NSNumber numberWithInt:UIKeyboardTypePhonePad], @"PhonePad",
                                    [NSNumber numberWithInt:UIKeyboardTypeNamePhonePad], @"NamePhonePad",
                                    [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], @"EmailAddress",
                                    [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], @"DecimalPad",
                                    [NSNumber numberWithInt:UIKeyboardTypeTwitter], @"Twitter",
                                    [NSNumber numberWithInt:UIKeyboardTypeAlphabet], @"Alphabet",
                                    nil], @"keyboardType",

                    [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInt:UIKeyboardAppearanceDefault], @"Default",
                                    [NSNumber numberWithInt:UIKeyboardAppearanceAlert], @"Alert",
                                    nil], @"keyboardAppearance",

                    [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:UIReturnKeyDefault], @"Default",
                                    [NSNumber numberWithInt:UIReturnKeyGo], @"Go",
                                    [NSNumber numberWithInt:UIReturnKeyGoogle], @"Google",
                                    [NSNumber numberWithInt:UIReturnKeyJoin], @"Join",
                                    [NSNumber numberWithInt:UIReturnKeyNext], @"Next",
                                    [NSNumber numberWithInt:UIReturnKeyRoute], @"Route",
                                    [NSNumber numberWithInt:UIReturnKeySearch], @"Search",
                                    [NSNumber numberWithInt:UIReturnKeySend], @"Send",
                                    [NSNumber numberWithInt:UIReturnKeyYahoo], @"Yahoo",
                                    [NSNumber numberWithInt:UIReturnKeyDone], @"Done",
                                    [NSNumber numberWithInt:UIReturnKeyEmergencyCall], @"EmergencyCall",
                                    nil], @"returnKeyType",

                    nil];
}


@end