Class {
	#name : #MiCBAddConditionCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBAddConditionCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : #default }
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

{ #category : #executing }
MiCBAddConditionCommand >> execute [

	self context openAddConditionDialog
]
