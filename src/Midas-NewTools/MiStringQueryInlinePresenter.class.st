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

	| constraints padding |
	padding := 5.
	constraints := [ :cons | cons padding: padding ].
	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
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
				   yourself)
		  height: self toolbarHeight
]
