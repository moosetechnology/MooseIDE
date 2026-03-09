Class {
	#name : 'MiColorSelectionPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'colorButton',
		'colorPicker',
		'button'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'layout' }
MiColorSelectionPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: colorButton;
		  yourself
]

{ #category : 'initialization' }
MiColorSelectionPresenter >> initializePresenters [

	colorButton := self newButton
		               color: configuration baseColor;
		               whenActivatedDo: [
			               self
				               openNewColorPickerFrom: colorButton
				               on: colorButton color ];
		               yourself
]

{ #category : 'as yet unclassified' }
MiColorSelectionPresenter >> openNewColorPickerFrom: aButton on: aColor [

	| picker popover |
	picker := aButton newColorPicker.
	picker
		setColor: aColor;
		whenColorChangedDo: [ :newColor |
				configuration baseColor: newColor.
				aButton color: newColor.
				self update ].

	popover := picker asPopover.
	popover whenOpenedDo: [ "Not nice to have to get to the widget, but no other way worked."
			popover withAdapterDo: [ :a |
				a widgetDo: [ :w | w extent: 350 @ 500 ] ] ].

	popover popup
]
