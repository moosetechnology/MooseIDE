"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parent` | `FamixCBTRuleComponent` | `children` | `FamixCBContext` | Parent context, if it exists.|
| `violations` | `FamixCBCondition` | `violatedCondition` | `FamixCBViolation` | Every violation of this condition.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `query` | `Object` | nil | Block to execute to find violations to the condition within the parent context|
| `severity` | `Object` | nil | Severity for the violations of this condition|
| `summary` | `String` | nil | A rule component can have an explanatory summary|

"
Class {
	#name : #FamixCBCondition,
	#superclass : #FamixCBEntity,
	#traits : 'FamixCBTRuleComponent',
	#classTraits : 'FamixCBTRuleComponent classTrait',
	#instVars : [
		'#query => FMProperty',
		'#severity => FMProperty',
		'#violations => FMMany type: #FamixCBViolation opposite: #violatedCondition'
	],
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBCondition class >> annotation [

	<FMClass: #Condition super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #'instance creation' }
FamixCBCondition class >> named: aString on: aQuery [
	^ self new
		name: aString;
		query: aQuery;
		yourself
]

{ #category : #'instance creation' }
FamixCBCondition class >> named: aString on: aQuery summary: aSummary [
	^ self new
		name: aString;
		query: aQuery;
		summary: aSummary;
		yourself
]

{ #category : #'instance creation' }
FamixCBCondition class >> named: aString on: aQuery summary: aSummary severity: aSeverity [
	^ self new
		name: aString;
		query: aQuery;
		summary: aSummary;
		severity: aSeverity;
		yourself
]

{ #category : #adding }
FamixCBCondition >> addViolation: anObject [
	<generated>
	^ self violations add: anObject
]

{ #category : #accessing }
FamixCBCondition >> putViolationsInto: aDictionary [
	aDictionary at: self put: violations asMooseSpecializedGroup
]

{ #category : #accessing }
FamixCBCondition >> query [

	<FMProperty: #query type: #Object>
	<generated>
	<FMComment: 'Block to execute to find violations to the condition within the parent context'>
	^ query
]

{ #category : #accessing }
FamixCBCondition >> query: aQuery [

	(aQuery isKindOf: FamixCBQueryHandler)
		ifTrue: [ query := aQuery ]
		ifFalse: [ self error: FamixCBNotAValidQuery signal ]
]

{ #category : #removing }
FamixCBCondition >> removeAllViolations [
	[ violations isNotEmpty ] whileTrue: [ self removeViolation: violations anyOne ]
]

{ #category : #removing }
FamixCBCondition >> removeViolation: aViolation [
	self violations remove: aViolation ifAbsent: [ ^ self ].
	aViolation violatingEntity ifNotNil: [ aViolation violatingEntity removeViolation: aViolation ]
]

{ #category : #removing }
FamixCBCondition >> resetExecutionOfTree [ 
	self removeAllViolations
]

{ #category : #running }
FamixCBCondition >> runDownTree: aCollection withCallback: aBlock [

	self runOn: aCollection withCallback: aBlock
]

{ #category : #running }
FamixCBCondition >> runOn: aCollection [

	(self query runOnCollection: aCollection) do: [ :each | 
		self addViolation: (FamixCBViolation new violatingEntity: each) ]
]

{ #category : #running }
FamixCBCondition >> runOn: aCollection withCallback: aBlock [

	aBlock value: self name.
	self runOn: aCollection
]

{ #category : #removing }
FamixCBCondition >> runUpTree: aCollection [
	self runOn: (parent runUpTree: aCollection)
]

{ #category : #accessing }
FamixCBCondition >> severity [

	<FMProperty: #severity type: #Object>
	<FMComment: 'Severity for the violations of this condition'>
	^ severity ifNil: [ FamixCBAbstractSeverity allSubclasses detectMin: #level ]
]

{ #category : #accessing }
FamixCBCondition >> severity: anObject [
	<generated>
	severity := anObject
]

{ #category : #'ston persistence' }
FamixCBCondition >> stonOn: stonWriter [

	stonWriter writeObject: self streamMap: [ :dictionary | 
		self class stonAllInstVarNames do: [ :each | 
			(self instVarNamed: each) ifNotNil: [ :value | 
				dictionary
					at: each asSymbol
					put: ((value isKindOf: FamixCBQueryHandler)
							 ifTrue: [ value convertToSTONString ]
							 ifFalse: [ value ]) ] ] ]
]

{ #category : #accessing }
FamixCBCondition >> violations [
	"Relation named: #violations type: #FamixCBViolation opposite: #violatedCondition"

	<generated>
	<FMComment: 'Every violation of this condition.'>
	<derived>
	^ violations
]

{ #category : #accessing }
FamixCBCondition >> violations: anObject [

	<generated>
	violations value: anObject
]
