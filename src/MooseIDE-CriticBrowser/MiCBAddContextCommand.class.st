Class {
	#name : #MiCBAddContextCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBAddContextCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : #default }
MiCBAddContextCommand class >> defaultName [

	^ 'Add context'
]

{ #category : #accessing }
MiCBAddContextCommand class >> priority [

	^ 3
]

{ #category : #testing }
MiCBAddContextCommand >> canBeExecuted [

	^ self context rules selectedItem class ~= FamixCBCondition
]

{ #category : #executing }
MiCBAddContextCommand >> execute [

	self context openAddContextDialog
]
