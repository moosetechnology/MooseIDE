Class {
	#name : #MiCBRunConditionCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBRunConditionCommand class >> defaultIconName [

	^ #glamorousPlay
]

{ #category : #default }
MiCBRunConditionCommand class >> defaultName [

	^ 'Run condition'
]

{ #category : #accessing }
MiCBRunConditionCommand class >> priority [

	^ 5
]

{ #category : #testing }
MiCBRunConditionCommand >> canBeExecuted [

	^ self context rules selectedItem class = FamixCBCondition
]

{ #category : #executing }
MiCBRunConditionCommand >> execute [

	self context runSelectedCondition
]
