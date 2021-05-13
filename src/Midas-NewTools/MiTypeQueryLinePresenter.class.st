"
I am an extension of `MiTypeQueryPresenter`. I only change the layout for adapting to the format of the new queries browser.
"
Class {
	#name : #MiTypeQueryLinePresenter,
	#superclass : #MiTypeQueryPresenter,
	#category : #'Midas-NewTools-Queries Configuration'
}

{ #category : #layout }
MiTypeQueryLinePresenter >> buildLayout [

	self layout:
		(SpBoxLayout newHorizontal add: self typeCheckBoxesLayout)
]

{ #category : #layout }
MiTypeQueryLinePresenter >> typeCheckBoxesLayout [

	| checkBoxesLayout |
	typeCheckBoxes isCollection ifFalse: [ ^ typeCheckBoxes ].

	checkBoxesLayout := SpBoxLayout newHorizontal.

	(typeCheckBoxes groupsOf: (typeCheckBoxes size // 3 max: 1)) do: [ 
		:group | 
		| subLayout |
		subLayout := SpBoxLayout newVertical.
		group do: [ :checkBox | subLayout add: checkBox ].
		checkBoxesLayout add: subLayout ].

	^ checkBoxesLayout
]
