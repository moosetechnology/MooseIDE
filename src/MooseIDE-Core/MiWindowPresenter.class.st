Class {
	#name : #MiWindowPresenter,
	#superclass : #SpWindowPresenter,
	#instVars : [
		'menuButton',
		'toolbarCommands'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #private }
MiWindowPresenter >> defaultInitialExtent [

	^ 500 @ 400
]
