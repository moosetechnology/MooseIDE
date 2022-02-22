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
		'dynamicTagList'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #initialization }
MiHierarchicalMapSettings >> connectPresenters [

	submitButton action: [ self submit ].
	dynamicTagList addButton action: [ self owner openTagCreationForm ]
]

{ #category : #initialization }
MiHierarchicalMapSettings >> fillModelWithCurrentSettings [

	self model childrenBlock: (Smalltalk compiler
			 source: childrenBlockArea text;
			 logged: false;
			 evaluate)
]

{ #category : #initialization }
MiHierarchicalMapSettings >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (self newLabel label: 'Children block:') expand: false;
			 add: childrenBlockArea;
			 add: 'Properties:' asPresenter expand: false;
			 add: dynamicTagList;
			 add: submitButton expand: false;
			 yourself)
]

{ #category : #initialization }
MiHierarchicalMapSettings >> initializePresenters [

	super initializePresenters.
	submitButton := self newButton
		                label: 'Draw';
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
MiHierarchicalMapSettings >> model [

	^ self owner model
]

{ #category : #refreshing }
MiHierarchicalMapSettings >> refreshTagList [

	dynamicTagList items: self model dynamicTags
]

{ #category : #initialization }
MiHierarchicalMapSettings >> submit [

	| ow |
	ow := self owner.
	self fillModelWithCurrentSettings.
	ow visualization run.
	ow addmenuButtonToCanvas
]
