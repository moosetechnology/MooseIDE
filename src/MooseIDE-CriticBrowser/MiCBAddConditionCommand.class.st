Class {
	#name : 'MiCBAddConditionCommand',
	#superclass : 'MiAbstractCriticBrowserCommand',
	#category : 'MooseIDE-CriticBrowser-Commands',
	#package : 'MooseIDE-CriticBrowser',
	#tag : 'Commands'
}

{ #category : 'default' }
MiCBAddConditionCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : 'default' }
MiCBAddConditionCommand class >> defaultName [

	^ 'Add condition'
]

{ #category : 'accessing' }
MiCBAddConditionCommand class >> priority [

	^ 4
]

{ #category : 'testing' }
MiCBAddConditionCommand >> canBeExecuted [

	^ self context selectedRule
		  ifNil: [ false ]
		  ifNotNil: [ :ruleComponent | ruleComponent isCBCondition not ]
]

{ #category : 'executing' }
MiCBAddConditionCommand >> execute [

	(MiCBConditionBuilderPresenter on: self context model) openDialog
]
