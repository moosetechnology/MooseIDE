Class {
	#name : 'MiTextAreaSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'inputField',
		'inputFieldWidth',
		'inputFieldHeight'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> defaultInputFieldHeight [
	"about 3 lines"

	^60
]

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> defaultInputFieldWidth [

	^200
]

{ #category : 'layout' }
MiTextAreaSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		add: inputField withConstraints: [ :constraints |
			constraints
				expand: true ;
				fill: true ;
				width: self inputFieldWidth ;
				height: self inputFieldHeight
		] ;
		yourself
]

{ #category : 'initialization' }
MiTextAreaSettingPresenter >> initializePresenters [

	inputField := self newText
		help: self help;
		yourself.
]

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> inputFieldHeight [

	^inputFieldHeight ifNil: [ self defaultInputFieldHeight ]
]

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> inputFieldHeight: aNumber [

	inputFieldHeight := aNumber
]

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> inputFieldWidth [

	^inputFieldWidth ifNil: [ self defaultInputFieldWidth ]
]

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> inputFieldWidth: aNumber [

	inputFieldWidth := aNumber
]

{ #category : 'accessing' }
MiTextAreaSettingPresenter >> text: aString [

	inputField text: aString 
]

{ #category : 'enumerating' }
MiTextAreaSettingPresenter >> whenTextChangedDo: aBlock [

	inputField whenTextChangedDo: aBlock
]
