"
I am a subclass of `MiNumericQueryPresenter`. My only purpose is to re-implement the layout. Because I will be used in the new queries browser and this new browser has a different kind of format fot the ui. It is an inline presentation format.
"
Class {
	#name : #MiNumericInlineQueryPresenter,
	#superclass : #MiNumericQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #specs }
MiNumericInlineQueryPresenter class >> layout [

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
		  expand: false
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #initialization }
MiNumericInlineQueryPresenter >> newValueInputField [

	"The only thing that is changed here is the placeholder."

	^ super newValueInputField
		  placeholder: 'Numeric value';
		  yourself
]
