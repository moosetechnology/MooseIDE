"
Settings to build the hierarchical map

Settings are :
	- children block
	- dynamic tags
"
Class {
	#name : #MiHierarchicalMapSettings,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'childrenBlockArea',
		'dynamicTagList',
		'childrenQueryDropList',
		'closeButton',
		'linksCheckbox',
		'associationList',
		'tagList'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #initialization }
MiHierarchicalMapSettings >> connectPresenters [

	submitButton action: [ self submit ].
	closeButton action: [ self owner hideMenu ]
]

{ #category : #brokerage }
MiHierarchicalMapSettings >> consume: aQuery [

	childrenQueryDropList items: self fetchQueries.
]

{ #category : #initialization }
MiHierarchicalMapSettings >> fetchQueries [

	^ (self root application itemsFor: FQAbstractQuery)
		  asOrderedCollection select: [ :query | query isValid ]
]

{ #category : #initialization }
MiHierarchicalMapSettings >> fillModelWithCurrentSettings [

	self model childrenQuery: childrenQueryDropList selectedItem.
	self model showAllLinks: linksCheckbox state.
	self model associationTypes:
		associationList selectedItems asOrderedCollection.
	self model tags: tagList selectedItems asOrderedCollection
]

{ #category : #initialization }
MiHierarchicalMapSettings >> initializeLayout [

	| mainLayout leftLayout rightLayout |
	(leftLayout := SpBoxLayout newTopToBottom)
		add: (self newLabel label: 'Children query:') expand: false;
		add: childrenQueryDropList expand: false;
		add: linksCheckbox expand: false;
		add: 'Chose tags to add:' asPresenter expand: false;
		add: tagList.
	(rightLayout := SpBoxLayout newTopToBottom) add: associationList.
	(mainLayout := SpBoxLayout newLeftToRight)
		spacing: 4;
		add: leftLayout;
		add: rightLayout.
	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  hAlignCenter;
					  add: 'Settings' asPresenter;
					  yourself)
			 expand: false;
			 add: (SpBoxLayout newLeftToRight
					  hAlignCenter;
					  add: mainLayout width: 700;
					  yourself);
			 add: (SpBoxLayout newLeftToRight
					  add: closeButton;
					  add: submitButton;
					  yourself)
			 expand: false;
			 yourself)
]

{ #category : #initialization }
MiHierarchicalMapSettings >> initializePresenters [

	super initializePresenters.
	associationList := self instantiate:
		                   SpFilteringSelectableListPresenter.
	(tagList := self instantiate: SpFilteringSelectableListPresenter) 
		display: [ :item | item name ].
	linksCheckbox := self newCheckBox
		                 label: 'Show all links';
		                 yourself.
	submitButton := self newButton
		                label: 'Apply';
		                yourself.
	closeButton := self newButton
		               label: 'Close';
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
	self initializeLayout
]

{ #category : #initialization }
MiHierarchicalMapSettings >> model [

	^ self owner model
]

{ #category : #brokerage }
MiHierarchicalMapSettings >> remove: aQuery [

	childrenQueryDropList items: self fetchQueries
]

{ #category : #initialization }
MiHierarchicalMapSettings >> setTags [

	tagList items:
		(self root application itemsFor: FamixTag) asMooseGroup
]

{ #category : #initialization }
MiHierarchicalMapSettings >> submit [

	childrenQueryDropList selectedItem ifNil: [ ^ self ].
	self fillModelWithCurrentSettings.
	self owner hideMenu.
	self owner visualization update
]

{ #category : #updating }
MiHierarchicalMapSettings >> updateSettings [

	| mooseGroup |
	mooseGroup := self model entities asMooseGroup allUsing: TEntityMetaLevelDependency.
	mooseGroup ifEmpty: [ ^self ].
	associationList
		items: (mooseGroup allEntityTypes flatCollectAsSet: [ :class | 
					 class allIncomingAssociationTypesIn: mooseGroup metamodel ])
				asOrderedCollection;
		activateAll
]
