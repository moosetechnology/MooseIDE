"
I am a subclass of `MiBooleanQueryPresenter`. My only purpose is to re-implement the layout. Because I will be used in the new queries browser and this new browser has a different kind of format fot the ui. It is an inline presentation format.
"
Class {
	#name : #MiBooleanInlineQueryPresenter,
	#superclass : #MiBooleanQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #specs }
MiBooleanInlineQueryPresenter class >> layout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: #propertyDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: #comparatorDropList
		  expand: false
		  fill: false
		  padding: padding;
		  yourself
]
