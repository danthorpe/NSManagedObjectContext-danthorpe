//
//  NSManagedObjectContext+danthorpe.m
//
//  Created by Daniel Thorpe on 17/04/2012.
//  Copyright (c) 2012 Blinding Skies Limited. All rights reserved.
//

//  Created by Matt Gallagher on 26/02/07.
//  Copyright 2007 Matt Gallagher. All rights reserved.
//	http://cocoawithlove.com/2008/03/core-data-one-line-fetch.html
//
//	Adapted by Craig Hockenberry on 2/23/2012 to implement:
//	http://useyourloaf.com/blog/2012/1/19/core-data-queries-using-expressions.html


#import "NSManagedObjectContext+danthorpe.h"

@implementation NSManagedObjectContext (danthorpe)

#pragma mark -

- (NSArray *)fetchObjectsForRequest:(NSFetchRequest *)fetchRequest {
	NSError *error = nil;
	NSArray *results = [self executeFetchRequest:fetchRequest error:&error];	
	
    NSAssert(error == nil, [error description]);	
	
    return results;
}

- (NSFetchRequest *)fetchRequestForEntity:(NSEntityDescription *)entity {	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = entity;
	
    return request;
}

- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName {
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];

	return [self fetchRequestForEntity:entity];
}

#pragma mark - Counts

- (NSUInteger)countForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchRequestForEntityName:entityName];
	
	if (predicate) {
		request.predicate = predicate;
	}
	
	NSError *error = nil;
	NSUInteger result = [self countForFetchRequest:request error:&error];
	
	NSAssert(error == nil, [error description]);
	
	return result;
}

- (NSUInteger)countForEntityName:(NSString *)entityName withPredicateFormat:(NSString *)format arguments:(va_list)arguments {
	NSPredicate *predicate = nil;
	if (format) {
		predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
	}
	
	return [self countForEntityName:entityName withPredicate:predicate];
}

- (NSUInteger)countForEntityName:(NSString *)entityName withPredicateFormat:(NSString *)format, ... {
	va_list arguments;
	va_start(arguments, format);
	NSUInteger result = [self countForEntityName:entityName withPredicateFormat:format arguments:arguments];
	va_end(arguments);
	
	return result;
}


#pragma mark - Objects

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchRequestForEntityName:entityName];
	
	if (sortDescriptors) {
		request.sortDescriptors = sortDescriptors;
	}
	
	if (predicate) {
		request.predicate = predicate;
	}
	
	NSError *error = nil;
	NSArray *results = [self executeFetchRequest:request error:&error];
	
	NSAssert(error == nil, [error description]);
	
	return results;
}

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors withPredicateFormat:(NSString *)format arguments:(va_list)arguments {
	NSPredicate *predicate = nil;
	if (format) {
		predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
	}
	
	return [self fetchObjectArrayForEntityName:entityName usingSortDescriptors:sortDescriptors withPredicate:predicate];
}

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors withPredicateFormat:(NSString *)format, ... {
	va_list arguments;
	va_start(arguments, format);
	NSArray *results = [self fetchObjectArrayForEntityName:entityName usingSortDescriptors:sortDescriptors withPredicateFormat:format arguments:arguments];
	va_end(arguments);
	
	return results;
}

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName withPredicateFormat:(NSString *)format, ... {
	va_list arguments;
	va_start(arguments, format);
	NSArray *results = [self fetchObjectArrayForEntityName:entityName usingSortDescriptors:nil withPredicateFormat:format arguments:arguments];
	va_end(arguments);
	
	return results;
}

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors {
	return [self fetchObjectArrayForEntityName:entityName usingSortDescriptors:sortDescriptors withPredicate:nil];
}

- (id)firstObjectForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
    return [[self fetchObjectArrayForEntityName:entityName usingSortDescriptors:sortDescriptors withPredicate:predicate] objectAtIndex:0];
}

