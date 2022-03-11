Class {
	#name : #MiColorCodePresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'rCodeInput',
		'gCodeInput',
		'bCodeInput',
		'hexaCode',
		'colorBox'
	],
	#category : #'MooseIDE-Tagging-ColorPicker'
}

{ #category : #specs }
MiColorCodePresenter class >> defaultLayout [

	^ SpBoxLayout new
]

{ #category : #initialization }
MiColorCodePresenter >> connectPresenters [

	"rCodeInput whenTextChangedDo: [  self updateColorCode ] "
]

{ #category : #initialization }
MiColorCodePresenter >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: (SpBoxLayout newTopToBottom
					  spacing: 1;
					  add: (SpBoxLayout newLeftToRight
							   add: rCodeInput;
							   add: gCodeInput;
							   add: bCodeInput;
							   spacing: 1;
							   yourself)
					  expand: false;
					  add: (SpBoxLayout newLeftToRight
							   add: hexaCode;
							   yourself)
					  expand: false;
					  yourself);
			 add: colorBox;
			 spacing: 1;
			 yourself)
]

{ #category : #initialization }
MiColorCodePresenter >> initializePresenters [

	rCodeInput := self newTextInput.
	gCodeInput := self newTextInput.
	bCodeInput := self newTextInput.
	hexaCode := self newTextInput.
	colorBox := self instantiate: SpRoassalPresenter.
	self initializeLayout
]

{ #category : #initialization }
MiColorCodePresenter >> setColor: aColor [

	hexaCode placeholder: aColor asHexString.
	bCodeInput placeholder: (aColor blue * 255) asInteger asString.
	gCodeInput placeholder: (aColor green * 255) asInteger asString.
	rCodeInput placeholder: (aColor red * 255) asInteger asString.
	colorBox canvas
		color: aColor;
		signalUpdate
]

{ #category : #initialization }
MiColorCodePresenter >> updateColorCode [

	| r g b range |
	range := 255.
	r := rCodeInput text asInteger.
	g := gCodeInput text asInteger.
	b := bCodeInput text asInteger.
	(r isNil or: [ g isNil or: [ b isNil ]]) ifTrue: [ ^self ].
	((r between: 0 and: range) and: [ 
		 (g between: 0 and: range) and: [ b between: 0 and: range ] ]) 
		ifTrue: [ 
			self owner updatedColorCode: (Color
					 r: r
					 g: g
					 b: b
					 range: range) ]
]
