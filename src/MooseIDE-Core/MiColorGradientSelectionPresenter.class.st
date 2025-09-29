Class {
	#name : #MiColorGradientSelectionPresenter,
	#superclass : #MiAbstractSettingPresenter,
	#instVars : [
		'originButton',
		'gradient',
		'endButton',
		'colorPicker'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiColorGradientSelectionPresenter class >> help [

	^ 'Choose start color for the minimal value and end color for the higher value'
]

{ #category : #accessing }
MiColorGradientSelectionPresenter class >> label [

	^ 'Color range:'
]

{ #category : #initialization }
MiColorGradientSelectionPresenter >> buildGradientOn: aCanvas [

	| paint |
	aCanvas
		clear;
		color: Color transparent.

	paint := LinearGradientPaint fromArray: {
			         (0 -> configuration startColor).
			         (1 -> configuration endColor) }.
	paint
		start: -50 @ 0;
		stop: 50 @ 0.

	aCanvas newBox
		height: 23; "23 is (25 - 2) to align with buttons"
		width: 150;
		paint: paint
]

{ #category : #layout }
MiColorGradientSelectionPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom
		  add: (self newBoxLayoutLeftToRight
				   add: originButton width: 25;
				   add: gradient;
				   add: endButton width: 25;
				   spacing: 5;
				   yourself)
		  height: 25;
		  yourself
]

{ #category : #initialization }
MiColorGradientSelectionPresenter >> initializePresenters [

	originButton := self newButton
		                color: configuration startColor;
		                whenActivatedDo: [
				                self
					                openNewColorPickerFrom: originButton
					                on: configuration startColor
					                action: [ :newColor |
						                configuration startColor: newColor ] ].

	gradient := self newRoassal script: [ :canvas |
		            self buildGradientOn: canvas ].

	endButton := self newButton
		             color: configuration endColor;
		             whenActivatedDo: [
				             self
					             openNewColorPickerFrom: endButton
					             on: configuration endColor
					             action: [ :newColor | configuration endColor: newColor ] ]
]

{ #category : #'as yet unclassified' }
MiColorGradientSelectionPresenter >> openNewColorPickerFrom: aButton on: aColor action: aBlock [

	| picker popover |
	picker := aButton newColorPicker.
	picker
		setColor: aColor;
		whenColorChangedDo: [ :newColor |
				aBlock value: newColor.
				aButton color: newColor.
				gradient refresh.
				self update ].
	popover := picker asPopover.
	popover whenOpenedDo: [ "Not nice to have to get to the widget, but no other way worked."
			popover withAdapterDo: [ :a |
				a widgetDo: [ :w | w extent: 350 @ 500 ] ] ].
	popover popup
]