- (id)firstObjectArrayForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors withPredicateFormat:(NSString *)format arguments:(va_list)arguments {
    return [[self fetchObjectArrayForEntityName:entityName usingSortDescriptors:sortDescriptors withPredicateFormat:format arguments:arguments] objectAtIndex:0];
}

- (id)firstObjectArrayForEntityName:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors withPredicateFormat:(NSString *)format, ... {
	va_list arguments;
	va_start(arguments, format);
	NSArray *results = [self fetchObjectArrayForEntityName:entityName usingSortDescriptors:sortDescriptors withPredicateFormat:format arguments:arguments];
	va_end(arguments);
	
	return [results objectAtIndex:0];
}

- (id)firstObjectArrayForEntityName:(NSString *)entityName withPredicateFormat:(NSString *)format, ... {
	va_list arguments;
	va_start(arguments, format);
	NSArray *results = [self fetchObjectArrayForEntityName:entityName usingSortDescriptors:nil withPredicateFormat:format arguments:arguments];
	va_end(arguments);
    
    return [results objectAtIndex:0];
}


#pragma mark -

- (id)fetchValueForEntityName:(NSString *)entityName usingAttribute:(NSString *)attributeName andFunction:(NSString *)function withPredicate:(NSPredicate *)predicate {
	id value = nil;
	
	// Get the entity so we can check its attribute information
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	
	NSAttributeDescription *attribute = [[entity attributesByName] objectForKey:attributeName];
	if (attribute) {
		NSFetchRequest *request = [self fetchRequestForEntity:entity];
		
		NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:attributeName];
		NSExpression *functionExpression = [NSExpression expressionForFunction:function arguments:[NSArray arrayWithObject:keyPathExpression]];
        
		NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
		[expressionDescription setName:attributeName];
		[expressionDescription setExpression:functionExpression];
		[expressionDescription setExpressionResultType:[attribute attributeType]];
		
		[request setResultType:NSDictionaryResultType];
		[request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
        
		if (predicate) {
			[request setPredicate:predicate];
		}
        
		NSError *error = nil;
		NSArray *results = [self executeFetchRequest:request error:&error];
		NSAssert(error == nil, [error description]);
		
		if (results) {
			value = [[results lastObject] valueForKey:attributeName];
		}
	}
	
	return value;
}

- (id)fetchValueForEntityName:(NSString *)entityName usingAttribute:(NSString *)attributeName andFunction:(NSString *)function withPredicateFormat:(NSString *)format arguments:(va_list)arguments {
	NSPredicate *predicate = nil;
	if (format) {
		predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
	}
	
	return [self fetchValueForEntityName:entityName usingAttribute:attributeName andFunction:function withPredicate:predicate];
}

- (id)fetchValueForEntityName:(NSString *)entityName usingAttribute:(NSString *)attributeName andFunction:(NSString *)function withPredicateFormat:(NSString *)format, ... {
	id result = nil;
    
	va_list arguments;
	va_start(arguments, format);
	result = [self fetchValueForEntityName:entityName usingAttribute:attributeName andFunction:function withPredicateFormat:format arguments:arguments];
	va_end(arguments);
	
	return result;
}

- (id)fetchValueForEntityName:(NSString *)entityName usingAttribute:(NSString *)attributeName andFunction:(NSString *)function {
	return [self fetchValueForEntityName:entityName usingAttribute:attributeName andFunction:function withPredicate:nil];
}


#pragma mark - Changes

- (NSSet *)registeredObjectsOfEntityName:(NSString *)entityName 
                             withPredicate:(NSPredicate *)predicate {
    // Create a predicate for the entity name
    NSPredicate *entityNamePredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [entityName isEqualToString:NSStringFromClass([evaluatedObject class])];
    }]; 
    
    // Define the filter predicate
    NSPredicate *filter = nil;
    
    if (predicate) {
        // Create a filter predicate
        filter = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:entityNamePredicate, predicate, nil]];        
    } else {
        filter = entityNamePredicate;
    }
    
    // Filter the registered objects
    NSSet *filtered = [[self registeredObjects] filteredSetUsingPredicate:filter];
    
    return filtered;
}

@end
