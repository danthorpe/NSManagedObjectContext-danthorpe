//
//  NSManagedObjectContext+danthorpe.h
//  Talent
//
//  Created by Daniel Thorpe on 17/04/2012.
//  Copyright (c) 2012 Brave New Talent. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (danthorpe)

#pragma mark -

- (NSArray *)fetchObjectsForRequest:(NSFetchRequest *)fetchRequest;
- (NSFetchRequest *)fetchRequestForEntity:(NSEntityDescription *)entity;
- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName;

#pragma mark - Counts

- (NSUInteger)countForEntityName:(NSString *)entityName 
                   withPredicate:(NSPredicate *)predicate;

- (NSUInteger)countForEntityName:(NSString *)entityName 
             withPredicateFormat:(NSString *)format 
                       arguments:(va_list)arguments;

- (NSUInteger)countForEntityName:(NSString *)entityName 
             withPredicateFormat:(NSString *)format, ...;

#pragma mark - Objects

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName 
                      usingSortDescriptors:(NSArray *)sortDescriptors 
                             withPredicate:(NSPredicate *)predicate;

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName 
                      usingSortDescriptors:(NSArray *)sortDescriptors 
                       withPredicateFormat:(NSString *)format 
                                 arguments:(va_list)arguments;

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName 
                      usingSortDescriptors:(NSArray *)sortDescriptors 
                       withPredicateFormat:(NSString *)format, ...;

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName 
                       withPredicateFormat:(NSString *)format, ...;

- (NSArray *)fetchObjectArrayForEntityName:(NSString *)entityName 
                      usingSortDescriptors:(NSArray *)sortDescriptors;


#pragma mark - Value

- (id)fetchValueForEntityName:(NSString *)entityName 
               usingAttribute:(NSString *)attributeName 
                  andFunction:(NSString *)function 
                withPredicate:(NSPredicate *)predicate;

- (id)fetchValueForEntityName:(NSString *)entityName 
               usingAttribute:(NSString *)attributeName 
                  andFunction:(NSString *)function 
          withPredicateFormat:(NSString *)format 
                    arguments:(va_list)arguments;

- (id)fetchValueForEntityName:(NSString *)entityName 
               usingAttribute:(NSString *)attributeName 
                  andFunction:(NSString *)function 
          withPredicateFormat:(NSString *)format, ...;

- (id)fetchValueForEntityName:(NSString *)entityName 
               usingAttribute:(NSString *)attributeName 
                  andFunction:(NSString *)function;


@end
