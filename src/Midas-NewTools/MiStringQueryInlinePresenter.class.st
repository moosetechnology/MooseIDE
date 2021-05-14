"
I am a subclass of `MiStringQueryPresenter`. My only purpose is to re-implement the layout. Because I will be used in the new queries browser and this new browser has a different kind of format fot the ui.
"
Class {
	#name : #MiStringQueryInlinePresenter,
	#superclass : #MiStringQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #specs }
MiStringQueryInlinePresenter class >> layout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: #propertyDropList
		  expand: false
		  fill: false
		  padding: padding;
		  add: #comparatorDropList
		  expand: false
		  fill: false
		  padding: padding;
		  add: #valueInputField
		  expand: true
		  fill: true
		  padding: padding;
		  yourself
]
