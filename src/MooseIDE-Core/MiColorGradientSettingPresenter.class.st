Class {
	#name : 'MiColorGradientSettingPresenter',
	#superclass : 'MiAbstractColorSettingPresenter',
	#instVars : [
		'originButton',
		'gradient',
		'endButton'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiColorGradientSettingPresenter class >> help [

	^ 'Choose start color for the minimal value and end color for the higher value'
]

{ #category : 'accessing' }
MiColorGradientSettingPresenter class >> label [

	^ 'Color range:'
]

{ #category : 'initialization' }
MiColorGradientSettingPresenter >> buildGradientOn: aCanvas [

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

{ #category : 'layout' }
MiColorGradientSettingPresenter >> defaultLayout [

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

{ #category : 'initialization' }
MiColorGradientSettingPresenter >> initializePresenters [

	originButton := self newButton
		                color: configuration startColor;
		                whenActivatedDo: [
				                self
					                openColorPickerFrom: originButton
					                on: configuration startColor
					                action: [ :newColor |
							                configuration startColor: newColor.
							                gradient refresh ] ].

	gradient := self newRoassal script: [ :canvas |
		            self buildGradientOn: canvas ].

	endButton := self newButton
		             color: configuration endColor;
		             whenActivatedDo: [
				             self
					             openColorPickerFrom: endButton
					             on: configuration endColor
					             action: [ :newColor |
							             configuration endColor: newColor.
							             gradient refresh ] ]
]
