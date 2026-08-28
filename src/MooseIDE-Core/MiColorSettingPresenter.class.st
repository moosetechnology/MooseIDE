Class {
	#name : 'MiColorSettingPresenter',
	#superclass : 'MiAbstractColorSettingPresenter',
	#instVars : [
		'colorButton'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'layout' }
MiColorSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: colorButton;
		  yourself
]

{ #category : 'initialization' }
MiColorSettingPresenter >> initializePresenters [

	colorButton := self newButton
		               color: configuration baseColor;
		               whenActivatedDo: [
				               self
					               openColorPickerFrom: colorButton
					               on: colorButton color
					               action: [ :newColor |
						               configuration baseColor: newColor ] ];
		               yourself
]
