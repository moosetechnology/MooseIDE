Class {
	#name : #MiSpinnerPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'textMorphPresenter',
		'spinnerPresenter'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #initialization }
MiSpinnerPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: textMorphPresenter height: 40;
			 add: spinnerPresenter;
			 yourself)
]

{ #category : #initialization }
MiSpinnerPresenter >> initializePresenters [

	self initializeTextMorphPresenter.
	spinnerPresenter := self newSpinner.
	self initializeLayout
]

{ #category : #initialization }
MiSpinnerPresenter >> initializeTextMorphPresenter [

	| font morph |
	font := LogicalFont
		        familyName: StandardFonts defaultFont familyName
		        pointSize: 12.
	morph := StringMorph
		         contents: 'Computing...'
		         font: font
		         emphasis: TextEmphasis italic.
	textMorphPresenter := SpMorphPresenter new
		                      morph: (PanelMorph new
				                       addMorphFront: morph;
				                       yourself);
		                      yourself
]

{ #category : #accessing }
MiSpinnerPresenter >> miSelectedItem [

	^ MooseGroup new
]
