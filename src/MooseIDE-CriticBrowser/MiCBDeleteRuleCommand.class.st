Class {
	#name : 'MiCBDeleteRuleCommand',
	#superclass : 'MiAbstractCriticBrowserCommand',
	#category : 'MooseIDE-CriticBrowser-Commands',
	#package : 'MooseIDE-CriticBrowser',
	#tag : 'Commands'
}

{ #category : 'default' }
MiCBDeleteRuleCommand class >> defaultIconName [

	^ #smallDelete
]

{ #category : 'default' }
MiCBDeleteRuleCommand class >> defaultName [

	^ 'Delete rule'
]

{ #category : 'accessing' }
MiCBDeleteRuleCommand class >> priority [

	^ 2
]

{ #category : 'testing' }
MiCBDeleteRuleCommand >> canBeExecuted [

	^ self context selectedRule class ~= FamixCBRootContext
]

{ #category : 'executing' }
MiCBDeleteRuleCommand >> execute [

	self context deleteSelectedRule
]
