Class {
	#name : #MiCBAddContextCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #initialization }
MiCBAddContextCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : #'accessing - defaults' }
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

{ #category : #execution }
MiCBAddContextCommand >> execute [

	self context openAddContextDialog
]
