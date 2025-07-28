Class {
	#name : #MiNumberSettingPresenter,
	#superclass : #MiAbstractSettingPresenter,
	#instVars : [
		'inputField'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #layout }
MiNumberSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: inputField;
		  yourself
]

{ #category : #initialization }
MiNumberSettingPresenter >> initializePresenters [

	inputField := self newNumberInput
		              help: self help;
		              yourself
]

{ #category : #accessing }
MiNumberSettingPresenter >> maximum: aNumber [

	inputField maximum: aNumber
]

{ #category : #accessing }
MiNumberSettingPresenter >> minimum: aNumber [

	inputField minimum: aNumber
]

{ #category : #accessing }
MiNumberSettingPresenter >> number: aNumber [

	inputField number: aNumber
]

{ #category : #accessing }
MiNumberSettingPresenter >> placeHolder: aString [

	inputField placeHolder: aString
]

{ #category : #enumerating }
MiNumberSettingPresenter >> whenNumberChangedDo: aBlock [

	inputField whenNumberChangedDo: aBlock
]
