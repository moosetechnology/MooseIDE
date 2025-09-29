Class {
	#name : #MiColorSelectionPresenter,
	#superclass : #MiAbstractSettingPresenter,
	#instVars : [
		'colorButton',
		'colorPicker',
		'button'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiColorSelectionPresenter >> color: aColor [

	colorButton color: aColor
]

{ #category : #layout }
MiColorSelectionPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: colorButton;
		  yourself
]

{ #category : #initialization }
MiColorSelectionPresenter >> initializePresenters [

	colorButton := self newButton
]

{ #category : #'as yet unclassified' }
MiColorSelectionPresenter >> openNewColorPickerFrom: aButton on: aColor action: aBlock [

	| picker popover |
	picker := aButton newColorPicker.
	picker
		setColor: aColor;
		whenColorChangedDo: [ :newColor |
				aBlock value: newColor.
				aButton color: newColor.
				self update ].
	popover := picker asPopover.
	popover whenOpenedDo: [ "Not nice to have to get to the widget, but no other way worked."
			popover withAdapterDo: [ :a |
				a widgetDo: [ :w | w extent: 350 @ 500 ] ] ].
	popover popup
]

{ #category : #enumerating }
MiColorSelectionPresenter >> whenColorChangedDo: aBlock [

	colorButton whenActivatedDo: [
			self
				openNewColorPickerFrom: colorButton
				on: configuration startColor
				action: aBlock ]
]
