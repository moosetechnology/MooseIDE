Class {
	#name : 'MiCBRunConditionCommand',
	#superclass : 'MiAbstractCriticBrowserCommand',
	#category : 'MooseIDE-CriticBrowser-Commands',
	#package : 'MooseIDE-CriticBrowser',
	#tag : 'Commands'
}

{ #category : 'default' }
MiCBRunConditionCommand class >> defaultIconName [

	^ #glamorousPlay
]

{ #category : 'default' }
MiCBRunConditionCommand class >> defaultName [

	^ 'Run condition'
]

{ #category : 'accessing' }
MiCBRunConditionCommand class >> priority [

	^ 5
]

{ #category : 'testing' }
MiCBRunConditionCommand >> canBeExecuted [

	^ self context selectedRule
		  ifNil: [ false ]
		  ifNotNil: [ :ruleComponent | ruleComponent isCBCondition ]
]

{ #category : 'executing' }
MiCBRunConditionCommand >> execute [

	self context runSelectedCondition
]
