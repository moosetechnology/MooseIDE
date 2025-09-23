Class {
	#name : 'MiBooleanSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'checkbox'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'layout' }
MiBooleanSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: checkbox;
		  yourself
]

{ #category : 'accessing' }
MiBooleanSettingPresenter >> help: aString [

	super help: aString.
	checkbox help: aString
]

{ #category : 'initialization' }
MiBooleanSettingPresenter >> initializePresenters [

	checkbox := self newCheckBox
		            label: self label;
		            help: self help;
		            yourself
]

{ #category : 'initialization' }
MiBooleanSettingPresenter >> state: aBoolean [

	checkbox state: aBoolean
]

{ #category : 'enumerating' }
MiBooleanSettingPresenter >> whenStateChangedDo: aValuable [

	checkbox whenChangedDo: [ :boolean | aValuable value: boolean ]
]
