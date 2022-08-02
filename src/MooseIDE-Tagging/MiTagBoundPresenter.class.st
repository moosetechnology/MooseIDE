Class {
	#name : #MiTagBoundPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'comparatorDroplist',
		'boundInput'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #layout }
MiTagBoundPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: comparatorDroplist;
		  add: boundInput;
		  yourself
]

{ #category : #'as yet unclassified' }
MiTagBoundPresenter >> initializePresenters [

	comparatorDroplist := self newDropList items: { #=. #~=. #<. #<=. #>. #>= }.
	boundInput := self newTextInput.
	
	
]

{ #category : #initialization }
MiTagBoundPresenter >> setBound: anInteger [

	boundInput text: anInteger asString
]

{ #category : #initialization }
MiTagBoundPresenter >> setComparator: aSymbol [

	(comparatorDroplist items includes: aSymbol) ifTrue: [ 
		comparatorDroplist selectItem: aSymbol ]
]

{ #category : #accessing }
MiTagBoundPresenter >> submitValues [

	^ Dictionary newFrom: { 'comparator' -> comparatorDroplist selectedItem. 'bound' -> boundInput text asInteger }
]
