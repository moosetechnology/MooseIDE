"
The page of the TagBrowser notebook showing the entities in the tag and allowing to add or remove entities

This is the so called _Extent description_ of the tag
"
Class {
	#name : #MiTagExtentPage,
	#superclass : #MiTagPage,
	#instVars : [
		'incomingEntitiesFilteringList',
		'taggedEntitiesLabel',
		'taggedEntitiesFilteringList',
		'addButton',
		'addAllButton',
		'removeButton',
		'removeAllButton'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagExtentPage class >> maxNumberOfEntitiesToSort [
	"If we have a 'small' number of untagged entities we will sort them to be user friendly. But if we have a lot of them, this will just take too much time. In that case we will just not sort them. Here I'm defining the limit, with a magic number for a start, maybe this could be a setting in the future but I'm not sure it brings much value."

	^ 10000
]

{ #category : #action }
MiTagExtentPage >> add [

	(self currentTag isNil or: [
		 incomingEntitiesFilteringList selectedItems isEmpty ]) ifTrue: [
		^ self ].

	incomingEntitiesFilteringList selectedItems do: [ :entity |
		self specModel tagEntityNotYourself: entity ].

	self refreshTaggedEntitiesList.
	self refreshEntitiesList.
	self refreshBrowserToolbar
]

{ #category : #action }
MiTagExtentPage >> addAll [

	self currentTag ifNil: [ ^ self ].
	incomingEntitiesFilteringList items do: [ :entity |
		self specModel tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList.
	self refreshBrowserToolbar
]

{ #category : #accessing }
MiTagExtentPage >> currentTag [

	^ self specModel currentTag
]

{ #category : #accessing }
MiTagExtentPage >> incomingEntitiesFilteringList [

	^ incomingEntitiesFilteringList
]

{ #category : #initialization }
MiTagExtentPage >> initializeButtons [

	addButton := self newButton
		          label: ' > ';
		          action: [ self add ].
	addAllButton := self newButton
		             label: '>>>';
		             action: [ self addAll ].
	removeButton := self newButton
		          label: ' < ';
		          action: [ self remove ].
	removeAllButton := self newButton
		             label: '<<<';
		             action: [ self removeAll ]
]

{ #category : #initialization }
MiTagExtentPage >> initializeLayout [

	super initializeLayout.
	self layout add: (SpBoxLayout newHorizontal
			 spacing: 3;
			 add: (SpBoxLayout newTopToBottom
					  spacing: 2;
					  add: 'Entities queried:' expand: false;
					  add: incomingEntitiesFilteringList;
					  yourself);
			 add: (SpBoxLayout newVertical
					  spacing: 5;
					  add: SpNullPresenter new expand: true;
					  add: addButton expand: false;
					  add: addAllButton expand: false;
					  add: removeButton expand: false;
					  add: removeAllButton expand: false;
					  add: SpNullPresenter new expand: true;
					  yourself)
			 width: 35;
			 add: (SpBoxLayout newTopToBottom
					  spacing: 2;
					  add: 'Entities in tag:' expand: false;
					  add: taggedEntitiesFilteringList;
					  yourself);
			 yourself)
]

{ #category : #initialization }
MiTagExtentPage >> initializePresenters [

	super initializePresenters.
	taggedEntitiesLabel := self newLabel label: 'Entities in tag:'.
	incomingEntitiesFilteringList := (self instantiate:
			                                  SpFilteringSelectableListPresenter)
		                                 display: [ :entity |
			                                 String streamContents: [ :s |
					                                 entity displayStringOn: s ] ];
		                                 yourself.
	self refreshEntitiesList.
	taggedEntitiesFilteringList := (self instantiate:
			                                SpFilteringSelectableListPresenter)
		                               display: [ :entity |
			                               String streamContents: [ :s |
					                               entity displayStringOn: s ] ];
		                               yourself.
	self refreshTaggedEntitiesList.
	self initializeButtons.
	self initializeLayout
]

{ #category : #refreshing }
MiTagExtentPage >> onBrowserPageRedisplay [

	taggedEntitiesLabel
		label: 
			(self currentTag
				ifNil: [ '!*! No tag selected !*!' ]
				ifNotNil: [ :tag | 'Entities in tag [' , tag name , ']:' ]
			)
]

{ #category : #refreshing }
MiTagExtentPage >> refresh [

	super refresh.
	self refreshEntitiesList.
	self refreshTaggedEntitiesList.
	self update
]

{ #category : #action }
MiTagExtentPage >> refreshBrowserToolbar [

	self owner owner updateToolbar
]

{ #category : #refreshing }
MiTagExtentPage >> refreshEntitiesList [

	| untaggedEntities |
	untaggedEntities := self specModel entities asCollection
	                    \ self taggedEntities asCollection.
	untaggedEntities size < self class maxNumberOfEntitiesToSort ifTrue: [
		untaggedEntities sort: [ :a :b | a name < b name ] ].
	incomingEntitiesFilteringList items: untaggedEntities
]

{ #category : #refreshing }
MiTagExtentPage >> refreshTaggedEntitiesList [

	"check first if the entity being propogated is already in the list of TaggedEntitites and check (select) it in this case"

	self taggedEntities do: [:aTaggedEntity | 
		(self specModel entities includes: aTaggedEntity) ifTrue: [ 
			taggedEntitiesFilteringList activateItem: aTaggedEntity
			 ]
		].
	
	taggedEntitiesFilteringList items: self taggedEntities
]

{ #category : #action }
MiTagExtentPage >> remove [

	(self currentTag isNil or: [
		 taggedEntitiesFilteringList selectedItems isEmpty ]) ifTrue: [
		^ self ].

	taggedEntitiesFilteringList selectedItems do: [ :entity |
		self specModel untagEntity: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList.
	self refreshBrowserToolbar
]

{ #category : #action }
MiTagExtentPage >> removeAll [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList items do: [ :entity |
		self specModel untagEntity: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList.
	self refreshBrowserToolbar
]

{ #category : #accessing }
MiTagExtentPage >> selectedItems [

	^ taggedEntitiesFilteringList selectedItems
]

{ #category : #accessing }
MiTagExtentPage >> setTag: aTag [

	super setTag: aTag.
	self update
]

{ #category : #accessing }
MiTagExtentPage >> taggedEntities [

	^ self specModel entitiesTaggedWithCurrentTag sort: #name ascending
]
