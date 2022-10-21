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

{ #category : #action }
MiTagExtentPage >> add [

	self currentTag ifNil: [ ^ self ].
	incomingEntitiesFilteringList selectedItem ifNotNil: [ :entity | 
		self model tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList
]

{ #category : #action }
MiTagExtentPage >> addAll [

	self currentTag ifNil: [ ^ self ].
	incomingEntitiesFilteringList items do: [ :entity | 
		self model tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList
]

{ #category : #accessing }
MiTagExtentPage >> currentTag [

	^ self model currentTag
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
	incomingEntitiesFilteringList := self newFilteringList
		                                 display: [ :entity | 
			                                 String streamContents: [ :s | 
					                                 entity displayStringOn: s ] ];
		                                 "displayIcon: [ :entity | 
			                                 entity mooseIcon ];"
		                                 yourself.
	self refreshEntitiesList.
	taggedEntitiesFilteringList := self newFilteringList
		                               display: [ :entity | 
			                               String streamContents: [ :s | 
					                               entity displayStringOn: s ] ];
		                               "displayIcon: [ :entity | 
			                               entity mooseIcon ];"
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

{ #category : #refreshing }
MiTagExtentPage >> refreshEntitiesList [

	| sortedEntities untaggedEntities |
	untaggedEntities := self model entities asCollection
	                    \ self taggedEntities asCollection.
	sortedEntities := untaggedEntities sort: [ :a :b | a name < b name ].
	incomingEntitiesFilteringList items: sortedEntities
]

{ #category : #refreshing }
MiTagExtentPage >> refreshTaggedEntitiesList [
	taggedEntitiesFilteringList items: self taggedEntities
]

{ #category : #action }
MiTagExtentPage >> remove [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList selectedItem ifNotNil: [ :entity | 
		self model untagEntity: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList
]

{ #category : #action }
MiTagExtentPage >> removeAll [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList items do: [ :entity | 
		self model untagEntity: entity ].
	self refreshTaggedEntitiesList.
	self refreshEntitiesList
]

{ #category : #accessing }
MiTagExtentPage >> setTag: aTag [

	super setTag: aTag.
	self update
]

{ #category : #accessing }
MiTagExtentPage >> taggedEntities [

	^ self model entitiesTaggedWithCurrentTag sort: [ :a :b | 
		  a name < b name ]
]
