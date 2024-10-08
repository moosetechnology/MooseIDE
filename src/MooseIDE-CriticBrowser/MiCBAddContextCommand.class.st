Class {
	#name : #MiCBAddContextCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBAddContextCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : #default }
MiCBAddContextCommand class >> defaultName [

	^ 'Add context'
]

{ #category : #accessing }
MiCBAddContextCommand class >> priority [

	^ 3
]

{ #category : #testing }
MiCBAddContextCommand >> canBeExecuted [

	^ self context selectedRule
		  ifNil: [ false ]
		  ifNotNil: [ :ruleComponent | ruleComponent isCBCondition not ]
]

{ #category : #executing }
MiCBAddContextCommand >> execute [

	(MiCBContextBuilderPresenter on: self context model) openDialog
]
