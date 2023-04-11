"
A FamixStModel prebuilt with 6 attributes, 5 methods, and some accesses between them
"
Class {
	#name : #MiCoUsageTestFamixModel,
	#superclass : #FamixStModel,
	#category : #'MooseIDE-CoUsageMap-Tests-Resource'
}

{ #category : #testing }
MiCoUsageTestFamixModel class >> canBeImportedFromFile [

	^ false
]

{ #category : #initialization }
MiCoUsageTestFamixModel >> initialize [

	super initialize.
	self name: 'Test model for CoUsageMap'.
	self initializeAttributes.
	self initializeMethods.
	self initializeAccesses
]

{ #category : #initialization }
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

{ #category : #initialization }
MiCoUsageTestFamixModel >> initializeAttributes [

	FamixStAttribute new
		name: 'var1';
		mooseModel: self.
	FamixStAttribute new
		name: 'var2';
		mooseModel: self.
	FamixStAttribute new
		name: 'var3';
		mooseModel: self.
	FamixStAttribute new
		name: 'var4';
		mooseModel: self.
	FamixStAttribute new
		name: 'var5';
		mooseModel: self.
	FamixStAttribute new
		name: 'var6';
		mooseModel: self
]

{ #category : #initialization }
MiCoUsageTestFamixModel >> initializeMethods [

	FamixStMethod new
		name: 'method1';
		mooseModel: self.
	FamixStMethod new
		name: 'method2';
		mooseModel: self.
	FamixStMethod new
		name: 'method3';
		mooseModel: self.
	FamixStMethod new
		name: 'method4';
		mooseModel: self.
	FamixStMethod new
		name: 'method5';
		mooseModel: self
]
