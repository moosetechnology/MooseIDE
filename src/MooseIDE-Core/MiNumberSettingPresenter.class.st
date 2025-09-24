Class {
	#name : 'MiNumberSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'inputField',
		'unitLabel'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'layout' }
MiNumberSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: inputField width: 75;
		  add: unitLabel
		  expand: true
		  fill: true
		  padding: 5;
		  yourself
]

{ #category : 'initialization' }
MiNumberSettingPresenter >> initializePresenters [

	inputField := self newNumberInput
		              help: self help;
		              yourself.
	unitLabel := self newLabel
]

{ #category : 'accessing' }
MiNumberSettingPresenter >> maximum: aNumber [

	inputField maximum: aNumber
]

{ #category : 'accessing' }
MiNumberSettingPresenter >> minimum: aNumber [

	inputField minimum: aNumber
]

{ #category : 'accessing' }
MiNumberSettingPresenter >> number: aNumber [

	inputField number: aNumber
]

{ #category : 'as yet unclassified' }
MiNumberSettingPresenter >> unit: aString [

	unitLabel label: aString
]

{ #category : 'enumerating' }
MiNumberSettingPresenter >> whenNumberChangedDo: aBlock [

	inputField whenNumberChangedDo: aBlock
]
