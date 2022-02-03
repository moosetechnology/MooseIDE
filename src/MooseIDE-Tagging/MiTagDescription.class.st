Class {
	#name : #MiTagDescription,
	#superclass : #MiPresenter,
	#instVars : [
		'tagFormPresenter',
		'tagNameLabel',
		'tagDescriptionText',
		'tagDescriptionButton'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagDescription >> initializeLayout [

	| sep |
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 80
			 g: 80
			 b: 80
			 range: 255) translucent.
	self layout: (SpBoxLayout newTopToBottom
			 spacing: 1;
			 add: (SpBoxLayout newLeftToRight
					  vAlignCenter;
					  spacing: 5;
					  add: tagFormPresenter expand: false;
					  add: tagNameLabel expand: false;
					  add: (SpBoxLayout newLeftToRight hAlignEnd
							   add: tagDescriptionButton
							   expand: false);
					  yourself)
			 expand: false;
			 add: sep height: 2;
			 yourself)
]

{ #category : #initialization }
MiTagDescription >> initializePresenters [

	tagNameLabel := self newLabel.
	tagDescriptionText := self newText beNotEditable.
	tagDescriptionButton := self newToolbar
		                        beIcons;
		                        addItem: (self newToolbarPopoverButton
				                         content: tagDescriptionText;
				                         help: 'Tag desciption';
				                         icon: (self iconNamed: #help);
				                         yourself);
		                        addItem: (self newToolbarButton
				                         icon: (self iconNamed: #delete);
				                         help: 'Delete Tag';
				                         action: [ self owner deleteCurrentTag ];
				                         yourself);
		                        yourself.
	tagFormPresenter := self newImage.
	self initializeLayout
]

{ #category : #initialization }
MiTagDescription >> setTag: aTag [

	tagNameLabel label: aTag name.
	tagDescriptionText text: 'Description: ' , (aTag description
			 ifNotNil: [ :text | text ]
			 ifNil: [ 'No description.' ]).
	tagFormPresenter image: (self owner tagModel iconForTag: aTag).
	self update
]
