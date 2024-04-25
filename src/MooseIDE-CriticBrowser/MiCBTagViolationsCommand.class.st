Class {
	#name : #MiCBTagViolationsCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBTagViolationsCommand class >> defaultIconName [

	^ #famixTagLabel
]

{ #category : #default }
MiCBTagViolationsCommand class >> defaultName [

	^ 'Tag violations'
]

{ #category : #accessing }
MiCBTagViolationsCommand class >> priority [

	^ 6
]

{ #category : #testing }
MiCBTagViolationsCommand >> canBeExecuted [

	^ self context rules selectedItem class = FamixCBCondition
]

{ #category : #executing }
MiCBTagViolationsCommand >> execute [

	self context tagCurrentViolations.
	MiTagBrowser open
]
