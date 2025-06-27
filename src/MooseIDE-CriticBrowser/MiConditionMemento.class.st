Class {
	#name : #MiConditionMemento,
	#superclass : #MiRuleComponentMemento,
	#instVars : [
		'query',
		'severity'
	],
	#category : #'MooseIDE-CriticBrowser-Memento'
}

{ #category : #accessing }
MiConditionMemento >> forRule: aRule [

	super forRule: aRule.
	query := aRule query.
	severity := aRule severity
]

{ #category : #accessing }
MiConditionMemento >> query [

	^ query
]

{ #category : #accessing }
MiConditionMemento >> query: anObject [

	query := anObject
]

{ #category : #updating }
MiConditionMemento >> ruleClass [

	^ FamixCBCondition
]

{ #category : #accessing }
MiConditionMemento >> severity [

	^ severity
]

{ #category : #accessing }
MiConditionMemento >> severity: anObject [

	severity := anObject
]

{ #category : #updating }
MiConditionMemento >> updateRule [

	super updateRule.
	rule query: query.
	rule severity: severity
]
