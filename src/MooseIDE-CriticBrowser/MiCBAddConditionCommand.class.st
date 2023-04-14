Class {
	#name : #MiCBAddConditionCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #'accessing - defaults' }
MiCBAddConditionCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : #'accessing - defaults' }
MiCBAddConditionCommand class >> defaultName [

	^ 'Add condition'
]

{ #category : #accessing }
MiCBAddConditionCommand class >> priority [

	^ 4
]

{ #category : #testing }
MiCBAddConditionCommand >> canBeExecuted [

	^ self context rules selectedItem class ~= FamixCBCondition
]

{ #category : #execution }
MiCBAddConditionCommand >> execute [

	self context openAddConditionDialog
]
