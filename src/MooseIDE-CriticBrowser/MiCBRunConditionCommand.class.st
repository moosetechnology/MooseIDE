Class {
	#name : #MiCBRunConditionCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #'accessing - defaults' }
MiCBRunConditionCommand class >> defaultIconName [

	^ #glamorousPlay
]

{ #category : #'accessing - defaults' }
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

{ #category : #execution }
MiCBRunConditionCommand >> execute [

	self context runSelectedCondition
]
