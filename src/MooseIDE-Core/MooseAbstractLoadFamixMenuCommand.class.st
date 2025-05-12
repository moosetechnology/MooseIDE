Class {
	#name : #MooseAbstractLoadFamixMenuCommand,
	#superclass : #MooseAbstractLoadModuleMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #testing }
MooseAbstractLoadFamixMenuCommand class >> isAbstract [
	^ self = MooseAbstractLoadFamixMenuCommand
]

{ #category : #accessing }
MooseAbstractLoadFamixMenuCommand class >> menuPriority [

	^ 10
]
