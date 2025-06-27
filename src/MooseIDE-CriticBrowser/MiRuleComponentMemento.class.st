Class {
	#name : #MiRuleComponentMemento,
	#superclass : #Object,
	#instVars : [
		'parent',
		'summary',
		'rule'
	],
	#category : #'MooseIDE-CriticBrowser-Memento'
}

{ #category : #'instance creation' }
MiRuleComponentMemento class >> on: aRule [

	^ self new
		  forRule: aRule;
		  yourself
]

{ #category : #updating }
MiRuleComponentMemento >> createRule [

	rule := self ruleClass new parent: parent.
	self updateRule
]

{ #category : #accessing }
MiRuleComponentMemento >> forRule: aRule [

	rule := aRule.
	parent := aRule parent.
	summary := aRule summary
]

{ #category : #accessing }
MiRuleComponentMemento >> parent [

	^ parent
]

{ #category : #accessing }
MiRuleComponentMemento >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
MiRuleComponentMemento >> rule: aRule [

	rule := aRule 
]

{ #category : #updating }
MiRuleComponentMemento >> ruleClass [

	self subclassResponsibility
]

{ #category : #accessing }
MiRuleComponentMemento >> summary [

	^ summary
]

{ #category : #accessing }
MiRuleComponentMemento >> summary: anObject [

	summary := anObject
]

{ #category : #updating }
MiRuleComponentMemento >> updateRule [

	rule summary: summary
]
