"
Model used by the MooseIDE Critic Browser.
"
Class {
	#name : 'MiCriticModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'rootContext',
		'ruleComponents',
		'violations',
		'selectedRule'
	],
	#category : 'MooseIDE-CriticBrowser-Model',
	#package : 'MooseIDE-CriticBrowser',
	#tag : 'Model'
}

{ #category : 'adding' }
MiCriticModel >> addChild: aRuleComponent [

	selectedRule isCBCondition ifTrue: [ ^ self ].

	selectedRule addChild: aRuleComponent.
	ruleComponents add: aRuleComponent.
	browser updateRulesList
]

{ #category : 'adding' }
MiCriticModel >> addChild: aRuleComponent toContext: aContext [

	(aContext = rootContext or: [ ruleComponents includes: aContext ]) 
		ifFalse: [ ^ self ].
	aContext addChild: aRuleComponent.
	ruleComponents add: aRuleComponent.
	browser updateRulesList
]

{ #category : 'adding' }
MiCriticModel >> addChildToRootContext: aRuleComponent [
	rootContext addChild: aRuleComponent.
	ruleComponents add: aRuleComponent
	
]

{ #category : 'adding' }
MiCriticModel >> addViolationsFor: aCondition [

	violations
		at: aCondition
		put: aCondition violations asMooseSpecializedGroup
]

{ #category : 'accessing' }
MiCriticModel >> contextOf: aRuleComponent [

	^ (aRuleComponent class inheritsFromOrEqualTo: FamixCBContext)
		  ifTrue: [ aRuleComponent entities ifNil: [ entities ] ]
		  ifFalse: [ self contextOf: aRuleComponent parent ]
]

{ #category : 'running' }
MiCriticModel >> createHierarchyTree [
"creates a list with the index of the parent of each rule component in the ruleComponents
 used to export the rules (and represents the hierarchy)"
	^ ruleComponents collect: [ :el | ruleComponents indexOf: el parent ]
]

{ #category : 'removing' }
MiCriticModel >> deleteRuleComponent: aRuleComponent [

	self removeChild: aRuleComponent fromContext: aRuleComponent parent
]

{ #category : 'accessing' }
MiCriticModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiCriticModel >> getAllViolations [
"returns violations of every rule"
	| result |
	result := FamixCBViolationGroup new.
	violations do: [ :each | result addAll: each ].
	^ result
]

{ #category : 'testing' }
MiCriticModel >> hasBeenEdited: aRuleComponent [
	self removeRuleViolations: aRuleComponent.
	aRuleComponent resetExecutionOfTree.
	browser updateRulesList.
	browser updateResultList: self getAllViolations
]

{ #category : 'initialization' }
MiCriticModel >> initialize [ 

	super initialize.
	entities := MooseGroup new.
	rootContext := (FamixCBRootContext named: 'Root context (all entities)' on: '[ :col | col ]').
	ruleComponents := OrderedCollection new.
	violations := Dictionary new
]

{ #category : 'accessing' }
MiCriticModel >> miSelectedItem [

	^ (selectedRule
		   ifNil: [ self getAllViolations ]
		   ifNotNil: [ :ruleComponent | self violationsOf: ruleComponent ])
		  collect: #violatingEntity
]

{ #category : 'removing' }
MiCriticModel >> removeBranchFromRuleComponents: aRuleComponent [

	ruleComponents remove: aRuleComponent ifAbsent: [  ].
	aRuleComponent class = FamixCBContext ifTrue: [
		aRuleComponent children do: [ :child |
			self removeBranchFromRuleComponents: child ] ]
]

{ #category : 'adding' }
MiCriticModel >> removeChild: aRuleComponent fromContext: aContext [

	(aContext = rootContext or: [ ruleComponents includes: aContext ])
		ifFalse: [ ^ self ].
	aRuleComponent removeSelfFromTree.
	self removeBranchFromRuleComponents: aRuleComponent.
	self removeRuleViolations: aRuleComponent
]

{ #category : 'removing' }
MiCriticModel >> removeRuleViolations: aRuleComponent [

	aRuleComponent class = FamixCBContext
		ifTrue: [ aRuleComponent children do: [ :child | self removeRuleViolations: child ] ]
		ifFalse: [ violations removeKey: aRuleComponent ifAbsent: [  ] ] 
]

{ #category : 'removing' }
MiCriticModel >> resetResults [
	rootContext resetExecutionOfTree.
	violations := Dictionary new
]

{ #category : 'accessing' }
MiCriticModel >> rootContext [
	^ rootContext
]

{ #category : 'accessing - tests' }
MiCriticModel >> ruleComponents [
"used for testing purposes, do not access outside of tests"
	^ ruleComponents
]

{ #category : 'running' }
MiCriticModel >> run [

	rootContext runDownTree: entities withCallback: [ :aName |
		self browser updateStatusLabel: 'Running critic ' , aName , '.' ].
	violations := rootContext getAllViolations
]

{ #category : 'running' }
MiCriticModel >> runCondition: aCondition [
	aCondition runUpTree: entities.
	self addViolationsFor: aCondition
	
	
]

{ #category : 'accessing' }
MiCriticModel >> selectedRule [

	^ selectedRule
]

{ #category : 'accessing' }
MiCriticModel >> selectedRule: anObject [

	selectedRule := anObject
]

{ #category : 'accessing' }
MiCriticModel >> setEntities: aMooseObject [

	entities := aMooseObject isCollection
		            ifTrue: [ aMooseObject ]
		            ifFalse: [ { aMooseObject } asMooseGroup ].
	self resetResults
]

{ #category : 'accessing' }
MiCriticModel >> violations [

	^ violations
]

{ #category : 'accessing' }
MiCriticModel >> violationsOf: aRuleComponent [
	"Returns violations for a given condition or childs of the selected context"

	^ (self violationsOf: aRuleComponent in: MooseGroup new) specialize
]

{ #category : 'accessing' }
MiCriticModel >> violationsOf: aRuleComponent in: aMooseGroup [
	"returns violations for a given condition or childs of the selected context"

	aRuleComponent isCBContext
		ifTrue: [
			aRuleComponent children do: [ :child |
				self violationsOf: child in: aMooseGroup ] ]
		ifFalse: [
			aMooseGroup addAll:
				(self violations at: aRuleComponent ifAbsent: [ MooseGroup new ]) ].
	^ aMooseGroup
]
