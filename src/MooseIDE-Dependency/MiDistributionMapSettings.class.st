Class {
	#name : #MiDistributionMapSettings,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'childrenBlockArea',
		'dynamicTagList',
		'childrenQueryDropList'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #initialization }
MiDistributionMapSettings >> connectPresenters [

	submitButton action: [ self submit ].
	dynamicTagList addButton action: [ self owner openTagCreationForm ]
]

{ #category : #brokerage }
MiDistributionMapSettings >> consume: aQuery [

	childrenQueryDropList items: self fetchQueries.
]

{ #category : #initialization }
MiDistributionMapSettings >> fetchQueries [

	^ (self root application itemsFor: FQAbstractQuery)
		  asOrderedCollection select: [ :query | query isValid ]
]

{ #category : #initialization }
MiDistributionMapSettings >> fillModelWithCurrentSettings [

	self model childrenQuery: childrenQueryDropList selectedItem
]

{ #category : #initialization }
MiDistributionMapSettings >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (self newLabel label: 'Children query:') expand: false;
			 add: childrenQueryDropList expand: false;
			 add: 'Properties:' asPresenter expand: false;
			 add: dynamicTagList;
			 add: submitButton expand: false;
			 yourself)
]

{ #category : #initialization }
MiDistributionMapSettings >> initializePresenters [

	super initializePresenters.
	submitButton := self newButton
		                label: 'Apply';
		                yourself.
	childrenQueryDropList := self newDropList
		                         startWithoutSelection;
		                         items: self fetchQueries;
		                         yourself.
	childrenBlockArea := self newCode
		                     withoutLineNumbers;
		                     text: (self owner model childrenBlock
				                      ifNotNil: [ :block | block asText ]
				                      ifNil: [ 
					                      '[ :container | container children ]' ]);
		                     yourself.
	dynamicTagList := SpEditableListPresenter new
		                  display: [ :dt | dt name ];
		                  items: self owner model dynamicTags;
		                  displayIcon: [ :dt | 
			                  MiTagBrowserModel iconForTag: dt ];
		                  title: 'Properties';
		                  yourself.
	self initializeLayout
]

{ #category : #initialization }
MiDistributionMapSettings >> model [

	^ self owner model
]

{ #category : #refreshing }
MiDistributionMapSettings >> refreshTagList [

	dynamicTagList items: self model dynamicTags
]

{ #category : #brokerage }
MiDistributionMapSettings >> remove: aQuery [

	childrenQueryDropList items: self fetchQueries
]

{ #category : #initialization }
MiDistributionMapSettings >> submit [

	| ow |
	childrenQueryDropList selectedItem ifNil: [ ^self ].
	ow := self owner.
	self fillModelWithCurrentSettings.
	ow visualization run
]
