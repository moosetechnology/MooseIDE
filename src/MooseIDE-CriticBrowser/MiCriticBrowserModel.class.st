"
Model used by the MooseIDE Critic Browser.
"
Class {
	#name : #MiCriticBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'rules',
		'violations'
	],
	#category : #'MooseIDE-CriticBrowser'
}

{ #category : #accessing }
MiCriticBrowserModel >> addRule: aRule [

	((aRule class inheritsFrom: FamixCBRule) or: [ aRule class = FamixCBRule ]) ifTrue: [ rules add: aRule ]
]

{ #category : #deleting }
MiCriticBrowserModel >> deleteRule: aFamixCBRule [

	(rules indexOf: aFamixCBRule) = 0 ifTrue: [ ^ self ].
	rules remove: aFamixCBRule.
	violations removeKey: aFamixCBRule ifAbsent: [ ^ self ]
]

{ #category : #accessing }
MiCriticBrowserModel >> entities [

	^ entities
]

{ #category : #accessing }
MiCriticBrowserModel >> getAllViolations [
"returns violations of every rule"
	| result |
	result := FamixCBViolationGroup new.
	violations do: [ :each | result := result , each ].
	^ result
]

{ #category : #initialization }
MiCriticBrowserModel >> initialize [ 

	super initialize.
	entities := MooseGroup new.
	rules := OrderedCollection new.
	violations := Dictionary new.
]

{ #category : #removing }
MiCriticBrowserModel >> removeRuleViolations: aRule [
	violations removeKey: aRule ifAbsent: [  ].
]

{ #category : #accessing }
MiCriticBrowserModel >> rules [

	^ rules
]

{ #category : #execution }
MiCriticBrowserModel >> runRules [
"run on the entities every query in the model, and stores in output the result of each query linked to a key (the query)"
	rules do: [ :each | violations at: each put: (each runOn: entities) ].
	
]

{ #category : #accessing }
MiCriticBrowserModel >> setEntities: aMooseObject [
	entities := aMooseObject isCollection
		ifTrue: [ aMooseObject allUsing: FamixTNamedEntity ]
		ifFalse: [ ({aMooseObject} asMooseGroup) allUsing: FamixTNamedEntity ].
]

{ #category : #accessing }
MiCriticBrowserModel >> violations [

	^ violations
]

{ #category : #accessing }
MiCriticBrowserModel >> violationsOf: aFamixCBRule [
"returns violations for a given rule"
	(violations includesKey: aFamixCBRule)
		ifTrue: [ ^ self violations at: aFamixCBRule ]
]

{ #category : #accessing }
MiCriticBrowserModel >> violationsOfCollection: aCollection [
"returns violations for a given set of rules"
	| result |
	result := FamixCBViolationGroup new.
	aCollection do: [ :rule | result := result , (self violationsOf: rule) ].
	^ result 
]
