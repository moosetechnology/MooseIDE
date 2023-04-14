Class {
	#name : #MiCBEditRuleCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #'accessing - defaults' }
MiCBEditRuleCommand class >> defaultIconName [

	^ #glamorousEdit
]

{ #category : #'accessing - defaults' }
MiCBEditRuleCommand class >> defaultName [

	^ 'Edit rule'
]

{ #category : #accessing }
MiCBEditRuleCommand class >> priority [

	^ 1
]

{ #category : #testing }
MiCBEditRuleCommand >> canBeExecuted [

	^ self context rules selectedItem class ~= FamixCBRootContext
]

{ #category : #executing }
MiCBEditRuleCommand >> execute [

	self context openEditRuleDialog
]
