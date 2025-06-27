Class {
	#name : #MiContextMemento,
	#superclass : #MiRuleComponentMemento,
	#instVars : [
		'contextFilter'
	],
	#category : #'MooseIDE-CriticBrowser-Memento'
}

{ #category : #accessing }
MiContextMemento >> contextFilter [

	^ contextFilter
]

{ #category : #accessing }
MiContextMemento >> contextFilter: anObject [

	contextFilter := anObject
]

{ #category : #accessing }
MiContextMemento >> forRule: aRule [

	super forRule: aRule.
	contextFilter := aRule contextFilter
]

{ #category : #updating }
MiContextMemento >> ruleClass [

	^ FamixCBContext
]

{ #category : #updating }
MiContextMemento >> updateRule [

	super updateRule.
	rule contextFilter: contextFilter
]
