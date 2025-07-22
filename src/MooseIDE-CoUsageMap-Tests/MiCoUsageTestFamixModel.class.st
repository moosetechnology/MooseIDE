"
A FamixStModel prebuilt with 6 attributes, 5 methods, and some accesses between them
"
Class {
	#name : 'MiCoUsageTestFamixModel',
	#superclass : 'FamixStModel',
	#category : 'MooseIDE-CoUsageMap-Tests-Resource',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Resource'
}

{ #category : 'testing' }
MiCoUsageTestFamixModel class >> canBeImportedFromFile [

	^ false
]

{ #category : 'initialization' }
MiCoUsageTestFamixModel >> initialize [

	super initialize.
	self name: 'Test model for CoUsageMap'.
	self metamodel: FamixStModel metamodel.
	self initializeAttributes.
	self initializeMethods.
	self initializeAccesses
]

{ #category : 'initialization' }
MiCoUsageTestFamixModel >> initializeAccesses [

	(self entityNamed: 'method1') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var1')).
	(self entityNamed: 'method1') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var1')).
	(self entityNamed: 'method1') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var1')).
	(self entityNamed: 'method1') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var2')).

	(self entityNamed: 'method3') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var2')).
	(self entityNamed: 'method3') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var3')).
	(self entityNamed: 'method3') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var4')).

	(self entityNamed: 'method4') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var6')).
	(self entityNamed: 'method4') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var6')).

	(self entityNamed: 'method5') addAccess:
		(FamixStAccess new variable: (self entityNamed: 'var6'))
]

{ #category : 'initialization' }
MiCoUsageTestFamixModel >> initializeAttributes [

	self newAttributeNamed: 'var1'.
	self newAttributeNamed: 'var2'.
	self newAttributeNamed: 'var3'.
	self newAttributeNamed: 'var4'.
	self newAttributeNamed: 'var5'.
	self newAttributeNamed: 'var6'
]

{ #category : 'initialization' }
MiCoUsageTestFamixModel >> initializeMethods [

	self newMethodNamed: 'method1'.
	self newMethodNamed: 'method2'.
	self newMethodNamed: 'method3'.
	self newMethodNamed: 'method4'.
	self newMethodNamed: 'method5'
]
