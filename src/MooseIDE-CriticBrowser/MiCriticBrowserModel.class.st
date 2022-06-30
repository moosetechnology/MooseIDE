"
Model used by the MooseIDE Critic Browser.
"
Class {
	#name : #MiCriticBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'rootContext',
		'violations'
	],
	#category : #'MooseIDE-CriticBrowser'
}

{ #category : #adding }
MiCriticBrowserModel >> addRootContext: aContext [
	rootContext := aContext
]

{ #category : #'as yet unclassified' }
MiCriticBrowserModel >> deleteRuleComponent: aRuleComponent [
	aRuleComponent removeSelfFromTree.
	self removeRuleViolations: aRuleComponent
	

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
	rootContext := (FamixCBRootContext named: 'Root context (all entities)' on: '[ :col | col ]').
	violations := Dictionary new
]

{ #category : #removing }
MiCriticBrowserModel >> removeRuleViolations: aCondition [
	violations removeKey: aCondition ifAbsent: [  ].
]

{ #category : #accessing }
MiCriticBrowserModel >> rootContext [
	^ rootContext
]

{ #category : #running }
MiCriticBrowserModel >> run [
	rootContext runOnTree: entities.
	violations := rootContext getAllViolations
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
MiCriticBrowserModel >> violationsOf: aCondition [
"returns violations for a given rule"
	^ (violations includesKey: aCondition)
		ifTrue: [ self violations at: aCondition ]
		ifFalse: [ MooseGroup new ]
]

{ #category : #accessing }
MiCriticBrowserModel >> violationsOfCollection: aCollection [
"returns violations for a given set of rules"
	| result |
	result := FamixCBViolationGroup new.
	aCollection do: [ :condition | result := result , (self violationsOf: condition) ].
	^ result 
]
