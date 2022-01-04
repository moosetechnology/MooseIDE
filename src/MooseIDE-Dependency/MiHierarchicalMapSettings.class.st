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
		'tagCreateForm',
		'childrenBlockArea',
		'dynamicTagList'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #initialization }
MiHierarchicalMapSettings >> addDynamicTag: aTag [

	self model addDynamicTag: aTag.
	dynamicTagList items: self model dynamicTags
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapSettings >> closeTagCreationForm [

	self owner layout replace: tagCreateForm with: self
]

{ #category : #initialization }
MiHierarchicalMapSettings >> connectPresenters [

	submitButton action: [ self submit ].
	dynamicTagList addButton action: [ self openTagCreationForm ]
]

{ #category : #initialization }
MiHierarchicalMapSettings >> fillModelWithCurrentSettings [

	self model childrenBlock: (Smalltalk compiler
			 source: childrenBlockArea text;
			 logged: false;
			 evaluate)
]

{ #category : #initialization }
MiHierarchicalMapSettings >> iconForDynamicTag: aDynamicTag [

	^ (Form extent: 10 @ 10 depth: 32) fillColor:
		  (self model colorForDynamicTag: aDynamicTag)
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
	tagCreateForm := MiDynamicTagCreationForm owner: self.
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
		                  displayIcon: [ :dt | self iconForDynamicTag: dt ];
		                  title: 'Properties';
		                  yourself.
	self initializeLayout
]

{ #category : #initialization }
MiHierarchicalMapSettings >> model [

	^ self owner model
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapSettings >> openTagCreationForm [

	self owner layout replace: self with: tagCreateForm
]

{ #category : #initialization }
MiHierarchicalMapSettings >> submit [

	| ow |
	ow := self owner.
	self fillModelWithCurrentSettings.
	ow visualization run.
	ow addmenuButtonToCanvas
]
