"
I am a subclass of `MiStringQueryPresenter`. My only purpose is to re-implement the layout. Because I will be used in the new queries browser and this new browser has a different kind of format fot the ui.
"
Class {
	#name : #MiStringInlineQueryPresenter,
	#superclass : #MiStringQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #specs }
MiStringInlineQueryPresenter class >> layout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: #propertyDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: #comparatorDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: #valueInputField
		  expand: true
		  fill: true
		  padding: padding;
		  yourself
]
