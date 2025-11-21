"
A FamixStModel prebuilt with 6 variables/attributes, 5 methods, and some accesses between them

- method1 -> att1
- method1 -> att1
- method1 -> att1
- method1 -> var2
  
- method3 -> var2
- method3 -> att3
- method3 -> att4
- method3 -> att5
  
- method4 -> att6
- method4 -> att6
  
- method5 -> att6
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

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> att1 [

	^self entityNamed: 'att1'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> att3 [

	^self entityNamed: 'att3'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> att4 [

	^self entityNamed: 'att4'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> att5 [

	^self entityNamed: 'att5'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> att6 [

	^self entityNamed: 'att6'
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


	self newAccess accessor: self method1 ; variable: self att1.
	self newAccess accessor: self method1 ; variable: self att1.
	self newAccess accessor: self method1 ; variable: self att1.
	self newAccess accessor: self method1 ; variable: self var2.

	self newInvocation sender: self method2 ; candidates: {self method5}.
	
	self newAccess accessor: self method3 ; variable: self var2.
	self newAccess accessor: self method3 ; variable: self att3.
	self newAccess accessor: self method3 ; variable: self att4.
	self newAccess accessor: self method3 ; variable: self att5.

	self newAccess accessor: self method4 ; variable: self att6.
	self newAccess accessor: self method4 ; variable: self att6.

	self newAccess accessor: self method5 ; variable: self att6.
]

{ #category : 'initialization' }
MiCoUsageTestFamixModel >> initializeAttributes [

	self newAttributeNamed: 'att1'.
	self newLocalVariableNamed: 'var2'.
	self newAttributeNamed: 'att3'.
	self newAttributeNamed: 'att4'.
	self newAttributeNamed: 'att5'.
	self newAttributeNamed: 'att6'
]

{ #category : 'initialization' }
MiCoUsageTestFamixModel >> initializeMethods [

	self newMethodNamed: 'method1'.
	self newMethodNamed: 'method2'.
	self newMethodNamed: 'method3'.
	self newMethodNamed: 'method4'.
	(self newMethodNamed: 'method5') beGetter
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> method1 [

	^self entityNamed: 'method1'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> method2 [

	^self entityNamed: 'method2'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> method3 [

	^self entityNamed: 'method3'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> method4 [

	^self entityNamed: 'method4'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> method5 [

	^self entityNamed: 'method5'
]

{ #category : 'accessing' }
MiCoUsageTestFamixModel >> var2 [

	^self entityNamed: 'var2'
]
