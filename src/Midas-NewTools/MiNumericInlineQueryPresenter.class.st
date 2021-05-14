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
		  add: #propertyDropList withConstraints: [ :cons | 
			  cons
				  expand: true;
				  padding: padding ];
		  add: #comparatorDropList withConstraints: [ :cons | 
		  cons
			  width: 70;
			  padding: padding ];
		  add: #valueInputField withConstraints: [ :cons | 
		  cons
			  width: 150;
			  padding: padding ];
		  yourself
]
