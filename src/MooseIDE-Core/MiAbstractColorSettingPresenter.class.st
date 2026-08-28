Class {
	#name : 'MiAbstractColorSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'parentButton',
		'actionBlock'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'actions' }
MiAbstractColorSettingPresenter >> openColorPickerFrom: aButton on: aColor action: aBlock [
	"Open a color-picker dialog anchored to aButton, initialized to aColor.
	 aBlock is evaluated with the picked color as the user changes it (live preview),
	 and again with the original color if the dialog is cancelled (reverting the preview)."

	| picker dialog originalColor |
	originalColor := aColor.
	parentButton := aButton.
	actionBlock := aBlock.

	picker := aButton newColorPicker.
	picker
		setColor: aColor;
		whenColorChangedDo: [ :newColor | self updateTo:newColor ].

	dialog := picker asDialogWindow.
	dialog
		title: 'Choose a color';
		initialExtent: 350 @ 500;
		okAction: [
				dialog beOk.
				dialog close ];
		cancelAction: [
				self updateTo: originalColor.
				dialog beCancel.
				dialog close ].

	dialog open
]

{ #category : 'actions' }
MiAbstractColorSettingPresenter >> updateTo: aColor [

	parentButton color: aColor.
	actionBlock value: aColor.
	self update
]
