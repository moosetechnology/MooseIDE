Class {
	#name : #MiCBTagRuleResultCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBTagRuleResultCommand class >> defaultName [

	^ 'Tag rule results'
]

{ #category : #accessing }
MiCBTagRuleResultCommand class >> priority [

	^ 6
]

{ #category : #executing }
MiCBTagRuleResultCommand >> execute [
	self context tagRuleResult
]
