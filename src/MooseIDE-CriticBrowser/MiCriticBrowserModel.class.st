"
Model used by the MooseIDE Critic Browser.
"
Class {
	#name : #MiCriticBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'rootContext',
		'ruleComponents',
		'violations'
	],
	#category : #'MooseIDE-CriticBrowser-Model'
}

{ #category : #adding }
MiCriticBrowserModel >> addChild: aRuleComponent toContext: aContext [
	(aContext = rootContext or: [ ruleComponents includes: aContext ]) ifFalse: [ ^ self ].
	aContext addChild: aRuleComponent.
	ruleComponents add: aRuleComponent
	
]

{ #category : #adding }
MiCriticBrowserModel >> addChildToRootContext: aRuleComponent [
	rootContext addChild: aRuleComponent.
	ruleComponents add: aRuleComponent
	
]

{ #category : #'as yet unclassified' }
MiCriticBrowserModel >> createHierarchyTree [
"creates a list with the index of the parent of each rule component in the ruleComponents
 used to export the rules (and represents the hierarchy)"
	^ ruleComponents collect: [ :el | ruleComponents indexOf: el parent ]
]

{ #category : #'as yet unclassified' }
MiCriticBrowserModel >> deleteRuleComponent: aRuleComponent [
	aRuleComponent removeSelfFromTree.
	self removeRuleViolations: aRuleComponent.
	ruleComponents remove: aRuleComponent ifAbsent: [  ]
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

{ #category : #testing }
MiCriticBrowserModel >> hasBeenEdited: aRuleComponent [
	self removeRuleViolations: aRuleComponent.
	aRuleComponent removeAllViolations.
	browser updateRulesList.
	browser updateResultList: self getAllViolations
]

{ #category : #initialization }
MiCriticBrowserModel >> initialize [ 

	super initialize.
	entities := MooseGroup new.
	rootContext := (FamixCBRootContext named: 'Root context (all entities)' on: '[ :col | col ]').
	ruleComponents := OrderedCollection new.
	violations := Dictionary new
]

{ #category : #removing }
MiCriticBrowserModel >> removeAllViolations [
	rootContext removeAllViolationsFromTree
]

{ #category : #adding }
MiCriticBrowserModel >> removeChild: aRuleComponent fromContext: aContext [
	(aContext = rootContext or: [ ruleComponents includes: aContext ]) ifFalse: [ ^ self ].
	aContext removeChild: aRuleComponent.
	ruleComponents remove: aRuleComponent ifAbsent: [  ].
	
]

{ #category : #removing }
MiCriticBrowserModel >> removeRuleViolations: aCondition [
	violations removeKey: aCondition ifAbsent: [  ].
]

{ #category : #accessing }
MiCriticBrowserModel >> rootContext [
	^ rootContext
]

{ #category : #'accessing - tests' }
MiCriticBrowserModel >> ruleComponents [
"used for testing purposes, do not access outside of tests"
	^ ruleComponents
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
