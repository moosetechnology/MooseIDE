Class {
	#name : 'MiTextFieldSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'inputField'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'layout' }
MiTextFieldSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		add: inputField width: 200 ;
		yourself
]

{ #category : 'initialization' }
MiTextFieldSettingPresenter >> initializePresenters [

	inputField := self newTextInput
		help: self help;
		yourself.
]

{ #category : 'accessing' }
MiTextFieldSettingPresenter >> text: aString [

	inputField text: aString 
]

{ #category : 'enumerating' }
MiTextFieldSettingPresenter >> whenTextChangedDo: aBlock [

	inputField whenTextChangedDo: aBlock
]
