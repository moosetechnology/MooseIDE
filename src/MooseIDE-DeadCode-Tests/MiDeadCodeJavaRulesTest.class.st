Class {
	#name : 'MiDeadCodeJavaRulesTest',
	#superclass : 'MiDeadCodeRuleModelAbstractTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodeJavaRulesTest >> javaClass: aClass implements: anInterface [

	FamixJavaImplementation new
		implementingClass: aClass;
		interface: anInterface
]

{ #category : 'running' }
MiDeadCodeJavaRulesTest >> javaClass: aClass inherits: aSuperclass [

	FamixJavaInheritance new
		subclass: aClass;
		superclass: aSuperclass
]

{ #category : 'running' }
MiDeadCodeJavaRulesTest >> javaClassMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: FamixJavaClass new.

	^ entity
]

{ #category : 'running' }
MiDeadCodeJavaRulesTest >> javaInterfaceMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: FamixJavaInterface new.

	^ entity
]

{ #category : 'running' }
MiDeadCodeJavaRulesTest >> javaInvokeMethod: entity [

	FamixJavaInvocation new
		sender: entity;
		candidates: { entity }
]

{ #category : 'running' }
MiDeadCodeJavaRulesTest >> javaMethod: methName annotatedWith: annotationName [

	| entity |
	entity := FamixJavaMethod new.
	entity name: methName.

	FamixJavaAnnotationInstance new
		annotationType: (FamixJavaAnnotationType new name: annotationName);
		annotatedEntity: entity.

	^ entity
]

{ #category : 'entity creation' }
MiDeadCodeJavaRulesTest >> javaParametricInterfaceMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaParametricInterface new).

	^entity
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaAnnotationRuleDeadNoAnnotation [
	"Unused method with no annotation is dead"

	| entity |
	entity := FamixJavaMethod new.

	self assert: (MiDeadJavaTestAnnotationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaAnnotationRuleDeadWrongAnnotation [
	"Unused method with @Deprecated annotation is dead"

	| entity |
	entity := self
		          javaMethod: 'someFunctionality'
		          annotatedWith: 'Deprecated'.

	self assert: (MiDeadJavaTestAnnotationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaAnnotationRuleNotDead [
	"Unused method with JUnit annotation is not dead"

	| entity |
	entity := self
		          javaMethod: 'someFunctionality'
		          annotatedWith: 'BeforeClass'.

	self deny: (MiDeadJavaTestAnnotationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaHasOverridingRuleDead [
	"Unused method (entity1.doSomething()) with sub-method declaring @Override is not dead"

	| entity1 entity2 annotation |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity2 parentType inherits: entity1 parentType.

	annotation := FamixJavaAnnotationType new name: 'Override'.
	annotation annotationTypesContainer: (FamixJavaPackage new
			 name: 'lang';
			 parentPackage: (FamixJavaPackage new name: 'java')).
	FamixJavaAnnotationInstance new
		annotatedEntity: entity2;
		annotationType: annotation.

	self deny: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaHasOverridingRuleDeadNoAnnotation [
	"Unused method (entity1.doSomething()) with sub-method not declaring @Override is dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity2 parentType inherits: entity1 parentType.

	self assert: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaHasOverridingRuleDeadNoOverride [
	"Unused method (entity1.doSomething()) with sub-method not declaring @Override is dead"

	| entity1 entity2 annotation |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity2 parentType inherits: entity1 parentType.

	annotation := FamixJavaAnnotationType new name: 'Deprecated'.
	annotation annotationTypesContainer: (FamixJavaPackage new
			 name: 'lang';
			 parentPackage: (FamixJavaPackage new name: 'java')).

	FamixJavaAnnotationInstance new
		annotatedEntity: entity2;
		annotationType: annotation.

	self assert: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaHasOverridingRuleDeadNoSubMethod [
	"Unused method (entity1.doSomething()) with sub-method declaring @Override is dead
	 (note: entity1.doSomething() is not a sub method of entity1.doSomething()"

	| entity1 entity2 annotation |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.

	annotation := FamixJavaAnnotationType new name: 'Override'.
	annotation annotationTypesContainer: (FamixJavaPackage new
			 name: 'lang';
			 parentPackage: (FamixJavaPackage new name: 'java')).
	FamixJavaAnnotationInstance new
		annotatedEntity: entity2;
		annotationType: annotation.

	self assert: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaImplementsRuleGenericMethod [
	"Unused method (entity1.doSomething(String)) implementing a parametric interface declaration
	 should not be dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething(String)'.
	entity2 := self javaParametricInterfaceMethod: 'doSomething(T)'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self deny: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaImplementsRuleNoInterface [
	"Unused method (entity1.doSomething()) not implementing an abtract declaration is dead"

	| entity1 |
	entity1 := self javaClassMethod: 'doSomething()'.

	self assert: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaImplementsRuleNoOverride [
	"Unused method (entity1.doSomething())) implementing an interface declaration is not dead
	 (according to MiDeadCodeJavaImplementsAbstractHeuristic)"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self deny: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaImplementsRuleNotAbstract [
	"Unused method (entity1.doSomething()) overriding a super-method is dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity1 parentType inherits: entity2 parentType.

	self assert: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaImplementsRuleWithAbstract [
	"Unused method (entity1.doSomething()) overriding an abstract super-method is not dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	entity2 isAbstract: true.
	self javaClass: entity1 parentType inherits: entity2 parentType.

	self deny: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaImplementsRuleWithOverride [
	"Unused method (entity1.doSomething()) implementing an interface declaration but overriding a concrete implementation is dead"

	| entity1 entity2 entity3 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	entity3 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType inherits: entity2 parentType.
	self javaClass: entity1 parentType implements: entity3 parentType.

	self assert: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaInitializerRuleDefaultConstructor [

	| entity1 |
	entity1 := 	FamixJavaInitializer new.

	self deny: (MiDeadJavaInitializerRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaInitializerRuleNonDefaultConstructor [

	| entity1 |
	entity1 := FamixJavaInitializer new.
	entity1 name: 'SomeClass'.
	entity1 parentType: (FamixJavaClass new name: 'SomeClass' ; yourself).
	FamixJavaParameter new
		parentBehaviouralEntity: entity1.

	self assert: (MiDeadJavaInitializerRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaInitializerRuleNotConstructor [

	| entity1 |
	entity1 := self javaClassMethod: 'doSomething()'.

	self assert: (MiDeadJavaInitializerRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaNonDefaultConstructorRuleInheritsObject [
	"classes inheriting from 'Object' do not need explicit constructor (ie. there constructor can be dead)"

	| entity1 rule |
	entity1 := FamixJavaInitializer new.
	entity1 parentType: FamixJavaClass new.
	entity1 parentType name: 'SomeClass'.
	entity1 name: entity1 parentType name.
	self javaClass: entity1 parentType inherits: (FamixJavaClass new name: 'Object' ; yourself).

	rule := MiDeadJavaNonDefaultConstructorRule new.
	rule deadCodeModel: model.
	model addDeadEntity: entity1.

	self assert: (rule isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaNonDefaultConstructorRuleIsNotConstructor [

	| entity1 rule |
	entity1 := 	self javaClassMethod: 'someMethod()'.
	rule := MiDeadJavaNonDefaultConstructorRule new.
	rule deadCodeModel: model.

	self assert: (rule isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaNonDefaultConstructorRuleWithOtherConstructor [
	"there is 'another' constructor (even if this is the same here) not dead
	 so the main one can be dead"

	| entity1 rule |
	entity1 := FamixJavaInitializer new.
	entity1 parentType: FamixJavaClass new.
	entity1 parentType name: 'SomeClass'.
	entity1 name: entity1 parentType name.
	self javaClass: entity1 parentType inherits: (FamixJavaClass new name: 'Object' ; yourself).

	rule := MiDeadJavaNonDefaultConstructorRule new.
	rule deadCodeModel: model.

	self assert: (rule isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaNonDefaultConstructorRuleWithoutOtherConstructor [
	"no other constructor not dead, so the main one cannot be dead"

	| entity1 rule |
	entity1 := FamixJavaInitializer new.
	entity1 parentType: FamixJavaClass new.
	entity1 parentType name: 'SomeClass'.
	entity1 name: entity1 parentType name.
	self javaClass: entity1 parentType inherits: (FamixJavaClass new name: 'SuperClazz' ; yourself).

	rule := MiDeadJavaNonDefaultConstructorRule new.
	rule deadCodeModel: model.
	model addDeadEntity: entity1.

	self deny: (rule isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaOverridesRuleDeadNoInterface [
	"Unused method (entity1.doSomething()) is dead
	 note: no link between entity1 and entity2"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaInvokeMethod: entity2.

	self assert: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaOverridesRuleDeadNoInvocation [
	"Unused method implementing an interface declaration is dead
	 (according to MiDeadCodeJavaOverridesInvokedHeuristic)"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self assert: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaOverridesRuleDeadNoMethod [
	"Unused method (entity1.doSomething()) with no implementing sub-method used is dead
	 (according to MiDeadCodeJavaOverridesInvokedHeuristic)
	 note: methods names are different"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doOtherThing()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self javaInvokeMethod: entity2.

	self assert: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeJavaRulesTest >> testJavaOverridesRuleNotDead [
	"Unused method (entity1.doSomething()) with implementing sub-method used is not dead
	 (according to MiDeadCodeJavaOverridesInvokedHeuristic)"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self javaInvokeMethod: entity2.

	self deny: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]
