Class {
	#name : #MiCBEditRuleCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBEditRuleCommand class >> defaultIconName [

	^ #glamorousEdit
]

{ #category : #default }
MiCBEditRuleCommand class >> defaultName [

	^ 'Edit rule'
]

{ #category : #accessing }
MiCBEditRuleCommand class >> priority [

	^ 1
]

{ #category : #testing }
MiCBEditRuleCommand >> canBeExecuted [

	^ self context selectedRule class ~= FamixCBRootContext
]

{ #category : #executing }
MiCBEditRuleCommand >> execute [

	self context openEditRuleComponentDialog
]
