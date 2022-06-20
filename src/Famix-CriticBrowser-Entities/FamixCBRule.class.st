Class {
	#name : #FamixCBRule,
	#superclass : #FamixCBEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#summary => FMProperty',
		'#violations => FMMany type: #FamixCBViolation opposite: #violatedRule',
		'#query'
	],
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBRule class >> annotation [

	<FMClass: #Rule super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^self
]

{ #category : #'instance creation' }
FamixCBRule class >> named: aString on: aQuery [
	^ self new
		name: aString;
		query: aQuery;
		yourself
]

{ #category : #'instance creation' }
FamixCBRule class >> named: aString on: aQuery summary: aSummary [
	^ self new
		name: aString;
		query: aQuery;
		summary: aSummary;
		yourself
]

{ #category : #ston }
FamixCBRule class >> stonAllInstVarNames [
	^ super stonAllInstVarNames \ #(#mooseID #mooseModel #cache #entityAttributes #violations)
]

{ #category : #adding }
FamixCBRule >> addViolation: anObject [
	<generated>
	^ self violations add: anObject
]

{ #category : #accessing }
FamixCBRule >> query [

	^ query
]

{ #category : #accessing }
FamixCBRule >> query: aQuery [

	(aQuery class inheritsFrom: MiCriticBrowserAbstractQuery) 
		ifTrue: [ query := aQuery ]
		ifFalse: [ self error: NotAValidQuery signal ]
]

{ #category : #running }
FamixCBRule >> runOn: aCollection [
	^ ((self query runOnCollection: aCollection) collect: 
		[ :each | (FamixCBViolation rule: self violatedBy: each) ]) asMooseGroup specialize.
]

{ #category : #'ston persistence' }
FamixCBRule >> stonOn: stonWriter [
	stonWriter
		writeObject: self
		streamMap: [ :dictionary | 
			self class stonAllInstVarNames
				do: [ :each | 
					(self instVarNamed: each)
						ifNotNil: [ :value | 
							dictionary
								at: each asSymbol
								put:
									((value class inheritsFrom: MiCriticBrowserAbstractQuery)
										ifTrue: [ value convertToSTONString ]
										ifFalse: [ value ]) ] ] ]
]

{ #category : #accessing }
FamixCBRule >> summary [

	<FMProperty: #summary type: #String>
	<generated>
	<FMComment: 'A rule can have an explanatory summary'>
	^ summary
]

{ #category : #accessing }
FamixCBRule >> summary: anObject [
	<generated>
	summary := anObject
]

{ #category : #accessing }
FamixCBRule >> violations [
	"Relation named: #violations type: #FamixCBViolation opposite: #violatedRule"

	<generated>
	<FMComment: 'Every violation of this rule.'>
	<derived>
	^ violations
]

{ #category : #accessing }
FamixCBRule >> violations: anObject [

	<generated>
	violations value: anObject
]
